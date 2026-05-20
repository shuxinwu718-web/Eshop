package com.shopsphere.eshop.dto;

import lombok.Data;
// （修改密码请求）
@Data
public class PasswordChangeForm {
    private String oldPassword;
    private String newPassword;
}