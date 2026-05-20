package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.core.assist.ISqlRunner;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.CommentQueryDTO;
import com.shopsphere.eshop.dto.CommentReplyDTO;
import com.shopsphere.eshop.dto.CommentSaveDTO;
import com.shopsphere.eshop.entity.ProductComment;
import com.shopsphere.eshop.vo.ProductCommentVO;

import java.util.List;

public interface ProductCommentService {
    // 用户发表评论
    void addComment(CommentSaveDTO dto, Long userId);
    // 回复评论
    void replyComment(CommentReplyDTO dto, Long userId);
    // 删除评论（用户自己或管理员）
    void deleteComment(Long commentId, Long userId, boolean isAdmin);
    // 隐藏/显示评论（管理员）
    void updateCommentStatus(Long commentId, Integer status);
    // 分页查询商品评论（用户端，只显示 status=1 且未被删除的）
    Page<ProductComment> getProductComments(Long productId, Integer pageNum, Integer pageSize);
    // 管理员分页查询所有评论（可按商品/用户/评分等过滤）
    Page<ProductComment> adminQueryComments(CommentQueryDTO dto);

    // 分页获取某条评论的回复列表
    Page<ProductComment> getRepliesByParentId(Long parentId, Integer pageNum, Integer pageSize);

    List<ProductCommentVO> getProductCommentsFlat(Long productId);
}