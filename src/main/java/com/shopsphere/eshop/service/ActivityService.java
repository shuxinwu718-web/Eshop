package com.shopsphere.eshop.service;

import com.shopsphere.eshop.entity.Coupon;
import com.shopsphere.eshop.vo.FestivalCouponVO;
import com.shopsphere.eshop.vo.SigninMilestoneVO;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    /**
     * 用户签到
     * @return 如果满足连续签到规则，返回赠送的优惠券；否则返回 null
     */
    Coupon signIn(Long userId);

    List<String> getSignInRecords(Long userId);

    Map<String, Object> getSignInStatus(Long userId);

    /**
     * 获取签到里程碑配置（含用户领取状态）
     */
    List<SigninMilestoneVO> getMilestones(Long userId);

    /**
     * 获取进行中的节日活动（含用户签到进度）
     */
    List<FestivalCouponVO> getFestivalCoupons(Long userId);
}
