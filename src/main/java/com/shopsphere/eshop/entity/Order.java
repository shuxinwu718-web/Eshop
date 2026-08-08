package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("`order`")
public class Order {
    // 订单状态常量
    public static final int STATUS_PENDING_PAY = 0;    // 待付款
    public static final int STATUS_PAID = 1;            // 已付款/待发货
    public static final int STATUS_SHIPPED = 2;         // 已发货
    public static final int STATUS_COMPLETED = 3;       // 已完成
    public static final int STATUS_CANCELLED = 4;       // 已取消
    public static final int STATUS_REFUNDING = 5;       // 退款中
    public static final int STATUS_REFUNDED = 6;        // 已退款

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("order_no")
    private String orderNo;

    @TableField("user_id")
    private Long userId;

    @TableField("total_amount")
    private BigDecimal totalAmount;

    @TableField("pay_amount")
    private BigDecimal payAmount;

    private Integer type;

    /** 秒杀场次ID（秒杀商品订单来源标记，取消/退款时用于回滚秒杀库存） */
    @TableField("seckill_session_id")
    private Long seckillSessionId;

    @TableField("pay_status")
    private Integer payStatus;

    @TableField("order_status")
    private Integer orderStatus;

    @TableField("receiver_name")
    private String receiverName;

    @TableField("receiver_phone")
    private String receiverPhone;

    @TableField("receiver_address")
    private String receiverAddress;

    private String remark;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField("pay_time")
    private LocalDateTime payTime;

    @TableField("finish_time")
    private LocalDateTime finishTime;

    @TableField("cancel_time")
    private LocalDateTime cancelTime;

    @TableLogic
    private Integer deleted;

    @TableField(exist = false)
    private BigDecimal totalPrice;
}
