package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.annotation.Log;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.constant.OperationType;

import com.shopsphere.eshop.dto.*;
import com.shopsphere.eshop.service.OrderService;
import com.shopsphere.eshop.vo.OrderVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/order")
@RequiredArgsConstructor
@Tag(name = "订单管理", description = "管理员的对订单表的CRUD和用户查看自己的订单")
public class OrderController {

    private final OrderService orderService;

    @PostMapping("/create")
    public Result<?> createOrder(@Valid @RequestBody OrderCreateDTO dto,
                                 @CurrentUserId Long userId) {
        return Result.success(orderService.createOrder(dto, userId));
    }


    @PutMapping("/cancel/{orderId}")
    @Log(value = "取消订单", type = OperationType.CANCEL_ORDER, targetType = "Order")
    public Result<?> cancelOrder(@PathVariable Long orderId,
                                 @CurrentUserId Long userId) {
        orderService.cancelOrder(orderId, userId);
        return Result.success("取消成功");
    }

    @PutMapping("/pay/{orderId}")
    public Result<?> payOrder(@PathVariable Long orderId,
                              @RequestBody PayRequest payRequest,
                              @CurrentUserId Long userId) {
        orderService.payOrder(orderId, userId, payRequest.getActualAmount());
        return Result.success("支付成功");
    }

    @PutMapping("/confirm-receive/{orderId}")
    public Result<?> confirmReceive(@PathVariable Long orderId,
                                    @CurrentUserId Long userId) {
        orderService.confirmReceive(orderId, userId);
        return Result.success("确认收货成功");
    }

    @GetMapping("/page")
    public Result<Page<OrderVO>> pageQuery(OrderPageQueryDTO dto,
                                           @CurrentUserId Long userId) {
        return Result.success(orderService.pageQuery(dto, userId));
    }


    // 用户端：获取当前用户的订单（分页）
    @GetMapping("/user/page")
    public Result<Page<OrderVO>> getUserOrders(OrderPageQueryDTO dto,
                                               @CurrentUserId Long userId) {
        return Result.success(orderService.userPageQuery(dto, userId));
    }

    @GetMapping("/admin/page")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Page<OrderVO>> adminPageQuery(OrderPageQueryDTO dto) {
        return Result.success(orderService.adminPageQuery(dto));
    }

    @GetMapping("/admin/{orderId}")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<OrderVO> adminGetOrderDetail(@PathVariable Long orderId) {
        return Result.success(orderService.getAdminOrderDetail(orderId));
    }

    @GetMapping("/{orderId}")
    public Result<OrderVO> getOrderDetail(@PathVariable Long orderId,
                                          @CurrentUserId Long userId) {
        return Result.success(orderService.getOrderDetail(orderId, userId));
    }

    @PostMapping("/refund/apply")
    public Result<?> applyRefund(@RequestBody @Valid RefundApplyDTO dto,
                                 @CurrentUserId Long userId) {
        orderService.applyRefund(userId, dto);
        return Result.success("退款申请已提交，请等待审核");
    }


    @PutMapping("/admin/refund/audit")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> auditRefund(@RequestBody @Valid RefundAuditDTO dto,
                                 @CurrentUserId Long adminId) {
        dto.setOperatorRole("ADMIN");
        orderService.auditRefund(adminId, dto);
        return Result.success("审核完成");
    }

    /**
     * 商户审核退款
     */
    @PutMapping("/merchant/refund/audit")
    @PreAuthorize("hasRole('MERCHANT')")
    public Result<?> merchantAuditRefund(@RequestBody @Valid RefundAuditDTO dto,
                                         @CurrentUserId Long merchantId) {
        dto.setOperatorRole("MERCHANT");
        orderService.auditRefund(merchantId, dto);
        return Result.success("审核完成");
    }

    /**
     * 查询退款进度日志
     */
    @GetMapping("/refund/progress/{refundId}")
    public Result<?> getRefundProgress(@PathVariable Long refundId) {
        return Result.success(orderService.getRefundProgress(refundId));
    }

    /**
     * 退款详情及时间线
     */
    @GetMapping("/refund/stats/{refundId}")
    public Result<?> getRefundStats(@PathVariable Long refundId,
                                    @CurrentUserId Long userId) {
        return Result.success(orderService.getRefundStats(userId, refundId));
    }

    /**
     * 提交退款满意度评价
     */
    @PostMapping("/refund/satisfaction")
    public Result<?> submitSatisfaction(@RequestParam Long refundId,
                                        @RequestParam Integer rating,
                                        @RequestParam(required = false) String feedback,
                                        @CurrentUserId Long userId) {
        orderService.submitSatisfaction(userId, refundId, rating, feedback);
        return Result.success("评价成功");
    }


}