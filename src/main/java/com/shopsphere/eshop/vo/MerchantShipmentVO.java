package com.shopsphere.eshop.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class MerchantShipmentVO {
    // 发货单信息
    private Long id;
    private Long orderId;
    private String orderNo;
    private LocalDateTime orderCreateTime;
    private Integer payStatus;
    private BigDecimal payAmount;
    private Integer deliveryStatus;
    private String shippingName;
    private String shippingNo;
    private LocalDateTime shippingTime;
    private BigDecimal totalAmount;

    // 买家信息
    private Long userId;
    private String userNickname;
    private String userMobile;

    // 收货信息
    private String receiverName;
    private String receiverPhone;
    private String receiverAddress;

    // 商品明细列表
    private List<ItemVO> items;

    @Data
    public static class ItemVO {
        private Long itemId;
        private Long productId;
        private String productName;
        private String productImage;
        private BigDecimal price;
        private Integer quantity;
        private BigDecimal totalPrice;
    }
}
