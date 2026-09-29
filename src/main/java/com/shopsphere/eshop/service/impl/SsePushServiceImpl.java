package com.shopsphere.eshop.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.shopsphere.eshop.service.SsePushService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 内存态 SSE 连接注册表与定向推送实现。
 * 并发安全要点：
 * - userEmitters / 内层 Set 都必须用 Concurrent 容器（回调线程、心跳线程、业务线程并发增删）。
 * - 遍历 Set 期间 remove 是合法的（ConcurrentHashMap.newKeySet 的弱一致迭代器），
 *   普通 HashSet 会抛 ConcurrentModificationException，因此必须用 newKeySet。
 */
@Service
@RequiredArgsConstructor
public class SsePushServiceImpl implements SsePushService {

    private final ObjectMapper objectMapper;

    private final Map<Long, Set<SseEmitter>> userEmitters = new ConcurrentHashMap<>();

    @Override
    public void register(Long userId, SseEmitter emitter) {
        userEmitters.computeIfAbsent(userId, k -> ConcurrentHashMap.newKeySet()).add(emitter);
    }

    @Override
    public void unregister(Long userId, SseEmitter emitter) {
        Set<SseEmitter> set = userEmitters.get(userId);
        if (set != null) {
            set.remove(emitter);
            if (set.isEmpty()) {
                userEmitters.remove(userId); // 防止空 Set 堆积
            }
        }
    }

    @Override
    public boolean sendToUser(Long userId, String eventName, Object data) {
        Set<SseEmitter> set = userEmitters.get(userId);
        if (set == null || set.isEmpty()) {
            return false; // 不在线 → 调用方走离线兜底
        }
        boolean delivered = false;
        for (SseEmitter emitter : set) {
            try {
                // data 统一用 JSON 序列化，保证前端 handleCustomEvent 拿到合法 JSON 字符串
                String json = objectMapper.writeValueAsString(data);
                emitter.send(SseEmitter.event().name(eventName).data(json));
                delivered = true;
            } catch (IOException e) { // JsonProcessingException 是其子类，一并捕获
                set.remove(emitter); // 死连接顺手清掉
            }
        }
        if (set.isEmpty()) {
            userEmitters.remove(userId);
        }
        return delivered;
    }

    @Override
    public void broadcastOnlineCount(int count) {
        for (Map.Entry<Long, Set<SseEmitter>> entry : userEmitters.entrySet()) {
            Set<SseEmitter> set = entry.getValue();
            set.removeIf(emitter -> {
                try {
                    emitter.send(SseEmitter.event().name("online-count").data(String.valueOf(count)));
                    return false;
                } catch (IOException e) {
                    return true; // 发送失败 = 连接已断，本次遍历顺手剔除
                }
            });
            if (set.isEmpty()) {
                userEmitters.remove(entry.getKey());
            }
        }
    }
}