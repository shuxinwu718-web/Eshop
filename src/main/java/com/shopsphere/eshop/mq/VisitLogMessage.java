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
    private String requestUri;
    private LocalDateTime visitTime;
}