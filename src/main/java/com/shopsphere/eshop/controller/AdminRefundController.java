package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.annotation.Log;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.RefundAuditDTO;
import com.shopsphere.eshop.dto.RefundQueryDTO;
import com.shopsphere.eshop.service.OrderService;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import com.shopsphere.eshop.vo.RefundApplicationVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin/refund")
@RequiredArgsConstructor
@Tag(name = "管理员的退款申请审核")
public class AdminRefundController {

    private final OrderService orderService;
    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;
    @GetMapping("/list")
    public Result<Page<RefundApplicationVO>> getRefundList(RefundQueryDTO queryDTO) {
        Page<RefundApplicationVO> page = orderService.getRefundList(queryDTO);
        return Result.success(page);
    }

    @PutMapping("/audit")
    @Log(value = "审核退款申请", type = "AUDIT_REFUND", targetType = "Refund")
    public Result<?> auditRefund(@RequestBody @Valid RefundAuditDTO dto,
                                 @RequestHeader("Authorization") String authHeader) {
        Long adminId = getCurrentAdminId(authHeader); // 实现获取当前管理员ID的方法
        orderService.auditRefund(adminId, dto);
        return Result.success("审核完成");
    }

    private Long getCurrentAdminId(String authHeader) {
        // 从token中解析用户ID，并验证角色是否为ADMIN
        // 参考 UserController 中的方法
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        // 可选：查询用户角色确保是ADMIN
        return userId;
    }
}