package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("store_design")
public class StoreDesign {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long merchantId;
    private String backgroundColor;
    private String bannerUrl;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
