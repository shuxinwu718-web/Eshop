package com.shopsphere.eshop.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * 支付宝沙箱/正式支付配置（密钥外置到环境变量，禁止硬编码入库提交）
 */
@Data
@Component
@ConfigurationProperties(prefix = "alipay")
public class AlipayProperties {

    /** 未配置密钥时保持 false，前端支付按钮回落到模拟支付 */
    private boolean enabled = false;

    /** 沙箱网关：https://openapi-sandbox.dl.alipaydev.com/gateway.do；正式网关：https://openapi.alipay.com/gateway.do */
    private String gateway;

    /** 沙箱/正式 APPID */
    private String appId;

    /** 应用私钥（PKCS8） */
    private String appPrivateKey;

    /** 支付宝公钥（用于异步回调验签，注意不是"应用公钥"） */
    private String alipayPublicKey;

    /** 支付宝服务器异步通知地址，必须公网可达 */
    private String notifyUrl;

    /** 支付完成后浏览器同步跳转地址（前端支付结果页，仅作展示，不作为支付凭证） */
    private String returnUrl;

    private String signType = "RSA2";

    private String charset = "UTF-8";

    private String format = "JSON";
}
