package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.entity.MerchantNotification;

import java.util.List;

public interface MerchantNotificationService {

    void createNotification(Long merchantId, String type, String title, String content, Long orderId, String orderNo);

    Page<MerchantNotification> getNotifications(Long merchantId, int pageNum, int pageSize);

    long getUnreadCount(Long merchantId);

    void markAsRead(Long merchantId, Long notificationId);

    void markAllAsRead(Long merchantId);
}
