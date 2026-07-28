package com.shopsphere.eshop.vo;

import com.shopsphere.eshop.entity.ProductSpec;
import com.shopsphere.eshop.entity.ProductSku;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class MerchantProductVO {
    private Long id;
    private String name;
    private Long categoryId;
    private String categoryName;
    private BigDecimal price;
    private Integer stock;
    private String coverImage;   // 封面（建议统一驼峰）
    private String description;
    private Integer status;
    private LocalDateTime createTime;
    private List<String> images; // 商品相册图片URL列表

    // ========== 尺寸表数据 ==========
    private String sizeChartTitle;                         // 尺寸表标题
    private List<String> sizeChartColumns;                 // 列头定义
    private List<List<String>> sizeChartRows;              // 行数据

    // ========== 规格模板 ==========
    private List<ProductSpec> specs;                       // 规格模板列表

    // ========== SKU 列表 ==========
    private List<ProductSku> skus;                         // SKU 列表
}