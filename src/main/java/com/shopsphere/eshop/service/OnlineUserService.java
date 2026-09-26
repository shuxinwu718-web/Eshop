package com.shopsphere.eshop.service;

import java.util.Map;

public interface OnlineUserService {
    /** 会话版本 key 保留天数：需大于 JWT 有效期（4h），30 天兼顾"一号一端"踢人语义与 key 自动清理 */
    long SESSION_VER_TTL_DAYS = 30L;

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
