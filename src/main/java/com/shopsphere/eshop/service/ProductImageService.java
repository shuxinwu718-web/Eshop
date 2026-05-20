package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.shopsphere.eshop.entity.ProductImage;
import java.util.List;

public interface ProductImageService extends IService<ProductImage> {
    List<ProductImage> getImagesByProductId(Long productId);

    /**
     * 保存商品图片列表（先删后增）
     * @param productId 商品ID
     * @param imageUrls 带排序的图片URL列表（按顺序）
     */
    void saveProductImages(Long productId, List<String> imageUrls);

    List<String> getProductImages(Long id);
}
