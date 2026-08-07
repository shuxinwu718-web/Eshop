package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.annotation.Log;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.constant.OperationType;

import com.shopsphere.eshop.entity.Category;
import com.shopsphere.eshop.service.CategoryService;
import com.shopsphere.eshop.utils.JwtUtil;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/category")
@RequiredArgsConstructor
@Tag(name = "管理员对类型的管理", description = "对类型的CRUD")
public class CategoryController {

    private final CategoryService categoryService;


    @GetMapping("/tree")
    public Result<List<Category>> getTree() {
        return Result.success(categoryService.getTree());
    }

    @PostMapping
    @Log(value = "添加分类", type = OperationType.ADD_CATEGORY, targetType = "Category")
    public Result<?> addCategory(@RequestBody Category category) {
        categoryService.addCategory(category);
        return Result.success("添加成功");
    }

    @PutMapping
    @Log(value = "修改分类", type = OperationType.UPDATE_CATEGORY, targetType = "Category")
    public Result<?> updateCategory(@RequestBody Category category) {
        categoryService.updateCategory(category);
        return Result.success("修改成功");
    }

    @DeleteMapping("/{id}")
    @Log(value = "删除分类", type = OperationType.DELETE_CATEGORY, targetType = "Category")
    public Result<?> deleteCategory(@PathVariable Long id) {
        categoryService.deleteCategory(id);
        return Result.success("删除成功");
    }
}