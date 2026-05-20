package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("merchant_apply")
public class MerchantApply {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private String businessName;
    private String businessLicense;
    private String contactName;
    private String contactPhone;
    private String businessScope;
    private String address;
    private Integer status;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}