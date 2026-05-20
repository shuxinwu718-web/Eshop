package com.shopsphere.eshop.service;

import com.shopsphere.eshop.entity.Cart;
import java.util.List;

public interface CartService {
    void addToCart(Long userId, Long productId, Integer quantity);
    void updateCart(Long userId, Long productId, Integer quantity, Integer selected);
    void deleteCartItem(Long userId, Long productId);
    List<Cart> listCart(Long userId);
    void clearCart(Long userId);
}