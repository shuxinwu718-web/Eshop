package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import com.shopsphere.eshop.constant.SeckillSessionStatus;
import com.shopsphere.eshop.dto.SeckillSessionSaveDTO;
import com.shopsphere.eshop.entity.*;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.*;
import com.shopsphere.eshop.service.NoticeService;
import com.shopsphere.eshop.service.SeckillService;
import com.shopsphere.eshop.service.UserCouponService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.core.io.ClassPathResource;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class SeckillServiceImpl implements SeckillService {

    public static final String STOCK_KEY = "seckill:stock:";
    public static final String USERS_KEY = "seckill:users:";
    /** 活跃场次列表缓存 key（与 SeckillController 保持一致） */
    public static final String SESSIONS_CACHE_KEY = "seckill:sessions";

    // ==================== 高并发优化：本地缓存 + Lua 原子抢购 ====================

    /**
     * 场次元数据本地缓存（存在性/时间窗口/状态/类型）。
     * 高并发下每个请求都会校验场次，若每次都查 DB，光前置校验就能拖垮连接池；
     * 缓存 5s TTL，秒杀开始/结束存在秒级判定误差（业务可接受）。
     * Optional 包装用于缓存"不存在"结果，防止恶意 sessionId 穿透缓存打 DB。
     */
    private final Cache<Long, Optional<SeckillSession>> sessionCache = Caffeine.newBuilder()
            .expireAfterWrite(Duration.ofSeconds(5))
            .maximumSize(1_000)
            .build();

    /** 优惠券元数据本地缓存（状态/限领数），TTL 30s，管理端改券后最多 30s 生效 */
    private final Cache<Long, Optional<Coupon>> couponCache = Caffeine.newBuilder()
            .expireAfterWrite(Duration.ofSeconds(30))
            .maximumSize(1_000)
            .build();

    /** 商品元数据本地缓存（上架状态/商家归属），TTL 10s */
    private final Cache<Long, Optional<Product>> productCache = Caffeine.newBuilder()
            .expireAfterWrite(Duration.ofSeconds(10))
            .maximumSize(1_000)
            .build();

    /** 本地售罄标记：售罄后请求在进入 Redis/DB 之前直接拒绝，O(1) 挡住全部无效流量 */
    private final ConcurrentHashMap<Long, Boolean> localSoldOut = new ConcurrentHashMap<>();

    /**
     * 抢购原子脚本：判重 + 扣库存 + 记录用户合并为 1 次 Redis RTT。
     * 原实现为 SISMEMBER / DECR / SADD 三次往返，非原子且存在中间态竞态。
     */
    private final DefaultRedisScript<Long> claimScript = buildClaimScript();

    private static DefaultRedisScript<Long> buildClaimScript() {
        DefaultRedisScript<Long> script = new DefaultRedisScript<>();
        script.setLocation(new ClassPathResource("scripts/seckill_claim.lua"));
        script.setResultType(Long.class);
        return script;
    }

    private final SeckillSessionMapper seckillSessionMapper;
    private final CouponMapper couponMapper;
    private final UserCouponMapper userCouponMapper;
    private final StringRedisTemplate stringRedisTemplate;
    private final ProductMapper productMapper;
    private final ProductSkuMapper productSkuMapper;
    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;
    private final OrderShipmentMapper orderShipmentMapper;
    private final AddressMapper addressMapper;
    private final NoticeService noticeService;
    private final UserCouponService userCouponService;
    private final ObjectMapper objectMapper;
    /**
     * 编程式事务：只包裹落库段（扣库存 + 写单）。
     * 原实现 @Transactional 标注在整个抢购方法上，导致被拒绝的请求（重复/售罄，通常占绝大多数）
     * 也要借出 DB 连接并开启空事务——高并发下连接池被无效流量占满，成为吞吐瓶颈。
     */
    private final TransactionTemplate transactionTemplate;

    @Override
    public Page<SeckillSession> pageQuery(String sessionName, Integer status, Long couponId,
                                          Integer pageNum, Integer pageSize) {
        Page<SeckillSession> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<SeckillSession> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(sessionName)) {
            wrapper.like(SeckillSession::getSessionName, sessionName);
        }
        if (status != null) {
            wrapper.eq(SeckillSession::getStatus, status);
        }
        if (couponId != null) {
            wrapper.eq(SeckillSession::getCouponId, couponId);
        }
        wrapper.orderByDesc(SeckillSession::getStartTime);

        Page<SeckillSession> result = seckillSessionMapper.selectPage(page, wrapper);

        // 批量填充优惠券名称
        List<SeckillSession> records = result.getRecords();
        if (!records.isEmpty()) {
            List<Long> couponIds = records.stream().map(SeckillSession::getCouponId).collect(Collectors.toList());
            List<Coupon> coupons = couponMapper.selectBatchIds(couponIds);
            Map<Long, String> nameMap = coupons.stream().collect(Collectors.toMap(Coupon::getId, Coupon::getName));
            records.forEach(s -> s.setCouponName(nameMap.get(s.getCouponId())));
        }

        // 批量填充秒杀商品信息（秒商品模式）
        fillProductInfo(records);

        return result;
    }

    /** 为秒商品场次批量填充商品名称/封面/原价 */
    private void fillProductInfo(List<SeckillSession> sessions) {
        List<Long> productIds = sessions.stream()
                .filter(s -> s.getSeckillType() != null && s.getSeckillType() == 1 && s.getProductId() != null)
                .map(SeckillSession::getProductId)
                .distinct()
                .collect(Collectors.toList());
        if (productIds.isEmpty()) return;
        Map<Long, Product> productMap = productMapper.selectBatchIds(productIds)
                .stream().collect(Collectors.toMap(Product::getId, Function.identity()));
        sessions.forEach(s -> {
            if (s.getSeckillType() != null && s.getSeckillType() == 1) {
                Product p = productMap.get(s.getProductId());
                if (p != null) {
                    s.setProductName(p.getName());
                    s.setCoverImage(p.getCoverImage());
                    s.setOriginalPrice(p.getPrice());
                }
            }
        });
    }

    @Override
    public SeckillSession getById(Long id) {
        SeckillSession session = seckillSessionMapper.selectById(id);
        if (session != null) {
            Coupon coupon = couponMapper.selectById(session.getCouponId());
            if (coupon != null) {
                session.setCouponName(coupon.getName());
            }
            fillProductInfo(Collections.singletonList(session));
        }
        return session;
    }

    @Override
    @Transactional
    public void create(SeckillSessionSaveDTO dto) {
        int type = validateByType(dto);
        if (dto.getStartTime().isAfter(dto.getEndTime())) {
            throw new BusinessException("开始时间不能晚于结束时间");
        }
        if (dto.getStartTime().isBefore(LocalDateTime.now())) {
            throw new BusinessException("开始时间不能早于当前时间");
        }
        if (dto.getSeckillStock() == null || dto.getSeckillStock() <= 0) {
            throw new BusinessException("秒杀库存必须大于 0");
        }

        SeckillSession session = new SeckillSession();
        BeanUtils.copyProperties(dto, session);
        session.setSeckillType(type);
        session.setStatus(SeckillSessionStatus.PENDING);
        if (session.getLimitPerUser() == null) {
            session.setLimitPerUser(1);
        }
        seckillSessionMapper.insert(session);
        // 预热 Redis 库存
        stringRedisTemplate.opsForValue().set(STOCK_KEY + session.getId(), String.valueOf(session.getSeckillStock()));

        // ========== 新增：为 USERS_KEY 预设过期时间 ==========
        String usersKey = USERS_KEY + session.getId();
        // 计算场次结束时间到现在的秒数
        long ttlSeconds = Duration.between(LocalDateTime.now(), dto.getEndTime()).toSeconds();
        // 先删再设（防止之前有残留数据）
        stringRedisTemplate.delete(usersKey);
        stringRedisTemplate.expire(usersKey, ttlSeconds, TimeUnit.SECONDS);
        // ========== 新增结束 ==========

        // 新增场次影响活跃列表，清理场次列表缓存
        evictSessionsCache();
        log.info("秒杀场次 [{}] 创建成功，类型 [{}]，库存 {}", session.getSessionName(),
                type == 1 ? "秒杀商品" : "秒杀优惠券", session.getSeckillStock());
    }

    /** 按场次类型校验 DTO，返回类型（0=秒券 1=秒商品），默认 0 */
    private int validateByType(SeckillSessionSaveDTO dto) {
        int type = dto.getSeckillType() == null ? 0 : dto.getSeckillType();
        if (type == 0) {
            // 秒杀优惠券：校验优惠券存在且已启用
            if (dto.getCouponId() == null) {
                throw new BusinessException("请选择优惠券");
            }
            Coupon coupon = couponMapper.selectById(dto.getCouponId());
            if (coupon == null) {
                throw new BusinessException("优惠券不存在");
            }
            if (coupon.getStatus() != 1) {
                throw new BusinessException("优惠券已停用，无法创建秒杀场次");
            }
        } else if (type == 1) {
            // 秒杀商品：校验商品/秒杀价/库存上限
            if (dto.getProductId() == null) {
                throw new BusinessException("请选择秒杀商品");
            }
            if (dto.getSeckillPrice() == null || dto.getSeckillPrice().compareTo(BigDecimal.ZERO) <= 0) {
                throw new BusinessException("秒杀价必须大于 0");
            }
            Product product = productMapper.selectById(dto.getProductId());
            if (product == null) {
                throw new BusinessException("商品不存在");
            }
            if (product.getStatus() == null || product.getStatus() != 1) {
                throw new BusinessException("商品已下架，无法创建秒杀场次");
            }
            // 指定 SKU：以该 SKU 的价格/库存为校验基准；未指定则用商品原价/总库存
            BigDecimal priceBase;
            Integer stockLimit;
            if (dto.getSkuId() != null) {
                ProductSku sku = productSkuMapper.selectById(dto.getSkuId());
                if (sku == null || !sku.getProductId().equals(product.getId())) {
                    throw new BusinessException("商品规格（SKU）不存在");
                }
                priceBase = sku.getPrice();
                stockLimit = sku.getStock();
            } else {
                priceBase = product.getPrice();
                stockLimit = product.getStock();
            }
            if (priceBase != null && dto.getSeckillPrice().compareTo(priceBase) > 0) {
                throw new BusinessException(dto.getSkuId() != null ? "秒杀价不能高于规格价格" : "秒杀价不能高于商品原价");
            }
            if (dto.getSeckillStock() != null && dto.getSeckillStock() > stockLimit) {
                throw new BusinessException(dto.getSkuId() != null ? "秒杀库存不能超过规格库存" : "秒杀库存不能超过商品库存");
            }
        } else {
            throw new BusinessException("场次类型不合法");
        }
        return type;
    }

    @Override
    @Transactional
    public void update(SeckillSessionSaveDTO dto) {
        SeckillSession session = seckillSessionMapper.selectById(dto.getId());
        if (session == null) {
            throw new BusinessException("秒杀场次不存在");
        }
        if (session.getStatus() == SeckillSessionStatus.ENDED || session.getStatus() == SeckillSessionStatus.CANCELLED) {
            throw new BusinessException("已结束或已撤销的场次不能修改");
        }
        if (dto.getStartTime().isAfter(dto.getEndTime())) {
            throw new BusinessException("开始时间不能晚于结束时间");
        }

        if (dto.getSeckillType() == null) {
            dto.setSeckillType(session.getSeckillType() == null ? 0 : session.getSeckillType());
        }
        validateByType(dto);

        if (dto.getSeckillStock() != null) {
            Long claimed = stringRedisTemplate.opsForSet().size(USERS_KEY + dto.getId());
            if (claimed != null && dto.getSeckillStock() < claimed) {
                throw new BusinessException("秒杀库存不能低于已领取数量（" + claimed + "）");
            }
        }

        BeanUtils.copyProperties(dto, session);
        seckillSessionMapper.updateById(session);

        // 更新 Redis 库存
        stringRedisTemplate.opsForValue().set(STOCK_KEY + session.getId(), String.valueOf(session.getSeckillStock()));

        // 如果结束时间变了，更新 USERS_KEY 的 TTL
        if (dto.getEndTime() != null) {
            String usersKey = USERS_KEY + session.getId();
            long ttlSeconds = Duration.between(LocalDateTime.now(), dto.getEndTime()).toSeconds();

            // ⭐ 修复：只有 Key 存在时才设置过期时间，避免 sadd 空集合报错
            Boolean exists = stringRedisTemplate.hasKey(usersKey);
            if (Boolean.TRUE.equals(exists)) {
                stringRedisTemplate.expire(usersKey, ttlSeconds, TimeUnit.SECONDS);
            }
            // Key 不存在时，不创建空 Set，直接跳过（不影响业务）
        }

        evictSessionsCache();
        evictLocalCache(session);
        log.info("秒杀场次 [{}] 已更新，库存 {}", session.getSessionName(), session.getSeckillStock());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        SeckillSession session = seckillSessionMapper.selectById(id);
        if (session == null) return;
        seckillSessionMapper.deleteById(id);
        cleanRedisKeys(id);
        evictSessionsCache();
        log.info("秒杀场次 [{}] 已删除", session.getSessionName());
    }

    @Override
    @Transactional
    public void cancel(Long id) {
        SeckillSession session = seckillSessionMapper.selectById(id);
        if (session == null) {
            throw new BusinessException("秒杀场次不存在");
        }
        if (session.getStatus() == SeckillSessionStatus.ENDED || session.getStatus() == SeckillSessionStatus.CANCELLED) {
            throw new BusinessException("该场次已结束或已撤销");
        }
        session.setStatus(SeckillSessionStatus.CANCELLED);
        seckillSessionMapper.updateById(session);
        cleanRedisKeys(id);
        evictSessionsCache();
        log.info("秒杀场次 [{}] 已撤销", session.getSessionName());
    }

    @Override
    public void preheatStock(Long id) {
        SeckillSession session = seckillSessionMapper.selectById(id);
        if (session == null) {
            throw new BusinessException("秒杀场次不存在");
        }
        stringRedisTemplate.opsForValue().set(STOCK_KEY + id, String.valueOf(session.getSeckillStock()));
        localSoldOut.remove(id);
        log.info("场次 [{}] 库存已从 DB 恢复: {}", session.getSessionName(), session.getSeckillStock());
    }

    /**
     * 抢购主流程不加 @Transactional：拒绝路径（售罄/重复，占绝大多数）不借出 DB 连接；
     * 仅落库段（第 4 步）用 transactionTemplate 包裹，事务边界最小化。
     */
    @Override
    public Long seckill(Long sessionId, Long userId, Long addressId) {
        // 0. 本地售罄标记前置拦截：售罄后 O(1) 拒绝，不打 Redis / DB
        if (Boolean.TRUE.equals(localSoldOut.get(sessionId))) {
            throw new BusinessException("秒杀券已抢完");
        }

        // 1. 校验场次（本地缓存，5s TTL；Optional 缓存"不存在"防穿透）
        SeckillSession session = sessionCache.get(sessionId,
                id -> Optional.ofNullable(seckillSessionMapper.selectById(id))).orElse(null);
        if (session == null) {
            log.warn("秒杀失败 - 场次不存在, sessionId={}, userId={}", sessionId, userId);
            throw new BusinessException("秒杀场次不存在");
        }
        LocalDateTime now = LocalDateTime.now();
        if (now.isBefore(session.getStartTime())) {
            throw new BusinessException("秒杀还未开始");
        }
        if (now.isAfter(session.getEndTime())) {
            throw new BusinessException("秒杀已结束");
        }
        if (session.getStatus() == SeckillSessionStatus.CANCELLED) {
            throw new BusinessException("该场次已撤销");
        }

        // 秒杀商品模式：直接生成待支付秒杀订单
        if (session.getSeckillType() != null && session.getSeckillType() == 1) {
            return seckillProduct(session, userId, addressId);
        }

        // 1a. 校验关联优惠券仍然有效（本地缓存 30s）
        Coupon coupon = couponCache.get(session.getCouponId(),
                id -> Optional.ofNullable(couponMapper.selectById(id))).orElse(null);
        if (coupon == null) {
            throw new BusinessException("关联优惠券已不存在");
        }
        if (coupon.getStatus() != 1) {
            throw new BusinessException("关联优惠券已停用");
        }

        // 2. Lua 原子抢购：判重 + 扣库存 + 记录用户，1 次 Redis RTT 完成
        //    拒绝路径（重复/售罄）在此直接结束，不再触发任何 DB 查询
        Long remain = claimAtomically(sessionId, userId);
        if (remain == -2) {
            localSoldOut.put(sessionId, Boolean.TRUE);
            throw new BusinessException("秒杀券已抢完");
        }
        if (remain == -3) {
            // Redis key 丢失（宕机/被清），从 DB 恢复后重试一次
            preheatStock(sessionId);
            remain = claimAtomically(sessionId, userId);
            if (remain < 0) {
                throw new BusinessException("秒杀券已抢完");
            }
        }

        // 3. 限领与已持有校验（仅 Redis 记录命中/抢购成功路径才查 DB）
        //    「未使用且未过期」的券算作已拥有，已使用/已过期的券不占用名额，允许再次参与
        Integer limit = coupon.getLimitPerUser() != null ? coupon.getLimitPerUser() : 1;
        String usersKey = USERS_KEY + sessionId;
        if (remain == -1) {
            int usable = userCouponService.countUsable(userId, session.getCouponId());
            if (usable >= limit) {
                // 高频拒绝路径不打 info/warn：同步 appender 在洪峰下会串行化成为吞吐瓶颈（压测实测）
                log.debug("秒杀失败 - 超过限领数量, sessionId={}, userId={}, usable={}, limit={}",
                        sessionId, userId, usable, limit);
                throw new BusinessException("您已达到该优惠券的领取上限");
            }
            if (usable > 0) {
                log.debug("秒杀失败 - 已持有有效券, sessionId={}, userId={}", sessionId, userId);
                throw new BusinessException("您已持有该秒杀优惠券，请先使用后再参与");
            }
            // 旧券已失效：移除 Redis 旧记录后重新参与
            stringRedisTemplate.opsForSet().remove(usersKey, String.valueOf(userId));
            log.info("秒杀 - 用户{}旧券已失效，重新参与场次{}", userId, sessionId);
            remain = claimAtomically(sessionId, userId);
            if (remain < 0) {
                throw new BusinessException("您已领取过该秒杀券");
            }
        } else {
            // 抢购成功路径仍需校验限领数（limit_per_user > 1 的场次可能已领过但 Redis 未记录）
            int usable = userCouponService.countUsable(userId, session.getCouponId());
            if (usable >= limit) {
                rollbackClaim(sessionId, userId);
                throw new BusinessException("您已达到该优惠券的领取上限");
            }
        }

        // 4. 落库（编程式事务只包裹 DB 段，事务边界最小化）
        try {
            transactionTemplate.executeWithoutResult(status -> {
                // 原子扣减DB库存，防止与 Redis 库存不一致
                if (seckillSessionMapper.deductStock(sessionId) == 0) {
                    throw new BusinessException("秒杀券已抢完");
                }

                UserCoupon uc = new UserCoupon();
                uc.setUserId(userId);
                uc.setCouponId(session.getCouponId());
                uc.setStatus(0);
                uc.setGetTime(LocalDateTime.now());
                userCouponMapper.insert(uc);
            });

            log.info("秒杀成功 - sessionId={}, userId={}, couponId={}, remain={}", sessionId, userId, session.getCouponId(), remain);
        } catch (Exception e) {
            rollbackClaim(sessionId, userId);
            log.error("秒杀落库失败 - sessionId={}, userId={}", sessionId, userId, e);
            throw e;
        }
        return null; // 秒杀券模式无订单
    }

    /** 执行 Lua 抢购脚本（判重 + 扣库存 + 记录用户），返回约定码 */
    private Long claimAtomically(Long sessionId, Long userId) {
        return stringRedisTemplate.execute(claimScript,
                List.of(USERS_KEY + sessionId, STOCK_KEY + sessionId),
                String.valueOf(userId));
    }

    /** 回滚一次 Redis 抢占（库存 +1、移除用户记录），用于上层校验失败/落库失败 */
    private void rollbackClaim(Long sessionId, Long userId) {
        stringRedisTemplate.opsForValue().increment(STOCK_KEY + sessionId);
        stringRedisTemplate.opsForSet().remove(USERS_KEY + sessionId, String.valueOf(userId));
    }

    /**
     * 秒杀商品模式抢购：本地缓存元数据校验 + Lua 原子抢购，DB 扣减秒杀/商品库存，生成待支付秒杀订单
     */
    public Long seckillProduct(SeckillSession session, Long userId, Long addressId) {
        Long sessionId = session.getId();

        // 1. 校验商品/SKU 与用户身份（商品元数据走本地缓存 10s）
        Product product = productCache.get(session.getProductId(),
                id -> Optional.ofNullable(productMapper.selectById(id))).orElse(null);
        if (product == null) {
            throw new BusinessException("秒杀商品不存在");
        }
        if (product.getStatus() == null || product.getStatus() != 1) {
            throw new BusinessException("秒杀商品已下架");
        }
        if (product.getMerchantId() != null && product.getMerchantId().equals(userId)) {
            throw new BusinessException("不能购买自家商品");
        }
        ProductSku sku = null;
        if (session.getSkuId() != null) {
            sku = productSkuMapper.selectById(session.getSkuId());
            if (sku == null || !sku.getProductId().equals(product.getId())) {
                throw new BusinessException("商品规格（SKU）不存在");
            }
        }

        // 2. 校验收货地址（秒杀商品下单必填；地址属于用户动态数据，不缓存）
        if (addressId == null) {
            throw new BusinessException("请先完善收货地址");
        }
        Address address = addressMapper.selectById(addressId);
        if (address == null || !address.getUserId().equals(userId)) {
            throw new BusinessException("收货地址不存在");
        }

        // 3. Lua 原子抢购：判重 + 扣库存 + 记录用户，1 次 Redis RTT
        //    商品模式无"旧券重参与"语义，重复抢购直接拒绝
        Long remain = claimAtomically(sessionId, userId);
        if (remain == -1) {
            throw new BusinessException("您已抢购过该秒杀商品");
        }
        if (remain == -2) {
            localSoldOut.put(sessionId, Boolean.TRUE);
            throw new BusinessException("秒杀商品已抢完");
        }
        if (remain == -3) {
            // Redis key 丢失（宕机/被清），从 DB 恢复后重试一次
            preheatStock(sessionId);
            remain = claimAtomically(sessionId, userId);
            if (remain < 0) {
                throw new BusinessException("秒杀商品已抢完");
            }
        }

        // 4. 落库：扣秒杀库存 + 扣商品/SKU库存 + 生成订单（编程式事务只包裹 DB 段）
        final ProductSku skuRef = sku;
        Long orderId;
        try {
            orderId = transactionTemplate.execute(status -> {
                if (seckillSessionMapper.deductStock(sessionId) == 0) {
                    throw new BusinessException("秒杀商品已抢完");
                }
                if (skuRef != null) {
                    if (productSkuMapper.deductStock(skuRef.getId(), 1) == 0) {
                        throw new BusinessException("商品规格库存不足");
                    }
                    syncProductStock(product.getId());
                } else {
                    if (productMapper.deductStock(product.getId(), 1) == 0) {
                        throw new BusinessException("商品库存不足");
                    }
                }
                Order order = createSeckillOrder(session, product, skuRef, userId, address);
                return order.getId();
            });
            log.info("秒杀商品成功 - sessionId={}, userId={}, orderId={}, remain={}",
                    sessionId, userId, orderId, remain);
        } catch (Exception e) {
            // 回滚 Redis 库存与已抢用户记录（DB 变更由编程式事务回滚）
            rollbackClaim(sessionId, userId);
            log.error("秒杀商品落库失败 - sessionId={}, userId={}", sessionId, userId, e);
            throw e;
        }
        return orderId;
    }

    /** SKU 扣减后回写商品总库存（与普通下单逻辑保持一致） */
    private void syncProductStock(Long productId) {
        List<ProductSku> skuList = productSkuMapper.selectList(
                new LambdaQueryWrapper<ProductSku>().eq(ProductSku::getProductId, productId));
        if (skuList.isEmpty()) return;
        int total = skuList.stream()
                .filter(s -> s.getStock() != null)
                .mapToInt(ProductSku::getStock)
                .sum();
        Product prod = productMapper.selectById(productId);
        if (prod != null) {
            prod.setStock(total);
            productMapper.updateById(prod);
        }
    }

    /** 创建秒杀商品订单（单商品、数量 1、秒杀价、待付款） */
    private Order createSeckillOrder(SeckillSession session, Product product, ProductSku sku,
                                     Long userId, Address address) {
        BigDecimal price = session.getSeckillPrice();
        String orderNo = System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8);

        String receiverAddress = (address.getProvince() == null ? "" : address.getProvince())
                + (address.getCity() == null ? "" : address.getCity())
                + (address.getDistrict() == null ? "" : address.getDistrict())
                + (address.getDetailAddress() == null ? "" : address.getDetailAddress());

        Order order = new Order();
        order.setOrderNo(orderNo);
        order.setUserId(userId);
        order.setTotalAmount(price);
        order.setPayAmount(price);
        order.setOrderStatus(0); // 待付款
        order.setReceiverName(address.getReceiverName());
        order.setReceiverPhone(address.getReceiverPhone());
        order.setReceiverAddress(receiverAddress);
        order.setSeckillSessionId(session.getId());
        orderMapper.insert(order);

        OrderShipment shipment = new OrderShipment();
        shipment.setOrderId(order.getId());
        shipment.setSellerId(product.getMerchantId());
        shipment.setDeliveryStatus(0);
        shipment.setTotalAmount(price);
        orderShipmentMapper.insert(shipment);

        OrderItem item = new OrderItem();
        item.setOrderId(order.getId());
        item.setShipmentId(shipment.getId());
        item.setProductId(product.getId());
        item.setSkuId(sku != null ? sku.getId() : null);
        if (sku != null && sku.getSpecs() != null) {
            try {
                @SuppressWarnings("unchecked")
                Map<String, Object> specsMap = objectMapper.readValue(sku.getSpecs(), Map.class);
                item.setSkuSpecs(specsMap.entrySet().stream()
                        .map(e -> e.getKey() + ":" + e.getValue())
                        .collect(Collectors.joining(", ")));
            } catch (Exception e) {
                item.setSkuSpecs(sku.getSpecs());
            }
        }
        item.setProductName(product.getName());
        item.setProductImage(product.getCoverImage());
        item.setPrice(price);
        item.setQuantity(1);
        orderItemMapper.insert(item);

        // 通知商家（失败不影响下单结果）
        try {
            noticeService.createAndPublish("新订单通知", "您有新的秒杀订单，订单号：" + orderNo, 3,
                    product.getMerchantId(), "new_order", order.getId());
        } catch (Exception e) {
            log.warn("秒杀订单商家通知发送失败 orderNo={}", orderNo, e);
        }
        log.info("秒杀商品订单创建成功 orderNo={}, sessionId={}, userId={}, price={}",
                orderNo, session.getId(), userId, price);
        return order;
    }

    /**
     * 每分钟扫描一次，自动更新秒杀场次状态
     * - 待开始 → 进行中（startTime ≤ now）
     * - 进行中 → 已结束（endTime ≤ now）
     */
    @Scheduled(cron = "0 * * * * *")
    public void autoUpdateStatus() {
        // 检查表是否存在，避免未建表时频繁报错
        try {
            seckillSessionMapper.selectCount(new LambdaQueryWrapper<SeckillSession>().last("limit 1"));
        } catch (Exception e) {
            return;
        }

        LocalDateTime now = LocalDateTime.now();
        try {
            boolean listChanged = false;
            // 待开始 → 进行中（同时预热 Redis 库存）
            List<SeckillSession> toStart = seckillSessionMapper.selectList(
                    new LambdaQueryWrapper<SeckillSession>()
                            .eq(SeckillSession::getStatus, SeckillSessionStatus.PENDING)
                            .le(SeckillSession::getStartTime, now));
            for (SeckillSession s : toStart) {
                // 按类型校验关联资源是否仍然有效，无效则自动撤销
                if (s.getSeckillType() != null && s.getSeckillType() == 1) {
                    // 秒杀商品：校验商品仍存在且上架
                    Product product = s.getProductId() != null ? productMapper.selectById(s.getProductId()) : null;
                    if (product == null || product.getStatus() == null || product.getStatus() != 1) {
                        s.setStatus(SeckillSessionStatus.CANCELLED);
                        seckillSessionMapper.updateById(s);
                        listChanged = true;
                        log.warn("秒杀场次 [{}] 已自动撤销，原因：秒杀商品无效", s.getSessionName());
                        continue;
                    }
                } else {
                    // 秒杀优惠券：校验优惠券仍存在且启用
                    Coupon coupon = couponMapper.selectById(s.getCouponId());
                    if (coupon == null || coupon.getStatus() != 1) {
                        s.setStatus(SeckillSessionStatus.CANCELLED);
                        seckillSessionMapper.updateById(s);
                        listChanged = true;
                        log.warn("秒杀场次 [{}] 已自动撤销，原因：关联优惠券无效", s.getSessionName());
                        continue;
                    }
                }

                s.setStatus(SeckillSessionStatus.ACTIVE);
                seckillSessionMapper.updateById(s);
                stringRedisTemplate.opsForValue().set(STOCK_KEY + s.getId(), String.valueOf(s.getSeckillStock()));
                listChanged = true;
                log.info("秒杀场次 [{}] 已自动开始，库存已预热：{}", s.getSessionName(), s.getSeckillStock());
            }

            // 进行中 → 已结束
            List<SeckillSession> toEnd = seckillSessionMapper.selectList(
                    new LambdaQueryWrapper<SeckillSession>()
                            .eq(SeckillSession::getStatus, SeckillSessionStatus.ACTIVE)
                            .le(SeckillSession::getEndTime, now));
            for (SeckillSession s : toEnd) {
                s.setStatus(SeckillSessionStatus.ENDED);
                seckillSessionMapper.updateById(s);
                cleanRedisKeys(s.getId());
                sessionCache.invalidate(s.getId());
                localSoldOut.remove(s.getId());
                listChanged = true;
                log.info("秒杀场次 [{}] 已自动结束，Redis 缓存已清理", s.getSessionName());
            }

            // 活跃场次集合发生变化时，清理场次列表缓存
            if (listChanged) {
                evictSessionsCache();
            }
        } catch (Exception e) {
            log.error("秒杀状态自动更新异常", e);
        }
    }

    /** 清理场次相关的 Redis 缓存 */
    private void cleanRedisKeys(Long sessionId) {
        stringRedisTemplate.delete(STOCK_KEY + sessionId);
        stringRedisTemplate.delete(USERS_KEY + sessionId);
    }

    /** 清除活跃场次列表缓存（影响活跃场次集合的变更后调用，短TTL作为兜底） */
    private void evictSessionsCache() {
        stringRedisTemplate.delete(SESSIONS_CACHE_KEY);
    }

    /** 场次变更后失效本地元数据缓存与本地售罄标记（与 Redis 层缓存清理同步） */
    private void evictLocalCache(SeckillSession session) {
        sessionCache.invalidate(session.getId());
        localSoldOut.remove(session.getId());
        if (session.getCouponId() != null) {
            couponCache.invalidate(session.getCouponId());
        }
        if (session.getProductId() != null) {
            productCache.invalidate(session.getProductId());
        }
    }
}
