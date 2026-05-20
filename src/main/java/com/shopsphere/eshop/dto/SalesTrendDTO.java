package com.shopsphere.eshop.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

@Data
public class SalesTrendDTO {
    private List<String> dates;
    private List<BigDecimal> salesList;
    private List<Long> orderCountList;
}
