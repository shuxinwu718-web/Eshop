package com.shopsphere.eshop.dto;

import lombok.Data;
import jakarta.validation.constraints.NotNull;
import java.util.List;

@Data
public class OrderCreateDTO {
    @NotNull(message = "商品列表不能为空")
    private List<OrderItemDTO> items;
    private String receiverName;
    private String receiverPhone;
    private String receiverAddress;
    private String remark;
    private Long addressId;        // 新增
    private Long userCouponId;   // 新增：用户选中的优惠券记录ID
    @Data
    public static class OrderItemDTO {
        @NotNull(message = "商品ID不能为空")
        private Long productId;
        private Long skuId;       // 新增：选中的SKU ID（可选，兼容无SKU商品）
        @NotNull(message = "数量不能为空")
        private Integer quantity;
    }
}