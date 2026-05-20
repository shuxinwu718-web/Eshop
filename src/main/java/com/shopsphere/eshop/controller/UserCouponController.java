package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.CouponReceiveDTO;
import com.shopsphere.eshop.entity.Coupon;
import com.shopsphere.eshop.service.UserCouponService;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import com.shopsphere.eshop.vo.UserCouponVO;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/user/coupons")
@RequiredArgsConstructor
public class UserCouponController {

    private final UserCouponService userCouponService;
    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;
    /**
     * 领券中心 - 可领取的优惠券列表
     */
    @GetMapping("/available")
    public Result<List<Coupon>> getAvailableCoupons() {
        return Result.success(userCouponService.getAvailableCoupons());
    }

    /**
     * 领取优惠券
     */
    @PostMapping("/receive")
    public Result<?> receiveCoupon(@RequestBody @Valid CouponReceiveDTO dto,
                                   @RequestHeader("Authorization") String authHeader) {
        Long userId = jwtUtil.getUserIdFromToken(tokenUtils.extractToken(authHeader));
        userCouponService.receiveCoupon(userId, dto.getCouponId());
        return Result.success("领取成功");
    }

    /**
     * 我的优惠券（未使用）
     */
    @GetMapping("/my")
    public Result<List<UserCouponVO>> getMyCoupons(@RequestHeader("Authorization") String authHeader) {
        Long userId = jwtUtil.getUserIdFromToken(tokenUtils.extractToken(authHeader));
        return Result.success(userCouponService.getMyUsableCoupons(userId));
    }


    /**
     * 获取当前订单可用的优惠券列表（根据订单金额筛选）
     * @param totalAmount 订单原价总金额（由前端传入）
     * @param authHeader 用户token
     */
    @GetMapping("/usable")
    public Result<List<UserCouponVO>> getUsableCoupons(@RequestParam BigDecimal totalAmount,
                                                       @RequestHeader("Authorization") String authHeader) {
        Long userId = jwtUtil.getUserIdFromToken(tokenUtils.extractToken(authHeader));
        List<UserCouponVO> list = userCouponService.getUsableCoupons(userId, totalAmount);
        return Result.success(list);
    }

}