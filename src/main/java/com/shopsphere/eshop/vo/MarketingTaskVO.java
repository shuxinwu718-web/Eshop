package com.shopsphere.eshop.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 营销活动任务 VO（含用户进度）
 */
@Data
public class MarketingTaskVO {

    private Long id;

    private Long activityId;

    /** 任务类型: SIGNIN_DAYS / ORDER_COUNT / COLLECT_COUNT */
    private String taskType;

    private String taskName;

    private Integer targetValue;

    private Long rewardCouponId;

    private String rewardIcon;

    // ---------- 奖励券展示 ----------
    private String couponName;
    private Integer couponType;   // 0满减 1折扣
    private BigDecimal couponValue;
    private BigDecimal minAmount;

    // ---------- 用户进度 ----------
    /** 当前进度值（如已签到 3 天） */
    private Integer currentValue;

    /** 任务状态：0-未达成 1-可领取 2-已领取 */
    private Integer taskStatus;

    public boolean canClaim() {
        return taskStatus != null && taskStatus == 1;
    }
}
