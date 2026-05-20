package com.shopsphere.eshop.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class MerchantProductVO {
    private Long id;
    private String name;
    private Long categoryId;
    private String categoryName;
    private BigDecimal price;
    private Integer stock;
    private String coverImage;   // 封面（建议统一驼峰）
    private String description;
    private Integer status;
    private LocalDateTime createTime;
    private List<String> images; // 商品相册图片URL列表
}