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
    /** 使用该券可优惠金额（后端 CouponCalculator 计算，用于前端结算预览） */
    private BigDecimal discountAmount;
    /** 使用该券后实付金额（后端 CouponCalculator 计算，用于前端结算预览） */
    private BigDecimal payAmount;
}