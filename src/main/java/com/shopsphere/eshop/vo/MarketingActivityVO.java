package com.shopsphere.eshop.vo;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 营销活动 VO（含任务列表与用户进度）
 */
@Data
public class MarketingActivityVO {

    private Long id;

    private String activityName;

    private String activityIcon;

    private String description;

    private LocalDateTime startTime;

    private LocalDateTime endTime;

    private Integer status;

    private Integer sortOrder;

    /** 活动时间状态：0-未开始 1-进行中 2-已结束 */
    private Integer timeStatus;

    /** 任务列表 */
    private List<MarketingTaskVO> tasks;
}
