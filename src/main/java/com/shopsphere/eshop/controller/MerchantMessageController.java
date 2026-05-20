package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.service.MerchantMessageService;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/merchant-message")
@RequiredArgsConstructor
public class MerchantMessageController {

    private final MerchantMessageService messageService;
    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;

    @PostMapping
    public Result<?> sendMessage(@RequestBody Map<String, Object> body,
                                  @RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);

        Long productId = Long.valueOf(body.get("productId").toString());
        String content = (String) body.get("content");

        if (content == null || content.isBlank()) {
            return Result.error("请输入留言内容");
        }

        messageService.sendMessage(userId, productId, content);
        return Result.success("留言发送成功");
    }
}
