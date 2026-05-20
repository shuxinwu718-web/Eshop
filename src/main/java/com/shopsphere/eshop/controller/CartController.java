package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.service.CartService;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
@Tag(name = "用户获取购物车的管理", description = "对购物车的CRUD")
public class CartController {

    private final CartService cartService;
    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;

    @PostMapping("/add")
    public Result<?> addToCart(@RequestParam Long productId,
                               @RequestHeader("Authorization") String authHeader,
                               @RequestParam(defaultValue = "1") Integer quantity) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);

        cartService.addToCart(userId, productId, quantity);
        return Result.success("已添加到购物车");
    }

    @PutMapping("/update")
    public Result<?> updateCart(@RequestParam Long productId,
                                @RequestParam(required = false) Integer quantity,
                                @RequestHeader("Authorization") String authHeader,
                                @RequestParam(required = false) Integer selected) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        cartService.updateCart(userId, productId, quantity, selected);
        return Result.success("更新成功");
    }

    @DeleteMapping("/remove")
    public Result<?> removeFromCart(@RequestParam Long productId,
        @RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        cartService.deleteCartItem(userId, productId);
        return Result.success("删除成功");
    }

    @GetMapping("/list")
    public Result<?> listCart(@RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        return Result.success(cartService.listCart(userId));
    }

    @DeleteMapping("/clear")
    public Result<?> clearCart(@RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        cartService.clearCart(userId);
        return Result.success("已清空购物车");
    }
}