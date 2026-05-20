package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.assist.ISqlRunner;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shopsphere.eshop.dto.CommentQueryDTO;
import com.shopsphere.eshop.dto.CommentReplyDTO;
import com.shopsphere.eshop.dto.CommentSaveDTO;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.entity.ProductComment;
import com.shopsphere.eshop.mapper.ProductCommentMapper;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.service.ProductCommentService;
import com.shopsphere.eshop.vo.ProductCommentVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ProductCommentServiceImpl implements ProductCommentService {

    private final ProductCommentMapper commentMapper;
    private final ProductMapper productMapper;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    @Transactional
    public void addComment(CommentSaveDTO dto, Long userId) {
        Product product = productMapper.selectById(dto.getProductId());
        if (product == null) {
            throw new RuntimeException("商品不存在");
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
                throw new RuntimeException("图片格式错误");
            }
        }
        comment.setStatus(1);
        comment.setParentId(0L);
        commentMapper.insert(comment);
    }

    @Override
    @Transactional
    public void replyComment(CommentReplyDTO dto, Long userId) {
        ProductComment parent = commentMapper.selectById(dto.getParentId());
        if (parent == null || parent.getDeleted() != 0) {
            throw new RuntimeException("原评论不存在或已删除");
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
            throw new RuntimeException("评论不存在");
        }
        if (!isAdmin && !comment.getUserId().equals(userId)) {
            throw new RuntimeException("无权删除该评论");
        }
        commentMapper.deleteById(commentId);
    }

    @Override
    @Transactional
    public void updateCommentStatus(Long commentId, Integer status) {
        ProductComment comment = commentMapper.selectById(commentId);
        if (comment == null) {
            throw new RuntimeException("评论不存在");
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
}