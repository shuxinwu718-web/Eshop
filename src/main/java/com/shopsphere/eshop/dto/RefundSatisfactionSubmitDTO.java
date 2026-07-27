package com.shopsphere.eshop.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class RefundSatisfactionSubmitDTO {
    @NotNull
    private Long refundId;
    @NotNull
    private Integer rating;
    private String feedback;
}
