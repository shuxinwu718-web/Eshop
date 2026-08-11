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
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.*;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductServiceImpl implements ProductService {

    private final ProductMapper productMapper;
    private final CategoryMapper categoryMapper;
    private final ProductImageService productImageService;
    private final RedisTemplate<String, Object> redisTemplate;
    private final StringRedisTemplate stringRedisTemplate;
    private final ObjectMapper objectMapper;
    private final ProductSyncService productSyncService;
    private final UserMapper userMapper;
    private final ProductSpecMapper productSpecMapper;
    private final ProductSkuMapper productSkuMapper;
    private final ProductSizeChartMapper productSizeChartMapper;
    private static final String CACHE_HOT = "product:hot:";
    private static final String CACHE_DETAIL = "product:detail:";
    private static final String CACHE_IMAGES = "product:images:";
    /** 商品浏览量计数 key（Redis INCR 原子计数，定时批量落库） */
    private static final String CACHE_VIEW = "product:view:";
    private static final long HOT_TTL = 5;
    private static final long DETAIL_TTL = 30;
    /** 空值缓存占位符（防缓存穿透） */
    private static final String CACHE_NULL_VALUE = "NULL";
    /** 空值缓存过期时间（分钟），比正常缓存短 */
    private static final long NULL_TTL_MINUTES = 5;
    /** 商品详情缓存基础过期时间（分钟） */
    private static final long DETAIL_TTL_MINUTES = 30;
    /** 分布式锁过期时间（秒），防止持锁线程异常未释放导致死锁 */
    private static final long LOCK_TTL_SECONDS = 10;
    /** 拿不到锁时的自旋重试次数 */
    private static final int LOCK_RETRY_TIMES = 5;

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
        // 价格范围过滤（ES 降级搜索用）
        if (dto.getMinPrice() != null) {
            wrapper.ge(Product::getPrice, dto.getMinPrice());
        }
        if (dto.getMaxPrice() != null) {
            wrapper.le(Product::getPrice, dto.getMaxPrice());
        }
        // 排序（ES 降级搜索用）
        if ("price_asc".equals(dto.getSortBy())) {
            wrapper.orderByAsc(Product::getPrice);
        } else if ("price_desc".equals(dto.getSortBy())) {
            wrapper.orderByDesc(Product::getPrice);
        } else if ("sales".equals(dto.getSortBy())) {
            wrapper.orderByDesc(Product::getSales);
        } else {
            wrapper.orderByDesc(Product::getCreateTime);   // 现有默认：最新
        }
        return productMapper.selectPage(page, wrapper);
    }

    @Override
    public Product getProductById(Long id) {
        String key = CACHE_DETAIL + id;

        // 1. 快速查缓存（StringRedisTemplate 存 JSON 字符串，避免类型序列化陷阱）
        Product cached = readDetailCache(key);
        if (cached != null) return cached;
        if (isNullCached(key)) return null;   // 缓存中明确标记了"商品不存在"

        // 2. 加锁防缓存击穿：同一商品的高并发请求只放一个进 DB，其余等待
        String lockKey = "lock:product:" + id;
        String requestId = UUID.randomUUID().toString();
        Boolean locked = stringRedisTemplate.opsForValue()
                .setIfAbsent(lockKey, requestId, LOCK_TTL_SECONDS, TimeUnit.SECONDS);

        if (Boolean.TRUE.equals(locked)) {
            try {
                // 双重检查：拿到锁后可能已有其他线程回填了缓存
                Product cachedAgain = readDetailCache(key);
                if (cachedAgain != null) return cachedAgain;
                if (isNullCached(key)) return null;

                // 查数据库
                Product product = loadProductFromDB(id);
                if (product == null) {
                    // 缓存空值占位（防穿透），TTL 设短一些
                    stringRedisTemplate.opsForValue()
                            .set(key, CACHE_NULL_VALUE, NULL_TTL_MINUTES, TimeUnit.MINUTES);
                    return null;
                }
                // 随机 TTL 防雪崩：同一批 key 不会集中在同一时刻过期
                long ttl = DETAIL_TTL_MINUTES + ThreadLocalRandom.current().nextInt(10);
                writeDetailCache(key, product, ttl);
                return product;
            } finally {
                // 释放锁：校验 value 唯一标识，防止误删其他线程刚获取的锁
                if (requestId.equals(stringRedisTemplate.opsForValue().get(lockKey))) {
                    stringRedisTemplate.delete(lockKey);
                }
            }
        }

        // 3. 拿不到锁：自旋等待有限次（避免无限递归导致栈溢出 / 无超时阻塞）
        return spinRetryDetail(key, id);
    }

    /** 读商品详情缓存（JSON 字符串 → Product） */
    private Product readDetailCache(String key) {
        String json = stringRedisTemplate.opsForValue().get(key);
        if (json == null || CACHE_NULL_VALUE.equals(json)) return null;
        try {
            return objectMapper.readValue(json, Product.class);
        } catch (Exception e) {
            log.warn("商品详情缓存反序列化失败，回源DB, key={}", key, e);
            return null;
        }
    }

    /** 判断缓存是否为"商品不存在"占位 */
    private boolean isNullCached(String key) {
        return CACHE_NULL_VALUE.equals(stringRedisTemplate.opsForValue().get(key));
    }

    /** 写商品详情缓存（Product → JSON 字符串） */
    private void writeDetailCache(String key, Product product, long ttlMinutes) {
        try {
            stringRedisTemplate.opsForValue()
                    .set(key, objectMapper.writeValueAsString(product), ttlMinutes, TimeUnit.MINUTES);
        } catch (Exception e) {
            log.warn("商品详情缓存序列化失败, key={}", key, e);
        }
    }

    /** 未抢到锁时自旋重试，超限后兜底直查 DB */
    private Product spinRetryDetail(String key, Long id) {
        for (int i = 0; i < LOCK_RETRY_TIMES; i++) {
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            }
            Product cached = readDetailCache(key);
            if (cached != null) return cached;
            if (isNullCached(key)) return null;
        }
        // 兜底：高并发下不再无限等锁，直接查库（保证请求不被卡死）
        return loadProductFromDB(id);
    }

    // 提取查询方法（保持原有逻辑干净）
    private Product loadProductFromDB(Long id) {
        Product product = productMapper.selectById(id);
        if (product == null) return null;

        // 填充商家
        User merchant = userMapper.selectById(product.getMerchantId());
        if (merchant != null) {
            product.setMerchantName(merchant.getNickname());
            product.setMerchantAvatar(merchant.getAvatar());
        }

        // 填充规格
        product.setSpecs(productSpecMapper.selectList(
                new LambdaQueryWrapper<ProductSpec>()
                        .eq(ProductSpec::getProductId, id)
                        .orderByAsc(ProductSpec::getSortOrder)));

        // 填充 SKU
        List<ProductSku> skuList = productSkuMapper.selectList(
                new LambdaQueryWrapper<ProductSku>()
                        .eq(ProductSku::getProductId, id));
        product.setSkus(skuList);

        // 计算销量
        if (skuList != null) {
            int totalSales = skuList.stream()
                    .filter(s -> s.getSales() != null)
                    .mapToInt(ProductSku::getSales)
                    .sum();
            product.setSales(totalSales);
        }

        // 尺寸表
        ProductSizeChart chart = productSizeChartMapper.selectOne(
                new LambdaQueryWrapper<ProductSizeChart>()
                        .eq(ProductSizeChart::getProductId, id));
        if (chart != null) {
            product.setSizeChartTitle(chart.getChartTitle());
            try {
                List<String> columns = objectMapper.readValue(chart.getColumnsJson(), List.class);
                product.setSizeChartColumns(columns);
                List<List<String>> rows = objectMapper.readValue(chart.getRowsJson(), List.class);
                product.setSizeChartRows(rows);
            } catch (Exception e) {
                log.warn("解析尺寸表失败, productId={}", id, e);
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
                    stringRedisTemplate.delete(CACHE_DETAIL + p.getId());
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
        stringRedisTemplate.delete(CACHE_DETAIL + id);
        stringRedisTemplate.delete(CACHE_IMAGES + id);
    }

    private void evictHotCache() {
        Set<String> keys = stringRedisTemplate.keys(CACHE_HOT + "*");
        if (keys != null && !keys.isEmpty()) {
            stringRedisTemplate.delete(keys);
        }
    }

    @Override
    public Integer incrementViewCount(Long productId) {
        // Redis INCR 原子自增（高并发下不丢计数、无锁竞争）
        Long delta = stringRedisTemplate.opsForValue().increment(CACHE_VIEW + productId);
        Product product = productMapper.selectById(productId);
        if (product == null) {
            return delta != null ? delta.intValue() : 0;
        }
        // 实时浏览量 = DB 累计值 + Redis 待落库增量
        int dbViews = product.getViews() == null ? 0 : product.getViews();
        return dbViews + (delta == null ? 0 : delta.intValue());
    }

    /**
     * 浏览量异步落库（每5分钟）：Redis INCR 计数 → 合并到 product.views → 清空计数键。
     * 使用 GETDEL 原子"取值+删除"，避免并发重复累加；异常时键保留，下轮重试。
     */
    @Scheduled(cron = "0 */5 * * * ?")
    public void flushViewCounts() {
        Set<String> keys = stringRedisTemplate.keys(CACHE_VIEW + "*");
        if (keys == null || keys.isEmpty()) return;
        int updated = 0;
        for (String key : keys) {
            try {
                Long delta = Long.valueOf(stringRedisTemplate.opsForValue().getAndDelete(key));
                if (delta == null || delta <= 0) continue;
                Long productId = Long.parseLong(key.substring(CACHE_VIEW.length()));
                Product product = productMapper.selectById(productId);
                if (product == null) continue;
                int newViews = (product.getViews() == null ? 0 : product.getViews()) + delta.intValue();
                productMapper.updateViews(productId, newViews);
                // 详情缓存中的 views 快照已过期，删除以便下次读取时重建
                stringRedisTemplate.delete(CACHE_DETAIL + productId);
                updated++;
            } catch (Exception e) {
                log.warn("浏览量落库失败 key={}", key, e);
            }
        }
        if (updated > 0) {
            log.info("浏览量异步落库完成，共更新 {} 个商品", updated);
        }
    }
}