package com.shopsphere.eshop.dto;

import lombok.Data;
import org.jetbrains.annotations.NotNull;


@Data
public class RefundAuditDTO {
    @NotNull
    private Long refundId;
    @NotNull
    private Integer status; // 1-通过 2-拒绝
    private String remark;  // 拒绝原因
}