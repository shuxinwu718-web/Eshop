package com.shopsphere.eshop.vo;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.entity.Product;
import lombok.Data;

import java.util.Map;

@Data
public class MerchantStoreVO {
    private Long merchantId;
    private String shopName;
    private String avatar;
    private Long productCount;
    private Page<Product> products;
}
