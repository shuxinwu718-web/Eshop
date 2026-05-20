package com.shopsphere.eshop.dto;

import lombok.Data;

@Data
public class AuditRequest {
    private Integer status; // 1-通过 2-拒绝
    private String remark;  // 拒绝时填写原因
}