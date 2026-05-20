package com.shopsphere.eshop.vo;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class HotProductVO {
    private Long id;
    private String name;
    private BigDecimal price;
    private String coverImage;
    private String description;
    private Integer sales;
    private Double avgRating;
}
