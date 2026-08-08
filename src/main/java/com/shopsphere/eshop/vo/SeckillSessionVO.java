package com.shopsphere.eshop.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class SeckillSessionVO {
    private Long id;
    private Integer seckillType;    // 0=秒杀优惠券 1=秒杀商品
    private Long couponId;
    private String sessionName;
    private String couponName;
    private Long productId;         // 秒商品模式
    private Long skuId;
    private BigDecimal seckillPrice;    // 秒杀价
    private String productName;
    private String coverImage;
    private BigDecimal originalPrice;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Integer seckillStock;   // 总库存
    private Integer remainStock;    // 实时剩余库存
    private Integer limitPerUser;
    private Integer status;
    private Boolean isSeckilled;    // 当前登录用户是否已抢购/领取
}
