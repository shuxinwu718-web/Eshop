package com.shopsphere.eshop.config;

import com.shopsphere.eshop.mq.VisitLogMessage;
import com.shopsphere.eshop.utils.IpUtils;
import com.shopsphere.eshop.utils.JwtUtil;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.MDC;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import static com.shopsphere.eshop.config.RabbitMQConfig.LOG_EXCHANGE;
import static com.shopsphere.eshop.config.RabbitMQConfig.LOG_ROUTING_KEY;
import jakarta.annotation.PreDestroy;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;


@Component
@Order(Integer.MIN_VALUE)
@RequiredArgsConstructor
@Slf4j
public class TraceFilter extends OncePerRequestFilter {

    private static final String TRACE_HEADER = "X-Trace-Id";

    /**
     * 访问日志异步发送线程池：日志发送彻底脱离请求线程。
     * 秒杀等洪峰下，若线程池满则直接丢弃日志（有界队列 + DiscardPolicy），
     * 绝不让日志发送阻塞业务请求，也不拖垮订单/延迟取消等业务消息。
     * convertAndSend 是快网络写（无 DB），2 个工作线程足够消化。
     */
    private static final int LOG_THREADS = 2;
    private static final int LOG_QUEUE_CAPACITY = 2000;
    private final AtomicLong rejectedCount = new AtomicLong();
    private final ExecutorService asyncLogExecutor = new ThreadPoolExecutor(
            LOG_THREADS, LOG_THREADS,
            0L, TimeUnit.MILLISECONDS,
            new ArrayBlockingQueue<>(LOG_QUEUE_CAPACITY),
            r -> {
                Thread t = new Thread(r, "async-log-sender");
                t.setDaemon(true);
                return t;
            },
            (r, executor) -> {
                // 队列已满：直接丢弃并计数，保证不阻塞当前请求线程
                long n = rejectedCount.incrementAndGet();
                if (n % 5000 == 1) { // 定期提示，避免高频打日志
                    log.warn("访问日志异步队列已满，累计丢弃日志 {} 条", n);
                }
            });

    private final RabbitTemplate rabbitTemplate;
    private final JwtUtil jwtUtils;

    @PreDestroy
    void shutdown() {
        asyncLogExecutor.shutdownNow();
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        // 1. 生成 traceId
        String traceId = request.getHeader(TRACE_HEADER);
        if (traceId == null || traceId.isBlank()) {
            traceId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
        MDC.put("traceId", traceId);
        response.setHeader(TRACE_HEADER, traceId);

        // 2. 记录开始时间（用于计算响应耗时）
        long startTime = System.currentTimeMillis();

        try {
            filterChain.doFilter(request, response);
        } finally {
            // 3. ✅ 异步发送日志消息到独立线程池，不阻塞请求线程
            try {
                Long userId = extractUserId(request);
                String uri = request.getRequestURI();
                String method = request.getMethod();
                // 只记录业务接口，跳过静态资源与高频轮询接口（避免噪音虚高 PV/淹没日志）
                if (!isStaticResource(uri) && !isNoiseEndpoint(uri)) {
                    String ip = IpUtils.getIpAddress(request);
                    String userAgent = request.getHeader("User-Agent");
                    String currentTraceId = MDC.get(TRACE_HEADER);

                    VisitLogMessage msg = new VisitLogMessage(
                            userId,
                            ip,
                            userAgent,
                            method,
                            uri,
                            response.getStatus(),
                            (int) Math.min(System.currentTimeMillis() - startTime, Integer.MAX_VALUE),
                            LocalDateTime.now()
                    );
                    asyncLogExecutor.execute(() -> sendVisitLog(msg, currentTraceId));
                }
            } catch (Exception e) {
                // 日志发送失败不影响主流程，只记录日志
                log.debug("访问日志消息异步提交失败: {}", e.getMessage());
            }

            MDC.remove("traceId");
        }
    }

    /** 在线程池工作线程内发送日志；携带 traceId 保持链路可追踪 */
    private void sendVisitLog(VisitLogMessage msg, String traceId) {
        if (traceId != null) {
            MDC.put(TRACE_HEADER, traceId);
        }
        try {
            rabbitTemplate.convertAndSend(LOG_EXCHANGE, LOG_ROUTING_KEY, msg);
        } catch (Exception e) {
            log.debug("访问日志消息发送失败: {}", e.getMessage());
        } finally {
            if (traceId != null) {
                MDC.remove(TRACE_HEADER);
            }
        }
    }

    /**
     * 从请求中提取用户ID（从 Token 解析）
     */
    private Long extractUserId(HttpServletRequest request) {
        try {
            String token = request.getHeader("Authorization");
            if (token != null && token.startsWith("Bearer ")) {
                token = token.substring(7);
                return jwtUtils.getUserIdFromToken(token);
            }
        } catch (Exception e) {
            // 未登录或 Token 无效，返回 null
        }
        return null;
    }

    /**
     * 判断是否为高频轮询/长连接/自我监控类接口（不记录日志）。
     * 这类请求不代表真实用户行为：计入访问日志会虚高 PV/UV 并淹没日志列表。
     * 1. 未读通知轮询：前端 30s 一次（商城/商家布局）；
     * 2. 验证码图片：登录/注册页可反复刷新，带随机参数易刷屏；
     * 3. SSE 长连接：连接建立不等于一次访问；
     * 4. 监控大盘接口：监控页自动刷新（loadAll 轮询），会自己污染自己的访问日志；
     * 5. 秒杀场次状态：秒杀页每 10s 轮询一次。
     */
    private boolean isNoiseEndpoint(String uri) {
        if (uri == null) {
            return false;
        }
        return uri.startsWith("/api/v1/notices/unread-")
                || uri.startsWith("/api/merchant/messages/unread-count")
                || uri.startsWith("/api/captcha/")
                || uri.startsWith("/api/v1/sse/")
                || uri.startsWith("/api/v1/chat/unread-count")
                || uri.startsWith("/api/admin/monitor/")
                || uri.startsWith("/api/seckill/sessions");
    }

    /**
     * 判断是否为静态资源（不记录日志）
     */
    private boolean isStaticResource(String uri) {
        return uri == null ||
                uri.startsWith("/uploads/") ||
                uri.startsWith("/css/") ||
                uri.startsWith("/js/") ||
                uri.startsWith("/images/") ||
                uri.startsWith("/favicon.ico") ||
                uri.startsWith("/actuator/") ||
                uri.startsWith("/swagger-ui/") ||
                uri.startsWith("/v3/api-docs");
    }
}