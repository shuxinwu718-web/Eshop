package com.shopsphere.eshop.service;

import com.shopsphere.eshop.entity.Product;

public interface ProductSyncService {

    /**
     * 项目启动后自动执行全量同步（开发阶段方便）
     */
    void syncAllProducts();
    /**
     * 增量同步：新增或更新商品时调用
     */
    void syncOneProduct(Product product);
    /**
     * 删除商品时从 ES 中删除
     */
    void deleteProduct(Long productId);
}
