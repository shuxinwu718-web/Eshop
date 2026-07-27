package com.shopsphere.eshop.vo;

import lombok.Data;

@Data
public class SigninMilestoneVO {
    private Integer days;
    private String rewardName;
    private String rewardType;
    private Long rewardId;
    private String icon;
    private Integer status; // 0-未解锁 1-已达成 2-已领取
}
