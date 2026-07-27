package com.shopsphere.eshop.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.jetbrains.annotations.NotNull;

@Data
@NoArgsConstructor
public class RefundApplyDTO {
    @NotNull
    private Long orderId;
    private String reason;

    /** 退款原因分类ID */
    private Long reasonCategoryId;
}
