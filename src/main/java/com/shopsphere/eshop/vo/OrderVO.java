package com.shopsphere.eshop.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class OrderVO {
    private Long id;
    private String orderNo;
    private Long userId;
    private String userName;
    private BigDecimal totalAmount;
    private BigDecimal payAmount;   // 新增：实付金额
    private Integer status;
    private Integer payStatus;
    private LocalDateTime createTime;
    private String receiverName;
    private String receiverPhone;
    private String receiverAddress;

    private List<OrderItemVO> items;

    @Data
    public static class OrderItemVO {
        private Long productId;
        private String productName;
        private BigDecimal productPrice;
        private Integer quantity;
        private BigDecimal totalPrice;
        private String productImage;

        // 物流信息来自所属发货单
        private String shippingNo;
        private String shippingName;
        private Integer deliveryStatus;
    }
}
