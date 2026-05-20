package com.shopsphere.eshop.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class UserCouponVO {
    private Long userCouponId;   // 对应 user_coupon 的 id，用于后续使用
    private Long id;
    private String name;
    private Integer type;
    private BigDecimal value;
    private BigDecimal minAmount;
    private BigDecimal maxDiscount;
    private LocalDateTime expireTime;
    private Integer status;
}