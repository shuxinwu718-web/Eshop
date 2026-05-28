package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.*;
import com.shopsphere.eshop.entity.Order;
import com.shopsphere.eshop.vo.OrderVO;
import com.shopsphere.eshop.vo.RefundApplicationVO;

import java.math.BigDecimal;

public interface OrderService {
    Order createOrder(OrderCreateDTO dto, Long userId);
    void cancelOrder(Long orderId, Long userId);
    void payOrder(Long orderId, Long userId, BigDecimal actualAmount);
    Page<OrderVO> pageQuery(OrderPageQueryDTO dto, Long userId);
    OrderVO getOrderDetail(Long orderId, Long userId);
    Page<OrderVO> adminPageQuery(OrderPageQueryDTO dto);
    Page<OrderVO> userPageQuery(OrderPageQueryDTO dto, Long userId);
    /**
     * 自动取消超时未支付的订单（定时任务调用）
     */
    void autoCancelExpiredOrders();

    /**
     * 申请退款
     */
    void applyRefund(Long userId, RefundApplyDTO dto);

    /**
     * 审核退款（管理员）
     */
    void auditRefund(Long adminId, RefundAuditDTO dto);

    Page<RefundApplicationVO> getRefundList(RefundQueryDTO queryDTO);
}
