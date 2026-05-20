package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.entity.Favorite;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.mapper.FavoriteMapper;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.service.FavoriteService;
import com.shopsphere.eshop.vo.FavoriteProductVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FavoriteServiceImpl implements FavoriteService {

    private final FavoriteMapper favoriteMapper;
    private final ProductMapper productMapper;

    @Override
    @Transactional
    public void addFavorite(Long userId, Long productId) {
        if (favoriteMapper.existsByUserIdAndProductId(userId, productId)) {
            throw new RuntimeException("已收藏该商品");
        }
        Favorite favorite = new Favorite();
        favorite.setUserId(userId);
        favorite.setProductId(productId);
        favoriteMapper.insert(favorite);
    }

    @Override
    @Transactional
    public void removeFavorite(Long userId, Long productId) {
        LambdaQueryWrapper<Favorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Favorite::getUserId, userId).eq(Favorite::getProductId, productId);
        favoriteMapper.delete(wrapper);
    }

    @Override
    public Page<FavoriteProductVO> pageFavorites(Long userId, Integer pageNum, Integer pageSize) {
        Page<Favorite> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Favorite> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Favorite::getUserId, userId).orderByDesc(Favorite::getCreateTime);
        Page<Favorite> favoritePage = favoriteMapper.selectPage(page, wrapper);

        Page<FavoriteProductVO> voPage = new Page<>(favoritePage.getCurrent(), favoritePage.getSize(), favoritePage.getTotal());
        if (favoritePage.getRecords().isEmpty()) {
            return voPage;
        }

        List<Long> productIds = favoritePage.getRecords().stream()
                .map(Favorite::getProductId)
                .collect(Collectors.toList());
        List<Product> products = productMapper.selectBatchIds(productIds);
        Map<Long, Product> productMap = products.stream()
                .collect(Collectors.toMap(Product::getId, p -> p));

        List<FavoriteProductVO> records = favoritePage.getRecords().stream()
                .map(fav -> {
                    Product product = productMap.get(fav.getProductId());
                    if (product == null) return null;
                    FavoriteProductVO vo = new FavoriteProductVO();
                    vo.setId(fav.getId());
                    vo.setProductId(product.getId());
                    vo.setProductName(product.getName());
                    vo.setProductPrice(product.getPrice());
                    vo.setProductImage(product.getCoverImage());
                    vo.setCreateTime(fav.getCreateTime());
                    return vo;
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
        voPage.setRecords(records);
        return voPage;
    }

    @Override
    public boolean isFavorited(Long userId, Long productId) {
        return favoriteMapper.existsByUserIdAndProductId(userId, productId);
    }
}