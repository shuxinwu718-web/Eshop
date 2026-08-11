package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 拼团活动（方案A：绑定单规格，参团同规格数量1）
 */
@Data
@TableName("group_buy_activity")
public class GroupBuyActivity {

    /** 草稿 */
    public static final int STATUS_DRAFT = 0;
    /** 进行中 */
    public static final int STATUS_ONGOING = 1;
    /** 已暂停 */
    public static final int STATUS_PAUSED = 2;
    /** 已终止 */
    public static final int STATUS_TERMINATED = 3;

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("merchant_id")
    private Long merchantId;

    @TableField("product_id")
    private Long productId;

    @TableField("sku_id")
    private Long skuId;

    @TableField("group_price")
    private BigDecimal groupPrice;

    @TableField("target_count")
    private Integer targetCount;

    @TableField("duration_hours")
    private Integer durationHours;

    @TableField("start_time")
    private LocalDateTime startTime;

    @TableField("end_time")
    private LocalDateTime endTime;

    @TableField("total_stock")
    private Integer totalStock;

    @TableField("sold_count")
    private Integer soldCount;

    private Integer status;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField("update_time")
    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;

    // ===== 列表展示附加字段（非表字段）=====

    @TableField(exist = false)
    private String productName;

    @TableField(exist = false)
    private String coverImage;

    @TableField(exist = false)
    private String skuSpecs;
}
