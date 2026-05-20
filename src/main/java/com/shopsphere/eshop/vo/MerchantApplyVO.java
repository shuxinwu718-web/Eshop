package com.shopsphere.eshop.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class MerchantApplyVO {
    private Long id;
    private Long userId;
    private String username;
    private String nickname;
    private String businessName;
    private String businessLicense;
    private String contactName;
    private String contactPhone;
    private String businessScope;
    private String address;
    private Integer status;   // 0-待审核 1-通过 2-拒绝
    private String remark;
    private LocalDateTime createTime;
}