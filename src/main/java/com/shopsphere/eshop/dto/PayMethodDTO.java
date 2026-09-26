package com.shopsphere.eshop.dto;

import lombok.Data;

/**
 * 修改订单支付方式请求
 */
@Data
public class PayMethodDTO {

    /** 支付方式：1微信 2支付宝 */
    private Integer payMethod;
}
