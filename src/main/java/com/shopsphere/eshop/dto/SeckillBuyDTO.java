package com.shopsphere.eshop.dto;

import lombok.Data;

/**
 * 用户参与秒杀请求体
 */
@Data
public class SeckillBuyDTO {

    /** 收货地址ID（秒杀商品模式必填） */
    private Long addressId;
}
