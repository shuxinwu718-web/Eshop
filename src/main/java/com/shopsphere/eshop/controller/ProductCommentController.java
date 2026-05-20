package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.CommentQueryDTO;
import com.shopsphere.eshop.dto.CommentReplyDTO;
import com.shopsphere.eshop.dto.CommentSaveDTO;
import com.shopsphere.eshop.entity.ProductComment;
import com.shopsphere.eshop.service.ProductCommentService;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import com.shopsphere.eshop.vo.ProductCommentVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/comments")
@RequiredArgsConstructor
@Tag(name = "商品评论管理", description = "管理员对商品表的CRUD")
public class ProductCommentController {

    private final ProductCommentService commentService;
    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;
    private Long getCurrentUserId(@RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        return jwtUtil.getUserIdFromToken(token);
    }

    // 用户发表评论
    @PostMapping
    public Result<?> addComment(@Valid @RequestBody CommentSaveDTO dto,
                                @RequestHeader("Authorization") String authHeader) {
        Long userId = getCurrentUserId(authHeader);
        commentService.addComment(dto, userId);
        return Result.success("评论成功");
    }

    // 回复评论
    @PostMapping("/reply")
    public Result<?> replyComment(@Valid @RequestBody CommentReplyDTO dto,
                                  @RequestHeader("Authorization") String authHeader) {
        Long userId = getCurrentUserId(authHeader);
        commentService.replyComment(dto, userId);
        return Result.success("回复成功");
    }

    // 删除评论（用户删自己的，管理员可删任何）
    @DeleteMapping("/{commentId}")
    public Result<?> deleteComment(@PathVariable Long commentId,
                                   @RequestHeader("Authorization") String authHeader) {
        Long userId = getCurrentUserId(authHeader);
        // 判断是否是管理员（可通过 role 判断，这里简化：从 token 获取角色，需要扩展 JwtUtil）
        // 为了代码完整，假设有 isAdmin 方法
        boolean isAdmin = false; // 实际需要从 token 或数据库中获取角色
        commentService.deleteComment(commentId, userId, isAdmin);
        return Result.success("删除成功");
    }

    // 管理员隐藏/显示评论
    @PutMapping("/{commentId}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> updateCommentStatus(@PathVariable Long commentId, @RequestParam Integer status) {
        commentService.updateCommentStatus(commentId, status);
        return Result.success("状态更新成功");
    }

    // 用户端：分页获取某商品的评论（只显示正常状态的顶级评论）
    @GetMapping("/product/{productId}")
    public Result<Page<ProductComment>> getProductComments(@PathVariable Long productId,
                                                           @RequestParam(defaultValue = "1") Integer pageNum,
                                                           @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(commentService.getProductComments(productId, pageNum, pageSize));
    }

    // 用户端： 获取商品的评论，添加评论楼
    @GetMapping("/product/{productId}/all")
    public Result<List<ProductCommentVO>> getProductCommentsFlat(@PathVariable Long productId) {
        return Result.success(commentService.getProductCommentsFlat(productId));
    }

    // 管理员：分页查询所有评论
    @GetMapping("/admin/page")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Page<ProductComment>> adminPageQuery(CommentQueryDTO dto) {
        return Result.success(commentService.adminQueryComments(dto));
    }

    // 获取某条评论的回复列表（可单独接口，也可在商品评论接口中嵌套查询，按需）
    @GetMapping("/replies/{parentId}")
    public Result<Page<ProductComment>> getReplies(@PathVariable Long parentId,
                                                   @RequestParam(defaultValue = "1") Integer pageNum,
                                                   @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(commentService.getRepliesByParentId(parentId, pageNum, pageSize));
    }
}