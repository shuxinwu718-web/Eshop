package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.service.PayService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 支付宝沙箱支付接口
 */
@Tag(name = "支付宝支付", description = "沙箱统一下单 / 异步回调 / 查单对账")
@RestController
@RequestMapping("/api/pay/alipay")
@RequiredArgsConstructor
@Slf4j
public class PayController {

    private final PayService payService;

    /** 沙箱支付是否启用（未启用时前端支付按钮回落模拟支付） */
    @Operation(summary = "查询沙箱支付是否启用")
    @GetMapping("/enabled")
    public Result<Boolean> enabled() {
        return Result.success(payService.isEnabled());
    }

    /**
     * 统一下单：返回支付宝收银台支付表单 HTML（前端插入 DOM 后自动提交即跳转收银台）
     */
    @Operation(summary = "创建支付宝支付（返回收银台表单）")
    @PostMapping("/create/{orderId}")
    public Result<String> create(@PathVariable Long orderId,
                                 @CurrentUserId Long userId) {
        return Result.success(payService.createAlipayPayment(orderId, userId));
    }

    /**
     * 支付宝服务器异步通知（notify_url）：
     * - 必须公网可达、必须放行匿名访问（支付宝服务器不带 JWT）
     * - 处理成功返回纯文本 "success"，支付宝才停止重试通知（否则 24h 内多次重发）
     */
    @Operation(summary = "支付宝异步通知回调（支付宝服务器调用）", hidden = true)
    @PostMapping(value = "/notify", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE,
            produces = MediaType.TEXT_PLAIN_VALUE)
    public String notify(@RequestParam Map<String, String> params) {
        return payService.handleAlipayNotify(params);
    }

    /**
     * 主动查单：支付结果页轮询展示 + 回调丢失时人工/定时对账兜底
     */
    @Operation(summary = "查单（结果页轮询/对账）")
    @GetMapping("/query/{orderId}")
    public Result<Map<String, Object>> query(@PathVariable Long orderId,
                                             @CurrentUserId Long userId) {
        return Result.success(payService.queryTradeStatus(orderId, userId));
    }

    /**
     * 按订单号查单：支付宝同步回跳（return_url）只带回 out_trade_no 时由结果页调用
     */
    @Operation(summary = "按订单号查单（支付宝回跳场景）")
    @GetMapping("/query-no/{orderNo}")
    public Result<Map<String, Object>> queryByOrderNo(@PathVariable String orderNo,
                                                      @CurrentUserId Long userId) {
        return Result.success(payService.queryTradeStatusByOrderNo(orderNo, userId));
    }
}
