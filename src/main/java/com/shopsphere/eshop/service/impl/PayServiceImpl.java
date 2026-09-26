package com.shopsphere.eshop.service.impl;

import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.internal.util.AlipaySignature;
import com.alipay.api.request.AlipayTradePagePayRequest;
import com.alipay.api.request.AlipayTradeQueryRequest;
import com.alipay.api.response.AlipayTradePagePayResponse;
import com.alipay.api.response.AlipayTradeQueryResponse;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.shopsphere.eshop.config.AlipayProperties;
import com.shopsphere.eshop.entity.Order;
import com.shopsphere.eshop.entity.PaymentTransaction;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.OrderMapper;
import com.shopsphere.eshop.mapper.PaymentTransactionMapper;
import com.shopsphere.eshop.service.OrderService;
import com.shopsphere.eshop.service.PayService;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 支付宝支付实现。
 *
 * 关键设计（也是高频面试点）：
 * 1. 幂等：payment_transaction.out_trade_no 唯一约束 + 状态 CAS 条件更新，
 *    支付宝重复通知 / 回调与查单并发到达都不会重复入账；
 * 2. 安全：订单状态只认异步 notify_url 的验签结果，return_url（浏览器同步跳转）仅作展示；
 *    且回调金额必须与订单实付金额一致，防止金额篡改；
 * 3. 竞态：支付成功回调 vs 订单超时取消（RabbitMQ 延迟消息）撞车——
 *    订单已取消时把流水标记为「需退款」，补偿闭环；反之已支付后超时消息到达，
 *    OrderTimeoutConsumer 的状态检查会直接跳过。
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class PayServiceImpl implements PayService {

    private final AlipayProperties alipay;
    private final PaymentTransactionMapper transactionMapper;
    private final OrderMapper orderMapper;
    private final OrderService orderService;

    /** AlipayClient 内部线程安全（复用连接），全局单例；enabled=false 时不初始化 */
    private volatile AlipayClient alipayClient;

    @PostConstruct
    void init() {
        if (!alipay.isEnabled()) {
            log.info("支付宝沙箱支付未启用（alipay.enabled=false），支付按钮将走模拟支付");
            return;
        }
        if (isBlank(alipay.getAppId()) || isBlank(alipay.getAppPrivateKey()) || isBlank(alipay.getAlipayPublicKey())) {
            log.warn("alipay.enabled=true 但 APPID/密钥未配置，沙箱支付不可用，将回落模拟支付");
            alipay.setEnabled(false);
            return;
        }
        this.alipayClient = new DefaultAlipayClient(
                alipay.getGateway(), alipay.getAppId(), alipay.getAppPrivateKey(),
                alipay.getFormat(), alipay.getCharset(), alipay.getAlipayPublicKey(), alipay.getSignType());
        log.info("支付宝支付初始化完成，gateway={}", alipay.getGateway());
    }

    @Override
    public boolean isEnabled() {
        return alipay.isEnabled() && alipayClient != null;
    }

    @Override
    public String createAlipayPayment(Long orderId, Long userId) {
        if (!isEnabled()) {
            throw new BusinessException("沙箱支付未启用，请先在 application.yml 配置 alipay 密钥");
        }
        // 1. 订单校验：归属 + 待付款
        Order order = orderMapper.selectById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }
        if (order.getOrderStatus() != Order.STATUS_PENDING_PAY) {
            throw new BusinessException("订单状态异常，无法支付");
        }

        // 2. 幂等创建/复用支付流水（out_trade_no = 订单号，唯一约束兜底）
        PaymentTransaction tx = getOrCreateTransaction(order);

        // 3. 统一下单（电脑网站支付），SDK 本地签名后返回完整支付表单 HTML
        AlipayTradePagePayRequest request = new AlipayTradePagePayRequest();
        // notify/return 均为可选参数：未配置内网穿透时留空，靠查单对账自愈入账
        if (!isBlank(alipay.getNotifyUrl())) {
            request.setNotifyUrl(alipay.getNotifyUrl());
        }
        if (!isBlank(alipay.getReturnUrl())) {
            request.setReturnUrl(alipay.getReturnUrl());
        }
        // bizContent 用 SDK 的 Model 组装，避免手拼 JSON
        com.alipay.api.domain.AlipayTradePagePayModel model = new com.alipay.api.domain.AlipayTradePagePayModel();
        model.setOutTradeNo(order.getOrderNo());
        model.setTotalAmount(order.getPayAmount().toPlainString());
        model.setSubject("E-Shop 订单 " + order.getOrderNo());
        model.setProductCode("FAST_INSTANT_TRADE_PAY");
        request.setBizModel(model);

        try {
            AlipayTradePagePayResponse response = alipayClient.pageExecute(request);
            if (!response.isSuccess()) {
                log.error("支付宝统一下单失败: orderNo={}, code={}, msg={}",
                        order.getOrderNo(), response.getCode(), response.getMsg());
                throw new BusinessException("唤起支付宝失败：" + response.getMsg());
            }
            log.info("支付宝统一下单成功: orderNo={}, amount={}", order.getOrderNo(), order.getPayAmount());
            return response.getBody(); // 含自动提交 script 的表单 HTML
        } catch (AlipayApiException e) {
            log.error("支付宝下单异常: orderNo={}", order.getOrderNo(), e);
            throw new BusinessException("唤起支付宝失败，请稍后重试");
        }
    }

    @Override
    public String handleAlipayNotify(Map<String, String> params) {
        // 0. 验签：用「支付宝公钥」校验通知确实来自支付宝（防伪造回调刷单）
        boolean signOk;
        try {
            signOk = AlipaySignature.rsaCheckV1(params, alipay.getAlipayPublicKey(),
                    alipay.getCharset(), alipay.getSignType());
        } catch (AlipayApiException e) {
            log.error("回调验签异常", e);
            return "failure";
        }
        if (!signOk) {
            log.warn("支付宝回调验签失败，已拒绝，params={}", params);
            return "failure";
        }

        String outTradeNo = params.get("out_trade_no");
        String tradeNo = params.get("trade_no");
        String tradeStatus = params.get("trade_status");
        String totalAmount = params.get("total_amount");
        String buyerLogonId = params.get("buyer_logon_id");
        log.info("支付宝异步通知: outTradeNo={}, tradeNo={}, tradeStatus={}, totalAmount={}",
                outTradeNo, tradeNo, tradeStatus, totalAmount);

        // 1. 流水必须存在（否则说明不是本系统发起的交易）
        PaymentTransaction tx = transactionMapper.selectOne(new LambdaQueryWrapper<PaymentTransaction>()
                .eq(PaymentTransaction::getOutTradeNo, outTradeNo));
        if (tx == null) {
            log.warn("回调对应的支付流水不存在: outTradeNo={}", outTradeNo);
            return "failure";
        }

        // 2. 幂等：已受理过的通知直接 ack（支付宝会重发通知直到收到 success）
        if (tx.getStatus() != PaymentTransaction.STATUS_PENDING) {
            log.info("重复通知，流水当前状态={}，直接 ack: outTradeNo={}", tx.getStatus(), outTradeNo);
            return "success";
        }

        // 3. 金额校验（防篡改）+ app_id 校验
        if (alipay.getAppId() != null && !alipay.getAppId().equals(params.get("app_id"))) {
            log.warn("回调 app_id 不匹配: {}", params.get("app_id"));
            return "failure";
        }
        if (tx.getAmount().compareTo(new BigDecimal(totalAmount)) != 0) {
            log.warn("回调金额与流水不一致: 流水={}, 通知={}", tx.getAmount(), totalAmount);
            return "failure";
        }

        // 4. 仅 TRADE_SUCCESS / TRADE_FINISHED 视为支付成功
        boolean paid = "TRADE_SUCCESS".equals(tradeStatus) || "TRADE_FINISHED".equals(tradeStatus);
        if (!paid) {
            // TRADE_CLOSED 等：标记流水关闭
            transactionMapper.casUpdateStatus(outTradeNo, PaymentTransaction.STATUS_PENDING,
                    PaymentTransaction.STATUS_CLOSED, tradeNo, buyerLogonId, LocalDateTime.now());
            return "success";
        }

        // 5. 流水 CAS 0→1：并发通知只有一条继续走业务
        int rows = transactionMapper.casUpdateStatus(outTradeNo, PaymentTransaction.STATUS_PENDING,
                PaymentTransaction.STATUS_SUCCESS, tradeNo, buyerLogonId, LocalDateTime.now());
        if (rows == 0) {
            log.info("流水已被其他通知线程处理，跳过: outTradeNo={}", outTradeNo);
            return "success";
        }

        // 6. 推进订单状态（复用既有 payOrder 业务：销量/MQ 扣库存/拼团/商家通知）
        Order order = orderMapper.selectById(tx.getOrderId());
        if (order == null) {
            log.error("支付成功但订单不存在: outTradeNo={}, orderId={}", outTradeNo, tx.getOrderId());
            return "success"; // 数据异常先 ack，人工排查，避免支付宝无限重试
        }
        if (order.getOrderStatus() == Order.STATUS_PENDING_PAY) {
            orderService.payOrder(order.getId(), order.getUserId(), order.getPayAmount());
            log.info("支付宝支付成功，订单已入账: orderNo={}, tradeNo={}", outTradeNo, tradeNo);
        } else if (order.getOrderStatus() == Order.STATUS_CANCELLED) {
            // 竞态：用户在订单被超时取消的瞬间完成了支付 → 标记需退款，补偿闭环
            transactionMapper.casUpdateStatus(outTradeNo, PaymentTransaction.STATUS_SUCCESS,
                    PaymentTransaction.STATUS_REFUND_NEEDED, tradeNo, buyerLogonId, LocalDateTime.now());
            log.warn("订单已超时取消但支付成功（竞态），流水标记为需退款: outTradeNo={}, tradeNo={}",
                    outTradeNo, tradeNo);
        } else {
            log.info("订单状态={}（非待付款），流水保持成功: outTradeNo={}", order.getOrderStatus(), outTradeNo);
        }
        return "success";
    }

    @Override
    public Map<String, Object> queryTradeStatus(Long orderId, Long userId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }
        return queryTradeStatusInternal(order);
    }

    @Override
    public Map<String, Object> queryTradeStatusByOrderNo(String orderNo, Long userId) {
        Order order = orderMapper.selectOne(new LambdaQueryWrapper<Order>()
                .eq(Order::getOrderNo, orderNo));
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }
        return queryTradeStatusInternal(order);
    }

    private Map<String, Object> queryTradeStatusInternal(Order order) {
        Long orderId = order.getId();
        PaymentTransaction tx = transactionMapper.selectOne(new LambdaQueryWrapper<PaymentTransaction>()
                .eq(PaymentTransaction::getOrderId, orderId)
                .orderByDesc(PaymentTransaction::getId)
                .last("LIMIT 1"));

        String tradeStatus = null;
        // 本地已支付直接返回；未支付且启用沙箱时主动查支付宝（对账兜底：回调丢失场景）
        if (order.getOrderStatus() == Order.STATUS_PAID) {
            tradeStatus = "TRADE_SUCCESS";
        } else if (tx != null && isEnabled()) {
            tradeStatus = queryAlipayTrade(order.getOrderNo());
        }

        return Map.of(
                "orderNo", order.getOrderNo(),
                "orderId", orderId,
                "payAmount", order.getPayAmount() == null ? BigDecimal.ZERO : order.getPayAmount(),
                "localPaid", order.getOrderStatus() != Order.STATUS_PENDING_PAY,
                "tradeStatus", tradeStatus == null ? "WAIT_BUYER_PAY" : tradeStatus,
                "txStatus", tx == null ? -1 : tx.getStatus()
        );
    }

    /** 主动调用 alipay.trade.query；若确认已支付但本地未入账，走回调同款入账逻辑（对账自愈） */
    private String queryAlipayTrade(String outTradeNo) {
        AlipayTradeQueryRequest request = new AlipayTradeQueryRequest();
        com.alipay.api.domain.AlipayTradeQueryModel model = new com.alipay.api.domain.AlipayTradeQueryModel();
        model.setOutTradeNo(outTradeNo);
        request.setBizModel(model);
        try {
            AlipayTradeQueryResponse response = alipayClient.execute(request);
            if (response.isSuccess()) {
                String status = response.getTradeStatus();
                if ("TRADE_SUCCESS".equals(status) || "TRADE_FINISHED".equals(status)) {
                    reconcilePaidOrder(outTradeNo, response.getTradeNo());
                }
                return status;
            }
            // ACQ.TRADE_NOT_EXIST：用户根本没进收银台或未付款，属正常
            return "WAIT_BUYER_PAY";
        } catch (AlipayApiException e) {
            log.warn("支付宝查单异常: outTradeNo={}, err={}", outTradeNo, e.getMessage());
            return "QUERY_FAILED";
        }
    }

    /** 定时对账兜底：待支付流水超过 30 分钟 → 主动查单，防回调丢失导致"钱付了单没动" */
    @Scheduled(fixedDelay = 5 * 60 * 1000, initialDelay = 60 * 1000)
    public void reconcilePendingTransactions() {
        if (!isEnabled()) return;
        LocalDateTime threshold = LocalDateTime.now().minusMinutes(30);
        List<PaymentTransaction> pendings = transactionMapper.selectList(
                new LambdaQueryWrapper<PaymentTransaction>()
                        .eq(PaymentTransaction::getStatus, PaymentTransaction.STATUS_PENDING)
                        .lt(PaymentTransaction::getCreateTime, threshold));
        for (PaymentTransaction tx : pendings) {
            try {
                String status = queryAlipayTrade(tx.getOutTradeNo());
                log.info("支付对账: outTradeNo={}, 支付宝状态={}", tx.getOutTradeNo(), status);
            } catch (Exception e) {
                log.warn("对账单笔失败: outTradeNo={}", tx.getOutTradeNo(), e);
            }
        }
    }

    /** 查单确认已支付后的入账（与异步回调共用同一段幂等逻辑） */
    private void reconcilePaidOrder(String outTradeNo, String tradeNo) {
        PaymentTransaction tx = transactionMapper.selectOne(new LambdaQueryWrapper<PaymentTransaction>()
                .eq(PaymentTransaction::getOutTradeNo, outTradeNo));
        if (tx == null || tx.getStatus() != PaymentTransaction.STATUS_PENDING) {
            return; // 已处理过
        }
        int rows = transactionMapper.casUpdateStatus(outTradeNo, PaymentTransaction.STATUS_PENDING,
                PaymentTransaction.STATUS_SUCCESS, tradeNo, null, LocalDateTime.now());
        if (rows == 0) return;

        Order order = orderMapper.selectById(tx.getOrderId());
        if (order != null && order.getOrderStatus() == Order.STATUS_PENDING_PAY) {
            orderService.payOrder(order.getId(), order.getUserId(), order.getPayAmount());
            log.info("查单对账入账成功（回调可能丢失）: orderNo={}, tradeNo={}", outTradeNo, tradeNo);
        } else if (order != null && order.getOrderStatus() == Order.STATUS_CANCELLED) {
            transactionMapper.casUpdateStatus(outTradeNo, PaymentTransaction.STATUS_SUCCESS,
                    PaymentTransaction.STATUS_REFUND_NEEDED, tradeNo, null, LocalDateTime.now());
            log.warn("对账发现已取消订单实际支付成功，标记需退款: orderNo={}", outTradeNo);
        }
    }

    private PaymentTransaction getOrCreateTransaction(Order order) {
        PaymentTransaction existing = transactionMapper.selectOne(new LambdaQueryWrapper<PaymentTransaction>()
                .eq(PaymentTransaction::getOutTradeNo, order.getOrderNo()));
        if (existing != null) {
            if (existing.getStatus() == PaymentTransaction.STATUS_SUCCESS) {
                throw new BusinessException("该订单已支付成功，请勿重复支付");
            }
            if (existing.getStatus() == PaymentTransaction.STATUS_REFUND_NEEDED) {
                throw new BusinessException("该订单存在待退款支付流水，请联系客服处理");
            }
            return existing; // 待支付/已关闭 → 复用同一条流水继续支付
        }
        PaymentTransaction tx = new PaymentTransaction();
        tx.setOutTradeNo(order.getOrderNo());
        tx.setOrderId(order.getId());
        tx.setUserId(order.getUserId());
        tx.setAmount(order.getPayAmount());
        tx.setStatus(PaymentTransaction.STATUS_PENDING);
        tx.setCreateTime(LocalDateTime.now());
        tx.setUpdateTime(LocalDateTime.now());
        try {
            transactionMapper.insert(tx);
        } catch (org.springframework.dao.DuplicateKeyException e) {
            // 并发创建：唯一约束兜底，读回已有流水
            return transactionMapper.selectOne(new LambdaQueryWrapper<PaymentTransaction>()
                    .eq(PaymentTransaction::getOutTradeNo, order.getOrderNo()));
        }
        return tx;
    }

    private static boolean isBlank(String s) {
        return s == null || s.isBlank();
    }
}
