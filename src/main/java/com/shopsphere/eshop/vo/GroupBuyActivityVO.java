package com.shopsphere.eshop.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 拼团活动展示 VO（含进行中团列表）
 */
@Data
public class GroupBuyActivityVO {
    private Long id;
    private Long productId;
    private Long skuId;
    private BigDecimal groupPrice;
    /** 原价（用于展示拼团折扣） */
    private BigDecimal originalPrice;
    private Integer targetCount;
    private Integer durationHours;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Integer totalStock;
    private Integer status;
    private String productName;
    private String coverImage;
    private String skuSpecs;
    /** 进行中的团列表 */
    private List<GroupBuyGroupVO> activeGroups;
}
