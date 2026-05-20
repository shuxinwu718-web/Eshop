package com.shopsphere.eshop.dto;

import lombok.Data;

@Data
public class NoticeQueryDTO {
    private Integer pageNum = 1;
    private Integer pageSize = 10;
    private String title;          // 通知标题（模糊查询）
    private Integer publishStatus; // 发布状态：0-未发布 1-已发布 -1-已撤回
}
