package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.MerchantNotification;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface MerchantNotificationMapper extends BaseMapper<MerchantNotification> {

    @Select("SELECT COUNT(*) FROM merchant_notification WHERE merchant_id = #{merchantId} AND is_read = 0")
    Long countUnread(Long merchantId);
}
