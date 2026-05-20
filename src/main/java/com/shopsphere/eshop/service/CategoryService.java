package com.shopsphere.eshop.service;

import com.shopsphere.eshop.entity.Category;
import java.util.List;

public interface CategoryService {
    List<Category> getTree(); // 获取树形分类列表（一次性返回所有）
    void addCategory(Category category);
    void updateCategory(Category category);
    void deleteCategory(Long id);
}