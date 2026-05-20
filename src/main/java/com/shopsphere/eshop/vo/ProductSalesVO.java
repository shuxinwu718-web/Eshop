package com.shopsphere.eshop.vo;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class ProductSalesVO {
    private Long productId;
    private String productName;
    private String productImage;
    private BigDecimal price;
    private Integer stock;
    private Integer sales;
    private BigDecimal totalAmount;
}
