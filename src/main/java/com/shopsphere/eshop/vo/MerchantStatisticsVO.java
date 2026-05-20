package com.shopsphere.eshop.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class MerchantStatisticsVO {
    private BigDecimal totalSales;
    private Long totalOrders;
    private java.util.List<DailyStat> dailyStats;

    @Data
    public static class DailyStat {
        private String date;
        private BigDecimal sales;
        private Long orders;
    }
}
