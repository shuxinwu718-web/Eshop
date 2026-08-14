package com.shopsphere.eshop.vo;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 商品介绍 审核列表项（含商品/商家信息与正文预览）
 */
@Data
public class IntroAuditVO {

    private Long id;

    private Long productId;

    private Integer versionNo;

    /** 富文本 HTML 正文 */
    private String content;

    /** 0-草稿 1-待审核 2-已通过 3-已驳回 */
    private Integer status;

    private String auditRemark;

    private LocalDateTime submitTime;

    private String productName;

    private String coverImage;

    private String merchantName;
}
