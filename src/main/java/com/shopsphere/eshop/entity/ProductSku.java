package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;

@Data
@TableName("product_sku")
public class ProductSku {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long productId;
    private String specs;       // JSON键值对字符串，如{"颜色":"黑色","尺码":"41"}
    private BigDecimal price;
    private Integer stock;
    private String skuCode;
    private String image;
    private Integer sales;
}
