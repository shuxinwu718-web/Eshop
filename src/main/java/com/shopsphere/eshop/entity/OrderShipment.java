package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("order_shipment")
public class OrderShipment {
    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("order_id")
    private Long orderId;

    @TableField("seller_id")
    private Long sellerId;

    @TableField("delivery_status")
    private Integer deliveryStatus;

    @TableField("shipping_name")
    private String shippingName;

    @TableField("shipping_no")
    private String shippingNo;

    @TableField("shipping_time")
    private LocalDateTime shippingTime;

    @TableField("received_time")
    private LocalDateTime receivedTime;

    @TableField("total_amount")
    private BigDecimal totalAmount;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
