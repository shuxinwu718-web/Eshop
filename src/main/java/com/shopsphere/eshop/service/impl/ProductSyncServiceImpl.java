package com.shopsphere.eshop.service.impl;

import com.shopsphere.eshop.document.ProductDocument;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.repository.ProductSearchRepository;
import com.shopsphere.eshop.service.ProductSyncService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
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
    private final ProductSearchRepository searchRepository;

    /**
     * 项目启动后自动执行全量同步（开发阶段方便）
     */
    @EventListener(ApplicationReadyEvent.class)
    public void syncAllProducts() {
        log.info("开始全量同步商品数据到 Elasticsearch...");
        List<Product> products = productMapper.selectList(null);
        List<ProductDocument> documents = products.stream()
                .map(this::convertToDocument)
                .collect(Collectors.toList());
        searchRepository.saveAll(documents);
        log.info("同步完成，共 {} 条商品数据", documents.size());
    }

    /**
     * 增量同步：新增或更新商品时调用
     */
    public void syncOneProduct(Product product) {
        ProductDocument document = convertToDocument(product);
        searchRepository.save(document);
        log.info("同步单个商品到 ES，id={}", product.getId());
    }

    /**
     * 删除商品时从 ES 中删除
     */
    public void deleteProduct(Long productId) {
        searchRepository.deleteById(productId);
        log.info("从 ES 中删除商品，id={}", productId);
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
