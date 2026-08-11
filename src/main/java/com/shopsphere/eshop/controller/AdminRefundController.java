package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.annotation.Log;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.constant.OperationType;

import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.dto.RefundAuditDTO;
import com.shopsphere.eshop.dto.RefundQueryDTO;
import com.shopsphere.eshop.dto.RefundSatisfactionSubmitDTO;
import com.shopsphere.eshop.entity.RefundApplication;
import com.shopsphere.eshop.entity.RefundProgressLog;
import com.shopsphere.eshop.entity.RefundSatisfaction;
import com.shopsphere.eshop.mapper.RefundApplicationMapper;
import com.shopsphere.eshop.service.OrderService;
import com.shopsphere.eshop.vo.RefundApplicationVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/refund")
@RequiredArgsConstructor
@Tag(name = "管理员的退款申请审核")
public class AdminRefundController {

    private final OrderService orderService;
    private final RefundApplicationMapper refundApplicationMapper;

    @GetMapping("/list")
    @PreAuthorize("hasAnyRole('ADMIN', 'MERCHANT')")
    public Result<Page<RefundApplicationVO>> getRefundList(RefundQueryDTO queryDTO) {
        Page<RefundApplicationVO> page = orderService.getRefundList(queryDTO);
        return Result.success(page);
    }

    /**
     * 管理员/商户审核退款
     */
    @PutMapping("/audit")
    @Log(value = "审核退款申请", type = OperationType.AUDIT_REFUND, targetType = "Refund")
    @PreAuthorize("hasAnyRole('ADMIN', 'MERCHANT')")
    public Result<?> auditRefund(@RequestBody @Valid RefundAuditDTO dto,
                                 @CurrentUserId Long operatorId) {
        // 前端未传 operatorRole 时，根据退款当前状态推断角色
        if (dto.getOperatorRole() == null) {
            RefundApplication app = refundApplicationMapper.selectById(dto.getRefundId());
            if (app == null) {
                throw new BusinessException("退款申请不存在");
            }
            if (app.getStatus() == RefundApplication.STATUS_PENDING_MERCHANT) {
                dto.setOperatorRole("MERCHANT");
            } else {
                dto.setOperatorRole("ADMIN");
            }
        }
        orderService.auditRefund(operatorId, dto);
        return Result.success("审核完成");
    }

    /**
     * 退款进度日志
     */
    @GetMapping("/progress/{refundId}")
    public Result<List<RefundProgressLog>> getRefundProgress(@PathVariable Long refundId) {
        return Result.success(orderService.getRefundProgress(refundId));
    }

    /**
     * 退款统计信息（含时间线和满意度）
     */
    @GetMapping("/stats/{refundId}")
    public Result<?> getRefundStats(@PathVariable Long refundId,
                                    @CurrentUserId Long userId) {
        return Result.success(orderService.getRefundStats(userId, refundId));
    }

    /**
     * 提交退款满意度评价
     */
    @PostMapping("/satisfaction")
    public Result<?> submitSatisfaction(@RequestBody @Valid RefundSatisfactionSubmitDTO dto,
                                         @CurrentUserId Long userId) {
        orderService.submitSatisfaction(userId, dto.getRefundId(), dto.getRating(), dto.getFeedback());
        return Result.success("评价成功");
    }

    /**
     * 查询退款满意度评价（管理员/商户查看用户反馈）
     */
    @GetMapping("/satisfaction/{refundId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'MERCHANT')")
    public Result<RefundSatisfaction> getRefundSatisfaction(@PathVariable Long refundId) {
        return Result.success(orderService.getRefundSatisfaction(refundId));
    }
}
