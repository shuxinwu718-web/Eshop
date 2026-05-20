package com.shopsphere.eshop.dto;

import lombok.Data;

@Data
public class OrderPageQueryDTO {
    private Integer pageNum = 1;
    private Integer pageSize = 10;
    private Integer status; // 订单状态
    private String orderNo; // 订单号模糊搜索
}