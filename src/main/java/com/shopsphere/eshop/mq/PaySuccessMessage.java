package com.shopsphere.eshop.mq;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PaySuccessMessage implements Serializable {
    private Long orderId;
    private Long userId;
    private Long productId;
    private Integer quantity;
    private Long skuId;
    private BigDecimal payAmount;
}