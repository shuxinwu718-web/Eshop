package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.Order;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Mapper
public interface OrderMapper extends BaseMapper<Order> {

    @Select("SELECT COALESCE(SUM(pay_amount), 0) FROM `order` WHERE pay_status = 1 AND deleted = 0 AND order_status != 6")
    BigDecimal selectTotalSales();

    @Select("SELECT COALESCE(SUM(pay_amount), 0) FROM `order` WHERE pay_status = 1 AND deleted = 0 AND order_status != 6 AND create_time >= #{since}")
    BigDecimal selectTodaySales(@Param("since") LocalDateTime since);

    @Select("SELECT COUNT(*) FROM `order` WHERE deleted = 0 AND create_time >= #{since}")
    Long selectTodayOrderCount(@Param("since") LocalDateTime since);

    @Select("SELECT COUNT(*) FROM `order` WHERE pay_status = 0 AND deleted = 0")
    Long selectPendingOrderCount();

    @Select("SELECT COUNT(*) FROM `order` WHERE order_status = 3 AND deleted = 0")
    Long selectCompletedOrderCount();

    @Select("SELECT COUNT(*) FROM `order` WHERE order_status = 4 AND deleted = 0")
    Long selectCancelledOrderCount();

    @Select("SELECT DATE(create_time) as date, COALESCE(SUM(pay_amount), 0) as sales, COUNT(*) as cnt " +
            "FROM `order` WHERE pay_status = 1 AND deleted = 0 AND order_status != 6 " +
            "AND create_time >= #{startDate} AND create_time < #{endDate} " +
            "GROUP BY DATE(create_time) ORDER BY date")
    java.util.List<java.util.Map<String, Object>> selectDailySales(
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);


    @Select("SELECT * FROM `order` WHERE id = #{id} FOR UPDATE")
    Order selectForUpdate(@Param("id") Long id);
}