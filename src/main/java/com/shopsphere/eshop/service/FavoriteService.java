package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.vo.FavoriteProductVO;

public interface FavoriteService {
    void addFavorite(Long userId, Long productId);
    void removeFavorite(Long userId, Long productId);
    Page<FavoriteProductVO> pageFavorites(Long userId, Integer pageNum, Integer pageSize);
    boolean isFavorited(Long userId, Long productId);
}