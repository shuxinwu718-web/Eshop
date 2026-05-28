package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.OrderItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Mapper
public interface OrderItemMapper extends BaseMapper<OrderItem> {

    @Select("SELECT oi.product_id AS productId, oi.product_name AS productName, " +
            "oi.product_image AS productImage, " +
            "SUM(oi.quantity) AS totalQuantity, SUM(oi.price * oi.quantity) AS totalAmount " +
            "FROM order_item oi " +
            "JOIN `order` o ON oi.order_id = o.id " +
            "WHERE o.pay_status = 1 AND o.deleted = 0 AND o.order_status < 4 " +
            "AND o.pay_time >= #{since} " +
            "GROUP BY oi.product_id, oi.product_name, oi.product_image " +
            "ORDER BY totalQuantity DESC LIMIT #{limit}")
    List<Map<String, Object>> selectTopProducts(@Param("since") LocalDateTime since, @Param("limit") int limit);
}
