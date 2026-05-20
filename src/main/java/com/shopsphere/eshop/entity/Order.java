package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("`order`")
public class Order {
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

    @TableField("type")
    private Integer type;

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
