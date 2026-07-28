package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.ProductPageQueryDTO;
import com.shopsphere.eshop.dto.ProductSaveDTO;
import com.shopsphere.eshop.entity.Category;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.entity.ProductImage;
import com.shopsphere.eshop.entity.ProductSizeChart;
import com.shopsphere.eshop.entity.ProductSpec;
import com.shopsphere.eshop.entity.ProductSku;
import com.shopsphere.eshop.entity.User;
import com.shopsphere.eshop.mapper.ProductSizeChartMapper;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.CategoryMapper;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.mapper.ProductSpecMapper;
import com.shopsphere.eshop.mapper.ProductSkuMapper;
import com.shopsphere.eshop.mapper.UserMapper;
import com.shopsphere.eshop.service.ProductImageService;
import com.shopsphere.eshop.service.ProductService;
import com.shopsphere.eshop.service.ProductSyncService;
import com.shopsphere.eshop.utils.PinyinUtils;
import com.shopsphere.eshop.vo.HotProductVO;
import com.shopsphere.eshop.vo.ProductSalesVO;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductServiceImpl implements ProductService {

    private final ProductMapper productMapper;
    private final CategoryMapper categoryMapper;
    private final ProductImageService productImageService;
    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;
    private final ProductSyncService productSyncService;
    private final UserMapper userMapper;
    private final ProductSpecMapper productSpecMapper;
    private final ProductSkuMapper productSkuMapper;
    private final ProductSizeChartMapper productSizeChartMapper;
    private static final String CACHE_HOT = "product:hot:";
    private static final String CACHE_DETAIL = "product:detail:";
    private static final String CACHE_IMAGES = "product:images:";
    private static final long HOT_TTL = 5;
    private static final long DETAIL_TTL = 30;

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
        // 3. 保存尺寸表数据
        saveOrUpdateSizeChart(product.getId(), dto);
        // 4. 保存规格模板和SKU
        saveOrUpdateSpecsAndSkus(product.getId(), dto);

        productSyncService.syncOneProduct(product);
        // 新增商品可能影响热榜
        evictHotCache();
    }

    /**
     * 保存或更新尺寸表数据
     */
    private void saveOrUpdateSizeChart(Long productId, ProductSaveDTO dto) {
        // 如果有尺寸表数据则保存，否则删除已有尺寸表
        if (dto.getSizeChartColumns() != null && !dto.getSizeChartColumns().isEmpty()
                && dto.getSizeChartRows() != null && !dto.getSizeChartRows().isEmpty()) {
            // 先尝试查找已有的尺寸表记录
            ProductSizeChart chart = productSizeChartMapper.selectOne(
                    new LambdaQueryWrapper<ProductSizeChart>().eq(ProductSizeChart::getProductId, productId));
            if (chart == null) {
                chart = new ProductSizeChart();
                chart.setProductId(productId);
            }
            chart.setChartTitle(dto.getSizeChartTitle() != null ? dto.getSizeChartTitle() : "尺寸表");
            try {
                chart.setColumnsJson(objectMapper.writeValueAsString(dto.getSizeChartColumns()));
                chart.setRowsJson(objectMapper.writeValueAsString(dto.getSizeChartRows()));
            } catch (Exception e) {
                throw new BusinessException("尺寸表数据格式错误");
            }
            if (chart.getId() != null) {
                productSizeChartMapper.updateById(chart);
            } else {
                productSizeChartMapper.insert(chart);
            }
        } else {
            // 没有尺寸表数据则删除已有的
            productSizeChartMapper.delete(
                    new LambdaQueryWrapper<ProductSizeChart>().eq(ProductSizeChart::getProductId, productId));
        }
    }

    /**
     * 保存或更新规格模板和SKU（先删后增）
     */
    private void saveOrUpdateSpecsAndSkus(Long productId, ProductSaveDTO dto) {
        // 1. 保存规格模板
        productSpecMapper.delete(
                new LambdaQueryWrapper<ProductSpec>().eq(ProductSpec::getProductId, productId));
        if (dto.getSpecs() != null) {
            for (ProductSaveDTO.ProductSpecDTO specDTO : dto.getSpecs()) {
                ProductSpec spec = new ProductSpec();
                spec.setProductId(productId);
                spec.setSpecName(specDTO.getSpecName());
                try {
                    spec.setSpecValues(objectMapper.writeValueAsString(specDTO.getSpecValues()));
                } catch (Exception e) {
                    throw new BusinessException("规格值数据格式错误");
                }
                spec.setSortOrder(specDTO.getSortOrder() != null ? specDTO.getSortOrder() : 0);
                productSpecMapper.insert(spec);
            }
        }

        // 2. 保存SKU
        productSkuMapper.delete(
                new LambdaQueryWrapper<ProductSku>().eq(ProductSku::getProductId, productId));
        if (dto.getSkus() != null) {
            for (ProductSaveDTO.ProductSkuDTO skuDTO : dto.getSkus()) {
                ProductSku sku = new ProductSku();
                sku.setProductId(productId);
                sku.setSpecs(skuDTO.getSpecs());
                sku.setPrice(skuDTO.getPrice());
                sku.setStock(skuDTO.getStock());
                sku.setSkuCode(skuDTO.getSkuCode());
                sku.setImage(skuDTO.getImage());
                productSkuMapper.insert(sku);
            }
        }
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
        // 3. 更新尺寸表数据
        saveOrUpdateSizeChart(product.getId(), dto);
        // 4. 更新规格模板和SKU（先删后增）
        saveOrUpdateSpecsAndSkus(product.getId(), dto);

        productSyncService.syncOneProduct(product);
        // 更新商品后清除相关缓存
        evictDetailCache(product.getId());
        evictHotCache();
    }

    @Override
    public void deleteProduct(Long id) {
        // 删除关联尺寸表
        productSizeChartMapper.delete(
                new LambdaQueryWrapper<ProductSizeChart>().eq(ProductSizeChart::getProductId, id));
        // 删除关联规格模板
        productSpecMapper.delete(
                new LambdaQueryWrapper<ProductSpec>().eq(ProductSpec::getProductId, id));
        // 删除关联SKU
        productSkuMapper.delete(
                new LambdaQueryWrapper<ProductSku>().eq(ProductSku::getProductId, id));

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
            // 填充规格模板
            LambdaQueryWrapper<ProductSpec> specWrapper = new LambdaQueryWrapper<ProductSpec>()
                    .eq(ProductSpec::getProductId, id)
                    .orderByAsc(ProductSpec::getSortOrder);
            product.setSpecs(productSpecMapper.selectList(specWrapper));
            // 填充SKU列表
            LambdaQueryWrapper<ProductSku> skuWrapper = new LambdaQueryWrapper<ProductSku>()
                    .eq(ProductSku::getProductId, id);
            List<ProductSku> skuList = productSkuMapper.selectList(skuWrapper);
            product.setSkus(skuList);
            // 商品总销量 = 各SKU销量之和（有SKU时覆盖 product.sales）
            if (skuList != null && !skuList.isEmpty()) {
                int totalSkuSales = skuList.stream()
                        .filter(s -> s.getSales() != null)
                        .mapToInt(ProductSku::getSales)
                        .sum();
                product.setSales(totalSkuSales);
            }
            // 更新缓存（保证后续请求拿到最新数据）
            redisTemplate.opsForValue().set(key, product, 30, TimeUnit.MINUTES);

            // 填充尺寸表数据
            ProductSizeChart chart = productSizeChartMapper.selectOne(
                    new LambdaQueryWrapper<ProductSizeChart>().eq(ProductSizeChart::getProductId, id));
            if (chart != null) {
                product.setSizeChartTitle(chart.getChartTitle());
                try {
                    @SuppressWarnings("unchecked")
                    List<String> columns = objectMapper.readValue(chart.getColumnsJson(), List.class);
                    product.setSizeChartColumns(columns);
                    @SuppressWarnings("unchecked")
                    List<List<String>> rows = objectMapper.readValue(chart.getRowsJson(), List.class);
                    product.setSizeChartRows(rows);
                } catch (Exception e) {
                    log.warn("解析尺寸表JSON失败, productId={}", id, e);
                }
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

    /**
     * 定时刷新热门商品Redis缓存（每5分钟执行一次）
     * 策略说明：
     * - 定时触发：周期性刷新热门商品缓存，保证即使支付/退款等事件漏清理也能最终一致
     * - 事件触发：订单支付、退款、商品增删改时同步清理缓存（已在对应方法中实现）
     * - 懒加载触发：getHotProducts()/getProductById() 读取时若缓存缺失则回查DB
     * - 数据范围：热门商品(销量+评分)、商品详情(含SKU规格)、商品图片
     * - 一致性保障：DB为数据源，Redis为只读缓存，写操作先更新DB再清理缓存
     */
    @Scheduled(fixedRate = 5 * 60 * 1000) // 每5分钟
    public void scheduledSyncHotProducts() {
        try {
            // 1. 刷新热门商品缓存（重新从DB查询并写入Redis）
            List<HotProductVO> hotProducts = productMapper.selectHotProducts(20);
            if (hotProducts != null && !hotProducts.isEmpty()) {
                redisTemplate.opsForValue().set(
                        CACHE_HOT + 20, hotProducts, HOT_TTL, TimeUnit.MINUTES);
                log.debug("定时刷新热门商品缓存完成，共 {} 条", hotProducts.size());
            }

            // 2. 修正有SKU的商品库存和销量（将product表与SKU表对齐）
            List<Product> onlineProducts = productMapper.selectList(
                    new LambdaQueryWrapper<Product>()
                            .eq(Product::getDeleted, 0)
                            .eq(Product::getStatus, 1));
            int syncCount = 0;
            for (Product p : onlineProducts) {
                List<ProductSku> skuList = productSkuMapper.selectList(
                        new LambdaQueryWrapper<ProductSku>().eq(ProductSku::getProductId, p.getId()));
                if (skuList.isEmpty()) continue;
                int totalStock = skuList.stream()
                        .filter(s -> s.getStock() != null)
                        .mapToInt(ProductSku::getStock)
                        .sum();
                int totalSales = skuList.stream()
                        .filter(s -> s.getSales() != null)
                        .mapToInt(ProductSku::getSales)
                        .sum();
                boolean changed = false;
                if (!p.getStock().equals(totalStock)) {
                    p.setStock(totalStock);
                    changed = true;
                }
                if (!p.getSales().equals(totalSales)) {
                    p.setSales(totalSales);
                    changed = true;
                }
                if (changed) {
                    productMapper.updateById(p);
                    redisTemplate.delete(CACHE_DETAIL + p.getId());
                    syncCount++;
                }
            }
            if (syncCount > 0) {
                log.info("定时同步SKU库存/销量完成，修正了 {} 个商品", syncCount);
            }
        } catch (Exception e) {
            log.error("定时同步热门商品缓存失败", e);
        }
    }

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