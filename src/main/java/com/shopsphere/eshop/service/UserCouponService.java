package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.entity.Coupon;
import com.shopsphere.eshop.entity.UserCoupon;
import com.shopsphere.eshop.vo.UserCouponVO;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

public interface UserCouponService {
    /**
     * 获取用户可领取的普通优惠券列表（领券中心）
     */
    List<Coupon> getAvailableCoupons();

    // 领取优惠券时（不需要存过期时间，过期时间从 coupon 表获取）
    void receiveCoupon(Long userId, Long couponId);

    /**
     * 活动发放优惠券（不扣减库存、不检查领取上限）
     */
    void grantCoupon(Long userId, Long couponId);

    // 查询我的可用优惠券（需关联 coupon 表判断是否过期）
    List<UserCouponVO> getMyUsableCoupons(Long userId);

    //使用优惠券（下单时）
    void useCoupon(Long userCouponId, String orderNo);

    List<UserCouponVO> getUsableCoupons(Long userId, BigDecimal totalAmount);
}
