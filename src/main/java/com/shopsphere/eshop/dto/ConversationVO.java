package com.shopsphere.eshop.dto;

import lombok.Data;
import java.time.LocalDateTime;

/** 会话列表项：一次性把对话摘要 + 当前侧未读数 + 对方信息带回，前端零联动 */
@Data
public class ConversationVO {
    private Long id;
    private Long userId;
    private Long merchantId;
    private Long productId;
    private Long otherPartyId;
    private String otherPartyName;
    private String lastMessage;
    private Integer lastSender;
    private LocalDateTime lastMsgTime;
    /** 当前请求方未读数（后端按 asMerchant 折算 user_unread / merchant_unread） */
    private Integer unread;
}