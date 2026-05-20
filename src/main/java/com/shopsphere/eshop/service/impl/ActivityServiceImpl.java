package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.shopsphere.eshop.entity.Coupon;
import com.shopsphere.eshop.entity.UserSigninRecord;
import com.shopsphere.eshop.entity.UserSigninReward;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.CouponMapper;
import com.shopsphere.eshop.mapper.UserSigninRecordMapper;
import com.shopsphere.eshop.mapper.UserSigninRewardMapper;
import com.shopsphere.eshop.service.ActivityService;
import com.shopsphere.eshop.service.UserCouponService;
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

        // 4. 判断并发放奖励（每连续7天发放一次，且不重复）
        Coupon rewardCoupon = null;
        if (consecutiveDays % 7 == 0) {
            // 检查是否已领取过此轮奖励
            LambdaQueryWrapper<UserSigninReward> rewardWrapper = new LambdaQueryWrapper<>();
            rewardWrapper.eq(UserSigninReward::getUserId, userId)
                    .eq(UserSigninReward::getSigninConsecutiveDays, consecutiveDays);
            if (signinRewardMapper.selectCount(rewardWrapper) == 0) {
                Long couponId = getRewardCouponId(consecutiveDays);
                if (couponId != null) {
                    userCouponService.grantCoupon(userId, couponId);
                    // 记录奖励
                    UserSigninReward reward = new UserSigninReward();
                    reward.setUserId(userId);
                    reward.setRewardType(1);
                    reward.setRewardId(couponId);
                    reward.setSigninConsecutiveDays(consecutiveDays);
                    reward.setCreateTime(LocalDateTime.now());
                    signinRewardMapper.insert(reward);
                    rewardCoupon = couponMapper.selectById(couponId);
                    log.info("用户{}连续签到{}天，获得优惠券{}", userId, consecutiveDays, couponId);
                }
            }
        }
        return rewardCoupon;
    }

    private int getConsecutiveSignInDays(Long userId, LocalDate today) {
        // 查询用户所有签到日期，按日期降序
        LambdaQueryWrapper<UserSigninRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserSigninRecord::getUserId, userId)
                .orderByDesc(UserSigninRecord::getSignDate);
        List<UserSigninRecord> records = signinRecordMapper.selectList(wrapper);
        if (records.isEmpty()) return 1; // 今天已签，连续1天

        int count = 1;
        LocalDate prevDate = today;
        for (UserSigninRecord r : records) {
            LocalDate signDate = r.getSignDate();
            if (signDate.equals(prevDate)) continue; // 跳过今天
            if (signDate.equals(prevDate.minusDays(1))) {
                count++;
                prevDate = signDate;
            } else {
                break;
            }
        }
        return count;
    }

    private Long getRewardCouponId(int consecutiveDays) {
        // 示例配置：7天->优惠券ID=1，14天->优惠券ID=2
        // 实际可从数据库规则表读取
        switch (consecutiveDays) {
            case 7: return 3L;
            case 14: return 4L;
            default: return null;
        }
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
        // 今日是否签到
        LambdaQueryWrapper<UserSigninRecord> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(UserSigninRecord::getUserId, userId)
                .eq(UserSigninRecord::getSignDate, today);
        boolean signedToday = signinRecordMapper.selectCount(wrapper) > 0;

        int consecutiveDays = 0;
        if (signedToday) {
            consecutiveDays = getConsecutiveSignInDays(userId, today);
        } else {
            // 未签到时，从昨天开始往前数
            LocalDate yesterday = today.minusDays(1);
            LambdaQueryWrapper<UserSigninRecord> yesterdayWrapper = new LambdaQueryWrapper<>();
            yesterdayWrapper.eq(UserSigninRecord::getUserId, userId)
                    .eq(UserSigninRecord::getSignDate, yesterday);
            if (signinRecordMapper.selectCount(yesterdayWrapper) > 0) {
                consecutiveDays = getConsecutiveSignInDaysFromDate(userId, yesterday);
            }
        }
        Map<String, Object> result = new HashMap<>();
        result.put("signedToday", signedToday);
        result.put("consecutiveDays", consecutiveDays);
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
}