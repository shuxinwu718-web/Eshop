package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.assist.ISqlRunner;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shopsphere.eshop.dto.CommentQueryDTO;
import com.shopsphere.eshop.dto.CommentReplyDTO;
import com.shopsphere.eshop.dto.CommentSaveDTO;
import com.shopsphere.eshop.entity.CommentLike;
import com.shopsphere.eshop.entity.Order;
import com.shopsphere.eshop.entity.OrderItem;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.entity.ProductComment;
import com.shopsphere.eshop.mapper.CommentLikeMapper;
import com.shopsphere.eshop.mapper.OrderItemMapper;
import com.shopsphere.eshop.mapper.OrderMapper;
import com.shopsphere.eshop.mapper.ProductCommentMapper;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.service.ProductCommentService;
import com.shopsphere.eshop.vo.ProductCommentStatsVO;
import com.shopsphere.eshop.vo.ProductCommentVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ProductCommentServiceImpl implements ProductCommentService {

    private final ProductCommentMapper commentMapper;
    private final ProductMapper productMapper;
    private final CommentLikeMapper likeMapper;
    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    @Transactional
    public void addComment(CommentSaveDTO dto, Long userId) {
        Product product = productMapper.selectById(dto.getProductId());
        if (product == null) {
            throw new BusinessException("商品不存在");
        }
        // 订单评价入口：校验订单归属与商品关联，并防止重复评价
        if (dto.getOrderId() != null) {
            validateOrderComment(dto.getOrderId(), dto.getProductId(), userId);
        }
        ProductComment comment = new ProductComment();
        comment.setProductId(dto.getProductId());
        comment.setUserId(userId);
        comment.setRating(dto.getRating());
        comment.setContent(dto.getContent());
        if (dto.getImages() != null && !dto.getImages().isEmpty()) {
            try {
                String imagesJson = objectMapper.writeValueAsString(dto.getImages());
                comment.setImages(imagesJson);
            } catch (JsonProcessingException e) {
                log.error("图片列表转JSON失败", e);
                throw new BusinessException("图片格式错误");
            }
        }
        comment.setStatus(1);
        comment.setParentId(0L);
        commentMapper.insert(comment);
    }

    /**
     * 订单评价校验：订单归属当前用户、订单已完成、商品在订单中、未重复评价
     */
    private void validateOrderComment(Long orderId, Long productId, Long userId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }
        // 只允许已完成的订单发起评价（状态3=已完成）
        if (order.getOrderStatus() == null || order.getOrderStatus() != 3) {
            throw new BusinessException("只有已完成订单才能评价");
        }
        // 商品必须在订单中
        List<OrderItem> items = orderItemMapper.selectList(
                new LambdaQueryWrapper<OrderItem>()
                        .eq(OrderItem::getOrderId, orderId)
                        .eq(OrderItem::getProductId, productId));
        if (items.isEmpty()) {
            throw new BusinessException("该商品不在此订单中");
        }
        // 同一订单+商品只能评价一次
        if (existsUserComment(orderId, productId, userId)) {
            throw new BusinessException("您已评价过该商品");
        }
    }

    @Override
    public boolean existsUserComment(Long orderId, Long productId, Long userId) {
        // 通过订单号关联：查询该用户对该商品的已发表顶层评论（含订单关联场景）
        // 简化实现：同一用户同一商品在订单评价入口下只允许一条评论
        Long count = commentMapper.selectCount(
                new LambdaQueryWrapper<ProductComment>()
                        .eq(ProductComment::getUserId, userId)
                        .eq(ProductComment::getProductId, productId)
                        .eq(ProductComment::getParentId, 0)
                        .eq(ProductComment::getDeleted, 0));
        return count != null && count > 0;
    }

    @Override
    @Transactional
    public void replyComment(CommentReplyDTO dto, Long userId) {
        ProductComment parent = commentMapper.selectById(dto.getParentId());
        if (parent == null || parent.getDeleted() != 0) {
            throw new BusinessException("原评论不存在或已删除");
        }
        ProductComment reply = new ProductComment();
        reply.setProductId(parent.getProductId());
        reply.setUserId(userId);
        reply.setParentId(dto.getParentId());
        reply.setReplyUserId(dto.getReplyUserId());
        reply.setReplyContent(dto.getReplyContent());
        reply.setStatus(1);
        commentMapper.insert(reply);
    }

    @Override
    @Transactional
    public void deleteComment(Long commentId, Long userId, boolean isAdmin) {
        ProductComment comment = commentMapper.selectById(commentId);
        if (comment == null) {
            throw new BusinessException("评论不存在");
        }
        if (!isAdmin && !comment.getUserId().equals(userId)) {
            throw new BusinessException("无权删除该评论");
        }
        commentMapper.deleteById(commentId);
    }

    @Override
    @Transactional
    public void updateCommentStatus(Long commentId, Integer status) {
        ProductComment comment = commentMapper.selectById(commentId);
        if (comment == null) {
            throw new BusinessException("评论不存在");
        }
        comment.setStatus(status);
        commentMapper.updateById(comment);
    }

    @Override
    public Page<ProductComment> getProductComments(Long productId, Integer pageNum, Integer pageSize) {
        Page<ProductComment> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ProductComment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductComment::getProductId, productId)
                .eq(ProductComment::getStatus, 1)
                .eq(ProductComment::getParentId, 0)
                .orderByDesc(ProductComment::getCreateTime);
        return commentMapper.selectPage(page, wrapper);
    }

    @Override
    public Page<ProductComment> adminQueryComments(CommentQueryDTO dto) {
        Page<ProductComment> page = new Page<>(dto.getPageNum(), dto.getPageSize());
        LambdaQueryWrapper<ProductComment> wrapper = new LambdaQueryWrapper<>();
        if (dto.getProductId() != null) {
            wrapper.eq(ProductComment::getProductId, dto.getProductId());
        }
        if (dto.getUserId() != null) {
            wrapper.eq(ProductComment::getUserId, dto.getUserId());
        }
        if (dto.getRating() != null) {
            wrapper.eq(ProductComment::getRating, dto.getRating());
        }
        if (dto.getStatus() != null) {
            wrapper.eq(ProductComment::getStatus, dto.getStatus());
        }
        if (StringUtils.hasText(dto.getKeyword())) {
            wrapper.like(ProductComment::getContent, dto.getKeyword());
        }
        wrapper.orderByDesc(ProductComment::getCreateTime);
        return commentMapper.selectPage(page, wrapper);
    }

    @Override
    public Page<ProductComment> getRepliesByParentId(Long parentId, Integer pageNum, Integer pageSize) {
        Page<ProductComment> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ProductComment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductComment::getParentId, parentId)
                .orderByAsc(ProductComment::getCreateTime);
        return commentMapper.selectPage(page, wrapper);
    }

    @Override
    public List<ProductCommentVO> getProductCommentsFlat(Long productId) {
        return commentMapper.selectCommentsWithUser(productId);
    }

    @Override
    public Page<ProductCommentVO> pageProductComments(Long productId, Integer pageNum, Integer pageSize,
                                                      Integer type, Boolean onlyImage, Integer sortBy,
                                                      Long currentUserId) {
        Page<ProductCommentVO> page = new Page<>(pageNum, pageSize);
        commentMapper.selectCommentPage(page, productId, type, onlyImage, sortBy);
        if (page.getRecords().isEmpty()) {
            return page;
        }
        List<ProductCommentVO> tops = page.getRecords();
        List<Long> topIds = tops.stream().map(ProductCommentVO::getId).collect(Collectors.toList());

        // 1. 批量组装回复 + 识别商家回复（回复者 == 商品商家）
        Product product = productMapper.selectById(productId);
        List<ProductCommentVO> replies = commentMapper.selectRepliesByParentIds(topIds);
        Map<Long, List<ProductCommentVO>> replyMap = replies.stream()
                .collect(Collectors.groupingBy(ProductCommentVO::getParentId));
        replyMap.forEach((pid, list) -> {
            if (product != null) {
                list.forEach(r -> r.setMerchantReply(product.getMerchantId() != null
                        && product.getMerchantId().equals(r.getUserId())));
            }
        });
        tops.forEach(t -> t.setChildren(replyMap.getOrDefault(t.getId(), List.of())));

        // 2. 已购标识（按 userId 批量查询订单，避免 N+1）
        List<Long> userIds = tops.stream().map(ProductCommentVO::getUserId).distinct().collect(Collectors.toList());
        if (!userIds.isEmpty()) {
            Set<Long> purchasedIds = new HashSet<>(commentMapper.selectPurchasedUserIds(productId, userIds));
            tops.forEach(t -> t.setPurchased(purchasedIds.contains(t.getUserId())));
        }

        // 3. 当前登录用户的点赞状态（批量查询 comment_like）
        if (currentUserId != null) {
            Set<Long> likedIds = likeMapper.selectLikedCommentIds(topIds, currentUserId);
            tops.forEach(t -> t.setLiked(likedIds.contains(t.getId())));
        }
        return page;
    }

    @Override
    public ProductCommentStatsVO getCommentStats(Long productId) {
        ProductCommentStatsVO vo = new ProductCommentStatsVO();
        List<Map<String, Object>> dist = commentMapper.selectRatingDist(productId);
        Map<Integer, Long> ratingCount = new HashMap<>();
        long ratedTotal = 0;
        double sum = 0;
        for (Map<String, Object> row : dist) {
            int rating = ((Number) row.get("rating")).intValue();
            long cnt = ((Number) row.get("cnt")).longValue();
            ratingCount.put(rating, cnt);
            ratedTotal += cnt;
            sum += rating * cnt;
        }
        // 总评价数（顶层评论，含无评分）
        Long total = commentMapper.selectCount(new LambdaQueryWrapper<ProductComment>()
                .eq(ProductComment::getProductId, productId)
                .eq(ProductComment::getStatus, 1)
                .eq(ProductComment::getParentId, 0));
        long good = ratingCount.getOrDefault(4, 0L) + ratingCount.getOrDefault(5, 0L);
        vo.setTotal(total);
        vo.setAvgRating(ratedTotal == 0 ? 0.0 : Math.round(sum * 10.0 / ratedTotal) / 10.0);
        vo.setGoodRate(ratedTotal == 0 ? 0 : (int) Math.round(good * 100.0 / ratedTotal));
        vo.setDist(ratingCount);
        vo.setImageCount(commentMapper.countHasImage(productId));
        // 最近晒图（解析 images JSON，最多 8 张）
        List<String> recent = new ArrayList<>();
        for (String imagesJson : commentMapper.selectImageComments(productId, 8)) {
            try {
                List<String> imgs = objectMapper.readValue(imagesJson, new TypeReference<List<String>>() {});
                recent.addAll(imgs);
            } catch (JsonProcessingException ignored) {
                // 单条脏数据跳过，不影响统计
            }
        }
        vo.setRecentImages(recent.stream().limit(8).collect(Collectors.toList()));
        return vo;
    }

    @Override
    @Transactional
    public Map<String, Object> toggleLike(Long commentId, Long userId) {
        ProductComment comment = commentMapper.selectById(commentId);
        if (comment == null || comment.getDeleted() != 0) {
            throw new BusinessException("评论不存在");
        }
        LambdaQueryWrapper<CommentLike> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CommentLike::getCommentId, commentId).eq(CommentLike::getUserId, userId);
        CommentLike existing = likeMapper.selectOne(wrapper);
        boolean liked;
        if (existing != null) {
            // 已赞 → 取消
            likeMapper.deleteById(existing.getId());
            commentMapper.update(null, new LambdaUpdateWrapper<ProductComment>()
                    .eq(ProductComment::getId, commentId)
                    .gt(ProductComment::getLikeCount, 0)
                    .setSql("like_count = like_count - 1"));
            liked = false;
        } else {
            // 未赞 → 点赞（唯一键兜底并发重复）
            CommentLike like = new CommentLike();
            like.setCommentId(commentId);
            like.setUserId(userId);
            try {
                likeMapper.insert(like);
            } catch (DuplicateKeyException e) {
                // 并发下已存在，视为已点赞，直接返回最新数据
                ProductComment fresh = commentMapper.selectById(commentId);
                Map<String, Object> dup = new HashMap<>();
                dup.put("liked", true);
                dup.put("likeCount", fresh != null ? fresh.getLikeCount() : 0);
                return dup;
            }
            commentMapper.update(null, new LambdaUpdateWrapper<ProductComment>()
                    .eq(ProductComment::getId, commentId)
                    .setSql("like_count = like_count + 1"));
            liked = true;
        }
        ProductComment fresh = commentMapper.selectById(commentId);
        Map<String, Object> result = new HashMap<>();
        result.put("liked", liked);
        result.put("likeCount", fresh != null && fresh.getLikeCount() != null ? fresh.getLikeCount() : 0);
        return result;
    }
}