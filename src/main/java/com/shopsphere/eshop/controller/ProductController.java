package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.ProductPageQueryDTO;
import com.shopsphere.eshop.dto.ProductSaveDTO;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.entity.ProductImage;
import com.shopsphere.eshop.service.ProductImageService;
import com.shopsphere.eshop.service.ProductService;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/product")
@RequiredArgsConstructor
@Tag(name = "商品管理", description = "管理员对商品表的CRUD")
public class ProductController {

    private final ProductService productService;
    private final ProductImageService productImageService;
    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;
    @PostMapping
    public Result<?> addProduct(@Valid @RequestBody ProductSaveDTO dto,
                                @RequestHeader(value = "Authorization", required = true) String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        dto.setMerchantId(userId);

        productService.addProduct(dto);
        return Result.success("添加成功");
    }

    @PutMapping
    public Result<?> updateProduct(@Valid @RequestBody ProductSaveDTO dto) {
        productService.updateProduct(dto);
        return Result.success("修改成功");
    }

    @DeleteMapping("/{id}")
    public Result<?> deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return Result.success("删除成功");
    }

    @PutMapping("/status/{id}")
    public Result<?> changeStatus(@PathVariable Long id, @RequestParam Integer status) {
        productService.changeStatus(id, status);
        return Result.success("状态更新成功");
    }

    @GetMapping("/page")
    public Result<Page<Product>> pageQuery(ProductPageQueryDTO dto) {
        return Result.success(productService.pageQuery(dto));
    }

    @GetMapping("/{id}")
    public Result<Product> getProductById(@PathVariable Long id) {
        return Result.success(productService.getProductById(id));
    }

    @GetMapping("/{productId}/images")
    public Result<?> getProductImages(@PathVariable Long productId) {
        return Result.success(productImageService.getImagesByProductId(productId));
    }

    @GetMapping("/hot")
    public Result<?> getHotProducts(@RequestParam(defaultValue = "10") Integer limit) {
        return Result.success(productService.getHotProducts(limit));
    }

    @PostMapping("/batch-update-pinyin")
    public Result<?> batchUpdatePinyin() {
        productService.batchUpdatePinyin();
        return Result.success("拼音数据更新完成");
    }
}