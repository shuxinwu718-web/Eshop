package com.shopsphere.eshop.dto;

import lombok.Data;

@Data
public class SeckillSessionPageQueryDTO {
    private Integer pageNum = 1;
    private Integer pageSize = 10;
    private String sessionName;
    private Integer status;
    private Long couponId;
}
