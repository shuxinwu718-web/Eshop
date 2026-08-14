package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.annotation.Log;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.constant.OperationType;
import com.shopsphere.eshop.dto.IntroAuditDTO;
import com.shopsphere.eshop.service.ProductIntroService;
import com.shopsphere.eshop.vo.IntroAuditVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

/**
 * 管理端 商品介绍审核
 */
@RestController
@RequestMapping("/admin/intro-audit")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
@Tag(name = "管理员商品介绍审核", description = "审核商家提交的商品介绍版本")
public class AdminIntroAuditController {

    private final ProductIntroService productIntroService;

    /** 待审核分页（含正文预览，关联商品名/商家名） */
    @GetMapping("/pending")
    public Result<Page<IntroAuditVO>> pendingPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String keyword) {
        return Result.success(productIntroService.pendingPage(pageNum, pageSize, keyword));
    }

    /** 审核：通过（同步商品描述）/ 驳回（附原因） */
    @PostMapping("/audit")
    @Log(value = "审核商品介绍", type = OperationType.CHANGE_STATUS, targetType = "ProductIntroVersion")
    public Result<?> audit(@Valid @RequestBody IntroAuditDTO dto) {
        productIntroService.audit(dto.getId(), dto.getPass(), dto.getRemark());
        return Result.success(dto.getPass() ? "审核通过，商品介绍已更新" : "已驳回");
    }
}
