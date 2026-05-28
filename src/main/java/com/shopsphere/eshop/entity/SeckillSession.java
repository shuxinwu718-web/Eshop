package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("seckill_session")
public class SeckillSession {
    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("coupon_id")
    private Long couponId;

    @TableField("session_name")
    private String sessionName;

    @TableField("start_time")
    private LocalDateTime startTime;

    @TableField("end_time")
    private LocalDateTime endTime;

    @TableField("seckill_stock")
    private Integer seckillStock;

    @TableField("limit_per_user")
    private Integer limitPerUser;

    private Integer status;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;

    // 非数据库字段 — 关联的优惠券名称（用于列表展示）
    @TableField(exist = false)
    private String couponName;

    // 非数据库字段 — Redis 实时剩余库存
    @TableField(exist = false)
    private Integer remainStock;
}
