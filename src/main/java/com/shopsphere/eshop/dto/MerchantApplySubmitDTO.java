package com.shopsphere.eshop.dto;

import lombok.Data;

@Data
public class MerchantApplySubmitDTO {
    private String businessName;
    private String businessLicense;  // 上传后得到的URL
    private String contactName;
    private String contactPhone;
    private String businessScope;
    private String address;
}