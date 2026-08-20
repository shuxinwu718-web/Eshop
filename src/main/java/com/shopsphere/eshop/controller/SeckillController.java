package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.constant.SeckillSessionStatus;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shopsphere.eshop.dto.SeckillBuyDTO;
import com.shopsphere.eshop.entity.Coupon;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.entity.SeckillSession;
import com.shopsphere.eshop.entity.UserCoupon;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.CouponMapper;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.mapper.UserCouponMapper;
import com.shopsphere.eshop.service.SeckillService;
import com.shopsphere.eshop.service.UserCouponService;
import com.shopsphere.eshop.vo.SeckillSessionVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/seckill")
@RequiredArgsConstructor
@Tag(name = "用户参与秒杀卷活动接口", description = "从redis获取所有的秒杀优惠卷和对应商品的库存和实时根据redis更新商品库存")
public class SeckillController {

    private static final String STOCK_KEY = "seckill:stock:";
    private static final String RATE_KEY = "seckill:rate:";
    private static final String USERS_KEY = "seckill:users:";
    /** 活跃场次列表缓存 key（与 SeckillServiceImpl 保持一致） */
    public static final String SESSIONS_CACHE_KEY = "seckill:sessions";
    /** 场次列表缓存 TTL：短缓存，保证管理端增删改后快速可见 */
    private static final long SESSIONS_CACHE_TTL_SECONDS = 30;

    private final SeckillService seckillService;
    private final CouponMapper couponMapper;
    private final UserCouponMapper userCouponMapper;
    private final UserCouponService userCouponService;
    private final ProductMapper productMapper;
    private final StringRedisTemplate stringRedisTemplate;
    private final ObjectMapper objectMapper;
    private final HttpServletRequest request;

    @GetMapping("/sessions")
    public Result<List<SeckillSessionVO>> getSessions(@CurrentUserId Long userId) {
        List<SeckillSession> active = getActiveSessionsFromCache();

        if (active.isEmpty()) {
            return Result.success(Collections.emptyList());
        }

        // 批量查询优惠券名称（仅秒券场次）
        List<Long> couponIds = active.stream()
                .filter(s -> s.getSeckillType() == null || s.getSeckillType() == 0)
                .map(SeckillSession::getCouponId)
                .distinct()
                .collect(Collectors.toList());
        Map<Long, String> couponNameMap = couponIds.isEmpty() ? Collections.emptyMap()
                : couponMapper.selectBatchIds(couponIds)
                        .stream().collect(Collectors.toMap(Coupon::getId, Coupon::getName));

        // 批量查询秒杀商品信息（仅秒商品场次）
        List<Long> productIds = active.stream()
                .filter(s -> s.getSeckillType() != null && s.getSeckillType() == 1 && s.getProductId() != null)
                .map(SeckillSession::getProductId)
                .distinct()
                .collect(Collectors.toList());
        Map<Long, Product> productMap = productIds.isEmpty() ? Collections.emptyMap()
                : productMapper.selectBatchIds(productIds)
                        .stream().collect(Collectors.toMap(Product::getId, Function.identity()));

        List<SeckillSessionVO> list = active.stream().map(s -> {
            SeckillSessionVO vo = new SeckillSessionVO();
            BeanUtils.copyProperties(s, vo);

            // 秒杀券场次：填充优惠券名称 + 按已领取量还原总库存
            if (s.getSeckillType() == null || s.getSeckillType() == 0) {
                vo.setCouponName(couponNameMap.get(s.getCouponId()));

                // 还原原始总库存：DB 中已扣减的 seckillStock + 已领取数
                long claimed = userCouponMapper.selectCount(
                        new LambdaQueryWrapper<UserCoupon>()
                                .eq(UserCoupon::getCouponId, s.getCouponId())
                                .ge(UserCoupon::getGetTime, s.getStartTime())
                                .le(UserCoupon::getGetTime, s.getEndTime())
                );
                vo.setSeckillStock(s.getSeckillStock() + (int) claimed);
            } else {
                // 秒杀商品场次：填充商品信息，库存为 DB 原值（已实时扣减）
                Product p = productMap.get(s.getProductId());
                if (p != null) {
                    vo.setProductName(p.getName());
                    vo.setCoverImage(p.getCoverImage());
                    vo.setOriginalPrice(p.getPrice());
                }
            }

            // 实时剩余库存 — 从 Redis 获取，丢失时从 DB 恢复
            String stockStr = stringRedisTemplate.opsForValue().get(STOCK_KEY + s.getId());
            int remainStock;
            if (stockStr != null) {
                remainStock = Integer.parseInt(stockStr);
            } else {
                seckillService.preheatStock(s.getId());
                String recovered = stringRedisTemplate.opsForValue().get(STOCK_KEY + s.getId());
                remainStock = recovered != null ? Integer.parseInt(recovered) : s.getSeckillStock();
            }
            vo.setRemainStock(remainStock);

            // 秒杀商品场次：DB seckillStock 已被实时扣减，按「已抢数 + 剩余」还原总库存，供前端计算已抢进度
            if (s.getSeckillType() != null && s.getSeckillType() == 1) {
                Long sold = stringRedisTemplate.opsForSet().size(USERS_KEY + s.getId());
                vo.setSeckillStock((int) (sold == null ? 0 : sold) + remainStock);
            }

            // 当前用户是否已抢购/领取（未登录时为 false）
            // 秒杀券场次：仅「未使用且未过期」的券算作已领取（已使用/过期可再次参与）
            // 秒杀商品场次：以 Redis 场次记录为准（一次性抢购）
            if (userId != null) {
                boolean isSeckilled;
                if (s.getSeckillType() == null || s.getSeckillType() == 0) {
                    isSeckilled = s.getCouponId() != null
                            && userCouponService.countUsable(userId, s.getCouponId()) > 0;
                } else {
                    Boolean member = stringRedisTemplate.opsForSet()
                            .isMember(USERS_KEY + s.getId(), String.valueOf(userId));
                    isSeckilled = Boolean.TRUE.equals(member);
                }
                vo.setIsSeckilled(isSeckilled);
            }

            return vo;
        }).collect(Collectors.toList());

        return Result.success(list);
    }

    @PostMapping("/{sessionId}")
    public Result<?> seckill(@PathVariable Long sessionId,
                             @RequestBody(required = false) SeckillBuyDTO body,
                             @CurrentUserId Long userId) {
        // IP 频率限制：每 IP 每 10 秒最多 5 次
        String ip = request.getRemoteAddr();
        String rateKey = RATE_KEY + "ip:" + ip;
        Long ipCount = stringRedisTemplate.opsForValue().increment(rateKey);
        if (ipCount == null) ipCount = 0L;
        if (ipCount == 1) {
            stringRedisTemplate.expire(rateKey, 10, TimeUnit.SECONDS);
        }
        if (ipCount > 5) {
            throw new BusinessException("操作太频繁，请稍后再试");
        }

        // 用户频率限制：每用户每 2 秒最多 1 次
        String userRateKey = RATE_KEY + "user:" + userId;
        Long userCount = stringRedisTemplate.opsForValue().increment(userRateKey);
        if (userCount == null) userCount = 0L;
        if (userCount == 1) {
            stringRedisTemplate.expire(userRateKey, 2, TimeUnit.SECONDS);
        }
        if (userCount > 1) {
            throw new BusinessException("操作太频繁，请稍后再试");
        }

        Long orderId = seckillService.seckill(sessionId, userId, body != null ? body.getAddressId() : null);
        // 秒杀商品模式返回订单ID（前端跳转支付）；秒杀券模式返回提示语
        return Result.success(orderId != null ? orderId : "抢购成功");
    }

    /**
     * 读取活跃场次列表：优先走缓存（30s短TTL），未命中查DB并回填缓存。
     * 缓存只存"活跃场次基础信息"，优惠券名/商品信息/实时库存/用户状态仍在方法内实时聚合，
     * 保证每个字段都是最新值。
     */
    private List<SeckillSession> getActiveSessionsFromCache() {
        String cached = stringRedisTemplate.opsForValue().get(SESSIONS_CACHE_KEY);
        if (cached != null) {
            try {
                return objectMapper.readValue(cached, new TypeReference<List<SeckillSession>>() {
                });
            } catch (Exception e) {
                // 反序列化失败回源DB
            }
        }

        List<SeckillSession> all = seckillService.pageQuery(null, null, null, 1, 200).getRecords();
        List<SeckillSession> active = all.stream()
                .filter(s -> s.getStatus() == 0 || s.getStatus() == 1)
                .collect(Collectors.toList());
        try {
            stringRedisTemplate.opsForValue().set(SESSIONS_CACHE_KEY,
                    objectMapper.writeValueAsString(active), SESSIONS_CACHE_TTL_SECONDS, TimeUnit.SECONDS);
        } catch (Exception e) {
            // 缓存写入失败不影响本次返回
        }
        return active;
    }
}
