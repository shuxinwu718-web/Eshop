package com.shopsphere.eshop.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 商品介绍 保存草稿 / 提交审核 请求参数
 */
@Data
public class IntroSubmitDTO {

    @NotNull(message = "商品ID不能为空")
    private Long productId;

    /** 富文本 HTML 内容 */
    @NotNull(message = "商品介绍内容不能为空")
    private String content;
}
