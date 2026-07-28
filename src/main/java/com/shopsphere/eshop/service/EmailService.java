package com.shopsphere.eshop.service;

import com.shopsphere.eshop.exception.BusinessException;

public interface EmailService {

    /**
     * 发送邮箱验证码
     * @param email 目标邮箱
     * @throws BusinessException 邮箱已被绑定或发送失败
     */
    void sendEmailCode(String email);

    /**
     * 绑定邮箱到当前用户
     * @param userId 用户ID
     * @param email 邮箱地址
     * @param code 验证码
     * @throws BusinessException 验证码错误、邮箱已被占用等
     */
    void bindEmail(Long userId, String email, String code);


    /**
     * 发送重置密码验证码（忘记密码专用）
     * @param email 邮箱
     */
    void sendResetPasswordCode(String email);

    /**
     * 发送登录验证码（邮箱免密登录）
     * @param email 已注册的邮箱
     */
    void sendLoginCode(String email);
}
