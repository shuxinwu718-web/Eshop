package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shopsphere.eshop.entity.Category;
import com.shopsphere.eshop.mapper.CategoryMapper;
import com.shopsphere.eshop.service.CategoryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class CategoryServiceImpl implements CategoryService {

    /** 分类树缓存 key（全量树，数据量小，读写频率高） */
    private static final String CACHE_KEY = "category:tree";
    /** 分类树缓存过期时间（分钟），分类变更走主动清理，TTL 作为兜底 */
    private static final long CACHE_TTL_MINUTES = 60;

    private final CategoryMapper categoryMapper;
    private final StringRedisTemplate stringRedisTemplate;
    private final ObjectMapper objectMapper;

    @Override
    public List<Category> getTree() {
        // 1. 先读缓存
        String cached = stringRedisTemplate.opsForValue().get(CACHE_KEY);
        if (cached != null) {
            try {
                return objectMapper.readValue(cached, new TypeReference<List<Category>>() {
                });
            } catch (Exception e) {
                log.warn("分类树缓存反序列化失败，回源DB并重建缓存", e);
            }
        }

        // 2. 缓存未命中：查库组树
        List<Category> all = categoryMapper.selectList(new LambdaQueryWrapper<>());
        List<Category> tree = buildTree(all, 0L);

        // 3. 写缓存（分类树结构稳定，主动清理 + 兜底TTL双保障一致性）
        try {
            stringRedisTemplate.opsForValue()
                    .set(CACHE_KEY, objectMapper.writeValueAsString(tree), CACHE_TTL_MINUTES, TimeUnit.MINUTES);
        } catch (Exception e) {
            log.warn("分类树缓存序列化失败", e);
        }
        return tree;
    }

    /** 清除分类树缓存（新增/修改/删除分类时调用） */
    private void evictTreeCache() {
        stringRedisTemplate.delete(CACHE_KEY);
    }

    private List<Category> buildTree(List<Category> all, Long parentId) {
        return all.stream()
                .filter(c -> c.getParentId().equals(parentId))
                .peek(c -> c.setChildren(buildTree(all, c.getId())))
                .collect(Collectors.toList());
    }

    @Override
    public void addCategory(Category category) {
        // 自动设置 level
        if (category.getParentId() == null || category.getParentId() == 0) {
            category.setLevel(1);
        } else {
            Category parent = categoryMapper.selectById(category.getParentId());
            if (parent != null) {
                category.setLevel(parent.getLevel() + 1);
            } else {
                category.setLevel(1);
            }
        }
        categoryMapper.insert(category);
        // 新增分类影响树结构，立即清理缓存
        evictTreeCache();
    }

    @Override
    public void updateCategory(Category category) {
        categoryMapper.updateById(category);
        // 分类信息变更影响树展示，立即清理缓存
        evictTreeCache();
    }

    @Override
    public void deleteCategory(Long id) {
        // 先删除子分类
        LambdaQueryWrapper<Category> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Category::getParentId, id);
        categoryMapper.delete(wrapper);
        // 再删除自身
        categoryMapper.deleteById(id);
        // 删除分类影响树结构，立即清理缓存
        evictTreeCache();
    }


}