package com.shopsphere.eshop.service;

import java.util.Map;

/**
 * 支付宝沙箱/正式支付服务
 */
public interface PayService {

    /** 沙箱支付是否已启用（前端据此决定跳真实收银台还是模拟支付） */
    boolean isEnabled();

    /**
     * 创建支付宝支付（电脑网站支付），返回可自动提交的支付表单 HTML
     *
     * @param orderId 订单 ID
     * @param userId  当前登录用户（校验订单归属）
     * @return 支付宝收银台表单 HTML（前端插入 DOM 后自动提交即跳转）
     */
    String createAlipayPayment(Long orderId, Long userId);

    /**
     * 处理支付宝异步通知（notify_url）
     *
     * @param params 支付宝 POST 过来的全部表单参数
     * @return "success" 表示已受理（支付宝停止重试），"failure" 表示拒绝（支付宝会重试）
     */
    String handleAlipayNotify(Map<String, String> params);

    /**
     * 主动查单（用户回跳结果页展示 + 回调丢失时人工/自动对账）
     *
     * @return {tradeStatus, payStatus(本地订单是否已支付), orderNo, totalAmount}
     */
    Map<String, Object> queryTradeStatus(Long orderId, Long userId);

    /**
     * 按商户订单号查单：支付宝同步回跳（return_url）只带回 out_trade_no 时使用
     */
    Map<String, Object> queryTradeStatusByOrderNo(String orderNo, Long userId);
}
