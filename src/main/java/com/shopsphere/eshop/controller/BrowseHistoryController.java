package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.service.BrowseHistoryService;
import io.swagger.v3.oas.annotations.tags.Tag;
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
@Tag(name = "浏览历史接口", description = "添加和查看以及清空所有浏览历史")
public class BrowseHistoryController {
    private final BrowseHistoryService historyService;
    private final ProductMapper productMapper;
    @PostMapping
    public Result<?> addHistory(@RequestParam Long productId,
                                @CurrentUserId Long userId) {
        historyService.addHistory(userId, productId);
        return Result.success(null);
    }

    @GetMapping
    public Result<List<Product>> getHistory(@RequestParam(defaultValue = "10") int limit,
                                            @CurrentUserId Long userId) {
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
    public Result<?> clearHistory(@CurrentUserId Long userId) {
        historyService.clearHistory(userId);
        return Result.success(null);
    }
}
