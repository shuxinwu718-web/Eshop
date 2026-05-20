package com.shopsphere.eshop.service;

import com.shopsphere.eshop.entity.Coupon;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface ActivityService {
    /**
     * 用户签到
     * @return 如果满足连续签到规则，返回赠送的优惠券；否则返回 null
     */
    Coupon signIn(Long userId);

    // 新增
    List<String> getSignInRecords(Long userId);

    Map<String, Object> getSignInStatus(Long userId);
}
