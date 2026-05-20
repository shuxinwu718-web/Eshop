package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.MerchantApplySubmitDTO;
import com.shopsphere.eshop.service.MerchantApplyService;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
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

    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;

    public MerchantApplyController(MerchantApplyService applyService, JwtUtil jwtUtil, TokenUtils tokenUtils) {
        this.applyService = applyService;
        this.jwtUtil = jwtUtil;
        this.tokenUtils = tokenUtils;
    }

    // 提交申请（需登录）
    @PostMapping("/apply")
    public Result<?> submitApply(@RequestBody @Valid MerchantApplySubmitDTO dto,
                                 @RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        applyService.submitApply(userId, dto);
        return Result.success("申请提交成功，等待审核");
    }
}