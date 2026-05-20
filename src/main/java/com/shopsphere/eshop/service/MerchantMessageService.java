package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.entity.MerchantMessage;

public interface MerchantMessageService {

    void sendMessage(Long userId, Long productId, String content);

    Page<MerchantMessage> getMessages(Long merchantId, int pageNum, int pageSize);

    long getUnreadCount(Long merchantId);

    void markAsRead(Long merchantId, Long messageId);
}
