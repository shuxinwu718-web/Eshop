package com.shopsphere.eshop.controller;

import com.wf.captcha.SpecCaptcha;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/api/captcha")
@Tag(name = "生成验证码", description = "生成验证码图片")
public class CaptchaController {

    @Autowired
    private StringRedisTemplate redisTemplate;

    @GetMapping("/image")
    public void getCaptcha(HttpServletResponse response) throws IOException {
        // 使用 easy-captcha 生成验证码
        SpecCaptcha captcha = new SpecCaptcha(130, 48, 4);
        String code = captcha.text().toLowerCase();
        String key = UUID.randomUUID().toString();

        // 将验证码存入 Redis，有效期 5 分钟
        redisTemplate.opsForValue().set("captcha:" + key, code, 5, TimeUnit.MINUTES);

        // 返回验证码图片和 key
        Map<String, Object> result = new HashMap<>();
        result.put("key", key);
        result.put("image", captcha.toBase64());
        response.setContentType("application/json;charset=utf-8");
        response.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
}
