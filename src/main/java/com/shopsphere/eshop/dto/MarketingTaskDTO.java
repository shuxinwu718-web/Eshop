package com.shopsphere.eshop.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 营销活动任务 DTO（随活动一起保存）
 */
@Data
public class MarketingTaskDTO {

    /** 任务ID（编辑时回填，新增为空） */
    private Long id;

    /** 任务类型: SIGNIN_DAYS-累计签到天数 ORDER_COUNT-已支付订单数 COLLECT_COUNT-收藏商品数 */
    @NotBlank(message = "任务类型不能为空")
    private String taskType;

    /** 任务名称 */
    @NotBlank(message = "任务名称不能为空")
    private String taskName;

    /** 目标值（如签到5天/下单3笔/收藏2件） */
    @NotNull(message = "目标值不能为空")
    private Integer targetValue;

    /** 奖励优惠券ID */
    @NotNull(message = "奖励优惠券不能为空")
    private Long rewardCouponId;

    /** 奖励展示图标(emoji) */
    private String rewardIcon;

    /** 排序（越小越靠前） */
    private Integer sortOrder;
}
