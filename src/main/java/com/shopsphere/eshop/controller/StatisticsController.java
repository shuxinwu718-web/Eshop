package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.VisitStatsDTO;
import com.shopsphere.eshop.dto.VisitTrendDTO;
import com.shopsphere.eshop.service.StatisticsService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/logs/statistics")
@RequiredArgsConstructor
@Tag(name = "日志管理", description = "统计访问记录")
public class StatisticsController {

    private final StatisticsService statisticsService;

    @GetMapping("/views/over")
    public Result<VisitStatsDTO> getVisitOverview() {
        return Result.success(statisticsService.getVisitOverview());
    }

    @GetMapping("/views/trend")
    public Result<VisitTrendDTO> getVisitTrend(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate) {
        return Result.success(statisticsService.getVisitTrend(startDate, endDate));
    }
}