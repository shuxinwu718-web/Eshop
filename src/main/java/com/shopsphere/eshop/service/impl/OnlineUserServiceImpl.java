package com.shopsphere.eshop.service.impl;

import com.shopsphere.eshop.service.OnlineUserService;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
public class OnlineUserServiceImpl implements OnlineUserService {

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
