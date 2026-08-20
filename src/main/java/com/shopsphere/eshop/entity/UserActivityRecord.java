package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户活动领取记录（营销活动奖励防重流水，复用既有表）
 */
@Data
@TableName("user_activity_record")
public class UserActivityRecord {
    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private Long activityId;

    /** 领取的优惠券ID（关联coupon表） */
    private Long couponId;

    /** 营销任务ID（营销活动按任务防重；节日活动/签到等场景为空） */
    private Long taskId;

    /** 来源：ACTIVITY-活动领取，SIGNIN-签到，LOTTERY-抽奖，MARKETING-营销活动 */
    private String source;

    private LocalDateTime createTime;
}
