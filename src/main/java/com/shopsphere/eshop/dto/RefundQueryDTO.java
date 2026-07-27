package com.shopsphere.eshop.dto;

import lombok.Data;

@Data
public class RefundQueryDTO {
    private Integer pageNum = 1;
    private Integer pageSize = 10;
    private Integer status;
    private String orderNo;
}
