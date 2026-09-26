package com.shopsphere.eshop.vo;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * 商品详情页关联推荐结果
 */
@Data
public class RelatedProductsVO {

    /** 同类相似商品（同分类，按销量、评分降序） */
    private List<HotProductVO> similar = new ArrayList<>();

    /** 同店热销商品（同商家，按销量、评分降序） */
    private List<HotProductVO> storeHot = new ArrayList<>();
}
