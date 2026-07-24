package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("user")
public class User {
    @TableId(type = IdType.AUTO)
    private Long id;

    private String username;
    private String nickname;
    private String password;
    private String phone;
    private String email;
    private Integer status;  // 0-正常 1-冻结
    // 新增角色字段
    private String role;     // USER, ADMIN, MERCHANT
    private String githubId;   // GitHub 用户 ID（用于关联）
    private String avatar; //用户头像
    private Integer gender; // 0-未知 1-男 2-女
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;
}