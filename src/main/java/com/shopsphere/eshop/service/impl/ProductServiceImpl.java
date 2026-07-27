package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.ProductPageQueryDTO;
import com.shopsphere.eshop.dto.ProductSaveDTO;
import com.shopsphere.eshop.entity.Category;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.entity.ProductImage;
import com.shopsphere.eshop.entity.User;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.CategoryMapper;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.mapper.UserMapper;
import com.shopsphere.eshop.service.ProductImageService;
import com.shopsphere.eshop.service.ProductService;
import com.shopsphere.eshop.service.ProductSyncService;
import com.shopsphere.eshop.utils.PinyinUtils;
import com.shopsphere.eshop.vo.HotProductVO;
import com.shopsphere.eshop.vo.ProductSalesVO;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

    private final ProductMapper productMapper;
    private final CategoryMapper categoryMapper;
    private final ProductImageService productImageService;
    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;
    private final ProductSyncService productSyncService;
    private final UserMapper userMapper;
    private static final String CACHE_HOT = "product:hot:";
    private static final String CACHE_DETAIL = "product:detail:";
    private static final String CACHE_IMAGES = "product:images:";
    private static final long HOT_TTL = 5;
    private static final long DETAIL_TTL = 30;
    private static final long IMAGES_TTL = 30;

    @Override
    public void addProduct(ProductSaveDTO dto) {
        // 检查商品名称是否重复
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Product::getName, dto.getName());
        if (productMapper.selectCount(wrapper) > 0) {
            throw new BusinessException("商品名称已存在");
        }
        Product product = new Product();
        BeanUtils.copyProperties(dto, product);
        product.setStatus(1); // 默认上架
        product.setNamePinyin(PinyinUtils.getPinyin(dto.getName())); // 自动生成拼音（全拼）
        productMapper.insert(product);

        // 2. 保存商品图片列表
        if (dto.getImages() != null && !dto.getImages().isEmpty()) {
            productImageService.saveProductImages(product.getId(), dto.getImages());
        }
        productSyncService.syncOneProduct(product);
        // 新增商品可能影响热榜
        evictHotCache();
    }

    @Override
    public void updateProduct(ProductSaveDTO dto) {
        Product product = productMapper.selectById(dto.getId());
        if (product == null) {
            throw new BusinessException("商品不存在");
        }
        // 重名检查
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Product::getName, dto.getName())
                .ne(Product::getId, dto.getId());
        if (productMapper.selectCount(wrapper) > 0) {
            throw new BusinessException("商品名称已存在");
        }
        BeanUtils.copyProperties(dto, product);
        product.setNamePinyin(PinyinUtils.getPinyin(dto.getName())); // 更新拼音（全拼）
        productMapper.updateById(product);

        // 2. 更新图片列表（先删后增）
        if (dto.getImages() != null) {
            productImageService.saveProductImages(product.getId(), dto.getImages());
        }
        productSyncService.syncOneProduct(product);
        // 更新商品后清除相关缓存
        evictDetailCache(product.getId());
        evictHotCache();
    }

    @Override
    public void deleteProduct(Long id) {
        // 删除商品主表
        productMapper.deleteById(id);
        // 删除关联图片
        LambdaQueryWrapper<ProductImage> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductImage::getProductId, id);
        productImageService.remove(wrapper);


        productSyncService.deleteProduct(id);
        // 删除后清除缓存
        evictDetailCache(id);
        evictHotCache();
    }

    @Override
    public void changeStatus(Long id, Integer status) {
        Product product = productMapper.selectById(id);
        if (product == null) {
            throw new BusinessException("商品不存在");
        }
        product.setStatus(status);
        productMapper.updateById(product);

        // 状态变更影响商品展示，清除缓存
        evictDetailCache(id);
        evictHotCache();
    }

    @Override
    public Page<Product> pageQuery(ProductPageQueryDTO dto) {
        Page<Product> page = new Page<>(dto.getPageNum(), dto.getPageSize());
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(dto.getName())) {
            // 搜索 name 或 namePinyin（支持汉字和拼音模糊搜索）
            String keyword = dto.getName().trim().toLowerCase();
            // 拼音搜索：去掉空格后匹配（用户可能输入 "shouji" 来匹配 "shou ji"）
            String pinyinKeyword = keyword.replaceAll("\\s+", "");
            wrapper.and(w -> w.like(Product::getName, keyword)
                    .or()
                    .like(Product::getNamePinyin, keyword)
                    .or()
                    .apply("REPLACE(name_pinyin, ' ', '') LIKE {0}", "%" + pinyinKeyword + "%"));
        }
        if (dto.getCategoryId() != null) {
            // 获取该分类及其所有子分类ID
            Set<Long> categoryIds = getAllCategoryIds(dto.getCategoryId());
            wrapper.in(Product::getCategoryId, categoryIds);
        }
        if (dto.getStatus() != null) {
            wrapper.eq(Product::getStatus, dto.getStatus());
        }
        wrapper.orderByDesc(Product::getCreateTime);
        return productMapper.selectPage(page, wrapper);
    }

    @Override
    public Product getProductById(Long id) {
        String key = CACHE_DETAIL + id;
        Object cached = redisTemplate.opsForValue().get(key);
        Product product = null;
        if (cached instanceof Product) {
            product = (Product) cached;
        } else if (cached instanceof Map) {
            product = objectMapper.convertValue(cached, Product.class);
            redisTemplate.opsForValue().set(key, product, DETAIL_TTL, TimeUnit.MINUTES);
        } else {
            product = productMapper.selectById(id);
            if (product != null) {
                redisTemplate.opsForValue().set(key, product, DETAIL_TTL, TimeUnit.MINUTES);
            }
        }
        // 填充商家信息
        if (product != null) {
            User merchant = userMapper.selectById(product.getMerchantId());
            if (merchant != null) {
                product.setMerchantName(merchant.getNickname() != null ? merchant.getNickname() : merchant.getUsername());
                product.setMerchantAvatar(merchant.getAvatar());
            }
        }
        return product;
    }

    @Override
    public Page<Product> getMerchantProducts(Long merchantId, Integer pageNum, Integer pageSize) {
        Page<Product> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<Product>()
                .eq(Product::getMerchantId, merchantId)
                .eq(Product::getStatus, 1);
        return productMapper.selectPage(page, wrapper);
    }

    @Override
    public void batchUpdatePinyin() {
        List<Product> allProducts = productMapper.selectList(new LambdaQueryWrapper<>());
        for (Product product : allProducts) {
            String pinyin = PinyinUtils.getPinyin(product.getName());
            product.setNamePinyin(pinyin);
            productMapper.updateById(product);
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<HotProductVO> getHotProducts(int limit) {
        String key = CACHE_HOT + limit;
        Object cached = redisTemplate.opsForValue().get(key);
        if (cached instanceof List) {
            List<?> list = (List<?>) cached;
            if (!list.isEmpty()) {
                if (list.get(0) instanceof HotProductVO) {
                    return (List<HotProductVO>) list;
                }
                // 兼容序列化类型丢失（LinkedHashMap → HotProductVO）
                List<HotProductVO> converted = list.stream()
                        .map(item -> objectMapper.convertValue(item, HotProductVO.class))
                        .toList();
                redisTemplate.opsForValue().set(key, converted, HOT_TTL, TimeUnit.MINUTES);
                return converted;
            }
            return (List<HotProductVO>) list;
        }
        List<HotProductVO> result = productMapper.selectHotProducts(limit);
        redisTemplate.opsForValue().set(key, result, HOT_TTL, TimeUnit.MINUTES);
        return result;
    }

    @Override
    public List<ProductSalesVO> getProductSalesByMerchant(Long merchantId) {
        return productMapper.selectProductSalesByMerchant(merchantId);
    }

    /**
     * 递归获取指定分类及其所有子分类的ID集合
     */
    private Set<Long> getAllCategoryIds(Long parentId) {
        Set<Long> ids = new HashSet<>();
        ids.add(parentId);
        List<Category> allCategories = categoryMapper.selectList(new LambdaQueryWrapper<>());
        collectChildIds(allCategories, parentId, ids);
        return ids;
    }

    private void collectChildIds(List<Category> all, Long parentId, Set<Long> ids) {
        for (Category cat : all) {
            if (parentId.equals(cat.getParentId())) {
                ids.add(cat.getId());
                collectChildIds(all, cat.getId(), ids);
            }
        }
    }

    // ========== Redis 缓存操作 ==========

    private void evictDetailCache(Long id) {
        redisTemplate.delete(CACHE_DETAIL + id);
        redisTemplate.delete(CACHE_IMAGES + id);
    }

    private void evictHotCache() {
        Set<String> keys = redisTemplate.keys(CACHE_HOT + "*");
        if (keys != null && !keys.isEmpty()) {
            redisTemplate.delete(keys);
        }
    }
}