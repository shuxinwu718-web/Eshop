package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.*;
import com.shopsphere.eshop.entity.User;
import com.shopsphere.eshop.service.EmailService;
import com.shopsphere.eshop.service.UserService;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor

public class UserController {

    private final UserService userService;
    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    private final EmailService emailService;   // 注入邮件服务
    private final RedisTemplate<String, String> redisTemplate;
    @PostMapping("/register")
    public Result<?> register(@Valid @RequestBody RegisterRequest request) {
        userService.register(request);
        return Result.success("注册成功，恭喜获得新人礼包（5张优惠券）！");
    }

    @PostMapping("/login")
    public Result<?> login(@Valid @RequestBody LoginRequest request) {
        return Result.success(userService.login(request));
    }

    @GetMapping("/info")
    public Result<?> getUserInfo(@RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        return Result.success(userService.getUserInfo(userId));
    }


    // ========== 管理员接口 ==========

    @GetMapping("/admin/page")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> adminPageQuery(UserPageQueryDTO dto) {
        return Result.success(userService.adminPageQuery(dto));
    }

    @PostMapping("/admin/freeze/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> freezeUser(@PathVariable Long id) {
        userService.freezeUser(id);
        return Result.success("冻结成功");
    }

    @PostMapping("/admin/unfreeze/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> unfreezeUser(@PathVariable Long id) {
        userService.unfreezeUser(id);
        return Result.success("解冻成功");
    }

    @GetMapping("/admin/search")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<?> searchUsers(@RequestParam String keyword,
                                 @RequestParam(defaultValue = "1") Integer pageNum,
                                 @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(userService.searchUsers(keyword, pageNum, pageSize));
    }

    // ========== 用户自身接口 ==========

    @PostMapping("/deactivate")
    public Result<?> deactivateAccount(@RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        userService.deactivateAccount(userId);
        return Result.success("账号已注销");
    }







    // ========== 个人信息模块 ==========

    @GetMapping("/me")
    public Result<UserProfileDetail> getCurrentUserInfo(@RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        User user = userService.getById(userId);
        if (user == null) return Result.error("用户不存在");
        UserProfileDetail detail = new UserProfileDetail();
        detail.setUserId(user.getId());
        detail.setUsername(user.getUsername());
        detail.setNickname(user.getNickname());
        detail.setPhone(user.getPhone());
        detail.setEmail(user.getEmail());
        detail.setAvatar(user.getAvatar());
        detail.setRole(user.getRole());
        detail.setCreateTime(user.getCreateTime());
        return Result.success(detail);
    }

    @GetMapping("/profile")
    public Result<UserProfileDetail> getProfile(@RequestHeader("Authorization") String authHeader) {
        return getCurrentUserInfo(authHeader);
    }

    @PutMapping("/profile")
    public Result<Void> updateProfile(@RequestBody UserProfileForm form,
                                      @RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        User user = userService.getById(userId);
        if (user == null) return Result.error("用户不存在");
        if (form.getNickname() != null) user.setNickname(form.getNickname());
        if (form.getPhone() != null) user.setPhone(form.getPhone());
        if (form.getEmail() != null) user.setEmail(form.getEmail());
        if (form.getAvatar() != null) user.setAvatar(form.getAvatar());
        userService.updateById(user);
        return Result.success(null);
    }

    @PutMapping("/password")
    public Result<Void> changePassword(@RequestBody PasswordChangeForm form,
                                       @RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        User user = userService.getById(userId);
        if (user == null) return Result.error("用户不存在");

        if (!passwordEncoder.matches(form.getOldPassword(), user.getPassword())) {
            return Result.error("原密码错误");
        }
        user.setPassword(passwordEncoder.encode(form.getNewPassword()));
        userService.updateById(user);
        return Result.success(null);
    }

    @PostMapping("/mobile/code")
    public Result<Void> sendMobileCode(@RequestParam String mobile) {
        // TODO: 实现短信发送，将验证码存入 Redis，有效期5分钟
        return Result.success(null);
    }

    @PutMapping("/mobile")
    public Result<Void> bindOrChangeMobile(@RequestBody MobileUpdateForm form,
                                           @RequestHeader("Authorization") String authHeader) {
        // TODO: 验证验证码
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        User user = userService.getById(userId);
        user.setPhone(form.getMobile());
        userService.updateById(user);
        return Result.success(null);
    }


    /**
     * 发送邮箱验证码（用于绑定邮箱或找回密码）
     */
    @PostMapping("/email/code")
    public Result<Void> sendEmailCode(@RequestParam String email) {
        emailService.sendEmailCode(email);
        return Result.success(null);
    }

    /**
     * 绑定邮箱
     */
    @PostMapping("/bind-email")
    public Result<String> bindEmail(@RequestParam String email,
                                    @RequestParam String code,
                                    @RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        emailService.bindEmail(userId, email, code);
        return Result.success( "邮箱绑定成功");
    }


    /**
     * 绑定或更换邮箱（需要验证码）
     */
    @PutMapping("/email")
    public Result<String> bindOrChangeEmail(@RequestBody EmailUpdateForm form,
                                            @RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        emailService.bindEmail(userId, form.getEmail(), form.getCode());
        return Result.success("邮箱绑定成功");
    }

    /**
     * 解绑邮箱（需要密码验证）
     */
    @DeleteMapping("/email")
    public Result<String> unbindEmail(@RequestBody PasswordVerifyForm form,
                                      @RequestHeader("Authorization") String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        User user = userService.getById(userId);
        if (user == null) return Result.error("用户不存在");
        if (!passwordEncoder.matches(form.getPassword(), user.getPassword())) {
            return Result.error("密码错误");
        }
        user.setEmail(null);
        userService.updateById(user);
        return Result.success("解绑成功");
    }

    /**
     * 重置密码（通过邮箱验证码）
     */
    @PostMapping("/reset-password")
    public Result<String> resetPassword(@RequestBody ResetPasswordRequest request) {
        // 1. 校验验证码
        String redisKey = "email:code:" + request.getEmail() + ":reset";
        String cachedCode = redisTemplate.opsForValue().get(redisKey);
        if (cachedCode == null || !cachedCode.equals(request.getCode())) {
            return Result.error("验证码错误或已过期");
        }

        // 2. 查找用户
        User user = userService.findByEmail(request.getEmail());
        if (user == null) {
            return Result.error("该邮箱未注册");
        }
        // 3. 更新密码
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userService.updateById(user);
        // 4. 删除验证码缓存（防止重复使用）
        redisTemplate.delete("email:code:" + request.getEmail());
        return Result.success("密码重置成功");
    }


    @PostMapping("/reset-password/code")
    public Result<String> sendResetPasswordCode(@RequestParam String email) {
        emailService.sendResetPasswordCode(email);
        return Result.success("重置验证码发送成功");
    }

}