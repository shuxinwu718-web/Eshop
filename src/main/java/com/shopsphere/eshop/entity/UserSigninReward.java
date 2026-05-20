package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;
// 专门用于签到奖励防重
@Data
@TableName("user_signin_reward")
public class UserSigninReward {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Integer rewardType; // 1-优惠券
    private Long rewardId;
    private Integer signinConsecutiveDays;
    private LocalDateTime createTime;
}