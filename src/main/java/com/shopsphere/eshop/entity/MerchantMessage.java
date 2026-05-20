package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("merchant_message")
public class MerchantMessage {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long merchantId;
    private Long userId;
    private Long productId;
    private String content;
    private String replyContent;
    private LocalDateTime replyTime;
    private Integer isRead;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
