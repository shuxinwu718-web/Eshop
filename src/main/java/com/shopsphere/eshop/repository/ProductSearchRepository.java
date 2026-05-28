package com.shopsphere.eshop.repository;

import com.shopsphere.eshop.document.ProductDocument;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

public interface ProductSearchRepository extends ElasticsearchRepository<ProductDocument, Long> {
    // 可以添加自定义查询方法，但简单搜索直接用 ElasticsearchRestTemplate
}