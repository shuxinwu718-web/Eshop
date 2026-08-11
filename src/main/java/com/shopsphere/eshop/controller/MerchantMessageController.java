package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.entity.MerchantMessage;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.service.MerchantMessageService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/merchant-message")
@RequiredArgsConstructor
@Tag(name = "商家对回复信息的接口", description = "接受所有回复消息和回复消息")
public class MerchantMessageController {

    private final MerchantMessageService messageService;

    @PostMapping
    public Result<?> sendMessage(@RequestBody Map<String, Object> body,
                                  @CurrentUserId Long userId) {
        Long productId = Long.valueOf(body.get("productId").toString());
        String content = (String) body.get("content");

        if (content == null || content.isBlank()) {
            throw new BusinessException("请输入留言内容");
        }

        messageService.sendMessage(userId, productId, content);
        return Result.success("留言发送成功");
    }

    @GetMapping("/my")
    public Result<Page<MerchantMessage>> getMyMessages(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "20") Integer pageSize,
            @CurrentUserId Long userId) {
        return Result.success(messageService.getUserMessages(userId, pageNum, pageSize));
    }
}
