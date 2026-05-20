package com.shopsphere.eshop.vo;

import lombok.Data;

import java.time.LocalDateTime;

//消息
@Data
public class NoticeVO {
    private Long id;
    private String title;
    private Integer type;
    private Integer level;
    private Integer targetType;      // 1-全体 2-指定用户
    private String targetUserIds;    // 逗号分隔的用户ID（仅后端使用）
    private String content;
    private Long publisherId;
    private String publisherName;
    private Integer publishStatus;    // 0-未发布 1-已发布 -1-已撤回
    private LocalDateTime publishTime;
    private LocalDateTime revokeTime;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

    // 用户端专用字段
    private Integer isRead;           // 0-未读 1-已读
}