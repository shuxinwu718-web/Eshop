package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.CollectionUtils;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.shopsphere.eshop.entity.ProductImage;
import com.shopsphere.eshop.mapper.ProductImageMapper;
import com.shopsphere.eshop.service.ProductImageService;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductImageServiceImpl extends ServiceImpl<ProductImageMapper, ProductImage> implements ProductImageService {

    private final ProductImageMapper productImageMapper;
    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;

    private static final String CACHE_IMAGES = "product:images:";
    private static final long IMAGES_TTL = 30;

    @Override
    @SuppressWarnings("unchecked")
    public List<ProductImage> getImagesByProductId(Long productId) {
        String key = CACHE_IMAGES + productId;
        Object cached = redisTemplate.opsForValue().get(key);
        if (cached instanceof List) {
            List<?> list = (List<?>) cached;
            if (!list.isEmpty()) {
                if (list.get(0) instanceof ProductImage) {
                    return (List<ProductImage>) list;
                }
                // 兼容序列化类型丢失（LinkedHashMap → ProductImage）
                List<ProductImage> converted = list.stream()
                        .map(item -> objectMapper.convertValue(item, ProductImage.class))
                        .toList();
                redisTemplate.opsForValue().set(key, converted, IMAGES_TTL, TimeUnit.MINUTES);
                return converted;
            }
            return (List<ProductImage>) list;
        }
        LambdaQueryWrapper<ProductImage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductImage::getProductId, productId)
                .orderByAsc(ProductImage::getSort);
        List<ProductImage> list = productImageMapper.selectList(wrapper);
        redisTemplate.opsForValue().set(key, list, IMAGES_TTL, TimeUnit.MINUTES);
        return list;
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

        // 清除图片缓存
        redisTemplate.delete(CACHE_IMAGES + productId);
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
