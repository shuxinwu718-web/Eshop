package com.shopsphere.eshop.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class TopProductDTO {
    private Long productId;
    private String productName;
    private String productImage;
    private Integer totalQuantity;
    private BigDecimal totalAmount;
}
