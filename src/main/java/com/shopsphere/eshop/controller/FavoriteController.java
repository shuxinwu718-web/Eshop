package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.service.FavoriteService;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import com.shopsphere.eshop.vo.FavoriteProductVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/favorite")
@RequiredArgsConstructor
@Tag(name = "用户收藏商品的管理", description = "用户对自己收藏商品信息的CRUD")
public class FavoriteController {

    private final FavoriteService favoriteService;
    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;

    private Long getCurrentUserId(@RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        return jwtUtil.getUserIdFromToken(token);
    }

    @PostMapping
    public Result<Void> addFavorite(@RequestParam Long productId,
                                    @RequestHeader("Authorization") String authHeader) {
        Long userId = getCurrentUserId(authHeader);
        favoriteService.addFavorite(userId, productId);
        return Result.success(null);
    }

    @DeleteMapping
    public Result<Void> removeFavorite(@RequestParam Long productId,
                                       @RequestHeader("Authorization") String authHeader) {
        Long userId = getCurrentUserId(authHeader);
        favoriteService.removeFavorite(userId, productId);
        return Result.success(null);
    }

    @GetMapping("/page")
    public Result<Page<FavoriteProductVO>> pageFavorites(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestHeader("Authorization") String authHeader) {
        Long userId = getCurrentUserId(authHeader);
        return Result.success(favoriteService.pageFavorites(userId, pageNum, pageSize));
    }

    @GetMapping("/check")
    public Result<Boolean> checkFavorite(@RequestParam Long productId,
                                         @RequestHeader("Authorization") String authHeader) {
        Long userId = getCurrentUserId(authHeader);
        return Result.success(favoriteService.isFavorited(userId, productId));
    }
}