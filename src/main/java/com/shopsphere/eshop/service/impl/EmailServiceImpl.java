package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.shopsphere.eshop.entity.User;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.UserMapper;
import com.shopsphere.eshop.service.EmailService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Random;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailServiceImpl implements EmailService {

    private final UserMapper userMapper;
    private final RedisTemplate<String, String> redisTemplate;
    private final JavaMailSender javaMailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    @Override
    public void sendEmailCode(String email) {
        // 1. 校验邮箱是否已被绑定
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getEmail, email);
        if (userMapper.selectCount(wrapper) > 0) {
            throw new BusinessException("邮箱已被其他用户绑定");
        }

        // 2. 生成 6 位随机验证码
        String code = String.format("%06d", new Random().nextInt(999999));

        // 3. 存入 Redis，有效期 5 分钟
        String redisKey = "email:code:" + email;
        redisTemplate.opsForValue().set(redisKey, code, 5, TimeUnit.MINUTES);

        // 4. 发送邮件
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(email);
            message.setSubject("邮箱验证码");
            message.setText("您的验证码是：" + code + "，5分钟内有效。");
            javaMailSender.send(message);
            log.info("验证码已发送至 {}", email);
        } catch (Exception e) {
            log.error("邮件发送失败", e);
            throw new BusinessException("邮件发送失败，请稍后重试");
        }
    }

    @Override
    @Transactional
    public void bindEmail(Long userId, String email, String code) {
        // 1. 校验验证码
        String redisKey = "email:code:" + email;
        String cachedCode = redisTemplate.opsForValue().get(redisKey);
        if (cachedCode == null || !cachedCode.equals(code)) {
            throw new BusinessException("验证码错误或已过期");
        }

        // 2. 检查邮箱是否已被其他用户绑定（防止并发）
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getEmail, email);
        User existingUser = userMapper.selectOne(wrapper);
        if (existingUser != null && !existingUser.getId().equals(userId)) {
            throw new BusinessException("邮箱已被其他用户绑定");
        }

        // 3. 更新当前用户的邮箱
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        user.setEmail(email);
        userMapper.updateById(user);

        // 4. 删除验证码缓存
        redisTemplate.delete(redisKey);
    }

    @Override
    public void sendResetPasswordCode(String email) {
        // 忘记密码：校验邮箱必须存在
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getEmail, email);
        if (userMapper.selectCount(wrapper) == 0) {
            throw new BusinessException("该邮箱未注册");
        }
        sendCodeCommon(email, "reset");
    }


    @Override
    public void sendLoginCode(String email) {
        // 校验邮箱必须已注册
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getEmail, email);
        if (userMapper.selectCount(wrapper) == 0) {
            throw new BusinessException("该邮箱未注册");
        }
        sendCodeCommon(email, "login");
    }

    private void sendCodeCommon(String email, String purpose) {
        String code = String.format("%06d", new Random().nextInt(999999));
        String redisKey = "email:code:" + email + ":" + purpose;  // 区分不同用途
        redisTemplate.opsForValue().set(redisKey, code, 5, TimeUnit.MINUTES);
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(email);
            String subject;
            switch (purpose) {
                case "login": subject = "登录验证码"; break;
                case "reset": subject = "重置密码验证码"; break;
                default: subject = "邮箱验证码";
            }
            message.setSubject(subject);
            message.setText("您的验证码是：" + code + "，5分钟内有效。");
            javaMailSender.send(message);
            log.info("{}验证码已发送至 {}", purpose, email);
        } catch (Exception e) {
            log.error("邮件发送失败", e);
            throw new BusinessException("邮件发送失败，请稍后重试");
        }
    }

}