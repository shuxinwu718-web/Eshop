package com.shopsphere.eshop.vo;

import lombok.Data;
import java.time.LocalDateTime;

/** 商家通知视图（用于统一在用户端"我的通知"页面展示） */
@Data
public class MerchantNoticeVO {
    private Long id;
    private String title;
    private String content;
    private Integer isRead;
    private String source;      // "merchant" 标记来源
    private String type;        // 原始类型 new_order / order_paid / order_cancelled / new_message
    private Long orderId;
    private String orderNo;
    private LocalDateTime createTime;
}
