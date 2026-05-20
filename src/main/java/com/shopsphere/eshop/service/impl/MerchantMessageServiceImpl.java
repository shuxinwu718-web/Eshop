package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.entity.MerchantMessage;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.mapper.MerchantMessageMapper;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.service.MerchantMessageService;
import com.shopsphere.eshop.service.NoticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class MerchantMessageServiceImpl implements MerchantMessageService {

    private final MerchantMessageMapper messageMapper;
    private final ProductMapper productMapper;
    private final NoticeService noticeService;

    @Override
    @Transactional
    public void sendMessage(Long userId, Long productId, String content) {
        Product product = productMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException("商品不存在");
        }

        MerchantMessage message = new MerchantMessage();
        message.setMerchantId(product.getMerchantId());
        message.setUserId(userId);
        message.setProductId(productId);
        message.setContent(content);
        message.setIsRead(0);
        messageMapper.insert(message);

        // 同时发送通知给商家
        noticeService.createAndPublish(
                "新留言通知",
                "用户对商品「" + product.getName() + "」留言：" + content,
                3,
                product.getMerchantId(),
                "new_message",
                null
        );
    }

    @Override
    public Page<MerchantMessage> getMessages(Long merchantId, int pageNum, int pageSize) {
        Page<MerchantMessage> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<MerchantMessage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantMessage::getMerchantId, merchantId);
        wrapper.orderByDesc(MerchantMessage::getCreateTime);
        return messageMapper.selectPage(page, wrapper);
    }

    @Override
    public long getUnreadCount(Long merchantId) {
        LambdaQueryWrapper<MerchantMessage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantMessage::getMerchantId, merchantId)
               .eq(MerchantMessage::getIsRead, 0);
        return messageMapper.selectCount(wrapper);
    }

    @Override
    @Transactional
    public void markAsRead(Long merchantId, Long messageId) {
        MerchantMessage message = messageMapper.selectById(messageId);
        if (message != null && message.getMerchantId().equals(merchantId)) {
            message.setIsRead(1);
            messageMapper.updateById(message);
        }
    }

    @Override
    @Transactional
    public void replyToMessage(Long merchantId, Long messageId, String replyContent) {
        MerchantMessage message = messageMapper.selectById(messageId);
        if (message == null || !message.getMerchantId().equals(merchantId)) {
            throw new BusinessException("留言不存在");
        }
        message.setReplyContent(replyContent);
        message.setReplyTime(LocalDateTime.now());
        message.setIsRead(1);
        messageMapper.updateById(message);

        // 创建系统通知给用户
        noticeService.createAndPublish(
                "商家回复了您的留言",
                replyContent,
                3,
                message.getUserId(),
                "reply_message",
                messageId
        );
    }

    @Override
    public Page<MerchantMessage> getUserMessages(Long userId, int pageNum, int pageSize) {
        Page<MerchantMessage> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<MerchantMessage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantMessage::getUserId, userId);
        wrapper.orderByDesc(MerchantMessage::getCreateTime);
        return messageMapper.selectPage(page, wrapper);
    }
}
