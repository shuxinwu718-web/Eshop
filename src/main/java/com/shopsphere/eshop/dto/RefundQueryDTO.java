package com.shopsphere.eshop.dto;

import lombok.Data;

@Data
public class RefundQueryDTO {
    private Integer pageNum = 1;
    private Integer pageSize = 10;
    private Integer status; // 0-待审核 1-已通过 2-已拒绝
    private String orderNo;
}