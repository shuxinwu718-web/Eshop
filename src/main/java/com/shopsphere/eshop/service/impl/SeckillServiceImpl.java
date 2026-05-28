package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.constant.SeckillSessionStatus;
import com.shopsphere.eshop.dto.SeckillSessionSaveDTO;
import com.shopsphere.eshop.entity.Coupon;
import com.shopsphere.eshop.entity.SeckillSession;
import com.shopsphere.eshop.entity.UserCoupon;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.CouponMapper;
import com.shopsphere.eshop.mapper.SeckillSessionMapper;
import com.shopsphere.eshop.mapper.UserCouponMapper;
import com.shopsphere.eshop.service.SeckillService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class SeckillServiceImpl implements SeckillService {

    private static final String STOCK_KEY = "seckill:stock:";
    private static final String USERS_KEY = "seckill:users:";

    private final SeckillSessionMapper seckillSessionMapper;
    private final CouponMapper couponMapper;
    private final UserCouponMapper userCouponMapper;
    private final StringRedisTemplate stringRedisTemplate;

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

        return result;
    }

    @Override
    public SeckillSession getById(Long id) {
        SeckillSession session = seckillSessionMapper.selectById(id);
        if (session != null) {
            Coupon coupon = couponMapper.selectById(session.getCouponId());
            if (coupon != null) {
                session.setCouponName(coupon.getName());
            }
        }
        return session;
    }

    @Override
    @Transactional
    public void create(SeckillSessionSaveDTO dto) {
        // 校验优惠券存在且已启用
        Coupon coupon = couponMapper.selectById(dto.getCouponId());
        if (coupon == null) {
            throw new BusinessException("优惠券不存在");
        }
        if (coupon.getStatus() != 1) {
            throw new BusinessException("优惠券已停用，无法创建秒杀场次");
        }
        if (dto.getStartTime().isAfter(dto.getEndTime())) {
            throw new BusinessException("开始时间不能晚于结束时间");
        }
        if (dto.getStartTime().isBefore(LocalDateTime.now())) {
            throw new BusinessException("开始时间不能早于当前时间");
        }
        if (dto.getSeckillStock() <= 0) {
            throw new BusinessException("秒杀库存必须大于 0");
        }

        SeckillSession session = new SeckillSession();
        BeanUtils.copyProperties(dto, session);
        session.setStatus(SeckillSessionStatus.PENDING);
        if (session.getLimitPerUser() == null) {
            session.setLimitPerUser(1);
        }
        seckillSessionMapper.insert(session);

        // 预热 Redis 库存
        stringRedisTemplate.opsForValue().set(STOCK_KEY + session.getId(), String.valueOf(session.getSeckillStock()));
        log.info("秒杀场次 [{}] 创建成功，关联优惠券 [{}]，库存 {}", session.getSessionName(), coupon.getName(), session.getSeckillStock());
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

        // 如果正在修改优惠券，检查新优惠券是否有效
        if (dto.getCouponId() != null && !dto.getCouponId().equals(session.getCouponId())) {
            Coupon coupon = couponMapper.selectById(dto.getCouponId());
            if (coupon == null) {
                throw new BusinessException("优惠券不存在");
            }
            if (coupon.getStatus() != 1) {
                throw new BusinessException("优惠券已停用");
            }
        }

        // 如果减少库存，校验不能低于已领取数量
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
        log.info("秒杀场次 [{}] 已更新，库存 {}", session.getSessionName(), session.getSeckillStock());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        SeckillSession session = seckillSessionMapper.selectById(id);
        if (session == null) return;
        seckillSessionMapper.deleteById(id);
        cleanRedisKeys(id);
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
        log.info("秒杀场次 [{}] 已撤销", session.getSessionName());
    }

    @Override
    public void preheatStock(Long id) {
        SeckillSession session = seckillSessionMapper.selectById(id);
        if (session == null) {
            throw new BusinessException("秒杀场次不存在");
        }
        stringRedisTemplate.opsForValue().set(STOCK_KEY + id, String.valueOf(session.getSeckillStock()));
        log.info("场次 [{}] 库存已从 DB 恢复: {}", session.getSessionName(), session.getSeckillStock());
    }

    @Override
    @Transactional
    public void seckill(Long sessionId, Long userId) {
        // 1. 校验场次
        SeckillSession session = seckillSessionMapper.selectById(sessionId);
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

        // 1a. 校验关联优惠券仍然有效
        Coupon coupon = couponMapper.selectById(session.getCouponId());
        if (coupon == null) {
            throw new BusinessException("关联优惠券已不存在");
        }
        if (coupon.getStatus() != 1) {
            throw new BusinessException("关联优惠券已停用");
        }

        // 2. 检查重复领取（早于库存扣减，避免浪费 Redis 操作）
        String usersKey = USERS_KEY + sessionId;
        Boolean alreadyClaimed = stringRedisTemplate.opsForSet().isMember(usersKey, String.valueOf(userId));
        if (Boolean.TRUE.equals(alreadyClaimed)) {
            log.warn("秒杀失败 - 重复领取, sessionId={}, userId={}", sessionId, userId);
            throw new BusinessException("您已领取过该秒杀券");
        }

        // 3. Redis 扣减库存（原子操作）
        String stockKey = STOCK_KEY + sessionId;
        Long remain = stringRedisTemplate.opsForValue().decrement(stockKey);

        // 3a. Redis key 不存在（宕机/丢失），从 DB 恢复后再试
        if (remain == null) {
            preheatStock(sessionId);
            String recoveredStr = stringRedisTemplate.opsForValue().get(stockKey);
            int recovered = recoveredStr != null ? Integer.parseInt(recoveredStr) : 0;
            if (recovered <= 0) {
                throw new BusinessException("秒杀券已抢完");
            }
            remain = stringRedisTemplate.opsForValue().decrement(stockKey);
        }

        if (remain < 0) {
            stringRedisTemplate.opsForValue().increment(stockKey);
            throw new BusinessException("秒杀券已抢完");
        }

        // 4. 记录已领取用户（SADD 保证并发安全）
        Long added = stringRedisTemplate.opsForSet().add(usersKey, String.valueOf(userId));
        if (added == null || added == 0) {
            stringRedisTemplate.opsForValue().increment(stockKey);
            throw new BusinessException("您已领取过该秒杀券");
        }

        // 5. 落库
        try {
            SeckillSession fresh = seckillSessionMapper.selectById(sessionId);
            if (fresh.getSeckillStock() <= 0) {
                throw new BusinessException("秒杀券已抢完");
            }
            fresh.setSeckillStock(fresh.getSeckillStock() - 1);
            seckillSessionMapper.updateById(fresh);

            UserCoupon uc = new UserCoupon();
            uc.setUserId(userId);
            uc.setCouponId(session.getCouponId());
            uc.setStatus(0);
            uc.setGetTime(LocalDateTime.now());
            userCouponMapper.insert(uc);

            log.info("秒杀成功 - sessionId={}, userId={}, couponId={}, remain={}", sessionId, userId, session.getCouponId(), remain);
        } catch (Exception e) {
            stringRedisTemplate.opsForValue().increment(stockKey);
            stringRedisTemplate.opsForSet().remove(usersKey, String.valueOf(userId));
            log.error("秒杀落库失败 - sessionId={}, userId={}", sessionId, userId, e);
            throw e;
        }
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
            // 待开始 → 进行中（同时预热 Redis 库存）
            List<SeckillSession> toStart = seckillSessionMapper.selectList(
                    new LambdaQueryWrapper<SeckillSession>()
                            .eq(SeckillSession::getStatus, SeckillSessionStatus.PENDING)
                            .le(SeckillSession::getStartTime, now));
            for (SeckillSession s : toStart) {
                // 检查关联优惠券是否仍然有效，无效则自动撤销
                Coupon coupon = couponMapper.selectById(s.getCouponId());
                if (coupon == null || coupon.getStatus() != 1) {
                    s.setStatus(SeckillSessionStatus.CANCELLED);
                    seckillSessionMapper.updateById(s);
                    log.warn("秒杀场次 [{}] 已自动撤销，原因：关联优惠券无效", s.getSessionName());
                    continue;
                }

                s.setStatus(SeckillSessionStatus.ACTIVE);
                seckillSessionMapper.updateById(s);
                stringRedisTemplate.opsForValue().set(STOCK_KEY + s.getId(), String.valueOf(s.getSeckillStock()));
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
                log.info("秒杀场次 [{}] 已自动结束，Redis 缓存已清理", s.getSessionName());
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
}
