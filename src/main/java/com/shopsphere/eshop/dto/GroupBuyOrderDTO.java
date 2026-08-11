package com.shopsphere.eshop.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 拼团下单 DTO（开团/参团共用）
 */
@Data
public class GroupBuyOrderDTO {
    /** 参团必填：目标团ID（开团不需要） */
    private Long groupId;

    @NotNull(message = "请选择收货地址")
    private Long addressId;
}
