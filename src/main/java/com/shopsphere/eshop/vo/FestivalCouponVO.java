package com.shopsphere.eshop.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
public class FestivalCouponVO {
    private Long id;
    private Long couponId;
    private String festivalName;
    private String festivalIcon;
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer requiredSigninDays;
    private String description;

    // 优惠券信息
    private String couponName;
    private Integer couponType;
    private BigDecimal couponValue;
    private BigDecimal minAmount;
    private Integer couponStock;

    // 用户进度
    private Integer userConsecutiveDays;
    private boolean canClaim;
    private boolean alreadyClaimed;
}
