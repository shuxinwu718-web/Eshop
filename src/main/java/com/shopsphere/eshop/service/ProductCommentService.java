package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.core.assist.ISqlRunner;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.CommentQueryDTO;
import com.shopsphere.eshop.dto.CommentReplyDTO;
import com.shopsphere.eshop.dto.CommentSaveDTO;
import com.shopsphere.eshop.entity.ProductComment;
import com.shopsphere.eshop.vo.ProductCommentVO;
import com.shopsphere.eshop.vo.ProductCommentStatsVO;

import java.util.List;
import java.util.Map;

public interface ProductCommentService {
    // 用户发表评论
    void addComment(CommentSaveDTO dto, Long userId);

    /** 查询当前用户是否已对某订单中某商品发表过评价 */
    boolean existsUserComment(Long orderId, Long productId, Long userId);

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

    // 用户端：分页查询商品评论（带用户信息/已购标识/点赞状态，支持 全部/好评/中评/差评/有图 筛选与热度排序）
    Page<ProductCommentVO> pageProductComments(Long productId, Integer pageNum, Integer pageSize,
                                               Integer type, Boolean onlyImage, Integer sortBy,
                                               Long currentUserId);

    // 用户端：商品评价聚合统计（平均分/好评率/星级分布/有图数/最近晒图）
    ProductCommentStatsVO getCommentStats(Long productId);

    // 点赞/取消点赞（toggle），返回 {liked, likeCount}
    Map<String, Object> toggleLike(Long commentId, Long userId);
}