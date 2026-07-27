package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("refund_satisfaction")
public class RefundSatisfaction {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long refundId;
    private Long userId;
    private Integer rating;
    private String feedback;
    private LocalDateTime createTime;
}
