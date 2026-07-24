package com.shopsphere.eshop.dto;

import lombok.Data;
import java.time.LocalDateTime;
// （获取个人资料请求）
@Data
public class UserProfileDetail {
    private Long userId;
    private String username;
    private String nickname;
    private String phone;
    private String mobile;
    private String email;
    private String avatar;
    private String role;
    private String roleNames;
    private Integer gender;
    private LocalDateTime createTime;
}