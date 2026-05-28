package com.shopsphere.eshop.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;
// 避免存储时出现乱码或类型转换异常。
@Configuration
public class RedisConfig {
    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory factory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(factory);
        // 设置 key 和 value 的序列化方式
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(genericJacksonSerializer());
        template.setHashKeySerializer(new StringRedisSerializer());
        template.setHashValueSerializer(genericJacksonSerializer());
        template.afterPropertiesSet();
        return template;
    }

    @Bean
    public GenericJackson2JsonRedisSerializer genericJacksonSerializer() {
        ObjectMapper mapper = new ObjectMapper();
        // 注册 JSR310 模块以支持 LocalDateTime 等 Java 8 日期类型
        mapper.registerModule(new JavaTimeModule());
        // 禁止将日期序列化为时间戳，使用 ISO-8601 字符串格式
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        return new GenericJackson2JsonRedisSerializer(mapper);
    }
}