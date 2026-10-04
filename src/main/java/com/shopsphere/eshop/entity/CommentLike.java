package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 评论点赞记录：一条记录代表某用户赞过某评论，UNIQUE(comment_id, user_id) 保证去重。
 */
@Data
@TableName("comment_like")
public class CommentLike {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long commentId;
    private Long userId;
    private LocalDateTime createTime;
}
