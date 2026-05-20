package com.shopsphere.eshop.dto;

import lombok.Data;

@Data
public class CommentQueryDTO {
    private Integer pageNum = 1;
    private Integer pageSize = 10;
    private Long productId;      // 商品ID（用户端）
    private Long userId;         // 用户ID（管理员按用户查询）
    private Integer rating;      // 评分
    private Integer status;      // 状态
    private String keyword;      // 评论内容关键词
}