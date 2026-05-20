package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("merchant_notification")
public class MerchantNotification {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long merchantId;
    private String type;
    private String title;
    private String content;
    private Long orderId;
    private String orderNo;
    private Integer isRead;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
