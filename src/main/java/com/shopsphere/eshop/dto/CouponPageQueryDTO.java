package com.shopsphere.eshop.dto;

import lombok.Data;

@Data
public class CouponPageQueryDTO {
    private Integer pageNum = 1;
    private Integer pageSize = 10;
    private String name;
    private Integer type;
    private Integer status;
}
