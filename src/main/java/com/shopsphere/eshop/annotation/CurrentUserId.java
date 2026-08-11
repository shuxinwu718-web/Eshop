package com.shopsphere.eshop.annotation;

import java.lang.annotation.*;

/**
 * 注入当前登录用户ID。
 * 用法：控制器方法参数 {@code @CurrentUserId Long userId}。
 * 未登录/解析失败时为 null（供「可选用户」接口使用；需登录接口由 Spring Security 保证）。
 */
@Target(ElementType.PARAMETER)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface CurrentUserId {
}
