package com.shopsphere.eshop.dto;

import lombok.Data;

@Data
public class StoreDesignDTO {
    private String backgroundColor;
    private String bannerUrl;
    private String announcement;
    /** 装修楼层草稿配置 JSON（保存草稿用） */
    private String draftLayout;
}
