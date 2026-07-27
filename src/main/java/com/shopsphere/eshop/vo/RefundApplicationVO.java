package com.shopsphere.eshop.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class RefundApplicationVO {
    private Long id;
    private Long orderId;
    private String orderNo;
    private Long userId;
    private String username;
    private String reason;
    private Long reasonCategoryId;
    private String reasonCategoryName;
    private Integer status;
    private String remark;
    private BigDecimal refundAmount;
    private LocalDateTime applyTime;
    private LocalDateTime auditTime;
    private LocalDateTime merchantAuditTime;
    private LocalDateTime adminAuditTime;
    private LocalDateTime refundTime;
}
