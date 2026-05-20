package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.shopsphere.eshop.entity.Category;
import com.shopsphere.eshop.mapper.CategoryMapper;
import com.shopsphere.eshop.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {

    private final CategoryMapper categoryMapper;

    @Override
    public List<Category> getTree() {
        List<Category> all = categoryMapper.selectList(new LambdaQueryWrapper<>());
        return buildTree(all, 0L);
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
    }

    @Override
    public void updateCategory(Category category) {
        categoryMapper.updateById(category);
    }

    @Override
    public void deleteCategory(Long id) {
        // 先删除子分类
        LambdaQueryWrapper<Category> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Category::getParentId, id);
        categoryMapper.delete(wrapper);
        // 再删除自身
        categoryMapper.deleteById(id);
    }


}