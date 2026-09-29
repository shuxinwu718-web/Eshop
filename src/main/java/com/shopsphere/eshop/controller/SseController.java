package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.service.OnlineUserService;
import com.shopsphere.eshop.service.SsePushService;
import com.shopsphere.eshop.utils.JwtUtil;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@Slf4j
@RestController
@RequestMapping("/api/v1/sse")
@RequiredArgsConstructor
@Tag(name = "SSE 长连接", description = "服务端事件推送：在线状态 + 客服消息")
public class SseController {

    private final OnlineUserService onlineUserService;
    private final JwtUtil jwtUtil;
    private final SsePushService ssePushService;
    private final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();

    @GetMapping(value = "/connect", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter connect(@RequestParam String token) {
        Long userId;
        String username;
        // EventSource 无法携带 Authorization 头，token 只能放在 URL query，这里手动校验整包解析。
        // 注意：不依赖 @CurrentUserId（它从 Authorization 头解析，EventSource 请求拿不到，恒为 null）。
        try {
            username = jwtUtil.getUsernameFromToken(token);
            userId = jwtUtil.getUserIdFromToken(token);
        } catch (Exception e) {
            log.warn("SSE 连接 token 验证失败: {}", e.getMessage());
            // 不能抛异常返回 JSON：浏览器 EventSource 对非 text/event-stream 响应判定失败并无限重连。
            // 改为发一条 error 事件后关闭。
            SseEmitter errorEmitter = new SseEmitter(0L);
            try {
                errorEmitter.send(SseEmitter.event().name("error").data("Token验证失败"));
            } catch (IOException ignored) {
            }
            errorEmitter.complete();
            return errorEmitter;
        }

        // 记录在线状态（管理端在线人数用）
        onlineUserService.updateHeartbeat(userId, username);

        // 超时 1 小时，到点触发 onTimeout，前端 EventSource 自动重连接形成"自然续期"
        SseEmitter emitter = new SseEmitter(3600000L);
        ssePushService.register(userId, emitter);

        // 首帧立即发出，让前端 EventSource 立刻判定连接建立（OPEN），并顺带拿到当前在线数
        try {
            emitter.send(SseEmitter.event()
                    .name("online-count")
                    .data(String.valueOf(onlineUserService.getOnlineCount())));
        } catch (IOException e) {
            ssePushService.unregister(userId, emitter);
        }

        // 三个生命周期回调必须都注册：任一触发都要从注册表移除，否则长时间运行会累积泄漏
        emitter.onCompletion(() -> ssePushService.unregister(userId, emitter));
        emitter.onTimeout(() -> ssePushService.unregister(userId, emitter));
        emitter.onError(e -> ssePushService.unregister(userId, emitter));

        log.info("SSE 连接建立: userId={}, username={}", userId, username);
        return emitter;
    }

    @PostConstruct
    public void init() {
        // 每 5 秒广播在线人数（兼作心跳，防止 Nginx/防火墙掐断静默长连接）
        scheduler.scheduleAtFixedRate(() ->
                ssePushService.broadcastOnlineCount(onlineUserService.getOnlineCount()),
                5, 5, TimeUnit.SECONDS);
    }

    @PreDestroy
    public void shutdown() {
        scheduler.shutdown(); // 优雅停机，避免应用停止时调度线程残留
    }
}