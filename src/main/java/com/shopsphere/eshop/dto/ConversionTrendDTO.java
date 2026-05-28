package com.shopsphere.eshop.dto;

import lombok.Data;
import java.util.List;

@Data
public class ConversionTrendDTO {
    private List<String> dates;
    private List<Long> visitorCountList;
    private List<Long> orderCountList;
    private List<Double> conversionRateList;
}
