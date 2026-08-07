package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.annotation.Log;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.constant.OperationType;

import com.shopsphere.eshop.dto.CouponPageQueryDTO;
import com.shopsphere.eshop.dto.CouponSaveDTO;
import com.shopsphere.eshop.entity.Coupon;
import com.shopsphere.eshop.service.CouponService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin/coupon")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
@Tag(name = "管理员管理折扣劵", description = "对折扣劵的CRUD")
public class AdminCouponController {

    private final CouponService couponService;

    @GetMapping("/page")
    public Result<Page<Coupon>> pageQuery(CouponPageQueryDTO dto) {
        return Result.success(couponService.pageQuery(dto));
    }

    @GetMapping("/{id}")
    public Result<Coupon> getById(@PathVariable Long id) {
        return Result.success(couponService.getCouponById(id));
    }

    @PostMapping
    @Log(value = "新增优惠卷", type = OperationType.ADD_COUPON, targetType = "CouponSaveDTO")
    public Result<?> addCoupon(@Valid @RequestBody CouponSaveDTO dto) {
        couponService.addCoupon(dto);
        return Result.success("添加成功");
    }

    @PutMapping
    @Log(value = "修改优惠卷", type = OperationType.UPDATE_COUPON, targetType = "CouponSaveDTO")
    public Result<?> updateCoupon(@Valid @RequestBody CouponSaveDTO dto) {
        couponService.updateCoupon(dto);
        return Result.success("修改成功");
    }

    @DeleteMapping("/{id}")
    @Log(value = "删除优惠卷", type = OperationType.DELETE_COUPON, targetType = "CouponSaveDTO")
    public Result<?> deleteCoupon(@PathVariable Long id) {
        couponService.deleteCoupon(id);
        return Result.success("删除成功");
    }

    @PutMapping("/status/{id}")
    @Log(value = "修改优惠卷状态", type = OperationType.CHANGE_STATUS, targetType = "status")
    public Result<?> changeStatus(@PathVariable Long id, @RequestParam Integer status) {
        couponService.changeStatus(id, status);
        return Result.success("状态更新成功");
    }
}
