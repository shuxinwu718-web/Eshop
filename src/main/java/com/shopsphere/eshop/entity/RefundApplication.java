package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

// 退款申请
@Data
@TableName("refund_application")
public class RefundApplication {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long orderId;
    private Long userId;
    private String reason;
    private Integer status;
    private String remark;
    private BigDecimal refundAmount;
    private LocalDateTime applyTime;
    private LocalDateTime auditTime;
}