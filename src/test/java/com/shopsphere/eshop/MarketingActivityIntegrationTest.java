package com.shopsphere.eshop;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.shopsphere.eshop.entity.MarketingActivity;
import com.shopsphere.eshop.entity.MarketingTask;
import com.shopsphere.eshop.entity.UserActivityRecord;
import com.shopsphere.eshop.entity.UserCoupon;
import com.shopsphere.eshop.entity.UserSigninRecord;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.MarketingActivityMapper;
import com.shopsphere.eshop.mapper.MarketingTaskMapper;
import com.shopsphere.eshop.mapper.UserActivityRecordMapper;
import com.shopsphere.eshop.mapper.UserCouponMapper;
import com.shopsphere.eshop.mapper.UserSigninRecordMapper;
import com.shopsphere.eshop.service.MarketingActivityService;
import com.shopsphere.eshop.vo.MarketingActivityVO;
import com.shopsphere.eshop.vo.MarketingTaskVO;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 营销活动模块集成测试（通用任务制 + 优惠券奖励）
 * <p>
 * 覆盖：
 * - 进行中活动列表返回任务与奖励券信息
 * - 未达标领取被拒绝
 * - 签到达标后可领取（发券 + 流水防重）
 * - 重复领取被拒绝
 * 说明：测试数据带唯一标记，用例结束后物理清理，不影响开发库。
 */
@SpringBootTest
class MarketingActivityIntegrationTest {

    @Autowired private MarketingActivityService marketingActivityService;
    @Autowired private MarketingActivityMapper activityMapper;
    @Autowired private MarketingTaskMapper taskMapper;
    @Autowired private UserActivityRecordMapper activityRecordMapper;
    @Autowired private UserSigninRecordMapper signinRecordMapper;
    @Autowired private UserCouponMapper userCouponMapper;
    @Autowired private JdbcTemplate jdbcTemplate;

    private final String marker = "MKT" + UUID.randomUUID().toString().substring(0, 8);
    private final Long testUserId = 4L; // lisi（USER 角色种子用户）
    private final Long rewardCouponId = 15L; // 签到专属无门槛券（启用中）

    private Long activityId;
    private Long taskId;
    private Long createdUserCouponId;

    @AfterEach
    void cleanup() {
        if (taskId != null) {
            jdbcTemplate.update("DELETE FROM marketing_task WHERE id = ?", taskId);
        }
        if (activityId != null) {
            jdbcTemplate.update("DELETE FROM marketing_activity WHERE id = ?", activityId);
            jdbcTemplate.update("DELETE FROM user_activity_record WHERE activity_id = ? AND source = 'MARKETING'", activityId);
        }
        if (createdUserCouponId != null) {
            jdbcTemplate.update("DELETE FROM user_coupon WHERE id = ?", createdUserCouponId);
        }
        jdbcTemplate.update("DELETE FROM user_signin_record WHERE user_id = ? AND sign_date >= ?", testUserId, LocalDate.now().minusDays(5));
    }

    private void insertActivityAndTask() {
        MarketingActivity a = new MarketingActivity();
        a.setActivityName("测试活动-" + marker);
        a.setActivityIcon("🎁");
        a.setStartTime(LocalDateTime.now().minusDays(3));
        a.setEndTime(LocalDateTime.now().plusDays(5));
        a.setStatus(1);
        a.setSortOrder(0);
        activityMapper.insert(a);
        activityId = a.getId();

        MarketingTask t = new MarketingTask();
        t.setActivityId(activityId);
        t.setTaskType("SIGNIN_DAYS");
        t.setTaskName("活动期间累计签到3天");
        t.setTargetValue(3);
        t.setRewardCouponId(rewardCouponId);
        t.setSortOrder(0);
        taskMapper.insert(t);
        taskId = t.getId();
    }

    @Test
    void marketingActivityFullFlow() {
        insertActivityAndTask();

        // 1. 进行中活动列表：游客视角返回任务与奖励券信息（无进度）
        List<MarketingActivityVO> active = marketingActivityService.listActive(null);
        MarketingActivityVO vo = active.stream()
                .filter(v -> v.getId().equals(activityId))
                .findFirst()
                .orElseThrow(() -> new AssertionError("进行中活动列表未包含测试活动"));
        assertEquals(1, vo.getTasks().size());
        MarketingTaskVO taskVO = vo.getTasks().get(0);
        assertEquals("SIGNIN_DAYS", taskVO.getTaskType());
        assertEquals("签到专属无门槛券", taskVO.getCouponName());
        assertNull(taskVO.getCurrentValue());

        // 2. 未达标领取 → 拒绝
        BusinessException notReady = assertThrows(BusinessException.class,
                () -> marketingActivityService.claimReward(testUserId, activityId, taskId));
        assertTrue(notReady.getMessage().contains("尚未达成"), "未达标提示不符: " + notReady.getMessage());

        // 3. 造 3 条活动期内签到记录 → 达标
        for (int i = 0; i < 3; i++) {
            UserSigninRecord r = new UserSigninRecord();
            r.setUserId(testUserId);
            r.setSignDate(LocalDate.now().minusDays(2 - i));
            r.setCreateTime(LocalDateTime.now());
            signinRecordMapper.insert(r);
        }

        // 4. 达标领取 → 成功发券
        marketingActivityService.claimReward(testUserId, activityId, taskId);
        UserCoupon uc = userCouponMapper.selectOne(new LambdaQueryWrapper<UserCoupon>()
                .eq(UserCoupon::getUserId, testUserId)
                .eq(UserCoupon::getCouponId, rewardCouponId)
                .orderByDesc(UserCoupon::getId)
                .last("LIMIT 1"));
        assertNotNull(uc, "领取后用户应获得优惠券");
        createdUserCouponId = uc.getId();
        long records = activityRecordMapper.selectCount(new LambdaQueryWrapper<UserActivityRecord>()
                .eq(UserActivityRecord::getUserId, testUserId)
                .eq(UserActivityRecord::getActivityId, activityId)
                .eq(UserActivityRecord::getTaskId, taskId));
        assertEquals(1, records, "领取流水应写入一条");

        // 5. 重复领取 → 拒绝（防重）
        BusinessException dup = assertThrows(BusinessException.class,
                () -> marketingActivityService.claimReward(testUserId, activityId, taskId));
        assertTrue(dup.getMessage().contains("已领取"), "防重提示不符: " + dup.getMessage());

        // 6. 用户视角：任务状态应为已领取(2)
        MarketingActivityVO detail = marketingActivityService.getDetail(activityId, testUserId);
        assertEquals(2, detail.getTasks().get(0).getTaskStatus(), "任务状态应为已领取");
    }
}
