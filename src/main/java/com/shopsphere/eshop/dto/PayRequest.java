package com.shopsphere.eshop.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class PayRequest {
    private BigDecimal actualAmount;
}