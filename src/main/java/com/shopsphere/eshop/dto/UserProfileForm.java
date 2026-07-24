package com.shopsphere.eshop.dto;

import lombok.Data;
//（修改个人资料请求）
@Data
public class UserProfileForm {
    private String nickname;
    private String phone;
    private String email;
    private String avatar;
    private Integer gender;
}