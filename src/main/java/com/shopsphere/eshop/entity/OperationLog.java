package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

//操作日志
@Data
@TableName("operation_log")
public class OperationLog {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long operatorId;
    private String operatorName;
    private String operationType;
    private String targetType;
    private Long targetId;
    private String content;
    private String requestUrl;
    private String requestParams;
    private String ip;
    private String userAgent;
    private LocalDateTime createTime;
}