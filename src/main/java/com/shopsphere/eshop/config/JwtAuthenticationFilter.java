package com.shopsphere.eshop.config;

import com.shopsphere.eshop.service.OnlineUserService;
import com.shopsphere.eshop.service.impl.UserServiceImpl;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {


    private final JwtUtil jwtUtil;

    private final UserServiceImpl userService;
    private final TokenUtils tokenUtils;
    private final OnlineUserService onlineUserService;

    // 定义公开路径（与 SecurityConfig 中的 .permitAll() 保持一致）
    private static final List<String> PUBLIC_PATHS = Arrays.asList(
            "/api/user/login",
            "/api/user/register",
            "/swagger-ui/**",
            "/v3/api-docs/**",
            "/webjars/**",
            "/uploads/"
    );
    private final AntPathMatcher pathMatcher = new AntPathMatcher();

    private boolean isPublicPath(String requestUri) {
        return PUBLIC_PATHS.stream().anyMatch(pattern -> pathMatcher.match(pattern, requestUri));
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        String requestUri = request.getRequestURI();
        // 1. 公开路径直接放行，不检查 token，也不打印任何日志
        if (isPublicPath(requestUri)) {
            filterChain.doFilter(request, response);
            return;
        }

        // 2. 检查 Authorization 头
        final String authorizationHeader = request.getHeader("Authorization");

        if (!StringUtils.hasText(authorizationHeader)) {
            filterChain.doFilter(request, response);
            return;
        }

        try {
            // 3. 提取并验证 Token
            String token = tokenUtils.extractToken(authorizationHeader);

            if (jwtUtil.validateToken(token)) {
                String username = jwtUtil.getUsernameFromToken(token);
                Long userId = jwtUtil.getUserIdFromToken(token);

                // 4. 检查会话版本号（一号一端：旧 token 自动失效）
                Long tokenSver = jwtUtil.getSessionVersionFromToken(token);
                if (onlineUserService.isSessionExpired(userId, tokenSver)) {
                    log.warn("用户 {} 会话已过期（异地登录），拒绝访问", username);
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    response.setContentType("application/json;charset=utf-8");
                    response.getWriter().write("{\"code\":401,\"msg\":\"您的账号已在异地登录，您将被跳转到登录页\",\"data\":null}");
                    return;
                }

                // 5. 加载用户信息并设置认证上下文
                UserDetails userDetails = userService.loadUserByUsername(username);
                UsernamePasswordAuthenticationToken authentication =
                        new UsernamePasswordAuthenticationToken(
                                userDetails,
                                null,
                                userDetails.getAuthorities()
                        );
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authentication);

                // 6. 更新用户在线心跳
                onlineUserService.updateHeartbeat(userId, username);

                log.info("✅ 用户 {} 认证成功，请求路径: {}", username, requestUri);
            } else {
                log.warn("Token 验证失败，请求路径: {}", requestUri);
            }
        } catch (Exception e) {
            log.error("Token 验证过程发生异常: {}", e.getMessage());
        }

        filterChain.doFilter(request, response);
    }
}