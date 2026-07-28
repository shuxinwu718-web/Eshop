package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

@Data
@TableName("product_spec")
public class ProductSpec {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long productId;
    private String specName;
    private String specValues;  // JSON数组字符串
    private Integer sortOrder;
}
