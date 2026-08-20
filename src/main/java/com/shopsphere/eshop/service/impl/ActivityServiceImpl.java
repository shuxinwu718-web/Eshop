package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.shopsphere.eshop.entity.*;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.*;
import com.shopsphere.eshop.service.ActivityService;
import com.shopsphere.eshop.service.UserCouponService;
import com.shopsphere.eshop.vo.FestivalCouponVO;
import com.shopsphere.eshop.vo.SigninMilestoneVO;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ActivityServiceImpl implements ActivityService {

    private final UserSigninRecordMapper signinRecordMapper;
    private final UserSigninRewardMapper signinRewardMapper;
    private final UserCouponService userCouponService;
    private final CouponMapper couponMapper;
    private final FestivalCouponPlanMapper festivalCouponPlanMapper;

    private static final List<MilestoneDef> MILESTONES = Arrays.asList(
            new MilestoneDef(3, "签到3天礼券", 21L, 1, "🎫"),
            new MilestoneDef(7, "签到7天折扣券", 22L, 1, "🎁"),
            new MilestoneDef(14, "签到14天满减券", 23L, 1, "🎁"),
            new MilestoneDef(30, "签到30天大奖券", 24L, 1, "🏆")
    );

    @Data
    @AllArgsConstructor
    private static class MilestoneDef {
        private int days;
        private String rewardName;
        private Long couponId;
        private Integer rewardType;
        private String icon;
    }

    @Override
    @Transactional
    public Coupon signIn(Long userId) {
        LocalDate today = LocalDate.now();

        // 1. 检查今日是否已签到
        LambdaQueryWrapper<UserSigninRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserSigninRecord::getUserId, userId)
                .eq(UserSigninRecord::getSignDate, today);
        if (signinRecordMapper.selectCount(wrapper) > 0) {
            throw new BusinessException("今日已签到");
        }

        // 2. 记录签到
        UserSigninRecord record = new UserSigninRecord();
        record.setUserId(userId);
        record.setSignDate(today);
        record.setCreateTime(LocalDateTime.now());
        signinRecordMapper.insert(record);

        // 3. 计算连续签到天数（包含今天）
        int consecutiveDays = getConsecutiveSignInDays(userId, today);

        // 4. 判断并发放奖励（可配置的里程碑奖励）
        Coupon rewardCoupon = null;
        for (MilestoneDef milestone : MILESTONES) {
            if (milestone.getCouponId() != null && consecutiveDays == milestone.getDays()) {
                // 仅「未使用且未过期」的券算作已拥有；已使用/已过期的券可再次领取（每次发放仍记录 reward 历史）
                int usable = userCouponService.countUsable(userId, milestone.getCouponId());
                Coupon coupon = couponMapper.selectById(milestone.getCouponId());
                boolean claimed = usable > 0
                        || (coupon != null && coupon.getStatus() != 1)
                        || (coupon != null && usable >= coupon.getLimitPerUser());
                if (!claimed) {
                    userCouponService.grantCoupon(userId, milestone.getCouponId());
                    UserSigninReward reward = new UserSigninReward();
                    reward.setUserId(userId);
                    reward.setRewardType(milestone.getRewardType());
                    reward.setRewardId(milestone.getCouponId());
                    reward.setSigninConsecutiveDays(consecutiveDays);
                    reward.setCreateTime(LocalDateTime.now());
                    signinRewardMapper.insert(reward);
                    rewardCoupon = coupon;
                    log.info("用户{}连续签到{}天，获得优惠券{}", userId, consecutiveDays, milestone.getCouponId());
                }
                break;
            }
        }
        return rewardCoupon;
    }

    private int getConsecutiveSignInDays(Long userId, LocalDate today) {
        LambdaQueryWrapper<UserSigninRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserSigninRecord::getUserId, userId)
                .orderByDesc(UserSigninRecord::getSignDate);
        List<UserSigninRecord> records = signinRecordMapper.selectList(wrapper);
        if (records.isEmpty()) return 1;

        int count = 1;
        LocalDate prevDate = today;
        for (UserSigninRecord r : records) {
            LocalDate signDate = r.getSignDate();
            if (signDate.equals(prevDate)) continue;
            if (signDate.equals(prevDate.minusDays(1))) {
                count++;
                prevDate = signDate;
            } else {
                break;
            }
        }
        return count;
    }

    @Override
    public List<String> getSignInRecords(Long userId) {
        LambdaQueryWrapper<UserSigninRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserSigninRecord::getUserId, userId)
                .orderByDesc(UserSigninRecord::getSignDate);
        List<UserSigninRecord> records = signinRecordMapper.selectList(wrapper);
        return records.stream()
                .map(r -> r.getSignDate().toString())
                .collect(Collectors.toList());
    }

    @Override
    public Map<String, Object> getSignInStatus(Long userId) {
        LocalDate today = LocalDate.now();
        LambdaQueryWrapper<UserSigninRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserSigninRecord::getUserId, userId)
                .eq(UserSigninRecord::getSignDate, today);
        boolean signedToday = signinRecordMapper.selectCount(wrapper) > 0;

        int consecutiveDays = 0;
        if (signedToday) {
            consecutiveDays = getConsecutiveSignInDays(userId, today);
        } else {
            LocalDate yesterday = today.minusDays(1);
            LambdaQueryWrapper<UserSigninRecord> yesterdayWrapper = new LambdaQueryWrapper<>();
            yesterdayWrapper.eq(UserSigninRecord::getUserId, userId)
                    .eq(UserSigninRecord::getSignDate, yesterday);
            if (signinRecordMapper.selectCount(yesterdayWrapper) > 0) {
                consecutiveDays = getConsecutiveSignInDaysFromDate(userId, yesterday);
            }
        }
        // 累计签到天数
        long totalDays = signinRecordMapper.selectCount(
                new LambdaQueryWrapper<UserSigninRecord>()
                        .eq(UserSigninRecord::getUserId, userId));

        Map<String, Object> result = new HashMap<>();
        result.put("signedToday", signedToday);
        result.put("consecutiveDays", consecutiveDays);
        result.put("totalDays", (int) totalDays);
        return result;
    }

    private int getConsecutiveSignInDaysFromDate(Long userId, LocalDate startDate) {
        LambdaQueryWrapper<UserSigninRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserSigninRecord::getUserId, userId)
                .orderByDesc(UserSigninRecord::getSignDate);
        List<UserSigninRecord> records = signinRecordMapper.selectList(wrapper);
        if (records.isEmpty()) return 0;
        int count = 0;
        LocalDate current = startDate;
        for (UserSigninRecord r : records) {
            if (r.getSignDate().equals(current)) {
                count++;
                current = current.minusDays(1);
            } else {
                break;
            }
        }
        return count;
    }

    @Override
    public List<SigninMilestoneVO> getMilestones(Long userId) {
        // 获取当前连续天数
        Map<String, Object> status = getSignInStatus(userId);
        int consecutiveDays = (int) status.get("consecutiveDays");

        List<SigninMilestoneVO> result = new ArrayList<>();
        for (MilestoneDef def : MILESTONES) {
            SigninMilestoneVO vo = new SigninMilestoneVO();
            vo.setDays(def.getDays());
            vo.setRewardName(def.getRewardName());
            vo.setRewardType(def.getCouponId() != null ? "coupon" : "none");
            vo.setRewardId(def.getCouponId());
            vo.setIcon(def.getIcon());
            // 仅「未使用且未过期」的券算作已领取；已使用/已过期的券视为可再次领取
            int usable = def.getCouponId() != null ? userCouponService.countUsable(userId, def.getCouponId()) : 0;
            if (usable > 0) {
                vo.setStatus(2); // 已领取（持有可用券）
            } else if (consecutiveDays >= def.getDays()) {
                vo.setStatus(1); // 已达成，可领取
            } else {
                vo.setStatus(0); // 未解锁
            }
            result.add(vo);
        }
        return result;
    }

    @Override
    public List<FestivalCouponVO> getFestivalCoupons(Long userId) {
        LocalDate today = LocalDate.now();

        // 查询进行中的活动
        List<FestivalCouponPlan> plans = festivalCouponPlanMapper.selectList(
                new LambdaQueryWrapper<FestivalCouponPlan>()
                        .eq(FestivalCouponPlan::getStatus, 1)
                        .le(FestivalCouponPlan::getStartDate, today)
                        .ge(FestivalCouponPlan::getEndDate, today)
        );

        if (plans.isEmpty()) return Collections.emptyList();

        // 批量加载优惠券信息
        Set<Long> couponIds = plans.stream().map(FestivalCouponPlan::getCouponId).collect(Collectors.toSet());
        List<Coupon> coupons = couponMapper.selectBatchIds(couponIds);
        Map<Long, Coupon> couponMap = coupons.stream().collect(Collectors.toMap(Coupon::getId, c -> c));

        // 获取用户连续签到天数（游客为 0）
        int consecutiveDays = 0;
        if (userId != null) {
            Map<String, Object> status = getSignInStatus(userId);
            consecutiveDays = (int) status.get("consecutiveDays");
        }

        // 查询用户已拥有的有效券（仅未使用且未过期算已领取，游客视为未领取）
        Map<Long, Boolean> claimedMap = new HashMap<>();
        for (FestivalCouponPlan plan : plans) {
            boolean claimed = false;
            if (userId != null && plan.getCouponId() != null) {
                claimed = userCouponService.countUsable(userId, plan.getCouponId()) > 0;
            }
            claimedMap.put(plan.getId(), claimed);
        }

        List<FestivalCouponVO> result = new ArrayList<>();
        for (FestivalCouponPlan plan : plans) {
            FestivalCouponVO vo = new FestivalCouponVO();
            vo.setId(plan.getId());
            vo.setCouponId(plan.getCouponId());
            vo.setFestivalName(plan.getFestivalName());
            vo.setFestivalIcon(plan.getFestivalIcon());
            vo.setStartDate(plan.getStartDate());
            vo.setEndDate(plan.getEndDate());
            vo.setRequiredSigninDays(plan.getRequiredSigninDays());
            vo.setDescription(plan.getDescription());

            Coupon coupon = couponMap.get(plan.getCouponId());
            if (coupon != null) {
                vo.setCouponName(coupon.getName());
                vo.setCouponType(coupon.getType());
                vo.setCouponValue(coupon.getValue());
                vo.setMinAmount(coupon.getMinAmount());
                vo.setCouponStock(coupon.getStock());
            }

            vo.setUserConsecutiveDays(consecutiveDays);
            vo.setCanClaim(consecutiveDays >= plan.getRequiredSigninDays() && !claimedMap.get(plan.getId()));
            vo.setAlreadyClaimed(claimedMap.get(plan.getId()));

            result.add(vo);
        }
        return result;
    }
}
