package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 商品介绍版本（富文本 HTML 快照，含审核状态）
 */
@Data
@TableName("product_intro_version")
public class ProductIntroVersion {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long productId;

    /** 版本号（每次提交审核递增） */
    private Integer versionNo;

    /** 富文本 HTML 正文 */
    private String content;

    /** 0-草稿 1-待审核 2-已通过 3-已驳回 */
    private Integer status;

    /** 驳回原因/审核意见 */
    private String auditRemark;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
