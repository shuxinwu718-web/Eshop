package com.shopsphere.eshop.dto;

import lombok.Data;

import java.util.List;

@Data
public class VisitTrendDTO {
    private List<String> dates;
    private List<Long> pvList;
    private List<Long> ipList;   // 前端称为 ipList，实际是 UV 数量
}