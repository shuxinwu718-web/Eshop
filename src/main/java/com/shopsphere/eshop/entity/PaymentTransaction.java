package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 支付流水（支付宝）。out_trade_no 唯一约束是回调幂等的基石：
 * 同一笔订单的重复异步通知只会命中同一条流水，状态条件更新保证不重复入账。
 */
@Data
@TableName("payment_transaction")
public class PaymentTransaction {

    public static final int STATUS_PENDING = 0;   // 待支付
    public static final int STATUS_SUCCESS = 1;   // 支付成功
    public static final int STATUS_CLOSED  = 2;   // 已关闭（超时未付/查单确认关单）
    public static final int STATUS_REFUND_NEEDED = 3; // 支付成功但订单已取消（竞态），需退款补偿

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 商户订单号 = order.orderNo */
    @TableField("out_trade_no")
    private String outTradeNo;

    @TableField("order_id")
    private Long orderId;

    @TableField("user_id")
    private Long userId;

    @TableField("amount")
    private BigDecimal amount;

    /** 支付宝交易号 */
    @TableField("trade_no")
    private String tradeNo;

    /** 买家支付宝账号（脱敏） */
    @TableField("buyer_logon_id")
    private String buyerLogonId;

    @TableField("status")
    private Integer status;

    @TableField("notify_time")
    private LocalDateTime notifyTime;

    @TableField("create_time")
    private LocalDateTime createTime;

    @TableField("update_time")
    private LocalDateTime updateTime;
}
