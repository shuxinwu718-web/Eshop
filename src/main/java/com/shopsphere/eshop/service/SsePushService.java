package com.shopsphere.eshop.service;

import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

/**
 * SSE 定向推送服务：以 userId 为维度的连接注册表 + 定向推送门面。
 * 所有需要向指定在线用户推送的场景（客服消息、通知等）都通过它。
 * 注：进程内存态，仅支持单实例部署；多实例需换 Redis pub/sub 扇出。
 */
public interface SsePushService {

    /** 建立连接时注册（一个用户可有多个活跃连接：多标签页/多设备） */
    void register(Long userId, SseEmitter emitter);

    /** 连接结束/超时/出错时注销 */
    void unregister(Long userId, SseEmitter emitter);

    /**
     * 向某用户的全部在线连接推一条事件。
     * @return true=至少送达一条；false=用户不在线（调用方应走离线兜底，如站内通知）
     */
    boolean sendToUser(Long userId, String eventName, Object data);

    /** 广播在线人数（兼作心跳，维持长连接不被防火墙掐断） */
    void broadcastOnlineCount(int count);
}