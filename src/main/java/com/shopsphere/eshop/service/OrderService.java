package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.OrderCreateDTO;
import com.shopsphere.eshop.dto.OrderPageQueryDTO;
import com.shopsphere.eshop.entity.Order;
import com.shopsphere.eshop.vo.OrderVO;

import java.math.BigDecimal;

public interface OrderService {
    Order createOrder(OrderCreateDTO dto, Long userId);
    void cancelOrder(Long orderId, Long userId);
    void payOrder(Long orderId, Long userId, BigDecimal actualAmount);
    Page<OrderVO> pageQuery(OrderPageQueryDTO dto, Long userId);
    OrderVO getOrderDetail(Long orderId, Long userId);
    Page<OrderVO> adminPageQuery(OrderPageQueryDTO dto);
    Page<OrderVO> userPageQuery(OrderPageQueryDTO dto, Long userId);
}
