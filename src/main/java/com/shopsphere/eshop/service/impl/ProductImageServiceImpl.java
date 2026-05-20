package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.CollectionUtils;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shopsphere.eshop.entity.ProductImage;
import com.shopsphere.eshop.mapper.ProductImageMapper;
import com.shopsphere.eshop.service.ProductImageService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductImageServiceImpl extends ServiceImpl<ProductImageMapper, ProductImage> implements ProductImageService {

    private final ProductImageMapper productImageMapper;

    @Override
    public List<ProductImage> getImagesByProductId(Long productId) {
        LambdaQueryWrapper<ProductImage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductImage::getProductId, productId)
                .orderByAsc(ProductImage::getSort);
        return productImageMapper.selectList(wrapper);
    }


    @Override
    @Transactional
    public void saveProductImages(Long productId, List<String> imageUrls) {
        // 删除旧图片
        LambdaQueryWrapper<ProductImage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductImage::getProductId, productId);
        this.remove(wrapper);

        if (CollectionUtils.isEmpty(imageUrls)) {
            return;
        }

        // 批量插入新图片，按顺序设置 sort
        List<ProductImage> list = new ArrayList<>();
        for (int i = 0; i < imageUrls.size(); i++) {
            ProductImage img = new ProductImage();
            img.setProductId(productId);
            img.setImageUrl(imageUrls.get(i));
            img.setSort(i); // 从0开始排序
            list.add(img);
        }
        this.saveBatch(list);
    }

    @Override
    public List<String> getProductImages(Long productId) {
        LambdaQueryWrapper<ProductImage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductImage::getProductId, productId)
                .orderByAsc(ProductImage::getSort);
        List<ProductImage> list = this.list(wrapper);
        return list.stream().map(ProductImage::getImageUrl).collect(Collectors.toList());
    }


}
