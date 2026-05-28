package com.shopsphere.eshop.annotation;

import java.lang.annotation.*;
//操作日志
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Log {
    String value() default "";          // 操作描述
    String type() default "";           // 操作类型（如 DELETE_PRODUCT）
    String targetType() default "";     // 目标类型（如 Product, User）
}