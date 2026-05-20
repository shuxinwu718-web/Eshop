package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.shopsphere.eshop.entity.Cart;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.mapper.CartMapper;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CartServiceImpl implements CartService {

    private final CartMapper cartMapper;
    private final ProductMapper productMapper;

    @Override
    public void addToCart(Long userId, Long productId, Integer quantity) {
        LambdaQueryWrapper<Cart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Cart::getUserId, userId).eq(Cart::getProductId, productId);
        Cart existing = cartMapper.selectOne(wrapper);
        if (existing != null) {
            existing.setQuantity(existing.getQuantity() + quantity);
            cartMapper.updateById(existing);
        } else {
            Cart cart = new Cart();
            cart.setUserId(userId);
            cart.setProductId(productId);
            cart.setQuantity(quantity);
            cart.setSelected(1);
            cartMapper.insert(cart);
        }
    }

    @Override
    public void updateCart(Long userId, Long productId, Integer quantity, Integer selected) {
        LambdaQueryWrapper<Cart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Cart::getUserId, userId).eq(Cart::getProductId, productId);
        Cart cart = cartMapper.selectOne(wrapper);
        if (cart == null) {
            throw new RuntimeException("购物车项不存在");
        }
        if (quantity != null) cart.setQuantity(quantity);
        if (selected != null) cart.setSelected(selected);
        cartMapper.updateById(cart);
    }

    @Override
    public void deleteCartItem(Long userId, Long productId) {
        LambdaQueryWrapper<Cart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Cart::getUserId, userId).eq(Cart::getProductId, productId);
        cartMapper.delete(wrapper);
    }

    @Override
    public List<Cart> listCart(Long userId) {
        LambdaQueryWrapper<Cart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Cart::getUserId, userId).orderByDesc(Cart::getCreateTime);
        List<Cart> cartList = cartMapper.selectList(wrapper);
        // 填充商品信息
        return cartList.stream().peek(cart -> {
            Product product = productMapper.selectById(cart.getProductId());
            if (product != null) {
                cart.setProductName(product.getName());
                cart.setProductPrice(product.getPrice());
                cart.setProductImage(product.getCoverImage());
                cart.setStock(product.getStock());
            }
        }).collect(Collectors.toList());
    }

    @Override
    public void clearCart(Long userId) {
        LambdaQueryWrapper<Cart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Cart::getUserId, userId);
        cartMapper.delete(wrapper);
    }
}