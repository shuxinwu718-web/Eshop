package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 拼团成员（每个参团用户一行，含开团人）
 */
@Data
@TableName("group_buy_member")
public class GroupBuyMember {

    /** 开团 */
    public static final int ROLE_LEADER = 1;
    /** 参团 */
    public static final int ROLE_MEMBER = 0;

    /** 待支付 */
    public static final int PAY_PENDING = 0;
    /** 已支付 */
    public static final int PAY_PAID = 1;

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("group_id")
    private Long groupId;

    @TableField("user_id")
    private Long userId;

    @TableField("order_id")
    private Long orderId;

    private Integer role;

    @TableField("pay_status")
    private Integer payStatus;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableLogic
    private Integer deleted;
}
