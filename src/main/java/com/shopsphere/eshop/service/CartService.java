package com.shopsphere.eshop.service;

import com.shopsphere.eshop.entity.Cart;
import java.util.List;

public interface CartService {
    void addToCart(Long userId, Long productId, Integer quantity, Long skuId);
    void updateCart(Long userId, Long productId, Integer quantity, Integer selected, Long skuId);
    void deleteCartItem(Long userId, Long productId, Long skuId);
    List<Cart> listCart(Long userId);
    void clearCart(Long userId);
}