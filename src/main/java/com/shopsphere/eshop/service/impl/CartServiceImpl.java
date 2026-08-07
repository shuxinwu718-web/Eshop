package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.shopsphere.eshop.entity.Cart;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.entity.ProductSku;
import com.shopsphere.eshop.mapper.CartMapper;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.mapper.ProductSkuMapper;
import com.shopsphere.eshop.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CartServiceImpl implements CartService {

    private final CartMapper cartMapper;
    private final ProductMapper productMapper;
    private final ProductSkuMapper productSkuMapper;

    @Override
    public void addToCart(Long userId, Long productId, Integer quantity, Long skuId) {
        if (quantity == null || quantity < 1) {
            throw new BusinessException("购买数量必须大于0");
        }
        // 禁止商家购买自家商品
        Product product = productMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException("商品不存在");
        }
        if (product.getMerchantId() != null && product.getMerchantId().equals(userId)) {
            throw new BusinessException("不能购买自家商品");
        }

        LambdaQueryWrapper<Cart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Cart::getUserId, userId)
               .eq(Cart::getProductId, productId)
               .eq(skuId != null, Cart::getSkuId, skuId);
        Cart existing = cartMapper.selectOne(wrapper);
        if (existing != null) {
            existing.setQuantity(existing.getQuantity() + quantity);
            cartMapper.updateById(existing);
        } else {
            Cart cart = new Cart();
            cart.setUserId(userId);
            cart.setProductId(productId);
            cart.setSkuId(skuId);
            // 设置skuSpecs（描述文字）
            if (skuId != null) {
                ProductSku sku = productSkuMapper.selectById(skuId);
                if (sku != null) {
                    cart.setSkuSpecs(sku.getSpecs());
                }
            }
            cart.setQuantity(quantity);
            cart.setSelected(1);
            cartMapper.insert(cart);
        }
    }

    @Override
    public void updateCart(Long userId, Long productId, Integer quantity, Integer selected, Long skuId) {
        if (quantity != null && quantity < 1) {
            throw new BusinessException("购买数量必须大于0");
        }
        LambdaQueryWrapper<Cart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Cart::getUserId, userId)
               .eq(Cart::getProductId, productId)
               .eq(skuId != null, Cart::getSkuId, skuId);
        Cart cart = cartMapper.selectOne(wrapper);
        if (cart == null) {
            throw new BusinessException("购物车项不存在");
        }
        if (quantity != null) cart.setQuantity(quantity);
        if (selected != null) cart.setSelected(selected);
        cartMapper.updateById(cart);
    }

    @Override
    public void deleteCartItem(Long userId, Long productId, Long skuId) {
        LambdaQueryWrapper<Cart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Cart::getUserId, userId)
               .eq(Cart::getProductId, productId)
               .eq(skuId != null, Cart::getSkuId, skuId);
        cartMapper.delete(wrapper);
    }

    @Override
    public List<Cart> listCart(Long userId) {
        LambdaQueryWrapper<Cart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Cart::getUserId, userId).orderByDesc(Cart::getCreateTime);
        List<Cart> cartList = cartMapper.selectList(wrapper);
        if (cartList.isEmpty()) {
            return cartList;
        }
        // Q9 整改：批量查询商品与 SKU，避免逐条 selectById（N+1）
        List<Long> productIds = cartList.stream()
                .map(Cart::getProductId)
                .filter(Objects::nonNull)
                .distinct()
                .collect(Collectors.toList());
        Map<Long, Product> productMap = productMapper.selectBatchIds(productIds).stream()
                .collect(Collectors.toMap(Product::getId, p -> p));

        List<Long> skuIds = cartList.stream()
                .map(Cart::getSkuId)
                .filter(Objects::nonNull)
                .distinct()
                .collect(Collectors.toList());
        Map<Long, ProductSku> skuMap = skuIds.isEmpty() ? Collections.emptyMap()
                : productSkuMapper.selectBatchIds(skuIds).stream()
                        .collect(Collectors.toMap(ProductSku::getId, s -> s));

        // 填充商品信息
        cartList.forEach(cart -> {
            Product product = productMap.get(cart.getProductId());
            if (product != null) {
                cart.setProductName(product.getName());
                // 如果选中了SKU，使用SKU的价格和库存
                if (cart.getSkuId() != null) {
                    ProductSku sku = skuMap.get(cart.getSkuId());
                    if (sku != null) {
                        cart.setProductPrice(sku.getPrice());
                        cart.setStock(sku.getStock());
                        cart.setProductImage(sku.getImage() != null ? sku.getImage() : product.getCoverImage());
                    } else {
                        cart.setProductPrice(product.getPrice());
                        cart.setStock(product.getStock());
                        cart.setProductImage(product.getCoverImage());
                    }
                } else {
                    cart.setProductPrice(product.getPrice());
                    cart.setProductImage(product.getCoverImage());
                    cart.setStock(product.getStock());
                }
            }
        });
        return cartList;
    }

    @Override
    public void clearCart(Long userId) {
        LambdaQueryWrapper<Cart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Cart::getUserId, userId);
        cartMapper.delete(wrapper);
    }
}
