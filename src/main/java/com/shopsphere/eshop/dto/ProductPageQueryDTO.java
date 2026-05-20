package com.shopsphere.eshop.dto;

import lombok.Data;

@Data
public class ProductPageQueryDTO {
    private Integer pageNum = 1;
    private Integer pageSize = 10;
    private String name;      // 模糊搜索
    private Long categoryId;
    private Integer status;   // 0-下架 1-上架
}