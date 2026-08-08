package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.constant.SeckillSessionStatus;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
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
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
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

    private final SeckillService seckillService;
    private final CouponMapper couponMapper;
    private final UserCouponMapper userCouponMapper;
    private final ProductMapper productMapper;
    private final StringRedisTemplate stringRedisTemplate;
    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;
    private final HttpServletRequest request;

    @GetMapping("/sessions")
    public Result<List<SeckillSessionVO>> getSessions() {
        List<SeckillSession> all = seckillService.pageQuery(null, null, null, 1, 200).getRecords();
        List<SeckillSession> active = all.stream()
                .filter(s -> s.getStatus() == 0 || s.getStatus() == 1)
                .collect(Collectors.toList());

        if (active.isEmpty()) {
            return Result.success(Collections.emptyList());
        }

        // 当前登录用户（未登录或 token 解析失败时为 null）
        final Long currentUserId = parseCurrentUserId(request);

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
            if (currentUserId != null) {
                Boolean member = stringRedisTemplate.opsForSet()
                        .isMember(USERS_KEY + s.getId(), String.valueOf(currentUserId));
                vo.setIsSeckilled(Boolean.TRUE.equals(member));
            }

            return vo;
        }).collect(Collectors.toList());

        return Result.success(list);
    }

    @PostMapping("/{sessionId}")
    public Result<?> seckill(@PathVariable Long sessionId,
                             @RequestBody(required = false) SeckillBuyDTO body,
                             @RequestHeader("Authorization") String authHeader) {
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

        Long userId = jwtUtil.getUserIdFromToken(tokenUtils.extractToken(authHeader));

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

    /** 从 Authorization 头解析当前用户ID，未登录或解析失败返回 null */
    private Long parseCurrentUserId(HttpServletRequest request) {
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return null;
        }
        try {
            return jwtUtil.getUserIdFromToken(tokenUtils.extractToken(authHeader));
        } catch (Exception ignored) {
            return null;
        }
    }
}
