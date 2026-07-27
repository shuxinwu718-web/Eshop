package com.shopsphere.eshop.dto;

import lombok.Data;
import org.jetbrains.annotations.NotNull;

@Data
public class RefundAuditDTO {
    @NotNull
    private Long refundId;
    @NotNull
    private Integer status; // 2=通过 3=拒绝 4=执行退款
    private String remark;

    /** 操作人角色：MERCHANT / ADMIN */
    private String operatorRole;
}
