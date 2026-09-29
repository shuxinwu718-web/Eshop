package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 客服会话表。一个 (user_id, merchant_id) 组合一条会话。
 * 冗余 last_message/last_msg_time/双向未读，换取列表页零 JOIN。
 */
@Data
@TableName("chat_conversation")
public class ChatConversation {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long merchantId;
    private Long productId;
    private String lastMessage;
    private Integer lastSender;
    private LocalDateTime lastMsgTime;
    private Integer userUnread;
    private Integer merchantUnread;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}