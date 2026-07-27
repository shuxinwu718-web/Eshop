package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("refund_progress_log")
public class RefundProgressLog {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long refundId;
    private String nodeName;
    private String operator;
    private String operatorRole;
    private String remark;
    private LocalDateTime createTime;
}
