package com.shopsphere.eshop.service;

import com.shopsphere.eshop.dto.ChatMessageVO;
import com.shopsphere.eshop.dto.ConversationVO;

import java.util.List;

/**
 * 客服会话服务：买家↔商家双向多轮对话。
 * 下行推送走 {@link SsePushService}（用户在线即时送达），离线降级为站内通知。
 */
public interface ChatService {

    /**
     * 发起/获取与某商家的会话（uk_user_merchant 唯一键防重，商定 session）。
     * @return 已存在则直接返回，否则新建。
     */
    Long getOrCreateConversation(Long userId, Long merchantId, Long productId);

    /**
     * 我的会话列表，按最后消息时间倒序。
     * @param asMerchant true=商家视角（按 merchantId 过滤、取 merchant_unread）
     */
    List<ConversationVO> listConversations(Long actorId, boolean asMerchant);

    /**
     * 历史消息，游标分页（id 倒序）。
     * @param beforeId 分页游标：取比它更早的消息；null 表示取最新 limit 条
     */
    List<ChatMessageVO> listMessages(Long actorId, Long conversationId, Long beforeId, int limit);

    /**
     * 发送消息：归属校验 → 落库 → 更新会话冗余字段+对方未读 → SSE 推对方（离线兜底站内通知）。
     */
    ChatMessageVO sendMessage(Long actorId, Long conversationId, String content);

    /** 进入会话：把该会话中"对方发来的"消息与未读数清零 */
    void markRead(Long actorId, Long conversationId);

    /** 顶栏/角标用：我的全部未读消息总数 */
    int getUnreadTotal(Long actorId, boolean asMerchant);
}