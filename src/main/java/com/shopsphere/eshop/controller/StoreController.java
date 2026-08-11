package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.entity.StoreDesign;
import com.shopsphere.eshop.entity.User;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.mapper.StoreDesignMapper;
import com.shopsphere.eshop.mapper.UserMapper;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/api/merchant")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "店铺信息", description = "公开的商家店铺信息")
public class StoreController {

    /** 小店信息缓存 key 前缀：store:info:{merchantId} */
    public static final String CACHE_KEY_PREFIX = "store:info:";
    /** 小店信息缓存 TTL（秒）：店铺编辑会主动清缓存，短TTL作兜底 */
    private static final long CACHE_TTL_SECONDS = 30;

    private final UserMapper userMapper;
    private final ProductMapper productMapper;
    private final StoreDesignMapper storeDesignMapper;
    private final StringRedisTemplate stringRedisTemplate;
    private final ObjectMapper objectMapper;

    @GetMapping("/{merchantId}/store")
    public Result<Map<String, Object>> getStoreInfo(@PathVariable Long merchantId) {
        String cacheKey = CACHE_KEY_PREFIX + merchantId;

        // 1. 先读缓存
        String cached = stringRedisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            try {
                return Result.success(objectMapper.readValue(cached, new TypeReference<Map<String, Object>>() {
                }));
            } catch (Exception e) {
                log.warn("小店信息缓存反序列化失败，回源DB, merchantId={}", merchantId);
            }
        }

        // 2. 缓存未命中：查库组装
        User merchant = userMapper.selectById(merchantId);
        if (merchant == null) {
            throw new BusinessException("商家不存在");
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

        // 3. 写缓存（店铺信息变动频率低，店铺设计更新时会主动清除）
        try {
            stringRedisTemplate.opsForValue()
                    .set(cacheKey, objectMapper.writeValueAsString(storeInfo), CACHE_TTL_SECONDS, TimeUnit.SECONDS);
        } catch (Exception e) {
            log.warn("小店信息缓存序列化失败, merchantId={}", merchantId);
        }
        return Result.success(storeInfo);
    }
}
