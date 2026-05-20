package com.shopsphere.eshop.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class NoticeFormDTO {
    private Long id;                // 编辑时传入

    @NotBlank(message = "标题不能为空")
    private String title;

    @NotNull(message = "通知类型不能为空")
    private Integer type;           // 0=系统公告 1=活动通知 2=订单提醒

    @NotNull(message = "通知等级不能为空")
    private Integer level;          // 0=普通 1=重要 2=紧急

    private Integer targetType = 1; // 1-全体 2-指定用户

    private List<Long> targetUsers; // 指定用户的ID列表（targetType=2时必填）

    @NotBlank(message = "内容不能为空")
    private String content;         // HTML内容

    private Long publisherId;
    private String publisherName;
    private Integer publishStatus;    // 0-未发布 1-已发布 -1-已撤回
}