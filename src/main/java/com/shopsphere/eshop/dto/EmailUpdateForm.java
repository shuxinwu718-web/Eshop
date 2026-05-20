package com.shopsphere.eshop.dto;

import lombok.Data;

// 修改邮箱请求
@Data
public class EmailUpdateForm {
    private String email;
    private String code;
}
