package com.shopsphere.eshop.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

//用户申请订单退款
@Data
public class RefundApplicationVO {
    private Long id;
    private Long orderId;
    private String orderNo;
    private Long userId;
    private String username;
    private String reason;
    private Integer status;
    private String remark;
    private BigDecimal refundAmount;
    private LocalDateTime applyTime;
    private LocalDateTime auditTime;
}