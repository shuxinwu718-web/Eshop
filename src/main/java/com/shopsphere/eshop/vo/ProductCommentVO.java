package com.shopsphere.eshop.vo;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class ProductCommentVO {
    private Long id;
    private Long productId;
    private Long userId;
    private String userName;    // 评论人昵称
    private String userAvatar;  // 评论人头像
    private Integer rating;
    private String content;
    private String images;       // JSON数组
    private Integer likeCount;
    private Long parentId;
    private Long replyUserId;
    private String replyContent;
    private LocalDateTime createTime;
    // 前端组装子评论用
    private List<ProductCommentVO> children;  // 非数据库字段，用于前端树形结构
}