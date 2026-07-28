package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

@Data
@TableName("product_size_chart")
public class ProductSizeChart {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long productId;
    private String chartTitle;
    private String columnsJson;  // JSON数组字符串
    private String rowsJson;     // JSON数组字符串
}
