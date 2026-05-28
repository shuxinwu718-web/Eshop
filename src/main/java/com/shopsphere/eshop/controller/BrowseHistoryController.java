package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.service.BrowseHistoryService;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/product/history")
@RequiredArgsConstructor
public class BrowseHistoryController {
    private final BrowseHistoryService historyService;
    private final ProductMapper productMapper;
    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;
    @PostMapping
    public Result<?> addHistory(@RequestParam Long productId,
                                @RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        historyService.addHistory(userId, productId);
        return Result.success(null);
    }

    @GetMapping
    public Result<List<Product>> getHistory(@RequestParam(defaultValue = "10") int limit,
                                            @RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        List<Long> productIds = historyService.getRecentProductIds(userId, limit);
        if (productIds.isEmpty()) {
            return Result.success(List.of());
        }
        // 批量查询商品，保持顺序
        List<Product> products = productMapper.selectBatchIds(productIds);
        // 按照 productIds 的顺序重新排序
        Map<Long, Product> productMap = products.stream().collect(Collectors.toMap(Product::getId, Function.identity()));
        List<Product> sorted = productIds.stream()
                .map(productMap::get)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
        return Result.success(sorted);
    }

    @DeleteMapping
    public Result<?> clearHistory(@RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        historyService.clearHistory(userId);
        return Result.success(null);
    }
}