package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.MarketingActivitySaveDTO;
import com.shopsphere.eshop.dto.MarketingTaskDTO;
import com.shopsphere.eshop.entity.*;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.*;
import com.shopsphere.eshop.service.MarketingActivityService;
import com.shopsphere.eshop.service.UserCouponService;
import com.shopsphere.eshop.vo.MarketingActivityVO;
import com.shopsphere.eshop.vo.MarketingTaskVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 平台营销活动服务实现
 * <p>
 * 任务类型（taskType）：
 * - SIGNIN_DAYS：活动期内累计签到天数（user_signin_record 按日去重）
 * - ORDER_COUNT：活动期内已支付订单数（order.pay_status=1）
 * - COLLECT_COUNT：活动期内收藏商品数（favorite）
 * <p>
 * 奖励发放：复用 UserCouponService.grantCoupon 直发优惠券，user_activity_record 按
 * (user_id, activity_id, task_id) 防重，同一任务每人仅可领取一次。
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class MarketingActivityServiceImpl implements MarketingActivityService {

    public static final String SOURCE_MARKETING = "MARKETING";
    private static final Set<String> TASK_TYPES = Set.of("SIGNIN_DAYS", "ORDER_COUNT", "COLLECT_COUNT");

    private final MarketingActivityMapper activityMapper;
    private final MarketingTaskMapper taskMapper;
    private final UserActivityRecordMapper activityRecordMapper;
    private final UserSigninRecordMapper signinRecordMapper;
    private final OrderMapper orderMapper;
    private final FavoriteMapper favoriteMapper;
    private final CouponMapper couponMapper;
    private final UserCouponService userCouponService;

    // ==================== 管理端 ====================

    @Override
    public Page<MarketingActivityVO> pageQuery(Integer pageNum, Integer pageSize, String keyword, Integer status) {
        LambdaQueryWrapper<MarketingActivity> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            wrapper.like(MarketingActivity::getActivityName, keyword);
        }
        if (status != null) {
            wrapper.eq(MarketingActivity::getStatus, status);
        }
        wrapper.orderByAsc(MarketingActivity::getSortOrder)
                .orderByDesc(MarketingActivity::getCreateTime);

        Page<MarketingActivity> page = activityMapper.selectPage(new Page<>(pageNum, pageSize), wrapper);
        Page<MarketingActivityVO> voPage = new Page<>(page.getCurrent(), page.getSize(), page.getTotal());
        voPage.setRecords(toActivityVOs(page.getRecords(), null));
        return voPage;
    }

    @Override
    public MarketingActivityVO getById(Long id) {
        MarketingActivity activity = activityMapper.selectById(id);
        if (activity == null) {
            throw new BusinessException("活动不存在");
        }
        return toActivityVO(activity, null);
    }

    @Override
    @Transactional
    public void add(MarketingActivitySaveDTO dto) {
        validate(dto);
        MarketingActivity activity = new MarketingActivity();
        BeanUtils.copyProperties(dto, activity);
        activity.setId(null);
        activityMapper.insert(activity);
        saveTasks(activity.getId(), dto.getTasks());
    }

    @Override
    @Transactional
    public void update(MarketingActivitySaveDTO dto) {
        if (dto.getId() == null) {
            throw new BusinessException("活动ID不能为空");
        }
        MarketingActivity exists = activityMapper.selectById(dto.getId());
        if (exists == null) {
            throw new BusinessException("活动不存在");
        }
        validate(dto);
        MarketingActivity activity = new MarketingActivity();
        BeanUtils.copyProperties(dto, activity);
        activityMapper.updateById(activity);
        // 任务整体重建：先删旧任务，再按新列表插入
        taskMapper.delete(new LambdaQueryWrapper<MarketingTask>()
                .eq(MarketingTask::getActivityId, dto.getId()));
        saveTasks(dto.getId(), dto.getTasks());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        activityMapper.deleteById(id);
        taskMapper.delete(new LambdaQueryWrapper<MarketingTask>()
                .eq(MarketingTask::getActivityId, id));
    }

    @Override
    public void changeStatus(Long id, Integer status) {
        if (status == null || (status != 0 && status != 1)) {
            throw new BusinessException("状态值不合法");
        }
        MarketingActivity activity = activityMapper.selectById(id);
        if (activity == null) {
            throw new BusinessException("活动不存在");
        }
        activity.setStatus(status);
        activityMapper.updateById(activity);
    }

    private void validate(MarketingActivitySaveDTO dto) {
        if (dto.getStartTime() == null || dto.getEndTime() == null) {
            throw new BusinessException("活动起止时间不能为空");
        }
        if (dto.getEndTime().isBefore(dto.getStartTime())) {
            throw new BusinessException("结束时间不能早于开始时间");
        }
        if (dto.getTasks() == null || dto.getTasks().isEmpty()) {
            throw new BusinessException("至少配置一个任务");
        }
        for (MarketingTaskDTO t : dto.getTasks()) {
            if (!TASK_TYPES.contains(t.getTaskType())) {
                throw new BusinessException("未知任务类型: " + t.getTaskType());
            }
            if (t.getTargetValue() == null || t.getTargetValue() <= 0) {
                throw new BusinessException("任务目标值必须大于0");
            }
            if (t.getRewardCouponId() == null) {
                throw new BusinessException("任务奖励优惠券不能为空");
            }
        }
    }

    private void saveTasks(Long activityId, List<MarketingTaskDTO> tasks) {
        int sort = 0;
        for (MarketingTaskDTO t : tasks) {
            MarketingTask task = new MarketingTask();
            task.setActivityId(activityId);
            task.setTaskType(t.getTaskType());
            task.setTaskName(t.getTaskName());
            task.setTargetValue(t.getTargetValue());
            task.setRewardCouponId(t.getRewardCouponId());
            task.setRewardIcon(t.getRewardIcon());
            task.setSortOrder(t.getSortOrder() != null ? t.getSortOrder() : sort++);
            taskMapper.insert(task);
        }
    }

    // ==================== 用户端 ====================

    @Override
    public List<MarketingActivityVO> listActive(Long userId) {
        LocalDateTime now = LocalDateTime.now();
        List<MarketingActivity> activities = activityMapper.selectList(
                new LambdaQueryWrapper<MarketingActivity>()
                        .eq(MarketingActivity::getStatus, 1)
                        .le(MarketingActivity::getStartTime, now)
                        .ge(MarketingActivity::getEndTime, now)
                        .orderByAsc(MarketingActivity::getSortOrder));
        return toActivityVOs(activities, userId);
    }

    @Override
    public MarketingActivityVO getDetail(Long id, Long userId) {
        MarketingActivity activity = activityMapper.selectById(id);
        if (activity == null) {
            throw new BusinessException("活动不存在");
        }
        return toActivityVO(activity, userId);
    }

    @Override
    @Transactional
    public void claimReward(Long userId, Long activityId, Long taskId) {
        MarketingActivity activity = activityMapper.selectById(activityId);
        if (activity == null || activity.getStatus() == null || activity.getStatus() != 1) {
            throw new BusinessException("活动已停用");
        }
        LocalDateTime now = LocalDateTime.now();
        if (activity.getStartTime() != null && now.isBefore(activity.getStartTime())) {
            throw new BusinessException("活动尚未开始");
        }
        if (activity.getEndTime() != null && now.isAfter(activity.getEndTime())) {
            throw new BusinessException("活动已结束");
        }

        MarketingTask task = taskMapper.selectById(taskId);
        if (task == null || !task.getActivityId().equals(activityId)) {
            throw new BusinessException("任务不存在");
        }

        // 防重：同一用户同一活动同一任务仅可领取一次
        Long claimed = activityRecordMapper.selectCount(new LambdaQueryWrapper<UserActivityRecord>()
                .eq(UserActivityRecord::getUserId, userId)
                .eq(UserActivityRecord::getActivityId, activityId)
                .eq(UserActivityRecord::getTaskId, taskId)
                .eq(UserActivityRecord::getSource, SOURCE_MARKETING));
        if (claimed != null && claimed > 0) {
            throw new BusinessException("该任务奖励已领取");
        }

        int current = calcTaskProgress(userId, task, activity);
        if (current < task.getTargetValue()) {
            throw new BusinessException("任务尚未达成，当前进度 " + current + "/" + task.getTargetValue());
        }

        userCouponService.grantCoupon(userId, task.getRewardCouponId());

        UserActivityRecord record = new UserActivityRecord();
        record.setUserId(userId);
        record.setActivityId(activityId);
        record.setCouponId(task.getRewardCouponId());
        record.setTaskId(taskId);
        record.setSource(SOURCE_MARKETING);
        record.setCreateTime(now);
        activityRecordMapper.insert(record);
    }

    // ==================== 组装 ====================

    private List<MarketingActivityVO> toActivityVOs(List<MarketingActivity> activities, Long userId) {
        if (activities == null || activities.isEmpty()) {
            return Collections.emptyList();
        }
        List<Long> activityIds = activities.stream().map(MarketingActivity::getId).collect(Collectors.toList());
        // 批量查任务与奖励券，避免 N+1
        List<MarketingTask> tasks = taskMapper.selectList(
                new LambdaQueryWrapper<MarketingTask>()
                        .in(MarketingTask::getActivityId, activityIds)
                        .orderByAsc(MarketingTask::getSortOrder));
        Map<Long, List<MarketingTask>> tasksByActivity = tasks.stream()
                .collect(Collectors.groupingBy(MarketingTask::getActivityId));

        List<Long> couponIds = tasks.stream().map(MarketingTask::getRewardCouponId).distinct().collect(Collectors.toList());
        Map<Long, Coupon> couponMap = couponIds.isEmpty() ? Collections.emptyMap()
                : couponMapper.selectBatchIds(couponIds).stream()
                        .collect(Collectors.toMap(Coupon::getId, Function.identity(), (a, b) -> a));

        // 用户已领取记录（仅一次批量查询）
        Map<Long, Set<Long>> claimedTaskIdsByActivity = Collections.emptyMap();
        if (userId != null) {
            List<UserActivityRecord> records = activityRecordMapper.selectList(
                    new LambdaQueryWrapper<UserActivityRecord>()
                            .eq(UserActivityRecord::getUserId, userId)
                            .in(UserActivityRecord::getActivityId, activityIds)
                            .eq(UserActivityRecord::getSource, SOURCE_MARKETING));
            claimedTaskIdsByActivity = records.stream()
                    .collect(Collectors.groupingBy(UserActivityRecord::getActivityId,
                            Collectors.mapping(UserActivityRecord::getTaskId, Collectors.toSet())));
        }
        Map<Long, Set<Long>> claimedFinal = claimedTaskIdsByActivity;

        LocalDateTime now = LocalDateTime.now();
        List<MarketingActivityVO> result = new ArrayList<>();
        for (MarketingActivity a : activities) {
            MarketingActivityVO vo = new MarketingActivityVO();
            BeanUtils.copyProperties(a, vo);
            vo.setTimeStatus(calcTimeStatus(a, now));
            List<MarketingTask> activityTasks = tasksByActivity.getOrDefault(a.getId(), Collections.emptyList());
            vo.setTasks(activityTasks.stream()
                    .map(t -> toTaskVO(t, couponMap.get(t.getRewardCouponId()),
                            claimedFinal.getOrDefault(a.getId(), Collections.emptySet()),
                            userId, a))
                    .collect(Collectors.toList()));
            result.add(vo);
        }
        return result;
    }

    private MarketingActivityVO toActivityVO(MarketingActivity a, Long userId) {
        return toActivityVOs(Collections.singletonList(a), userId).get(0);
    }

    private MarketingTaskVO toTaskVO(MarketingTask t, Coupon coupon, Set<Long> claimedTaskIds,
                                     Long userId, MarketingActivity activity) {
        MarketingTaskVO vo = new MarketingTaskVO();
        BeanUtils.copyProperties(t, vo);
        if (coupon != null) {
            vo.setCouponName(coupon.getName());
            vo.setCouponType(coupon.getType());
            vo.setCouponValue(coupon.getValue());
            vo.setMinAmount(coupon.getMinAmount());
        }
        if (userId != null) {
            int current = calcTaskProgress(userId, t, activity);
            vo.setCurrentValue(current);
            if (claimedTaskIds.contains(t.getId())) {
                vo.setTaskStatus(2); // 已领取
            } else if (current >= t.getTargetValue()) {
                vo.setTaskStatus(1); // 可领取
            } else {
                vo.setTaskStatus(0); // 未达成
            }
        }
        return vo;
    }

    /** 计算用户在活动时间范围内的任务进度 */
    private int calcTaskProgress(Long userId, MarketingTask task, MarketingActivity activity) {
        if (userId == null || activity == null) {
            return 0;
        }
        LocalDateTime start = activity.getStartTime() == null ? LocalDateTime.of(1970, 1, 1, 0, 0) : activity.getStartTime();
        LocalDateTime end = activity.getEndTime() == null ? LocalDateTime.now() : activity.getEndTime();
        switch (task.getTaskType()) {
            case "SIGNIN_DAYS": {
                // 活动期内累计签到天数（按日去重）
                List<UserSigninRecord> records = signinRecordMapper.selectList(
                        new LambdaQueryWrapper<UserSigninRecord>()
                                .eq(UserSigninRecord::getUserId, userId)
                                .between(UserSigninRecord::getSignDate, start.toLocalDate(), end.toLocalDate()));
                return (int) records.stream().map(UserSigninRecord::getSignDate).distinct().count();
            }
            case "ORDER_COUNT": {
                Long count = orderMapper.selectCount(new LambdaQueryWrapper<Order>()
                        .eq(Order::getUserId, userId)
                        .eq(Order::getPayStatus, 1)
                        .between(Order::getCreateTime, start, end));
                return count == null ? 0 : count.intValue();
            }
            case "COLLECT_COUNT": {
                Long count = favoriteMapper.selectCount(new LambdaQueryWrapper<Favorite>()
                        .eq(Favorite::getUserId, userId)
                        .between(Favorite::getCreateTime, start, end));
                return count == null ? 0 : count.intValue();
            }
            default:
                return 0;
        }
    }

    /** 活动时间状态：0-未开始 1-进行中 2-已结束 */
    private int calcTimeStatus(MarketingActivity a, LocalDateTime now) {
        if (a.getStartTime() != null && now.isBefore(a.getStartTime())) {
            return 0;
        }
        if (a.getEndTime() != null && now.isAfter(a.getEndTime())) {
            return 2;
        }
        return 1;
    }
}
