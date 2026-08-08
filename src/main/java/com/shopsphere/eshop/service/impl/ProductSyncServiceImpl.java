package com.shopsphere.eshop.service.impl;

import com.shopsphere.eshop.document.ProductDocument;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.repository.ProductSearchRepository;
import com.shopsphere.eshop.service.ProductSyncService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;

import java.time.ZoneOffset;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ProductSyncServiceImpl implements ProductSyncService {


    private final ProductMapper productMapper;
    private final ObjectProvider<ProductSearchRepository> searchRepositoryProvider;

    /**
     * 项目启动后自动执行全量同步（开发阶段方便）
     */
    @EventListener(ApplicationReadyEvent.class)
    public void syncAllProducts() {
        ProductSearchRepository searchRepository = searchRepositoryProvider.getIfAvailable();
        if (searchRepository == null) {
            log.info("Elasticsearch 未启用，跳过全量商品同步");
            return;
        }
        log.info("开始全量同步商品数据到 Elasticsearch...");
        try {
            List<Product> products = productMapper.selectList(null);
            List<ProductDocument> documents = products.stream()
                    .map(this::convertToDocument)
                    .collect(Collectors.toList());
            searchRepository.saveAll(documents);
            log.info("同步完成，共 {} 条商品数据", documents.size());
        } catch (Exception e) {
            log.error("ES 同步失败（应用仍可正常运行）: {}", e.getMessage());
        }
    }

    /**
     * 增量同步：新增或更新商品时调用
     */
    public void syncOneProduct(Product product) {
        ProductSearchRepository searchRepository = searchRepositoryProvider.getIfAvailable();
        if (searchRepository == null) {
            return; // ES 未启用，跳过同步（不影响 MySQL 侧业务）
        }
        try {
            ProductDocument document = convertToDocument(product);
            searchRepository.save(document);
            log.info("同步单个商品到 ES，id={}", product.getId());
        } catch (Exception e) {
            log.error("同步商品到 ES 失败（已忽略）: {}", e.getMessage());
        }
    }

    /**
     * 删除商品时从 ES 中删除
     */
    public void deleteProduct(Long productId) {
        ProductSearchRepository searchRepository = searchRepositoryProvider.getIfAvailable();
        if (searchRepository == null) {
            return; // ES 未启用，跳过删除
        }
        try {
            searchRepository.deleteById(productId);
            log.info("从 ES 中删除商品，id={}", productId);
        } catch (Exception e) {
            log.error("从 ES 删除商品失败（已忽略）: {}", e.getMessage());
        }
    }

    private ProductDocument convertToDocument(Product product) {
        ProductDocument doc = new ProductDocument();
        BeanUtils.copyProperties(product, doc);
        // 时间戳转换：LocalDateTime → epoch millis
        if (product.getCreateTime() != null) {
            doc.setCreateTime(product.getCreateTime().toInstant(ZoneOffset.ofHours(8)).toEpochMilli());
        }
        // 拼音去空格，方便 ES 连续拼音搜索（如 "shouji" 匹配 "shou ji"）
        if (product.getNamePinyin() != null) {
            doc.setNamePinyin(product.getNamePinyin().replace(" ", ""));
        }
        return doc;
    }


}
