package com.shopsphere.eshop.aspect;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.shopsphere.eshop.annotation.Log;
import com.shopsphere.eshop.entity.OperationLog;
import com.shopsphere.eshop.mapper.OperationLogMapper;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.time.LocalDateTime;
import java.util.Arrays;

@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class LogAspect {

    private final OperationLogMapper operationLogMapper;
    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;
    private final ObjectMapper objectMapper;

    @Pointcut("@annotation(com.shopsphere.eshop.annotation.Log)")
    public void logPointCut() {}

    @AfterReturning(pointcut = "logPointCut()", returning = "result")
    public void saveLog(JoinPoint joinPoint, Object result) {
        try {
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes == null) return;
            HttpServletRequest request = attributes.getRequest();

            MethodSignature signature = (MethodSignature) joinPoint.getSignature();
            Method method = signature.getMethod();
            Log logAnnotation = method.getAnnotation(Log.class);

            // 获取操作人信息
            String token = tokenUtils.extractToken(request.getHeader("Authorization"));
            Long operatorId = null;
            String operatorName = null;
            if (token != null) {
                try {
                    operatorId = jwtUtil.getUserIdFromToken(token);
                    operatorName = jwtUtil.getUsernameFromToken(token);
                    log.info("解析 token 成功: operatorId={}, operatorName={}", operatorId, operatorName);
                } catch (Exception e) {
                    log.warn("解析 token 失败: {}", e.getMessage(), e);
                }
            }

            // 请求参数（过滤掉 HttpServletRequest/Response 等无法序列化的对象）
            String requestParams = "";
            try {
                Object[] args = joinPoint.getArgs();
                if (args != null && args.length > 0) {
                    Object[] filtered = Arrays.stream(args)
                            .filter(arg -> !(arg instanceof HttpServletRequest))
                            .filter(arg -> !(arg instanceof HttpServletResponse))
                            .toArray();
                    requestParams = objectMapper.writeValueAsString(filtered);
                }
            } catch (Exception e) {
                requestParams = "参数序列化失败";
            }


            Long targetId = extractTargetId(joinPoint, request);


            // IP 获取（不依赖 hutool）
            String ip = getClientIp(request);

            OperationLog logEntry = new OperationLog();
            logEntry.setOperatorId(operatorId);
            logEntry.setOperatorName(operatorName);
            logEntry.setOperationType(logAnnotation.type());
            logEntry.setTargetType(logAnnotation.targetType());
            logEntry.setContent(logAnnotation.value());
            logEntry.setRequestUrl(request.getRequestURI());
            logEntry.setRequestParams(requestParams);
            logEntry.setIp(ip);
            logEntry.setUserAgent(request.getHeader("User-Agent"));
            logEntry.setCreateTime(LocalDateTime.now());
            logEntry.setTargetId(targetId);
            
            operationLogMapper.insert(logEntry);
        } catch (Exception e) {
            log.error("记录操作日志失败", e);
        }
    }

    private Long extractTargetId(JoinPoint joinPoint, HttpServletRequest request) {
        // 1. 优先从 @PathVariable 中获取（例如 /api/user/admin/freeze/{id}）
        try {
            // 获取方法签名
            MethodSignature signature = (MethodSignature) joinPoint.getSignature();
            Method method = signature.getMethod();
            Object[] args = joinPoint.getArgs();
            Parameter[] parameters = method.getParameters();

            for (int i = 0; i < parameters.length; i++) {
                // 检查参数是否有 @PathVariable 注解，且参数名常见为 id, userId, productId 等
                PathVariable pathVariable = parameters[i].getAnnotation(PathVariable.class);
                if (pathVariable != null) {
                    String paramName = pathVariable.value();
                    if (paramName.isEmpty()) paramName = parameters[i].getName();
                    // 常见的 ID 参数名
                    if ("id".equals(paramName) || "userId".equals(paramName) || "productId".equals(paramName)) {
                        Object arg = args[i];
                        if (arg instanceof Long) return (Long) arg;
                        if (arg instanceof Integer) return ((Integer) arg).longValue();
                        if (arg instanceof String) {
                            try { return Long.parseLong((String) arg); } catch (NumberFormatException e) {}
                        }
                    }
                }
            }

            // 2. 如果没有 @PathVariable，尝试查找第一个 Long 类型的参数（假设为目标 ID）
            for (int i = 0; i < args.length; i++) {
                if (args[i] instanceof Long) {
                    return (Long) args[i];
                }
                if (args[i] instanceof Integer) {
                    return ((Integer) args[i]).longValue();
                }
            }

            // 3. 从请求路径中提取最后一个数字段（如 /freeze/5 -> 5）
            String path = request.getRequestURI();
            String[] segments = path.split("/");
            for (int i = segments.length - 1; i >= 0; i--) {
                try {
                    return Long.parseLong(segments[i]);
                } catch (NumberFormatException e) {
                    // 不是数字则继续
                }
            }
        } catch (Exception e) {
            log.warn("提取 targetId 失败", e);
        }
        return null;
    }

    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0];
        }
        return ip != null ? ip : "";
    }
}