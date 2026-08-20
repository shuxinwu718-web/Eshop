package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.shopsphere.eshop.entity.Coupon;
import com.shopsphere.eshop.entity.FestivalCouponPlan;
import com.shopsphere.eshop.entity.UserCoupon;
import com.shopsphere.eshop.entity.UserSigninRecord;
import com.shopsphere.eshop.entity.UserSigninReward;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.CouponMapper;
import com.shopsphere.eshop.mapper.FestivalCouponPlanMapper;
import com.shopsphere.eshop.mapper.UserCouponMapper;
import com.shopsphere.eshop.mapper.UserSigninRecordMapper;
import com.shopsphere.eshop.mapper.UserSigninRewardMapper;
import com.shopsphere.eshop.service.UserCouponService;
import com.shopsphere.eshop.vo.AvailableCouponVO;
import com.shopsphere.eshop.vo.UserCouponVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/user/coupon")
@Tag(name = "用户折扣劵管理", description = "用户获取、使用折扣劵以及系统自动删除库存")
public class UserCouponServiceImpl implements UserCouponService {

    private final UserCouponMapper userCouponMapper;
    private final CouponMapper couponMapper;
    private final FestivalCouponPlanMapper festivalCouponPlanMapper;
    private final UserSigninRewardMapper signinRewardMapper;
    private final UserSigninRecordMapper signinRecordMapper;


    @Override
    public List<Coupon> getAvailableCoupons(Integer type, String keyword, String timeStatus) {
        LocalDateTime now = LocalDateTime.now();
        LambdaQueryWrapper<Coupon> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Coupon::getStatus, 1)
                .gt(Coupon::getStock, 0)
                .eq(Coupon::getObtainType, 0); // 仅普通领取的券显示在领券中心

        // 时间筛选
        if (timeStatus == null || "ongoing".equals(timeStatus)) {
            wrapper.and(w -> w.isNull(Coupon::getStartTime).or().le(Coupon::getStartTime, now))
                    .and(w -> w.isNull(Coupon::getEndTime).or().ge(Coupon::getEndTime, now));
        } else if ("upcoming".equals(timeStatus)) {
            wrapper.isNotNull(Coupon::getStartTime)
                    .gt(Coupon::getStartTime, now);
        }
        // "all" 不做时间过滤

        if (type != null) {
            wrapper.eq(Coupon::getType, type);
        }
        if (keyword != null && !keyword.isBlank()) {
            wrapper.like(Coupon::getName, keyword);
        }
        wrapper.orderByDesc(Coupon::getStartTime);
        return couponMapper.selectList(wrapper);
    }

    @Override
    public List<AvailableCouponVO> getAvailableCouponsWithClaim(Long userId, Integer type, String keyword, String timeStatus) {
        List<Coupon> coupons = getAvailableCoupons(type, keyword, timeStatus);
        return coupons.stream().map(c -> {
            AvailableCouponVO vo = new AvailableCouponVO();
            BeanUtils.copyProperties(c, vo);
            vo.setClaimedCount(userId == null ? 0 : countUsable(userId, c.getId()));
            return vo;
        }).collect(Collectors.toList());
    }

    @Override
    public List<UserCouponVO> getMyCoupons(Long userId, Integer status) {
        // 1. 根据状态查询用户券记录
        LambdaQueryWrapper<UserCoupon> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserCoupon::getUserId, userId);
        if (status != null) {
            wrapper.eq(UserCoupon::getStatus, status);
        }
        List<UserCoupon> userCoupons = userCouponMapper.selectList(wrapper);
        if (userCoupons.isEmpty()) return Collections.emptyList();

        // 2. 批量查询优惠券模板
        Set<Long> couponIds = userCoupons.stream().map(UserCoupon::getCouponId).collect(Collectors.toSet());
        List<Coupon> coupons = couponMapper.selectBatchIds(couponIds);
        Map<Long, Coupon> couponMap = coupons.stream().collect(Collectors.toMap(Coupon::getId, Function.identity()));

        LocalDateTime now = LocalDateTime.now();
        List<UserCouponVO> result = new ArrayList<>();

        for (UserCoupon uc : userCoupons) {
            Coupon coupon = couponMap.get(uc.getCouponId());
            if (coupon == null) continue;

            // 对于未使用券（status=0），检查是否过期，若是则更新为已过期并跳过
            if (status == null || status == 0) {
                if (coupon.getEndTime() != null && coupon.getEndTime().isBefore(now) && uc.getStatus() == 0) {
                    uc.setStatus(2);
                    userCouponMapper.updateById(uc);
                    continue; // 过期的券不返回
                }
            }

            UserCouponVO vo = new UserCouponVO();
            BeanUtils.copyProperties(coupon, vo);
            vo.setUserCouponId(uc.getId());
            vo.setExpireTime(coupon.getEndTime());
            vo.setStatus(uc.getStatus());
            result.add(vo);
        }
        return result;
    }

    @Override
    public int countUsable(Long userId, Long couponId) {
        if (userId == null || couponId == null) return 0;
        LocalDateTime now = LocalDateTime.now();
        Coupon coupon = couponMapper.selectById(couponId);
        List<UserCoupon> existing = userCouponMapper.selectList(
                new LambdaQueryWrapper<UserCoupon>()
                        .eq(UserCoupon::getUserId, userId)
                        .eq(UserCoupon::getCouponId, couponId)
        );
        int usable = 0;
        for (UserCoupon uc : existing) {
            if (uc.getStatus() != null && uc.getStatus() != 0) continue; // 已使用(1)/已过期(2)
            if (coupon != null && coupon.getEndTime() != null && coupon.getEndTime().isBefore(now)) continue; // 模板已过期
            usable++;
        }
        return usable;
    }

    @Override
    @Transactional
    public void receiveCoupon(Long userId, Long couponId) {
        Coupon coupon = couponMapper.selectById(couponId);
        if (coupon == null || coupon.getStatus() != 1) {
            throw new BusinessException("优惠券不存在或已下架");
        }
        // 仅允许领取普通领取类型的优惠券，防止绕过秒杀/签到等渠道
        Integer obtainType = coupon.getObtainType();
        if (obtainType != null && obtainType != 0) {
            throw new BusinessException("该优惠券不能直接领取");
        }
        // 先检查领取上限：仅统计「当前仍持有且可使用（未使用且未过期）」的券，
        // 已使用(1)/已过期(2 或模板已过期)的券不占用名额，避免过期券被误判为已拥有
        int usableCount = countUsable(userId, couponId);
        if (usableCount >= coupon.getLimitPerUser()) {
            throw new BusinessException("您已达到领取上限");
        }
        // 原子扣减库存：仅当库存充足时扣减成功，防止并发超发
        if (couponMapper.deductStock(couponId) == 0) {
            throw new BusinessException("优惠券已抢完");
        }
        // 发放用户券
        UserCoupon uc = new UserCoupon();
        uc.setUserId(userId);
        uc.setCouponId(couponId);
        uc.setStatus(0);
        uc.setGetTime(LocalDateTime.now());
        // 注意：没有 expireTime 字段，也不存 orderNo（此时订单号为空）
        userCouponMapper.insert(uc);
    }

    @Override
    @Transactional
    public void grantCoupon(Long userId, Long couponId) {
        Coupon coupon = couponMapper.selectById(couponId);
        if (coupon == null || coupon.getStatus() != 1) {
            throw new BusinessException("优惠券不存在或已停用");
        }
        // 直接插入用户券，不扣减库存，不检查限领次数
        UserCoupon uc = new UserCoupon();
        uc.setUserId(userId);
        uc.setCouponId(couponId);
        uc.setStatus(0);
        uc.setGetTime(LocalDateTime.now());
        // 如果 UserCoupon 有 expireTime 字段，可设置过期时间
        // uc.setExpireTime(coupon.getEndTime());
        userCouponMapper.insert(uc);
    }

    @Override
    public List<UserCouponVO> getMyUsableCoupons(Long userId) {
        // 查询用户所有未使用且未过期的优惠券
        // 方式：先查出用户未使用的 user_coupon 记录，再过滤 coupon.endTime >= now
        List<UserCoupon> userCoupons = userCouponMapper.selectList(
                new LambdaQueryWrapper<UserCoupon>()
                        .eq(UserCoupon::getUserId, userId)
                        .eq(UserCoupon::getStatus, 0)
        );
        if (userCoupons.isEmpty()) return Collections.emptyList();
        // 提取 couponId 列表
        Set<Long> couponIds = userCoupons.stream().map(UserCoupon::getCouponId).collect(Collectors.toSet());
        List<Coupon> coupons = couponMapper.selectBatchIds(couponIds);
        Map<Long, Coupon> couponMap = coupons.stream().collect(Collectors.toMap(Coupon::getId, Function.identity()));
        LocalDateTime now = LocalDateTime.now();
        List<UserCouponVO> result = new ArrayList<>();
        for (UserCoupon uc : userCoupons) {
            Coupon coupon = couponMap.get(uc.getCouponId());
            if (coupon == null) continue;
            // 检查有效期
            if (coupon.getEndTime() != null && coupon.getEndTime().isBefore(now)) {
                // 已过期，可更新 user_coupon 状态为 2 并跳过
                uc.setStatus(2);
                userCouponMapper.updateById(uc);
                continue;
            }
            UserCouponVO vo = new UserCouponVO();
            BeanUtils.copyProperties(coupon, vo);
            vo.setUserCouponId(uc.getId());  // 用户优惠券记录ID
            vo.setExpireTime(coupon.getEndTime());
            vo.setStatus(uc.getStatus());
            result.add(vo);
        }
        return result;
    }


    @Override
    @Transactional
    public void useCoupon(Long userCouponId, String orderNo) {
        UserCoupon uc = userCouponMapper.selectById(userCouponId);
        if (uc == null || uc.getStatus() != 0) {
            throw new BusinessException("优惠券不可用");
        }
        // 再次校验优惠券模板的有效期和规则
        Coupon coupon = couponMapper.selectById(uc.getCouponId());
        if (coupon == null || coupon.getStatus() != 1) {
            throw new BusinessException("优惠券无效");
        }
        if (coupon.getEndTime() != null && coupon.getEndTime().isBefore(LocalDateTime.now())) {
            throw new BusinessException("优惠券已过期");
        }
        // 标记已使用
        uc.setStatus(1);
        uc.setUseTime(LocalDateTime.now());
        uc.setOrderNo(orderNo);
        userCouponMapper.updateById(uc);
    }



    @Override
    public List<UserCouponVO> getUsableCoupons(Long userId, BigDecimal totalAmount) {
        // 获取用户所有未使用的优惠券（关联coupon表获取完整信息）
        List<UserCoupon> userCoupons = userCouponMapper.selectList(
                new LambdaQueryWrapper<UserCoupon>()
                        .eq(UserCoupon::getUserId, userId)
                        .eq(UserCoupon::getStatus, 0)
        );
        if (userCoupons.isEmpty()) return Collections.emptyList();

        // 批量查询优惠券模板
        List<Long> couponIds = userCoupons.stream().map(UserCoupon::getCouponId).collect(Collectors.toList());
        List<Coupon> coupons = couponMapper.selectBatchIds(couponIds);
        Map<Long, Coupon> couponMap = coupons.stream().collect(Collectors.toMap(Coupon::getId, Function.identity()));

        LocalDateTime now = LocalDateTime.now();
        List<UserCouponVO> result = new ArrayList<>();
        for (UserCoupon uc : userCoupons) {
            Coupon coupon = couponMap.get(uc.getCouponId());
            if (coupon == null) continue;
            // 检查有效期
            if (coupon.getEndTime() != null && coupon.getEndTime().isBefore(now)) {
                continue; // 已过期，不返回（也可以更新状态）
            }
            // 检查使用门槛
            if (totalAmount.compareTo(coupon.getMinAmount()) < 0) {
                continue;
            }
            UserCouponVO vo = new UserCouponVO();
            BeanUtils.copyProperties(coupon, vo);
            vo.setUserCouponId(uc.getId());
            vo.setExpireTime(coupon.getEndTime());
            vo.setStatus(uc.getStatus());
            result.add(vo);
        }
        return result;
    }

    @Override
    @Transactional
    public void claimFestivalCoupon(Long userId, Long planId) {
        FestivalCouponPlan plan = festivalCouponPlanMapper.selectById(planId);
        if (plan == null || plan.getStatus() != 1) {
            throw new BusinessException("活动不存在或已结束");
        }

        LocalDate today = LocalDate.now();
        if (today.isBefore(plan.getStartDate()) || today.isAfter(plan.getEndDate())) {
            throw new BusinessException("活动不在进行中");
        }

        // 获取用户连续签到天数
        int consecutiveDays = getConsecutiveDays(userId);

        if (consecutiveDays < plan.getRequiredSigninDays()) {
            throw new BusinessException("连续签到天数不足，还需" + (plan.getRequiredSigninDays() - consecutiveDays) + "天");
        }

        // 检查限领与是否已拥有：仅「未使用且未过期」的券算作已拥有，
        // 已使用/已过期的券不占用名额，允许再次领取
        Coupon coupon = couponMapper.selectById(plan.getCouponId());
        if (coupon == null || coupon.getStatus() != 1) {
            throw new BusinessException("活动优惠券不存在或已停用");
        }
        int usableCount = countUsable(userId, plan.getCouponId());
        if (usableCount >= coupon.getLimitPerUser()) {
            throw new BusinessException("您已达到该优惠券的领取上限");
        }
        if (usableCount > 0) {
            throw new BusinessException("已领取过该活动优惠券");
        }

        // 发放优惠券
        grantCoupon(userId, plan.getCouponId());

        // 记录奖励
        UserSigninReward reward = new UserSigninReward();
        reward.setUserId(userId);
        reward.setRewardType(2);
        reward.setRewardId(plan.getCouponId());
        reward.setSigninConsecutiveDays(consecutiveDays);
        reward.setCreateTime(LocalDateTime.now());
        signinRewardMapper.insert(reward);

        log.info("用户{}领取节日活动优惠券: planId={}, couponId={}", userId, planId, plan.getCouponId());
    }

    private int getConsecutiveDays(Long userId) {
        LocalDate today = LocalDate.now();
        // 今日是否签到
        boolean signedToday = signinRecordMapper.selectCount(
                new LambdaQueryWrapper<UserSigninRecord>()
                        .eq(UserSigninRecord::getUserId, userId)
                        .eq(UserSigninRecord::getSignDate, today)
        ) > 0;

        if (signedToday) {
            List<UserSigninRecord> records = signinRecordMapper.selectList(
                    new LambdaQueryWrapper<UserSigninRecord>()
                            .eq(UserSigninRecord::getUserId, userId)
                            .orderByDesc(UserSigninRecord::getSignDate)
            );
            int count = 1;
            LocalDate prev = today;
            for (UserSigninRecord r : records) {
                LocalDate sd = r.getSignDate();
                if (sd.equals(prev)) continue;
                if (sd.equals(prev.minusDays(1))) {
                    count++;
                    prev = sd;
                } else break;
            }
            return count;
        } else {
            boolean yesterdaySigned = signinRecordMapper.selectCount(
                    new LambdaQueryWrapper<UserSigninRecord>()
                            .eq(UserSigninRecord::getUserId, userId)
                            .eq(UserSigninRecord::getSignDate, today.minusDays(1))
            ) > 0;
            if (!yesterdaySigned) return 0;

            List<UserSigninRecord> records = signinRecordMapper.selectList(
                    new LambdaQueryWrapper<UserSigninRecord>()
                            .eq(UserSigninRecord::getUserId, userId)
                            .orderByDesc(UserSigninRecord::getSignDate)
            );
            int count = 0;
            LocalDate current = today.minusDays(1);
            for (UserSigninRecord r : records) {
                if (r.getSignDate().equals(current)) {
                    count++;
                    current = current.minusDays(1);
                } else break;
            }
            return count;
        }
    }


}
