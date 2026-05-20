package com.shopsphere.eshop.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class CouponSaveDTO {
    private Long id;

    @NotBlank(message = "优惠券名称不能为空")
    private String name;

    @NotNull(message = "类型不能为空")
    private Integer type;

    @NotNull(message = "面值不能为空")
    private BigDecimal value;

    private BigDecimal minAmount;

    private BigDecimal maxDiscount;

    private Integer stock;

    private Integer limitPerUser;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime startTime;

    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime endTime;

    private Integer status;

    private String description;
}
