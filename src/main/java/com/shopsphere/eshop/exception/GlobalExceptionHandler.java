package com.shopsphere.eshop.exception;

import com.shopsphere.eshop.common.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.converter.HttpMessageNotReadableException;
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

    // 1. 处理参数校验异常（@Valid 校验失败）
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result<?> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach(error -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        log.warn("参数校验失败: {}", errors);
        return Result.error("参数校验失败: " + errors);
    }

    // 2. 处理表单参数绑定异常（@ModelAttribute 参数校验）
    @ExceptionHandler(BindException.class)
    public Result<?> handleBindException(BindException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach(error -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        log.warn("参数绑定失败: {}", errors);
        return Result.error("参数绑定失败: " + errors);
    }

    // 3. 处理 JSON 格式错误（如请求体无法反序列化）
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public Result<?> handleHttpMessageNotReadableException(HttpMessageNotReadableException ex) {
        log.error("请求体格式错误", ex);
        return Result.error("请求体格式错误，请检查 JSON 格式或字段类型");
    }

    // 4. 处理缺失请求参数（如 @RequestParam 必需的参数未传）
    @ExceptionHandler(MissingServletRequestParameterException.class)
    public Result<?> handleMissingServletRequestParameterException(MissingServletRequestParameterException ex) {
        log.warn("缺少必填参数: {}", ex.getParameterName());
        return Result.error("缺少必填参数: " + ex.getParameterName());
    }

    // 5. 处理参数类型不匹配（例如接口期望 Long，传了字符串）
    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public Result<?> handleMethodArgumentTypeMismatchException(MethodArgumentTypeMismatchException ex) {
        log.warn("参数类型不匹配: 参数 {} 应为 {} 类型", ex.getName(), ex.getRequiredType().getSimpleName());
        return Result.error("参数 " + ex.getName() + " 类型错误，应为 " + ex.getRequiredType().getSimpleName());
    }

    // 6. 处理请求方法不支持（如 POST 接口使用了 GET 访问）
    @ExceptionHandler(org.springframework.web.HttpRequestMethodNotSupportedException.class)
    public Result<?> handleHttpRequestMethodNotSupportedException(org.springframework.web.HttpRequestMethodNotSupportedException ex) {
        log.warn("请求方法不支持: {}", ex.getMessage());
        return Result.error("请求方法不支持，请使用 " + ex.getSupportedMethods());
    }

    // 7. 处理 404 未找到（需要配置 spring.mvc.throw-exception-if-no-handler-found=true）
    @ExceptionHandler(NoHandlerFoundException.class)
    public Result<?> handleNoHandlerFoundException(NoHandlerFoundException ex) {
        log.warn("接口不存在: {}", ex.getRequestURL());
        return Result.error("请求的接口不存在");
    }

    // 8. 处理自定义业务异常（你可以在 Service 中 throw 这个异常）
    @ExceptionHandler(BusinessException.class)
    public Result<?> handleBusinessException(BusinessException ex) {
        log.warn("业务异常: {}", ex.getMessage());
        return Result.error(ex.getMessage());
    }

    // 9. 处理所有未被捕获的运行时异常（兜底）
    @ExceptionHandler(RuntimeException.class)
    public Result<?> handleRuntimeException(RuntimeException e) {
        // 只记录错误消息，不打印堆栈（生产环境）
        log.error("业务异常: {}", e.getMessage());
        // 或者只在 DEBUG 级别打印堆栈
        // log.debug("异常详情", e);
        return Result.error(e.getMessage());
    }

    // 10. 处理通用 Exception（防止遗漏）
    @ExceptionHandler(Exception.class)
    public Result<?> handleException(Exception ex) {
        log.error("未知异常", ex);
        return Result.error("服务繁忙，请稍后再试");
    }


}