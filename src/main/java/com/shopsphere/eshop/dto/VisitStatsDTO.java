package com.shopsphere.eshop.dto;

import lombok.Data;
import java.util.List;

@Data
public class VisitStatsDTO {
    private Long todayUvCount;
    private Double uvGrowthRate;
    private Long totalUvCount;
    private Long todayPvCount;
    private Double pvGrowthRate;
    private Long totalPvCount;
}

