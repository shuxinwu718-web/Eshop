package com.shopsphere.eshop.dto;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.List;

@Data
public class ProductSaveDTO {
    private Long id;
    @NotBlank(message = "商品名称不能为空")
    private String name;
    private Long categoryId; //类型id
    private Long merchantId; //商家id
    private List<String> images; // 商品相册图片URL列表（按顺序）
    @NotNull(message = "价格不能为空")
    private BigDecimal price;
    @NotNull(message = "库存不能为空")
    private Integer stock;
    private String description;
    private String coverImage;
    private Integer status;

    // ========== 尺寸表数据 ==========
    private String sizeChartTitle;                         // 尺寸表标题
    private List<String> sizeChartColumns;                 // 列头定义（如 ["尺码", "肩宽", "胸围", "衣长"]）
    private List<List<String>> sizeChartRows;              // 行数据

    // ========== 规格模板 ==========
    private List<ProductSpecDTO> specs;                    // 规格模板列表

    // ========== SKU 列表 ==========
    private List<ProductSkuDTO> skus;                      // SKU 列表

    @Data
    public static class ProductSpecDTO {
        private Long id;
        private String specName;       // 规格名，如"颜色"
        private List<String> specValues; // 规格值列表，如["黑色","白色"]
        private Integer sortOrder;
    }

    @Data
    public static class ProductSkuDTO {
        private Long id;
        private String specs;          // JSON键值对字符串，如{"颜色":"黑色","尺码":"41"}
        private BigDecimal price;
        private Integer stock;
        private String skuCode;
        private String image;
    }
}
