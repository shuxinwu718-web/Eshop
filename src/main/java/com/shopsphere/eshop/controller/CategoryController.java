package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
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
    public Result<?> addCategory(@RequestBody Category category) {
        categoryService.addCategory(category);
        return Result.success("添加成功");
    }

    @PutMapping
    public Result<?> updateCategory(@RequestBody Category category) {
        categoryService.updateCategory(category);
        return Result.success("修改成功");
    }

    @DeleteMapping("/{id}")
    public Result<?> deleteCategory(@PathVariable Long id) {
        categoryService.deleteCategory(id);
        return Result.success("删除成功");
    }
}