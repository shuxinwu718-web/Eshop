package com.shopsphere.eshop.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import jakarta.validation.constraints.NotNull;

@Data
@NoArgsConstructor
public class RefundApplyDTO {
    @NotNull
    private Long orderId;
    private String reason;

    /** 退款原因分类ID */
    private Long reasonCategoryId;
}
