package com.shopsphere.eshop.vo;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 商品介绍 版本元数据（不含正文，供列表展示）
 */
@Data
public class IntroVersionVO {

    private Long id;

    private Long productId;

    private Integer versionNo;

    /** 0-草稿 1-待审核 2-已通过 3-已驳回 */
    private Integer status;

    private String auditRemark;

    private LocalDateTime createTime;
}
