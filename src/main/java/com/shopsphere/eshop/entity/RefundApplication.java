package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("refund_application")
public class RefundApplication {
    // 退款状态常量
    public static final int STATUS_PENDING_MERCHANT = 0;  // 待商户审核
    public static final int STATUS_PENDING_ADMIN = 1;      // 待管理员审核
    public static final int STATUS_APPROVED = 2;            // 已通过
    public static final int STATUS_REJECTED = 3;            // 已拒绝
    public static final int STATUS_REFUNDING = 4;           // 退款执行中
    public static final int STATUS_REFUNDED = 5;            // 已退款

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long orderId;
    private Long userId;
    private String reason;

    /** 退款原因分类ID */
    private Long reasonCategoryId;

    private Integer status;
    private String remark;
    private BigDecimal refundAmount;
    private LocalDateTime applyTime;
    private LocalDateTime auditTime;

    /** 商户审核时间 */
    private LocalDateTime merchantAuditTime;

    /** 管理员审核时间 */
    private LocalDateTime adminAuditTime;

    /** 退款执行时间 */
    private LocalDateTime refundTime;
}
