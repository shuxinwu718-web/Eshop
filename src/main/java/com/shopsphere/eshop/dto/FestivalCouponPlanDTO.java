package com.shopsphere.eshop.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;

/**
 * 节日优惠券活动计划 新增/编辑 请求参数
 */
@Data
public class FestivalCouponPlanDTO {

    private Long id;

    @NotNull(message = "关联优惠券不能为空")
    private Long couponId;

    @NotBlank(message = "活动名称不能为空")
    private String festivalName;

    private String festivalIcon;

    @NotNull(message = "开始日期不能为空")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate startDate;

    @NotNull(message = "结束日期不能为空")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate endDate;

    @NotNull(message = "所需签到天数不能为空")
    private Integer requiredSigninDays;

    private String description;

    private Integer status;
}
