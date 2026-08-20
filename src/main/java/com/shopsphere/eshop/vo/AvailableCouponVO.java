package com.shopsphere.eshop.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 领券中心优惠券项（含当前用户已领取数量）
 */
@Data
public class AvailableCouponVO {
    private Long id;
    private String name;
    private Integer type;
    private BigDecimal value;
    private BigDecimal minAmount;
    private BigDecimal maxDiscount;
    private Integer stock;
    private Integer limitPerUser;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String description;
    /** 当前用户已持有（未使用且未过期）数量 */
    private Integer claimedCount;
}
