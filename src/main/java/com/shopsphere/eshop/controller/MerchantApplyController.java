package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.MerchantApplySubmitDTO;
import com.shopsphere.eshop.service.MerchantApplyService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/user/merchant")
@Tag(name = "商家申请资格认证管理", description = "商家申请资格认证")
public class MerchantApplyController {

    @Autowired
    private MerchantApplyService applyService;

    public MerchantApplyController(MerchantApplyService applyService) {
        this.applyService = applyService;
    }

    // 提交申请（需登录）
    @PostMapping("/apply")
    public Result<?> submitApply(@RequestBody @Valid MerchantApplySubmitDTO dto,
                                 @CurrentUserId Long userId) {
        applyService.submitApply(userId, dto);
        return Result.success("申请提交成功，等待审核");
    }
}
