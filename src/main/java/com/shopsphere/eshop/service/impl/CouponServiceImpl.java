package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.CouponPageQueryDTO;
import com.shopsphere.eshop.dto.CouponSaveDTO;
import com.shopsphere.eshop.entity.Coupon;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.CouponMapper;
import com.shopsphere.eshop.service.CouponService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
@RequiredArgsConstructor
public class CouponServiceImpl implements CouponService {

    private final CouponMapper couponMapper;

    @Override
    public void addCoupon(CouponSaveDTO dto) {
        LambdaQueryWrapper<Coupon> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Coupon::getName, dto.getName());
        if (couponMapper.selectCount(wrapper) > 0) {
            throw new BusinessException("优惠券名称已存在");
        }
        Coupon coupon = new Coupon();
        BeanUtils.copyProperties(dto, coupon);
        coupon.setStatus(1);
        couponMapper.insert(coupon);
    }

    @Override
    public void updateCoupon(CouponSaveDTO dto) {
        Coupon coupon = couponMapper.selectById(dto.getId());
        if (coupon == null) {
            throw new BusinessException("优惠券不存在");
        }
        LambdaQueryWrapper<Coupon> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Coupon::getName, dto.getName())
                .ne(Coupon::getId, dto.getId());
        if (couponMapper.selectCount(wrapper) > 0) {
            throw new BusinessException("优惠券名称已存在");
        }
        BeanUtils.copyProperties(dto, coupon);
        couponMapper.updateById(coupon);
    }

    @Override
    public void deleteCoupon(Long id) {
        couponMapper.deleteById(id);
    }

    @Override
    public void changeStatus(Long id, Integer status) {
        Coupon coupon = couponMapper.selectById(id);
        if (coupon == null) {
            throw new BusinessException("优惠券不存在");
        }
        coupon.setStatus(status);
        couponMapper.updateById(coupon);
    }

    @Override
    public Page<Coupon> pageQuery(CouponPageQueryDTO dto) {
        Page<Coupon> page = new Page<>(dto.getPageNum(), dto.getPageSize());
        LambdaQueryWrapper<Coupon> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(dto.getName())) {
            wrapper.like(Coupon::getName, dto.getName());
        }
        if (dto.getType() != null) {
            wrapper.eq(Coupon::getType, dto.getType());
        }
        if (dto.getStatus() != null) {
            wrapper.eq(Coupon::getStatus, dto.getStatus());
        }
        wrapper.orderByDesc(Coupon::getCreateTime);
        return couponMapper.selectPage(page, wrapper);
    }

    @Override
    public Coupon getCouponById(Long id) {
        return couponMapper.selectById(id);
    }
}
