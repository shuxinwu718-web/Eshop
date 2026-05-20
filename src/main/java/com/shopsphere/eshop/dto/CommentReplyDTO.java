package com.shopsphere.eshop.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

// （回复评论）
@Data
public class CommentReplyDTO {
    @NotNull(message = "评论ID不能为空")
    private Long parentId;
    @NotNull(message = "被回复用户ID不能为空")
    private Long replyUserId;
    @Length(max = 500)
    private String replyContent;
}