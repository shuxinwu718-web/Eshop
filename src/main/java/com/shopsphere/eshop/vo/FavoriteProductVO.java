package com.shopsphere.eshop.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class FavoriteProductVO {
    private Long id;           // 收藏记录ID
    private Long productId;
    private String productName;
    private BigDecimal productPrice;
    private String productImage;
    private LocalDateTime createTime;
}