package com.shopsphere.eshop.service.impl;

import com.shopsphere.eshop.service.BrowseHistoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
@Service
public class BrowseHistoryServiceImpl implements BrowseHistoryService {

    private final RedisTemplate<String, Object> redisTemplate;
    private static final String HISTORY_KEY_PREFIX = "browse:history:";
    private static final int MAX_SIZE = 20;
    private static final long EXPIRE_DAYS = 7;

    public BrowseHistoryServiceImpl(RedisTemplate<String, Object> redisTemplate) {
        this.redisTemplate = redisTemplate;
    }

    /**
     * 记录浏览历史
     * @param userId 用户ID
     * @param productId 商品ID
     */
    public void addHistory(Long userId, Long productId) {
        String key = HISTORY_KEY_PREFIX + userId;
        // 先移除已存在的商品，保证唯一性
        redisTemplate.opsForList().remove(key, 1, productId);
        // 左侧推入最新浏览
        redisTemplate.opsForList().leftPush(key, productId);
        // 只保留最近 MAX_SIZE 条
        redisTemplate.opsForList().trim(key, 0, MAX_SIZE - 1);
        // 设置过期时间（7天），每次添加都重置过期时间
        redisTemplate.expire(key, EXPIRE_DAYS, TimeUnit.DAYS);
    }

    /**
     * 获取最近浏览的商品ID列表（按时间倒序）
     * @param userId 用户ID
     * @param limit 获取条数
     * @return 商品ID列表
     */
    public List<Long> getRecentProductIds(Long userId, int limit) {
        String key = HISTORY_KEY_PREFIX + userId;
        List<Object> list = redisTemplate.opsForList().range(key, 0, limit - 1);
        if (list == null || list.isEmpty()) {
            return List.of();
        }
        return list.stream()
                .map(obj -> Long.valueOf(obj.toString()))
                .collect(Collectors.toList());
    }

    /**
     * 清空浏览历史
     * @param userId 用户ID
     */
    public void clearHistory(Long userId) {
        String key = HISTORY_KEY_PREFIX + userId;
        redisTemplate.delete(key);
    }
}

