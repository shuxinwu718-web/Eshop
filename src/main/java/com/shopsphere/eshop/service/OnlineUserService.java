package com.shopsphere.eshop.service;

import java.util.Map;

public interface OnlineUserService {
    void updateHeartbeat(Long userId, String username);
    void removeUser(Long userId);
    void kickUser(Long userId);
    boolean isKicked(Long userId);
    int getOnlineCount();
    Map<Long, String> getOnlineUsers();
    /** 递增用户会话版本号（用于一号一端登录校验） */
    void incrementSessionVersion(Long userId);
    /** 检查 token 中的会话版本是否已过期 */
    boolean isSessionExpired(Long userId, Long tokenSver);
}
