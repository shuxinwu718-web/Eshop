package com.shopsphere.eshop.service;

import java.util.List;

public interface BrowseHistoryService {

    /**
     * 记录浏览历史
     * @param userId 用户ID
     * @param productId 商品ID
     */
    void addHistory(Long userId, Long productId);
    /**
     * 获取全部浏览的商品ID列表（按时间倒序）
     * @param userId 用户ID
     * @return 商品ID列表
     */
    List<Long> getAllProductIds(Long userId);
    /**
     * 清空浏览历史
     * @param userId 用户ID
     */
    void clearHistory(Long userId);
}
