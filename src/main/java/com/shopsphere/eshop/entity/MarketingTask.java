package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 营销活动任务
 */
@Data
@TableName("marketing_task")
public class MarketingTask {
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 所属活动ID */
    private Long activityId;

    /** 任务类型: SIGNIN_DAYS-累计签到天数 ORDER_COUNT-已支付订单数 COLLECT_COUNT-收藏商品数 */
    private String taskType;

    /** 任务名称 */
    private String taskName;

    /** 目标值（如签到5天/下单3笔/收藏2件） */
    private Integer targetValue;

    /** 奖励优惠券ID */
    private Long rewardCouponId;

    /** 奖励展示图标(emoji) */
    private String rewardIcon;

    /** 排序（越小越靠前） */
    private Integer sortOrder;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;
}
