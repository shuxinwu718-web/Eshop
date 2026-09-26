package com.shopsphere.eshop.mq;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class VisitLogMessage implements Serializable {
    private Long userId;
    private String ip;
    private String userAgent;
    /** HTTP 请求方法（GET/POST/...，独立存储供监控大盘筛选展示） */
    private String method;
    private String requestUri;
    /** HTTP 状态码 */
    private Integer statusCode;
    /** 请求耗时（毫秒） */
    private Integer durationMs;
    private LocalDateTime visitTime;
}