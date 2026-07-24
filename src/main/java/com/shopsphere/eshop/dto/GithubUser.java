package com.shopsphere.eshop.dto;

import lombok.Data;

@Data
public class GithubUser {
    private Long id;           // GitHub 用户 ID（唯一）
    private String login;      // GitHub 用户名
    private String name;       // 显示名称
    private String avatarUrl;  // 头像 URL
    private String email;      // 邮箱
    private String bio;        // 个人简介
}