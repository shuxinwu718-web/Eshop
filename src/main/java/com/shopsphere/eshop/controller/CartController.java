package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.service.CartService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Min;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Validated
@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
@Tag(name = "用户获取购物车的管理", description = "对购物车的CRUD")
public class CartController {

    private final CartService cartService;

    @PostMapping("/add")
    public Result<?> addToCart(@RequestParam Long productId,
                               @RequestParam(required = false) Long skuId,
                               @RequestParam(defaultValue = "1") Integer quantity,
                               @CurrentUserId Long userId) {
        cartService.addToCart(userId, productId, quantity, skuId);
        return Result.success("已添加到购物车");
    }

    @PutMapping("/update")
    public Result<?> updateCart(@RequestParam Long productId,
                                @RequestParam(required = false) Long skuId,
                                @RequestParam(required = false) @Min(value = 1, message = "购买数量必须大于0") Integer quantity,
                                @RequestParam(required = false) Integer selected,
                                @CurrentUserId Long userId) {
        cartService.updateCart(userId, productId, quantity, selected, skuId);
        return Result.success("更新成功");
    }

    @DeleteMapping("/remove")
    public Result<?> removeFromCart(@RequestParam Long productId,
        @RequestParam(required = false) Long skuId,
        @CurrentUserId Long userId) {
        cartService.deleteCartItem(userId, productId, skuId);
        return Result.success("删除成功");
    }

    @GetMapping("/list")
    public Result<?> listCart(@CurrentUserId Long userId) {
        return Result.success(cartService.listCart(userId));
    }

    @DeleteMapping("/clear")
    public Result<?> clearCart(@CurrentUserId Long userId) {
        cartService.clearCart(userId);
        return Result.success("已清空购物车");
    }
}
