package com.shopsphere.eshop.service;

import java.util.Map;

public interface OnlineUserService {
    void updateHeartbeat(Long userId, String username);
    void removeUser(Long userId);
    int getOnlineCount();
    Map<Long, String> getOnlineUsers();
}
