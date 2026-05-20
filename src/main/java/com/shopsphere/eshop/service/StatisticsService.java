package com.shopsphere.eshop.service;

import com.shopsphere.eshop.dto.VisitStatsDTO;
import com.shopsphere.eshop.dto.VisitTrendDTO;
import java.time.LocalDate;

public interface StatisticsService {
    VisitStatsDTO getVisitOverview();
    VisitTrendDTO getVisitTrend(LocalDate startDate, LocalDate endDate);
}