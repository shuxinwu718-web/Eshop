package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.entity.StoreDesign;
import com.shopsphere.eshop.entity.User;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.mapper.StoreDesignMapper;
import com.shopsphere.eshop.mapper.UserMapper;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/merchant")
@RequiredArgsConstructor
@Tag(name = "店铺信息", description = "公开的商家店铺信息")
public class StoreController {

    private final UserMapper userMapper;
    private final ProductMapper productMapper;
    private final StoreDesignMapper storeDesignMapper;

    @GetMapping("/{merchantId}/store")
    public Result<Map<String, Object>> getStoreInfo(@PathVariable Long merchantId) {
        User merchant = userMapper.selectById(merchantId);
        if (merchant == null) {
            return Result.error("商家不存在");
        }

        long productCount = productMapper.selectCount(
                new LambdaQueryWrapper<Product>()
                        .eq(Product::getMerchantId, merchantId)
                        .eq(Product::getStatus, 1));

        // 查询店铺设计配置
        StoreDesign design = storeDesignMapper.selectOne(
                new LambdaQueryWrapper<StoreDesign>()
                        .eq(StoreDesign::getMerchantId, merchantId));

        Map<String, Object> storeInfo = new HashMap<>();
        storeInfo.put("merchantId", merchant.getId());
        storeInfo.put("shopName", merchant.getNickname() != null ? merchant.getNickname() : merchant.getUsername());
        storeInfo.put("avatar", design != null && design.getBannerUrl() != null ? design.getBannerUrl() : merchant.getAvatar());
        storeInfo.put("backgroundColor", design != null ? design.getBackgroundColor() : "#667eea");
        storeInfo.put("productCount", productCount);
        return Result.success(storeInfo);
    }
}
