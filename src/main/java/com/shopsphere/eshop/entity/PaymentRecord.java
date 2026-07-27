package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("payment_record")
public class PaymentRecord {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long orderId;
    private String orderNo;
    private Long userId;
    private BigDecimal amount;
    private String payMethod;
    private String tradeNo;
    private Integer status;
    private LocalDateTime payTime;
    private LocalDateTime refundTime;
}
