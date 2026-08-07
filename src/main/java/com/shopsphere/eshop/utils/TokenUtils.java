package com.shopsphere.eshop.utils;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@Slf4j
@Component
public class TokenUtils {

    public String extractToken(String authorizationHeader) {
        if (!StringUtils.hasText(authorizationHeader)) {
            throw new IllegalArgumentException("Authorization 头为空");
        }

        // 去除开头的 "Bearer " 前缀（如果存在）
        String token = authorizationHeader.replaceFirst("(?i)^Bearer\\s+", "");

        if (StringUtils.isEmpty(token)) {
            throw new IllegalArgumentException("Token 为空");
        }

        log.debug("提取到的 Token: {}...", token.length() > 20 ? token.substring(0, 20) + "..." : token);
        return token;
    }

    /**
     * 从 HttpServletRequest 中提取 Token
     */
    public String extractTokenFromRequest(jakarta.servlet.http.HttpServletRequest request) {
        String authHeader = request.getHeader("Authorization");
        return extractToken(authHeader);
    }

}