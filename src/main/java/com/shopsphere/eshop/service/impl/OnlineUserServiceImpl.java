package com.shopsphere.eshop.service.impl;

import com.shopsphere.eshop.service.OnlineUserService;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
@RequiredArgsConstructor
public class OnlineUserServiceImpl implements OnlineUserService {

    private static final String SESSION_VER_KEY = "user:sver:";

    private final StringRedisTemplate stringRedisTemplate;

    private final Map<Long, UserSession> onlineUsers = new ConcurrentHashMap<>();
    private final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();

    /** 心跳超时时间（5分钟无操作视为离线） */
    private static final long HEARTBEAT_TIMEOUT_MS = 5 * 60 * 1000;

    @Override
    public void updateHeartbeat(Long userId, String username) {
        if (userId != null) {
            onlineUsers.put(userId, new UserSession(username, System.currentTimeMillis()));
        }
    }

    @Override
    public void removeUser(Long userId) {
        onlineUsers.remove(userId);
    }

    @Override
    public void kickUser(Long userId) {
        // 递增会话版本，所有旧的 token 自动失效
        incrementSessionVersion(userId);
        onlineUsers.remove(userId);
        log.info("用户 {} 已被强制下线", userId);
    }

    @Override
    public boolean isKicked(Long userId) {
        String sver = stringRedisTemplate.opsForValue().get(SESSION_VER_KEY + userId);
        return sver != null; // 有 session 版本号即表示曾经登录过，但此方法不再单独使用
    }

    @Override
    public void incrementSessionVersion(Long userId) {
        stringRedisTemplate.opsForValue().increment(SESSION_VER_KEY + userId);
    }

    @Override
    public boolean isSessionExpired(Long userId, Long tokenSver) {
        if (tokenSver == null) return true; // 旧 token 没有版本号，视为过期
        String currentSverStr = stringRedisTemplate.opsForValue().get(SESSION_VER_KEY + userId);
        if (currentSverStr == null) return false; // 还没有版本记录（首次登录后尚未再次登录）
        long currentSver = Long.parseLong(currentSverStr);
        return currentSver > tokenSver;
    }

    @Override
    public int getOnlineCount() {
        cleanupStaleSessions();
        return onlineUsers.size();
    }

    @Override
    public Map<Long, String> getOnlineUsers() {
        cleanupStaleSessions();
        Map<Long, String> result = new ConcurrentHashMap<>();
        onlineUsers.forEach((id, session) -> result.put(id, session.getUsername()));
        return result;
    }

    private void cleanupStaleSessions() {
        long now = System.currentTimeMillis();
        onlineUsers.entrySet().removeIf(entry ->
                (now - entry.getValue().getLastHeartbeat()) > HEARTBEAT_TIMEOUT_MS);
    }

    @PostConstruct
    public void init() {
        scheduler.scheduleAtFixedRate(this::cleanupStaleSessions, 1, 1, TimeUnit.MINUTES);
        log.info("在线用户清理任务已启动，超时时间: {}分钟", HEARTBEAT_TIMEOUT_MS / 1000 / 60);
    }

    private static class UserSession {
        private final String username;
        private final long lastHeartbeat;

        public UserSession(String username, long lastHeartbeat) {
            this.username = username;
            this.lastHeartbeat = lastHeartbeat;
        }

        public String getUsername() { return username; }
        public long getLastHeartbeat() { return lastHeartbeat; }
    }
}
