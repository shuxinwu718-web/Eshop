package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.ChatMessageVO;
import com.shopsphere.eshop.dto.ConversationVO;
import com.shopsphere.eshop.service.ChatService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 客服会话 REST 接口。
 * 这些接口走普通 Authorization 头，由 Spring Security 正常鉴权，绝不进 permitAll
 * （只有 SSE /connect 因 EventSource 带不了 Header 才放行）。
 */
@RestController
@RequestMapping("/api/v1/chat")
@RequiredArgsConstructor
@Tag(name = "客服会话", description = "买家↔商家双向多轮客服对话")
public class ChatController {

    private final ChatService chatService;

    @Operation(summary = "发起/获取与商家的会话")
    @PostMapping("/conversations")
    public Result<Long> getOrCreateConversation(@CurrentUserId Long userId,
                                                @RequestBody Map<String, Object> body) {
        Long merchantId = Long.valueOf(body.get("merchantId").toString());
        Long productId = body.get("productId") == null ? null : Long.valueOf(body.get("productId").toString());
        return Result.success(chatService.getOrCreateConversation(userId, merchantId, productId));
    }

    @Operation(summary = "我的会话列表")
    @GetMapping("/conversations")
    public Result<List<ConversationVO>> listConversations(@CurrentUserId Long userId,
                                                          @RequestParam(defaultValue = "false") boolean asMerchant) {
        return Result.success(chatService.listConversations(userId, asMerchant));
    }

    @Operation(summary = "历史消息（游标分页，id 倒序）")
    @GetMapping("/conversations/{id}/messages")
    public Result<List<ChatMessageVO>> listMessages(@CurrentUserId Long userId,
                                                    @PathVariable("id") Long conversationId,
                                                    @RequestParam(required = false) Long beforeId,
                                                    @RequestParam(defaultValue = "20") int size) {
        int limit = Math.min(Math.max(size, 1), 100);
        return Result.success(chatService.listMessages(userId, conversationId, beforeId, limit));
    }

    @Operation(summary = "发送消息")
    @PostMapping("/messages")
    public Result<ChatMessageVO> sendMessage(@CurrentUserId Long userId,
                                             @RequestBody Map<String, Object> body) {
        Long conversationId = Long.valueOf(body.get("conversationId").toString());
        String content = body.get("content") == null ? "" : body.get("content").toString();
        return Result.success(chatService.sendMessage(userId, conversationId, content));
    }

    @Operation(summary = "进入会话标记已读")
    @PutMapping("/conversations/{id}/read")
    public Result<Void> markRead(@CurrentUserId Long userId, @PathVariable("id") Long conversationId) {
        chatService.markRead(userId, conversationId);
        return Result.success(null);
    }

    @Operation(summary = "我的未读总数（角标用，高频轮询）")
    @GetMapping("/unread-count")
    public Result<Integer> unreadTotal(@CurrentUserId Long userId,
                                       @RequestParam(defaultValue = "false") boolean asMerchant) {
        return Result.success(chatService.getUnreadTotal(userId, asMerchant));
    }
}