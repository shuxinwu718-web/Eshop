package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.*;
import com.shopsphere.eshop.entity.Order;
import com.shopsphere.eshop.entity.RefundProgressLog;
import com.shopsphere.eshop.entity.RefundReasonCategory;
import com.shopsphere.eshop.entity.RefundSatisfaction;
import com.shopsphere.eshop.vo.OrderVO;
import com.shopsphere.eshop.vo.RefundApplicationVO;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface OrderService {
    Order createOrder(OrderCreateDTO dto, Long userId);
    void cancelOrder(Long orderId, Long userId);
    void payOrder(Long orderId, Long userId, BigDecimal actualAmount);
    Page<OrderVO> pageQuery(OrderPageQueryDTO dto, Long userId);
    OrderVO getOrderDetail(Long orderId, Long userId);
    OrderVO getAdminOrderDetail(Long orderId);
    Page<OrderVO> adminPageQuery(OrderPageQueryDTO dto);
    Page<OrderVO> userPageQuery(OrderPageQueryDTO dto, Long userId);
    void autoCancelExpiredOrders();
    void confirmReceive(Long orderId, Long userId);

    // ========== 退款相关 ==========

    /**
     * 用户申请退款
     */
    void applyRefund(Long userId, RefundApplyDTO dto);

    /**
     * 审核退款（支持商户/管理员多级审核）
     */
    void auditRefund(Long auditUserId, RefundAuditDTO dto);

    Page<RefundApplicationVO> getRefundList(RefundQueryDTO queryDTO);

    /**
     * 查询退款进度日志
     */
    List<RefundProgressLog> getRefundProgress(Long refundId);

    List<RefundReasonCategory> getReasonCategories();

    /**
     * 提交退款满意度反馈
     */
    void submitSatisfaction(Long userId, Long refundId, Integer rating, String feedback);

    /**
     * 获取退款统计信息
     */
    Map<String, Object> getRefundStats(Long userId, Long refundId);

    /**
     * 获取退款满意度评价（管理员/商户使用，无需userId校验）
     */
    RefundSatisfaction getRefundSatisfaction(Long refundId);

    void cancelOrderInternal(Order order);
}
