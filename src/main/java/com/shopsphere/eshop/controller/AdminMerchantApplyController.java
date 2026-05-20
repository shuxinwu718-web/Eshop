package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.AuditRequest;
import com.shopsphere.eshop.service.MerchantApplyService;
import com.shopsphere.eshop.vo.MerchantApplyVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin/merchant")
@Tag(name = "管理员对商家资格的申请", description = "商家入驻审核表的CRUD")
public class AdminMerchantApplyController {

    @Autowired
    private MerchantApplyService applyService;

    // 获取申请列表（可筛选状态）
    @GetMapping("/apply/list")
    public Result<Page<MerchantApplyVO>> getApplyList(@RequestParam(defaultValue = "1") Integer pageNum,
                                                      @RequestParam(defaultValue = "10") Integer pageSize,
                                                      @RequestParam(required = false) Integer status) {
        Page<MerchantApplyVO> page = applyService.getApplyList(pageNum, pageSize, status);
        return Result.success(page);
    }

    // 审核申请
    @PutMapping("/apply/{applyId}/audit")
    public Result<?> auditApply(@PathVariable Long applyId,
                                @RequestBody AuditRequest request) {
        if (request.getStatus() == null || (request.getStatus() != 1 && request.getStatus() != 2)) {
            return Result.error("审核状态无效");
        }
        applyService.auditApply(applyId, request.getStatus(), request.getRemark());
        return Result.success("审核完成");
    }
}