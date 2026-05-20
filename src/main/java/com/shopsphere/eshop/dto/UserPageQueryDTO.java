package com.shopsphere.eshop.dto;

import lombok.Data;

@Data
public class UserPageQueryDTO {
    private Integer pageNum = 1;
    private Integer pageSize = 10;
    private String username;
    private String phone;
    private String email;
    private Integer status;   // 0-正常 1-冻结
}