package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.ProductPageQueryDTO;
import com.shopsphere.eshop.dto.ProductSaveDTO;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.vo.HotProductVO;
import com.shopsphere.eshop.vo.ProductSalesVO;

import java.util.List;

public interface ProductService {
    void addProduct(ProductSaveDTO dto);
    void updateProduct(ProductSaveDTO dto);
    void deleteProduct(Long id);
    void changeStatus(Long id, Integer status);
    Page<Product> pageQuery(ProductPageQueryDTO dto);
    Product getProductById(Long id);
    Page<Product> getMerchantProducts(Long merchantId, Integer pageNum, Integer pageSize);
    void batchUpdatePinyin();
    List<HotProductVO> getHotProducts(int limit);
    List<ProductSalesVO> getProductSalesByMerchant(Long merchantId);

    /**
     * 商品浏览量 +1（Redis INCR 原子计数，定时异步落库）
     *
     * @return 实时浏览量 = DB 累计值 + Redis 待落库增量
     */
    Integer incrementViewCount(Long productId);
}