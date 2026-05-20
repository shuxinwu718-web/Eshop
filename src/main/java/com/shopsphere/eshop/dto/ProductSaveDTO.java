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
}
