package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("seckill_session")
public class SeckillSession {
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 场次类型：0=秒杀优惠券 1=秒杀商品 */
    @TableField("seckill_type")
    private Integer seckillType;

    @TableField("coupon_id")
    private Long couponId;

    /** 秒杀商品ID（seckill_type=1） */
    @TableField("product_id")
    private Long productId;

    /** 指定SKU ID（seckill_type=1，可选） */
    @TableField("sku_id")
    private Long skuId;

    /** 秒杀价（seckill_type=1） */
    @TableField("seckill_price")
    private BigDecimal seckillPrice;

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

    // 非数据库字段 — 秒杀商品信息（用于列表展示）
    @TableField(exist = false)
    private String productName;

    @TableField(exist = false)
    private String coverImage;

    @TableField(exist = false)
    private BigDecimal originalPrice;

    // 非数据库字段 — Redis 实时剩余库存
    @TableField(exist = false)
    private Integer remainStock;
}
