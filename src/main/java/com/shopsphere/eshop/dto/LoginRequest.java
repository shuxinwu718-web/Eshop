package com.shopsphere.eshop.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class LoginRequest {
    @NotBlank
    private String username;

    @NotBlank
    private String password;

    /** 图形验证码的 key（从 /api/captcha/image 获取） */
    @NotBlank(message = "验证码不能为空")
    private String captchaKey;

    /** 用户输入的验证码 */
    @NotBlank(message = "验证码不能为空")
    private String captchaCode;
}