package com.shopsphere.eshop.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.jetbrains.annotations.NotNull;

// 申请退款
@Data
@NoArgsConstructor
public class RefundApplyDTO {
    @NotNull
    private Long orderId;
    private String reason;
}