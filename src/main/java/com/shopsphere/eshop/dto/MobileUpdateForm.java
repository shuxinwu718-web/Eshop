package com.shopsphere.eshop.dto;

import lombok.Data;

//修改手机号请求
@Data
public class MobileUpdateForm {
    private String mobile;
    private String code;
}
