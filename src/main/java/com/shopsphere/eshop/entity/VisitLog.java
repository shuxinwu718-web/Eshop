package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("visit_log")
public class VisitLog {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private String ip;
    private String userAgent;
    /** HTTP 请求方法（GET/POST/...） */
    private String method;
    private String requestUri;
    /** HTTP 状态码（监控大盘：错误率统计） */
    private Integer statusCode;
    /** 请求耗时（毫秒，监控大盘：慢接口分析） */
    private Integer durationMs;
    private LocalDateTime visitTime;
}