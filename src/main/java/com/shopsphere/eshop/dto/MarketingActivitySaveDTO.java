package com.shopsphere.eshop.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 营销活动保存 DTO（含任务列表）
 */
@Data
public class MarketingActivitySaveDTO {

    /** 活动ID（编辑时回填，新增为空） */
    private Long id;

    @NotBlank(message = "活动名称不能为空")
    private String activityName;

    /** 活动图标(emoji) */
    private String activityIcon;

    /** 活动说明 */
    private String description;

    @NotNull(message = "开始时间不能为空")
    private LocalDateTime startTime;

    @NotNull(message = "结束时间不能为空")
    private LocalDateTime endTime;

    /** 0停用 1启用 */
    private Integer status;

    /** 排序（越小越靠前） */
    private Integer sortOrder;

    /** 任务列表 */
    @Valid
    private List<MarketingTaskDTO> tasks;
}
