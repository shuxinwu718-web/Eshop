package com.shopsphere.eshop.dto;

import lombok.Data;
import java.time.LocalDateTime;

/** 客服消息传输对象：既用于列表/分页返回，也作为 SSE im-message 推送负载 */
@Data
public class ChatMessageVO {
    private Long id;
    private Long conversationId;
    private Long senderId;
    private Integer senderType;
    private String content;
    private Integer isRead;
    private LocalDateTime createTime;
}