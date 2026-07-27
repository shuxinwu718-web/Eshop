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
}