package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.entity.MerchantNotification;
import com.shopsphere.eshop.mapper.MerchantNotificationMapper;
import com.shopsphere.eshop.service.MerchantNotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MerchantNotificationServiceImpl implements MerchantNotificationService {

    private final MerchantNotificationMapper notificationMapper;

    @Override
    @Transactional
    public void createNotification(Long merchantId, String type, String title, String content, Long orderId, String orderNo) {
        MerchantNotification notification = new MerchantNotification();
        notification.setMerchantId(merchantId);
        notification.setType(type);
        notification.setTitle(title);
        notification.setContent(content);
        notification.setOrderId(orderId);
        notification.setOrderNo(orderNo);
        notification.setIsRead(0);
        notificationMapper.insert(notification);
    }

    @Override
    public Page<MerchantNotification> getNotifications(Long merchantId, int pageNum, int pageSize) {
        Page<MerchantNotification> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<MerchantNotification> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantNotification::getMerchantId, merchantId);
        wrapper.orderByDesc(MerchantNotification::getCreateTime);
        return notificationMapper.selectPage(page, wrapper);
    }

    @Override
    public long getUnreadCount(Long merchantId) {
        Long count = notificationMapper.countUnread(merchantId);
        return count != null ? count : 0;
    }

    @Override
    @Transactional
    public void markAsRead(Long merchantId, Long notificationId) {
        MerchantNotification notification = notificationMapper.selectById(notificationId);
        if (notification != null && notification.getMerchantId().equals(merchantId)) {
            notification.setIsRead(1);
            notificationMapper.updateById(notification);
        }
    }

    @Override
    @Transactional
    public void markAllAsRead(Long merchantId) {
        MerchantNotification update = new MerchantNotification();
        update.setIsRead(1);
        LambdaQueryWrapper<MerchantNotification> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantNotification::getMerchantId, merchantId)
               .eq(MerchantNotification::getIsRead, 0);
        notificationMapper.update(update, wrapper);
    }
}
