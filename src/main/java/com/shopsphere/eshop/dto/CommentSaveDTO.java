package com.shopsphere.eshop.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import java.util.List;
// （用户发表评论）
@Data
public class CommentSaveDTO {
    @NotNull(message = "商品ID不能为空")
    private Long productId;
    @Min(1) @Max(5)
    private Integer rating;
    @Length(max = 1000)
    private String content;
    private List<String> images; // 前端上传图片后传递URL列表
}