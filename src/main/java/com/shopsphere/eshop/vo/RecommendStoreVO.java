package com.shopsphere.eshop.vo;

import lombok.Data;

/**
 * 首页推荐店铺 VO
 */
@Data
public class RecommendStoreVO {
    private Long merchantId;
    private String shopName;
    private String avatar;
    private String backgroundColor;
    private Integer productCount;
    private Long totalSales;
}
