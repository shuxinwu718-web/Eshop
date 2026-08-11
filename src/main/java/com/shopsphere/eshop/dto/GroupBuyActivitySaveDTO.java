package com.shopsphere.eshop.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 拼团活动保存 DTO（商家创建/编辑）
 */
@Data
public class GroupBuyActivitySaveDTO {
    private Long id;

    @NotNull(message = "请选择商品")
    private Long productId;

    /** 可选：绑定单规格（方案A）。无规格商品为 null */
    private Long skuId;

    @NotNull(message = "请输入拼团价")
    @DecimalMin(value = "0.01", message = "拼团价必须大于0")
    private BigDecimal groupPrice;

    @NotNull(message = "请输入成团人数")
    @Min(value = 2, message = "成团人数最少2人")
    @Max(value = 10, message = "成团人数最多10人")
    private Integer targetCount;

    @NotNull(message = "请输入拼团有效期")
    @Min(value = 1, message = "拼团有效期至少1小时")
    @Max(value = 72, message = "拼团有效期最多72小时")
    private Integer durationHours;

    @NotNull(message = "请选择活动开始时间")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime startTime;

    @NotNull(message = "请选择活动结束时间")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime endTime;

    @NotNull(message = "请输入拼团可售库存")
    @Min(value = 1, message = "库存至少为1")
    private Integer totalStock;
}
