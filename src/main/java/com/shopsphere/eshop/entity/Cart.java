package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("cart")
public class Cart {
    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("user_id")
    private Long userId;

    @TableField("product_id")
    private Long productId;

    private Long skuId;        // 选中的SKU ID（无规格商品为null）

    private String skuSpecs;   // SKU规格描述，如"颜色:黑色, 尺码:41"

    private Integer quantity;
    private Integer selected; // 1-选中 0-未选中

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    // 以下为非数据库字段，用于联查填充
    @TableField(exist = false)
    private String productName;

    @TableField(exist = false)
    private BigDecimal productPrice;

    @TableField(exist = false)
    private String productImage;

    @TableField(exist = false)
    private Integer stock;
}