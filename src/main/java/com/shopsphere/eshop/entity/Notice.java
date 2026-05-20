package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

// Notice.java
@Data
@TableName("sys_notice")
public class Notice {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String title;
    private Integer type;
    private Integer level;          // 0=普通,1=重要,2=紧急
    private Integer targetType;     // 1=全体,2=指定用户
    private String targetUserIds;
    private String content;
    private Long publisherId;
    private String publisherName;
    private LocalDateTime publishTime;
    private Integer status;          // 0-草稿,1-已发布,2-已撤回
    private LocalDateTime revokeTime;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
