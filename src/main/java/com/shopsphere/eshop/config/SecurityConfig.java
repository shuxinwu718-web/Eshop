package com.shopsphere.eshop.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http,
                                                   JwtAuthenticationFilter jwtAuthenticationFilter) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        // 公开路径
                        .requestMatchers("/api/user/register",
                                "/api/user/login", "/api/v1/sse/**",
                                  "/api/user/reset-password/code",
                                "/api/user/reset-password",
                                "/api/auth/**",
                                "/api/captcha/**",
                                "/swagger-ui.html", "/swagger-ui/**", "/v3/api-docs/**", "/webjars/**").permitAll()
                        // 商品 GET 放行
                        .requestMatchers(HttpMethod.GET, "/api/product/**").permitAll()
                        // 文件上传 需要登录（防止匿名上传恶意文件）
                        .requestMatchers("/api/v1/files/**").authenticated()
                        // 访问记录 放行
                        .requestMatchers("/api/v1/logs/views/**").permitAll()
                        // 收藏 需要登录（按用户操作）
                        .requestMatchers("/api/favorite/**").authenticated()
                        // 秒杀 放行（用户端）
                        .requestMatchers("/api/seckill/sessions").permitAll()
                        .requestMatchers(HttpMethod.POST, "/api/seckill/*").authenticated()

                        // 静态资源（图片、CSS、JS等）
                        .requestMatchers("/uploads/**").permitAll()  // ← 新增这一行
                        // 其他需要认证
                        .anyRequest().authenticated()
                )
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class); // 添加 JWT 过滤器

        return http.build();
    }

}