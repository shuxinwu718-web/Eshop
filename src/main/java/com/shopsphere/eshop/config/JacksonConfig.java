package com.shopsphere.eshop.config;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateSerializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalTimeSerializer;
import org.springframework.boot.autoconfigure.jackson.Jackson2ObjectMapperBuilderCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

/**
 * Jackson 全局时间格式配置（Web 接口 + Redis 缓存共用同一个 JavaTimeModule）。
 *
 * 统一约定：
 * - LocalDateTime 输出/入参：yyyy-MM-dd HH:mm:ss（不再出现 ISO-8601 的 T）
 * - LocalDate 输出/入参：yyyy-MM-dd
 * - LocalTime 输出/入参：HH:mm:ss
 *
 * 反序列化做宽松兼容：同时接受带 T（ISO）、空格分隔、带毫秒等历史格式，
 * 保证旧前端请求、Redis 旧缓存、已在途数据都能平滑解析。
 */
@Configuration
public class JacksonConfig {

    public static final String DATE_TIME_PATTERN = "yyyy-MM-dd HH:mm:ss";
    public static final String DATE_PATTERN = "yyyy-MM-dd";
    public static final String TIME_PATTERN = "HH:mm:ss";

    private static final DateTimeFormatter DATE_TIME_FORMATTER =
            DateTimeFormatter.ofPattern(DATE_TIME_PATTERN);
    private static final DateTimeFormatter DATE_FORMATTER =
            DateTimeFormatter.ofPattern(DATE_PATTERN);
    private static final DateTimeFormatter TIME_FORMATTER =
            DateTimeFormatter.ofPattern(TIME_PATTERN);

    /**
     * 全项目唯一的 JSR310 模块：Web ObjectMapper 与 Redis 序列化器均复用此 Bean，
     * 保证接口输出与缓存内容格式一致。
     */
    @Bean
    public JavaTimeModule javaTimeModule() {
        JavaTimeModule module = new JavaTimeModule();
        // 序列化（输出）：统一为不带 T 的中文习惯格式
        module.addSerializer(LocalDateTime.class, new LocalDateTimeSerializer(DATE_TIME_FORMATTER));
        module.addSerializer(LocalDate.class, new LocalDateSerializer(DATE_FORMATTER));
        module.addSerializer(LocalTime.class, new LocalTimeSerializer(TIME_FORMATTER));
        // 反序列化（入参）：宽松兼容多种历史格式
        module.addDeserializer(LocalDateTime.class, new FlexibleLocalDateTimeDeserializer());
        module.addDeserializer(LocalDate.class, new FlexibleLocalDateDeserializer());
        module.addDeserializer(LocalTime.class, LocalTimeDeserializer.INSTANCE);
        return module;
    }

    /**
     * 应用到 Spring MVC 的 ObjectMapper（接口 JSON 序列化/反序列化）。
     * modulesToInstall 为追加模式，不替换 Spring Boot 默认注册的其它模块。
     */
    @Bean
    public Jackson2ObjectMapperBuilderCustomizer jacksonCustomizer(JavaTimeModule javaTimeModule) {
        return builder -> builder.modulesToInstall(javaTimeModule);
    }

    /**
     * LocalDateTime 宽松反序列化器：
     * 兼容 "yyyy-MM-dd HH:mm:ss"、ISO 带 T、带毫秒等格式，空串按 null 处理。
     */
    public static class FlexibleLocalDateTimeDeserializer extends JsonDeserializer<LocalDateTime> {

        private static final DateTimeFormatter[] SUPPORTED = {
                DateTimeFormatter.ofPattern(DATE_TIME_PATTERN),
                DateTimeFormatter.ISO_LOCAL_DATE_TIME,
                DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"),
                DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS"),
                DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")
        };

        @Override
        public LocalDateTime deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
            String text = p.getText();
            if (text == null || text.isBlank()) {
                return null;
            }
            String value = text.trim();
            for (DateTimeFormatter formatter : SUPPORTED) {
                try {
                    return LocalDateTime.parse(value, formatter);
                } catch (DateTimeParseException ignored) {
                    // 尝试下一种格式
                }
            }
            // 仅日期（yyyy-MM-dd）按当天 00:00:00 处理
            try {
                return LocalDate.parse(value, DateTimeFormatter.ISO_LOCAL_DATE).atStartOfDay();
            } catch (DateTimeParseException ignored) {
                return (LocalDateTime) ctxt.handleWeirdStringValue(
                        LocalDateTime.class, text, "支持格式: yyyy-MM-dd HH:mm:ss 或 ISO-8601");
            }
        }
    }

    /**
     * LocalDate 宽松反序列化器：只取日期部分，兼容带 T 或空格的时间串。
     */
    public static class FlexibleLocalDateDeserializer extends JsonDeserializer<LocalDate> {

        @Override
        public LocalDate deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
            String text = p.getText();
            if (text == null || text.isBlank()) {
                return null;
            }
            String value = text.trim();
            try {
                return LocalDate.parse(value.length() >= 10 ? value.substring(0, 10) : value,
                        DateTimeFormatter.ISO_LOCAL_DATE);
            } catch (DateTimeParseException e) {
                return (LocalDate) ctxt.handleWeirdStringValue(
                        LocalDate.class, text, "支持格式: yyyy-MM-dd");
            }
        }
    }
}
