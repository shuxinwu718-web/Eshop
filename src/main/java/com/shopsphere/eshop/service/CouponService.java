package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.CouponPageQueryDTO;
import com.shopsphere.eshop.dto.CouponSaveDTO;
import com.shopsphere.eshop.entity.Coupon;

public interface CouponService {
    void addCoupon(CouponSaveDTO dto);
    void updateCoupon(CouponSaveDTO dto);
    void deleteCoupon(Long id);
    void changeStatus(Long id, Integer status);
    Page<Coupon> pageQuery(CouponPageQueryDTO dto);
    Coupon getCouponById(Long id);
}
