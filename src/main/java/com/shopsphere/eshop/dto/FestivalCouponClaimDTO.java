package com.shopsphere.eshop.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class FestivalCouponClaimDTO {
    @NotNull
    private Long planId;
}
