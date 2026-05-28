package com.shopsphere.eshop.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class SeckillSessionVO {
    private Long id;
    private Long couponId;
    private String sessionName;
    private String couponName;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Integer seckillStock;   // 总库存
    private Integer remainStock;    // 实时剩余库存
    private Integer limitPerUser;
    private Integer status;
}
