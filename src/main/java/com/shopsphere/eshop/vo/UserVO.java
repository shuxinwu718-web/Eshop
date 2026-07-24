package com.shopsphere.eshop.vo;

import lombok.Data;
import java.time.LocalDateTime;
//（用于返回给前端的用户信息）
@Data
public class UserVO {
    private Long id;
    private String username;
    private String nickname;
    private String phone;
    private String email;
    private String role;
    private Integer status;

    private String avatar;
    private Integer gender;
    private LocalDateTime createTime;
}
