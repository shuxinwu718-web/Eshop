package com.shopsphere.eshop.interceptor;

import com.shopsphere.eshop.entity.VisitLog;
import com.shopsphere.eshop.mapper.VisitLogMapper;
import com.shopsphere.eshop.utils.IpUtils;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.servlet.HandlerInterceptor;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class VisitLogInterceptor implements HandlerInterceptor {

    private final VisitLogMapper visitLogMapper;
    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;

    // 需要记录访问日志的前缀（只记录用户端前台操作）
    private static final List<String> RECORD_PREFIXES = Arrays.asList(
            "/api/product/",      // 商品列表、详情、搜索等
            "/api/cart/",         // 购物车操作
            "/api/order/",        // 下单、订单列表、订单详情（不含管理端订单管理）
            "/api/favorites/",    // 收藏操作
            "/api/address/",      // 收货地址管理
            "/api/comments/",     // 评论（如果有）
            "/api/likes/"         // 点赞（如果有）
            // 可根据需要继续添加其他前端路径
    );

    // 明确排除的后台路径（即便前缀匹配了也要排除）
    private static final List<String> EXCLUDE_PATHS = Arrays.asList(
            "/api/user/info",
            "/api/user/profile",
            "/api/logs/statistics/views",
            "/api/v1/sse/connect",
            "/swagger-ui/",
            "/v3/api-docs/",
            "/uploads/"
    );

    private final AntPathMatcher pathMatcher = new AntPathMatcher();

    private boolean isRecordable(String uri) {
        // 先检查排除路径
        for (String exclude : EXCLUDE_PATHS) {
            if (pathMatcher.match(exclude, uri)) {
                return false;
            }
        }
        // 再检查白名单前缀
        for (String prefix : RECORD_PREFIXES) {
            if (uri.startsWith(prefix)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String uri = request.getRequestURI();
        if (!isRecordable(uri)) {
            return true; // 不记录
        }

        try {
            VisitLog log = new VisitLog();
            log.setIp(IpUtils.getIpAddr(request));
            log.setUserAgent(request.getHeader("User-Agent"));
            log.setRequestUri(uri);
            log.setVisitTime(LocalDateTime.now());

            // 尝试从请求头中获取用户ID（已登录用户）
            String authHeader = request.getHeader("Authorization");
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                try {
                    String token = tokenUtils.extractToken(authHeader);
                    Long userId = jwtUtil.getUserIdFromToken(token);
                    log.setUserId(userId);
                } catch (Exception e) {
                    // token 无效或解析失败，不设 userId（游客）
                }
            }

            visitLogMapper.insert(log);
        } catch (Exception e) {
            // 记录日志不影响主流程
            log.error("记录访问日志失败", e);
        }
        return true;
    }
}