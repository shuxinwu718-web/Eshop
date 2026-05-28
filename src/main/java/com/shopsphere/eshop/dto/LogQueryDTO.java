package com.shopsphere.eshop.dto;

import lombok.Data;
//  管理员查询日志接口
@Data
public class LogQueryDTO {
    private Integer pageNum = 1;
    private Integer pageSize = 10;
    private Long operatorId;
    private String operationType;
    private String targetType;
    private String startTime;
    private String endTime;
}