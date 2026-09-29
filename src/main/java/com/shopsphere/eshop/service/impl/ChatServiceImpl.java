package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.shopsphere.eshop.dto.ChatMessageVO;
import com.shopsphere.eshop.dto.ConversationVO;
import com.shopsphere.eshop.entity.ChatConversation;
import com.shopsphere.eshop.entity.ChatMessage;
import com.shopsphere.eshop.entity.User;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.ChatConversationMapper;
import com.shopsphere.eshop.mapper.ChatMessageMapper;
import com.shopsphere.eshop.mapper.UserMapper;
import com.shopsphere.eshop.service.ChatService;
import com.shopsphere.eshop.service.NoticeService;
import com.shopsphere.eshop.service.SsePushService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 买家↔商家客服会话实现。
 * 并发与安全要点：
 * - 归属校验：任何按 conversationId 的操作，先确认 actorId 是会话双方之一，否则抛"会话不存在"，
 *   与商家留言模块保持同一安全口径（水平越权防线）。
 * - 未读数用 SQL 端原子自增（xxx_unread = xxx_unread + 1），避免读到旧值覆盖写入。
 */
@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {

    private final ChatConversationMapper conversationMapper;
    private final ChatMessageMapper messageMapper;
    private final UserMapper userMapper;
    private final SsePushService ssePushService;
    private final NoticeService noticeService;

    @Override
    @Transactional
    public Long getOrCreateConversation(Long userId, Long merchantId, Long productId) {
        ChatConversation exist = conversationMapper.selectOne(new LambdaQueryWrapper<ChatConversation>()
                .eq(ChatConversation::getUserId, userId)
                .eq(ChatConversation::getMerchantId, merchantId)
                .last("LIMIT 1"));
        if (exist != null) {
            return exist.getId();
        }
        // 并发两个请求同时未查到会撞唯一键，捕获后重查即可
        try {
            ChatConversation conv = new ChatConversation();
            conv.setUserId(userId);
            conv.setMerchantId(merchantId);
            conv.setProductId(productId);
            conv.setUserUnread(0);
            conv.setMerchantUnread(0);
            conversationMapper.insert(conv);
            return conv.getId();
        } catch (org.springframework.dao.DuplicateKeyException e) {
            return conversationMapper.selectOne(new LambdaQueryWrapper<ChatConversation>()
                    .eq(ChatConversation::getUserId, userId)
                    .eq(ChatConversation::getMerchantId, merchantId)
                    .last("LIMIT 1")).getId();
        }
    }

    @Override
    public List<ConversationVO> listConversations(Long actorId, boolean asMerchant) {
        LambdaQueryWrapper<ChatConversation> wrapper = new LambdaQueryWrapper<>();
        if (asMerchant) {
            wrapper.eq(ChatConversation::getMerchantId, actorId);
        } else {
            wrapper.eq(ChatConversation::getUserId, actorId);
        }
        wrapper.orderByDesc(ChatConversation::getLastMsgTime);
        List<ChatConversation> list = conversationMapper.selectList(wrapper);

        List<ConversationVO> result = new ArrayList<>(list.size());
        for (ChatConversation c : list) {
            ConversationVO vo = new ConversationVO();
            vo.setId(c.getId());
            vo.setUserId(c.getUserId());
            vo.setMerchantId(c.getMerchantId());
            vo.setProductId(c.getProductId());
            vo.setLastMessage(c.getLastMessage());
            vo.setLastSender(c.getLastSender());
            vo.setLastMsgTime(c.getLastMsgTime());
            vo.setUnread(asMerchant ? c.getMerchantUnread() : c.getUserUnread());
            Long otherId = asMerchant ? c.getUserId() : c.getMerchantId();
            vo.setOtherPartyId(otherId);
            User other = userMapper.selectById(otherId);
            if (other != null) {
                vo.setOtherPartyName(other.getNickname() != null && !other.getNickname().isBlank()
                        ? other.getNickname() : other.getUsername());
            }
            result.add(vo);
        }
        return result;
    }

    @Override
    public List<ChatMessageVO> listMessages(Long actorId, Long conversationId, Long beforeId, int limit) {
        ChatConversation conv = requireConversation(conversationId, actorId);

        LambdaQueryWrapper<ChatMessage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ChatMessage::getConversationId, conversationId);
        if (beforeId != null) {
            wrapper.lt(ChatMessage::getId, beforeId);
        }
        wrapper.orderByDesc(ChatMessage::getId).last("LIMIT " + limit);
        List<ChatMessage> rows = messageMapper.selectList(wrapper);

        // 返回最新在前（游标是 id 倒序），前端 callMessage.reverse() 后再拼接用户气泡
        List<ChatMessageVO> result = new ArrayList<>(rows.size());
        for (ChatMessage m : rows) {
            result.add(toVO(m));
        }
        return result;
    }

    @Override
    @Transactional
    public ChatMessageVO sendMessage(Long actorId, Long conversationId, String content) {
        if (content == null) {
            content = "";
        }
        if (content.strip().isEmpty()) {
            throw new BusinessException("消息内容不能为空");
        }
        if (content.length() > 500) {
            content = content.substring(0, 500);
        }

        ChatConversation conv = requireConversation(conversationId, actorId);
        boolean fromUser = conv.getUserId().equals(actorId);
        int senderType = fromUser ? 1 : 2;
        Long receiverId = fromUser ? conv.getMerchantId() : conv.getUserId();

        // 1. 落库（id 自增即游标）
        ChatMessage msg = new ChatMessage();
        msg.setConversationId(conversationId);
        msg.setSenderId(actorId);
        msg.setSenderType(senderType);
        msg.setContent(content);
        msg.setIsRead(0);
        messageMapper.insert(msg);

        // 2. 更新会话冗余字段 + 对方未读原子自增
        LambdaUpdateWrapper<ChatConversation> uw = new LambdaUpdateWrapper<>();
        uw.eq(ChatConversation::getId, conversationId)
                .set(ChatConversation::getLastMessage, content.length() > 200 ? content.substring(0, 200) : content)
                .set(ChatConversation::getLastSender, senderType)
                .set(ChatConversation::getLastMsgTime, LocalDateTime.now())
                .setSql(fromUser
                        ? "merchant_unread = merchant_unread + 1"
                        : "user_unread = user_unread + 1");
        conversationMapper.update(null, uw);

        ChatMessageVO vo = toVO(msg);

        // 3. 实时推给对方；不在线 → 离线站内通知兜底
        boolean delivered = ssePushService.sendToUser(receiverId, "im-message", vo);
        if (!delivered) {
            noticeService.createAndPublish(
                    "您有新的客服消息",
                    content.length() > 100 ? content.substring(0, 100) : content,
                    3, receiverId, "chat_message", msg.getId());
        }
        return vo;
    }

    @Override
    @Transactional
    public void markRead(Long actorId, Long conversationId) {
        ChatConversation conv = requireConversation(conversationId, actorId);
        boolean fromUser = conv.getUserId().equals(actorId);

        // 会话级未读清零（当前侧）
        LambdaUpdateWrapper<ChatConversation> uw = new LambdaUpdateWrapper<>();
        uw.eq(ChatConversation::getId, conversationId);
        if (fromUser) {
            uw.set(ChatConversation::getUserUnread, 0);
        } else {
            uw.set(ChatConversation::getMerchantUnread, 0);
        }
        conversationMapper.update(null, uw);

        // 消息级已读：把"对方发来"的消息置为已读
        LambdaUpdateWrapper<ChatMessage> mw = new LambdaUpdateWrapper<>();
        mw.eq(ChatMessage::getConversationId, conversationId)
                .eq(ChatMessage::getSenderType, fromUser ? 2 : 1)
                .eq(ChatMessage::getIsRead, 0)
                .set(ChatMessage::getIsRead, 1);
        messageMapper.update(null, mw);
    }

    @Override
    public int getUnreadTotal(Long actorId, boolean asMerchant) {
        LambdaQueryWrapper<ChatConversation> wrapper = new LambdaQueryWrapper<>();
        if (asMerchant) {
            wrapper.eq(ChatConversation::getMerchantId, actorId);
        } else {
            wrapper.eq(ChatConversation::getUserId, actorId);
        }
        List<ChatConversation> list = conversationMapper.selectList(wrapper);
        int unread = 0;
        for (ChatConversation c : list) {
            unread += asMerchant ? c.getMerchantUnread() : c.getUserUnread();
        }
        return unread;
    }

    /** 归属校验：会话必须存在，且 actorId 是会话买/卖双方之一；否则一律报"会话不存在"（防水平越权泄暴露） */
    private ChatConversation requireConversation(Long conversationId, Long actorId) {
        ChatConversation conv = conversationMapper.selectById(conversationId);
        if (conv == null
                || (!conv.getUserId().equals(actorId) && !conv.getMerchantId().equals(actorId))) {
            throw new BusinessException("会话不存在");
        }
        return conv;
    }

    private ChatMessageVO toVO(ChatMessage m) {
        ChatMessageVO vo = new ChatMessageVO();
        vo.setId(m.getId());
        vo.setConversationId(m.getConversationId());
        vo.setSenderId(m.getSenderId());
        vo.setSenderType(m.getSenderType());
        vo.setContent(m.getContent());
        vo.setIsRead(m.getIsRead());
        vo.setCreateTime(m.getCreateTime() != null ? m.getCreateTime() : LocalDateTime.now());
        return vo;
    }
}