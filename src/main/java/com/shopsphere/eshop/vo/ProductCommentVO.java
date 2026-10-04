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

    private Boolean purchased;      // 评论人是否已购买该商品（非数据库字段）
    private Boolean liked;          // 当前登录用户是否已点赞（非数据库字段）
    private Boolean merchantReply;  // 子评论是否为商家回复（非数据库字段）
}