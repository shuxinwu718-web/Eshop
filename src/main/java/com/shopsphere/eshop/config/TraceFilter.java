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
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;


@Component
@Order(Integer.MIN_VALUE)
@RequiredArgsConstructor
@Slf4j
public class TraceFilter extends OncePerRequestFilter {

    private static final String TRACE_HEADER = "X-Trace-Id";

    private final RabbitTemplate rabbitTemplate;
    private final JwtUtil jwtUtils;

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
            // 3. ✅ 发送异步日志消息（不阻塞主线程）
            try {
                Long userId = extractUserId(request);
                String uri = request.getRequestURI();
                String method = request.getMethod();
                // 只记录业务接口，跳过静态资源
                if (!isStaticResource(uri)) {
                    String ip = IpUtils.getIpAddress(request);
                    String userAgent = request.getHeader("User-Agent");

                    VisitLogMessage msg = new VisitLogMessage(
                            userId,
                            ip,
                            userAgent,
                            method + " " + uri,
                            LocalDateTime.now()
                    );
                    // 异步发送，不阻塞主线程
                    rabbitTemplate.convertAndSend(LOG_EXCHANGE, LOG_ROUTING_KEY, msg);
                }
            } catch (Exception e) {
                // 日志发送失败不影响主流程，只记录日志
                log.debug("访问日志消息发送失败: {}", e.getMessage());
            }

            MDC.remove("traceId");
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