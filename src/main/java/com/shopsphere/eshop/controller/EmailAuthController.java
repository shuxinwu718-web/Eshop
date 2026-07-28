package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.EmailLoginRequest;
import com.shopsphere.eshop.entity.User;
import com.shopsphere.eshop.service.EmailService;
import com.shopsphere.eshop.service.UserService;
import com.shopsphere.eshop.utils.JwtUtil;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/api/auth/email")
@RequiredArgsConstructor
@Tag(name = "邮箱认证接口", description = "邮箱验证码免密登录")
public class EmailAuthController {

    private final EmailService emailService;
    private final UserService userService;
    private final JwtUtil jwtUtil;
    private final StringRedisTemplate redisTemplate;

    /**
     * 发送登录验证码到邮箱
     */
    @PostMapping("/code")
    public Result<Void> sendCode(@RequestParam String email) {
        emailService.sendLoginCode(email);
        return Result.success(null);
    }

    /**
     * 邮箱 + 验证码免密登录
     */
    @PostMapping("/login")
    public Result<Map<String, String>> login(@Valid @RequestBody EmailLoginRequest request) {
        // 校验验证码
        String redisKey = "email:code:" + request.getEmail() + ":login";
        String cachedCode = redisTemplate.opsForValue().get(redisKey);
        if (cachedCode == null || !cachedCode.equals(request.getCode())) {
            return Result.error("验证码错误或已过期");
        }

        // 查找用户
        User user = userService.findByEmail(request.getEmail());
        if (user == null) {
            return Result.error("该邮箱未注册");
        }

        // 检查账号状态
        if (user.getStatus() == 1) {
            return Result.error("账号已被冻结，请联系管理员");
        }

        // 删除验证码缓存，防止重复使用
        redisTemplate.delete(redisKey);

        // 递增会话版本，旧 token 自动失效
        Long sver = redisTemplate.opsForValue().increment("user:sver:" + user.getId());

        // 生成 JWT
        String token = jwtUtil.generateToken(user.getId(), user.getUsername(), user.getRole(), sver);

        Map<String, String> result = new HashMap<>();
        result.put("token", token);
        return Result.success(result);
    }
}
