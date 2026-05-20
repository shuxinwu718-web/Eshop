package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.entity.MerchantMessage;

public interface MerchantMessageService {

    void sendMessage(Long userId, Long productId, String content);

    Page<MerchantMessage> getMessages(Long merchantId, int pageNum, int pageSize);

    long getUnreadCount(Long merchantId);

    void markAsRead(Long merchantId, Long messageId);

    /** 商家回复留言 */
    void replyToMessage(Long merchantId, Long messageId, String replyContent);

    /** 用户查看自己的留言 */
    Page<MerchantMessage> getUserMessages(Long userId, int pageNum, int pageSize);
}
