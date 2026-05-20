package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.UserCoupon;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface UserCouponMapper extends BaseMapper<UserCoupon> {

    @Select("SELECT COUNT(*) FROM user_coupon WHERE user_id = #{userId} AND coupon_id = #{couponId}")
    long countByUserAndCoupon(@Param("userId") Long userId, @Param("couponId") Long couponId);

    @Select("SELECT COALESCE(COUNT(*), 0) FROM user_coupon WHERE coupon_id = #{couponId}")
    long countClaimedByCouponId(@Param("couponId") Long couponId);
}
