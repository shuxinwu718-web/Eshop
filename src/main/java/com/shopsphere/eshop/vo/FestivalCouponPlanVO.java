package com.shopsphere.eshop.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 节日优惠券活动计划 管理端视图对象（含关联优惠券信息）
 */
@Data
public class FestivalCouponPlanVO {

    private Long id;

    private Long couponId;

    /** 关联优惠券名称 */
    private String couponName;

    /** 优惠券类型：0=满减 1=折扣 */
    private Integer couponType;

    /** 优惠券面值 */
    private BigDecimal couponValue;

    /** 优惠券使用门槛 */
    private BigDecimal minAmount;

    /** 优惠券库存 */
    private Integer couponStock;

    private String festivalName;

    private String festivalIcon;

    private LocalDate startDate;

    private LocalDate endDate;

    private Integer requiredSigninDays;

    private String description;

    /** 0-停用 1-启用 */
    private Integer status;

    private LocalDateTime createTime;
}
