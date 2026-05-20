package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.CouponPageQueryDTO;
import com.shopsphere.eshop.dto.CouponSaveDTO;
import com.shopsphere.eshop.entity.Coupon;
import com.shopsphere.eshop.service.CouponService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin/coupon")
@RequiredArgsConstructor
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
    public Result<?> addCoupon(@Valid @RequestBody CouponSaveDTO dto) {
        couponService.addCoupon(dto);
        return Result.success("添加成功");
    }

    @PutMapping
    public Result<?> updateCoupon(@Valid @RequestBody CouponSaveDTO dto) {
        couponService.updateCoupon(dto);
        return Result.success("修改成功");
    }

    @DeleteMapping("/{id}")
    public Result<?> deleteCoupon(@PathVariable Long id) {
        couponService.deleteCoupon(id);
        return Result.success("删除成功");
    }

    @PutMapping("/status/{id}")
    public Result<?> changeStatus(@PathVariable Long id, @RequestParam Integer status) {
        couponService.changeStatus(id, status);
        return Result.success("状态更新成功");
    }
}
