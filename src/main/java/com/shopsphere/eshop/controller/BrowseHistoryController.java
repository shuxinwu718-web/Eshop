package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.service.BrowseHistoryService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
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

    /**
     * 分页查询浏览历史（按时间倒序，支持商品名关键词搜索）
     * @param page 页码，从1开始
     * @param size 每页条数
     * @param keyword 商品名关键词（可选）
     */
    @GetMapping
    public Result<Page<Product>> getHistory(@RequestParam(defaultValue = "1") int page,
                                            @RequestParam(defaultValue = "10") int size,
                                            @RequestParam(required = false) String keyword,
                                            @CurrentUserId Long userId) {
        List<Long> productIds = historyService.getAllProductIds(userId);
        List<Product> sorted = new ArrayList<>();
        if (!productIds.isEmpty()) {
            // 批量查询商品，保持浏览顺序
            List<Product> products = productMapper.selectBatchIds(productIds);
            Map<Long, Product> productMap = products.stream()
                    .collect(Collectors.toMap(Product::getId, Function.identity()));
            sorted = productIds.stream()
                    .map(productMap::get)
                    .filter(Objects::nonNull)
                    .collect(Collectors.toList());
        }
        // 关键词过滤（商品名，忽略大小写）
        if (StringUtils.hasText(keyword)) {
            String kw = keyword.trim().toLowerCase();
            sorted = sorted.stream()
                    .filter(p -> p.getName() != null && p.getName().toLowerCase().contains(kw))
                    .collect(Collectors.toList());
        }
        int total = sorted.size();
        int from = Math.min(Math.max(page - 1, 0) * size, total);
        int to = Math.min(from + size, total);
        Page<Product> result = new Page<>(page, size, total);
        result.setRecords(new ArrayList<>(sorted.subList(from, to)));
        return Result.success(result);
    }

    @DeleteMapping
    public Result<?> clearHistory(@CurrentUserId Long userId) {
        historyService.clearHistory(userId);
        return Result.success(null);
    }
}
