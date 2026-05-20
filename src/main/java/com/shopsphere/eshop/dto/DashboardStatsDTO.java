package com.shopsphere.eshop.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class DashboardStatsDTO {
    // 销售与订单
    private BigDecimal totalSales;
    private Long orderCount;
    private Long pendingOrderCount;
    private Long completedOrderCount;
    private Long cancelledOrderCount;
    private BigDecimal todaySales;
    private Long todayOrderCount;

    // 商家
    private Long merchantCount;
    private Long newMerchantCount;
    private Long pendingMerchantCount;

    // 用户
    private Long userCount;
    private Long newUserCount;

    // 商品
    private Long productCount;
    private Long categoryCount;
}
