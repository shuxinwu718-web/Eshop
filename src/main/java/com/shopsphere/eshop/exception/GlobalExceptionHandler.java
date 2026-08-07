package com.shopsphere.eshop.exception;

import com.shopsphere.eshop.common.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    private ResponseEntity<Result<?>> buildResponse(int httpStatus, String message) {
        return ResponseEntity.status(httpStatus).body(Result.error(httpStatus, message));
    }

    // 1. 参数校验异常（@Valid）
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Result<?>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach(error -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        log.warn("参数校验失败: {}", errors);
        return buildResponse(400, "参数校验失败: " + errors);
    }

    // 2. 表单参数绑定异常
    @ExceptionHandler(BindException.class)
    public ResponseEntity<Result<?>> handleBindException(BindException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach(error -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        log.warn("参数绑定失败: {}", errors);
        return buildResponse(400, "参数绑定失败: " + errors);
    }

    // 3. JSON 格式错误
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<Result<?>> handleHttpMessageNotReadableException(HttpMessageNotReadableException ex) {
        log.warn("请求体格式错误: {}", ex.getMessage());
        return buildResponse(400, "请求体格式错误，请检查 JSON 格式或字段类型");
    }

    // 4. 缺少必填参数
    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<Result<?>> handleMissingServletRequestParameterException(MissingServletRequestParameterException ex) {
        log.warn("缺少必填参数: {}", ex.getParameterName());
        return buildResponse(400, "缺少必填参数: " + ex.getParameterName());
    }

    // 5. 参数类型不匹配
    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<Result<?>> handleMethodArgumentTypeMismatchException(MethodArgumentTypeMismatchException ex) {
        log.warn("参数类型不匹配: 参数 {} 应为 {} 类型", ex.getName(), ex.getRequiredType().getSimpleName());
        return buildResponse(400, "参数 " + ex.getName() + " 类型错误，应为 " + ex.getRequiredType().getSimpleName());
    }

    // 6. 请求方法不支持
    @ExceptionHandler(org.springframework.web.HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<Result<?>> handleHttpRequestMethodNotSupportedException(
            org.springframework.web.HttpRequestMethodNotSupportedException ex) {
        log.warn("请求方法不支持: {}", ex.getMessage());
        return buildResponse(405, "请求方法不支持，请使用 " + ex.getSupportedMethods());
    }

    // 7. 404 未找到
    @ExceptionHandler(NoHandlerFoundException.class)
    public ResponseEntity<Result<?>> handleNoHandlerFoundException(NoHandlerFoundException ex) {
        log.warn("接口不存在: {}", ex.getRequestURL());
        return buildResponse(404, "请求的接口不存在");
    }

    // 7.1 404 未找到（Spring Boot 3.2+：未匹配路径/静态资源统一抛 NoResourceFoundException，避免落入兜底变 500）
    @ExceptionHandler(org.springframework.web.servlet.resource.NoResourceFoundException.class)
    public ResponseEntity<Result<?>> handleNoResourceFoundException(
            org.springframework.web.servlet.resource.NoResourceFoundException ex) {
        log.warn("接口不存在: {}", ex.getResourcePath());
        return buildResponse(404, "请求的接口不存在");
    }

    // 8. 自定义业务异常
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<Result<?>> handleBusinessException(BusinessException ex) {
        log.warn("业务异常: {}", ex.getMessage());
        return buildResponse(ex.getHttpStatus(), ex.getMessage());
    }

    // 8.1 权限不足（@PreAuthorize 拒绝时返回 403，避免被 RuntimeException 兜底成 500）
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<Result<?>> handleAccessDeniedException(AccessDeniedException ex) {
        log.warn("权限不足: {}", ex.getMessage());
        return buildResponse(403, "权限不足，无法访问该资源");
    }

    // 9. 未捕获的 RuntimeException（兜底）
    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<Result<?>> handleRuntimeException(RuntimeException e) {
        log.error("运行时异常: {}", e.getMessage(), e);
        return buildResponse(500, "服务繁忙，请稍后再试");
    }

    // 10. 通用 Exception（最终兜底）
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Result<?>> handleException(Exception ex) {
        log.error("未知异常", ex);
        return buildResponse(500, "服务繁忙，请稍后再试");
    }
}
