package com.shopsphere.eshop.service.impl;

import com.shopsphere.eshop.dto.VisitStatsDTO;
import com.shopsphere.eshop.dto.VisitTrendDTO;
import com.shopsphere.eshop.mapper.VisitLogMapper;
import com.shopsphere.eshop.service.StatisticsService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StatisticsServiceImpl implements StatisticsService {

    private final VisitLogMapper visitLogMapper;

    @Override
    public VisitStatsDTO getVisitOverview() {
        Long todayPV = visitLogMapper.countTodayPV();
        Long todayUV = visitLogMapper.countTodayUV();
        Long totalPV = visitLogMapper.countTotalPV();
        Long totalUV = visitLogMapper.countTotalUV();
        Long yesterdayPV = visitLogMapper.countYesterdayPV();
        Long yesterdayUV = visitLogMapper.countYesterdayUV();

        double uvGrowthRate = 0.0;
        if (yesterdayUV != null && yesterdayUV > 0) {
            uvGrowthRate = (double) (todayUV - yesterdayUV) / yesterdayUV;
        } else if (yesterdayUV == 0 && todayUV > 0) {
            uvGrowthRate = 1.0;
        }

        double pvGrowthRate = 0.0;
        if (yesterdayPV != null && yesterdayPV > 0) {
            pvGrowthRate = (double) (todayPV - yesterdayPV) / yesterdayPV;
        } else if (yesterdayPV == 0 && todayPV > 0) {
            pvGrowthRate = 1.0;
        }

        VisitStatsDTO dto = new VisitStatsDTO();
        dto.setTodayUvCount(todayUV != null ? todayUV : 0L);
        dto.setUvGrowthRate(uvGrowthRate);
        dto.setTotalUvCount(totalUV != null ? totalUV : 0L);
        dto.setTodayPvCount(todayPV != null ? todayPV : 0L);
        dto.setPvGrowthRate(pvGrowthRate);
        dto.setTotalPvCount(totalPV != null ? totalPV : 0L);
        return dto;
    }

    @Override
    public VisitTrendDTO getVisitTrend(LocalDate startDate, LocalDate endDate) {
        List<Map<String, Object>> dailyStats = visitLogMapper.getDailyStats(startDate, endDate);

        // 生成完整日期范围内的所有日期（避免缺失日期）
        List<LocalDate> dateRange = startDate.datesUntil(endDate.plusDays(1))
                .collect(Collectors.toList());

        Map<LocalDate, Long> pvMap = new HashMap<>();
        Map<LocalDate, Long> uvMap = new HashMap<>();
        for (Map<String, Object> record : dailyStats) {
            LocalDate date = ((java.sql.Date) record.get("date")).toLocalDate();
            Long pv = ((Number) record.get("pv")).longValue();
            Long uv = ((Number) record.get("uv")).longValue();
            pvMap.put(date, pv);
            uvMap.put(date, uv);
        }

        List<String> dates = new ArrayList<>();
        List<Long> pvList = new ArrayList<>();
        List<Long> uvList = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        for (LocalDate date : dateRange) {
            dates.add(date.format(formatter));
            pvList.add(pvMap.getOrDefault(date, 0L));
            uvList.add(uvMap.getOrDefault(date, 0L));
        }

        VisitTrendDTO dto = new VisitTrendDTO();
        dto.setDates(dates);
        dto.setPvList(pvList);
        dto.setIpList(uvList);  // 前端使用 ipList 字段名
        return dto;
    }
}