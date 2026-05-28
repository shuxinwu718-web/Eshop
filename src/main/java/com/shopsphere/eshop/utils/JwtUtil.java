package com.shopsphere.eshop.utils;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
@Slf4j
@Component
public class JwtUtil {

    @Value("${jwt.secret}")
    private String secret;

    @Value("${jwt.expiration}")
    private Long expiration;

    /**
     * 从 Token 中获取用户ID
     */
    public Long getUserIdFromToken(String token) {
        try {
            // 1. 先验证Token格式
            if (token == null || token.trim().isEmpty()) {
                throw new IllegalArgumentException("Token不能为空");
            }

            // 2. 检查是否是有效的JWT格式（应包含2个点）
            String[] parts = token.split("\\.");
            if (parts.length != 3) {
                throw new MalformedJwtException("Token格式错误: 应包含3个部分，实际" + parts.length + "个");
            }

            // 3. 尝试解析
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(getSecretKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();

            // 4. 获取用户ID
            Long userId = claims.get("userId", Long.class);
            if (userId == null) {
                throw new RuntimeException("Token中未找到userId字段");
            }

            return userId;

        } catch (ExpiredJwtException e) {
            // Token过期
            throw e;
        } catch (MalformedJwtException e) {
            // Token格式错误
            throw new MalformedJwtException("Token格式错误: " + e.getMessage());
        } catch (SignatureException e) {
            // 签名无效
            throw new SignatureException("Token签名无效: " + e.getMessage());
        } catch (Exception e) {
            // 其他错误
            throw new RuntimeException("解析Token失败: " + e.getClass().getSimpleName() + " - " + e.getMessage());
        }
    }

    /**
     * 从 Token 中获取用户名
     */
    public String getUsernameFromToken(String token) {
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(getSecretKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
        return claims.getSubject();
    }

    /**
     * 生成 Token
     */
    public String generateToken(Long userId, String username, String role, Long sver) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", userId);
        claims.put("role", role);
        claims.put("sver", sver);

        return Jwts.builder()
                .setClaims(claims)
                .setSubject(username)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expiration))
                .signWith(getSecretKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * 从 Token 中获取会话版本号
     */
    public Long getSessionVersionFromToken(String token) {
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(getSecretKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
        return claims.get("sver", Long.class);
    }

    /**
     * 验证 Token
     */
    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(getSecretKey()).build().parseClaimsJws(token);
            return true;
        } catch (ExpiredJwtException e) {
            log.warn("Token 已过期: {}", e.getMessage());
        } catch (MalformedJwtException e) {
            log.warn("Token 格式错误: {}", e.getMessage());
        } catch (SignatureException e) {
            log.warn("Token 签名无效: {}", e.getMessage());
        } catch (Exception e) {
            log.warn("Token 验证异常: {}", e.getMessage());
        }
        return false;
    }

    /**
     * 获取密钥
     */
    private SecretKey getSecretKey() {
        byte[] keyBytes = secret.getBytes(StandardCharsets.UTF_8);
        return Keys.hmacShaKeyFor(keyBytes);
    }
}