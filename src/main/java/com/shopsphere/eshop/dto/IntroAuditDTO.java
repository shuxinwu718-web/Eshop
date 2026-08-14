package com.shopsphere.eshop.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 商品介绍 审核 请求参数
 */
@Data
public class IntroAuditDTO {

    @NotNull(message = "版本ID不能为空")
    private Long id;

    /** true=通过 false=驳回 */
    @NotNull(message = "审核结果不能为空")
    private Boolean pass;

    /** 驳回原因（驳回时必填） */
    private String remark;
}
