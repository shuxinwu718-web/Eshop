package com.shopsphere.eshop.dto;

import lombok.Data;

@Data
public class ProductPageQueryDTO {
    private Integer pageNum = 1;
    private Integer pageSize = 10;
    private String name;      // 模糊搜索
    private Long categoryId;
    private Integer status;   // 0-下架 1-上架
    private Double minPrice;  // 最低价（ES 降级搜索用）
    private Double maxPrice;  // 最高价（ES 降级搜索用）
    private String sortBy;    // price_asc / price_desc / sales / newest（ES 降级搜索用）
}