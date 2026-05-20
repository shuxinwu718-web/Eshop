package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.service.OnlineUserService;
import com.shopsphere.eshop.utils.JwtUtil;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@Slf4j
@RestController
@RequestMapping("/api/v1/sse")
@RequiredArgsConstructor
@Tag(name = "用户在线管理", description = "管理员查看用户在线情况")
public class SseController {

    private final OnlineUserService onlineUserService;
    private final JwtUtil jwtUtil;

    private final Map<String, SseEmitter> emitters = new ConcurrentHashMap<>();
    private final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();

    @GetMapping(value = "/connect", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter connect(@RequestParam String token) {
        // 验证 token
        Long userId;
        String username;
        try {
            userId = jwtUtil.getUserIdFromToken(token);
            username = jwtUtil.getUsernameFromToken(token);
        } catch (Exception e) {
            log.warn("SSE 连接 token 验证失败: {}", e.getMessage());
            SseEmitter errorEmitter = new SseEmitter(0L);
            try {
                errorEmitter.send(SseEmitter.event()
                        .name("error")
                        .data("Token验证失败: " + e.getMessage()));
            } catch (IOException ignored) {}
            errorEmitter.complete();
            return errorEmitter;
        }

        // 记录用户在线
        onlineUserService.updateHeartbeat(userId, username);

        // 创建 SSE 连接，超时时间设为 1 小时
        SseEmitter emitter = new SseEmitter(3600000L);
        String emitterId = userId + "_" + System.currentTimeMillis();
        emitters.put(emitterId, emitter);

        // 发送初始在线人数
        try {
            emitter.send(SseEmitter.event()
                    .name("online-count")
                    .data(String.valueOf(onlineUserService.getOnlineCount())));
        } catch (IOException e) {
            emitters.remove(emitterId);
        }

        emitter.onCompletion(() -> {
            emitters.remove(emitterId);
            log.debug("SSE 连接关闭: {}", emitterId);
        });

        emitter.onTimeout(() -> {
            emitters.remove(emitterId);
            log.debug("SSE 连接超时: {}", emitterId);
        });

        emitter.onError(e -> {
            emitters.remove(emitterId);
            log.debug("SSE 连接错误: {}", emitterId);
        });

        log.info("SSE 连接建立: userId={}, username={}", userId, username);
        return emitter;
    }

    @PostConstruct
    public void init() {
        // 定时广播在线人数
        scheduler.scheduleAtFixedRate(() -> {
            int count = onlineUserService.getOnlineCount();
            emitters.entrySet().removeIf(entry -> {
                try {
                    entry.getValue().send(SseEmitter.event()
                            .name("online-count")
                            .data(String.valueOf(count)));
                    return false;
                } catch (IOException e) {
                    return true;
                }
            });
        }, 5, 5, TimeUnit.SECONDS);
    }
}
