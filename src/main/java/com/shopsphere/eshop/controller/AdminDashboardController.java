package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.DashboardStatsDTO;
import com.shopsphere.eshop.dto.SalesTrendDTO;
import com.shopsphere.eshop.mapper.*;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admin/dashboard")
@RequiredArgsConstructor
@Tag(name = "管理员的面板统计", description = "统计订单销量，用户情况，商品信息统计，分类信息统计，商家申请情况")
public class AdminDashboardController {

    private final OrderMapper orderMapper;
    private final UserMapper userMapper;
    private final ProductMapper productMapper;
    private final CategoryMapper categoryMapper;
    private final MerchantApplyMapper merchantApplyMapper;

    @GetMapping("/stats")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<DashboardStatsDTO> getDashboardStats() {
        DashboardStatsDTO dto = new DashboardStatsDTO();
        LocalDateTime todayStart = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);

        // 销售与订单
        dto.setTotalSales(nullToZero(orderMapper.selectTotalSales()));
        dto.setOrderCount(orderMapper.selectCount(null));
        dto.setPendingOrderCount(nullToZero(orderMapper.selectPendingOrderCount()));
        dto.setCompletedOrderCount(nullToZero(orderMapper.selectCompletedOrderCount()));
        dto.setCancelledOrderCount(nullToZero(orderMapper.selectCancelledOrderCount()));
        dto.setTodaySales(nullToZero(orderMapper.selectTodaySales(todayStart)));
        dto.setTodayOrderCount(nullToZero(orderMapper.selectTodayOrderCount(todayStart)));

        // 商家
        dto.setMerchantCount(nullToZero(userMapper.selectMerchantCount()));
        dto.setNewMerchantCount(nullToZero(userMapper.selectNewMerchantCount(todayStart)));
        dto.setPendingMerchantCount(nullToZero(merchantApplyMapper.selectPendingCount()));

        // 用户
        dto.setUserCount(userMapper.selectCount(null));
        dto.setNewUserCount(nullToZero(userMapper.selectNewUserCount(todayStart)));

        // 商品
        dto.setProductCount(nullToZero(productMapper.selectProductCount()));
        dto.setCategoryCount(nullToZero(categoryMapper.selectCategoryCount()));

        return Result.success(dto);
    }

    @GetMapping("/sales-trend")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<SalesTrendDTO> getSalesTrend(@RequestParam(defaultValue = "7") Integer days) {
        LocalDate today = LocalDate.now();
        LocalDateTime startDate = today.minusDays(days - 1).atStartOfDay();
        LocalDateTime endDate = today.plusDays(1).atStartOfDay();

        List<Map<String, Object>> dailyStats = orderMapper.selectDailySales(startDate, endDate);

        // 生成完整日期范围
        List<LocalDate> dateRange = startDate.toLocalDate()
                .datesUntil(endDate.toLocalDate())
                .collect(Collectors.toList());

        Map<LocalDate, BigDecimal> salesMap = new HashMap<>();
        Map<LocalDate, Long> countMap = new HashMap<>();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        for (Map<String, Object> row : dailyStats) {
            LocalDate date = ((java.sql.Date) row.get("date")).toLocalDate();
            BigDecimal sales = (BigDecimal) row.get("sales");
            Long cnt = ((Number) row.get("cnt")).longValue();
            salesMap.put(date, sales);
            countMap.put(date, cnt);
        }

        List<String> dates = new ArrayList<>();
        List<BigDecimal> salesList = new ArrayList<>();
        List<Long> orderCountList = new ArrayList<>();

        for (LocalDate date : dateRange) {
            dates.add(date.format(fmt));
            salesList.add(salesMap.getOrDefault(date, BigDecimal.ZERO).setScale(2, RoundingMode.HALF_UP));
            orderCountList.add(countMap.getOrDefault(date, 0L));
        }

        SalesTrendDTO dto = new SalesTrendDTO();
        dto.setDates(dates);
        dto.setSalesList(salesList);
        dto.setOrderCountList(orderCountList);
        return Result.success(dto);
    }

    private Long nullToZero(Long val) {
        return val != null ? val : 0L;
    }

    private BigDecimal nullToZero(BigDecimal val) {
        return val != null ? val : BigDecimal.ZERO;
    }
}
