package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@TableName("product")
public class Product {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long merchantId;  // 商家ID
    private String name;
    private Long categoryId;
    private BigDecimal price;
    private Integer stock;
    private String description;
    private String coverImage;
    private Integer status;  // 0-下架 1-上架
    private Integer sales;   // 销量
    private Integer views;   // 浏览量（Redis 计数，定时落库）
    private String namePinyin; // 商品名称拼音（用于拼音搜索）
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;

    @TableField(exist = false)
    private String merchantName;

    @TableField(exist = false)
    private String merchantAvatar;

    @TableField(exist = false)
    private List<ProductSpec> specs;

    @TableField(exist = false)
    private List<ProductSku> skus;

    @TableField(exist = false)
    private String sizeChartTitle;

    @TableField(exist = false)
    private List<String> sizeChartColumns;

    @TableField(exist = false)
    private List<List<String>> sizeChartRows;
}