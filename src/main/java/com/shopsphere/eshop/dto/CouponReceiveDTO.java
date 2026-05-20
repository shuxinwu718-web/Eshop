package com.shopsphere.eshop.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CouponReceiveDTO {
    @NotNull
    private Long couponId;
}