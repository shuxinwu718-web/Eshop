package com.shopsphere.eshop.config;

import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.core.MethodParameter;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

/**
 * 解析 {@link CurrentUserId} 注解参数：从 Authorization 头提取当前登录用户ID。
 * 未携带/解析失败返回 null，与原各 Controller 手工解析逻辑保持一致。
 */
@Component
@RequiredArgsConstructor
public class CurrentUserIdArgumentResolver implements HandlerMethodArgumentResolver {

    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.hasParameterAnnotation(CurrentUserId.class)
                && Long.class.isAssignableFrom(parameter.getParameterType());
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest, WebDataBinderFactory binderFactory) {
        HttpServletRequest request = webRequest.getNativeRequest(HttpServletRequest.class);
        if (request == null) {
            return null;
        }
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return null;
        }
        try {
            return jwtUtil.getUserIdFromToken(tokenUtils.extractToken(authHeader));
        } catch (Exception e) {
            return null; // 解析失败视为未登录
        }
    }
}
