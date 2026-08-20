package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.CouponReceiveDTO;
import com.shopsphere.eshop.dto.FestivalCouponClaimDTO;
import com.shopsphere.eshop.vo.AvailableCouponVO;
import com.shopsphere.eshop.service.UserCouponService;
import com.shopsphere.eshop.vo.UserCouponVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/user/coupons")
@RequiredArgsConstructor
@Tag(name = "用户使用、获取优惠卷的接口", description = "领取优惠卷、查看优惠卷、根据签到天数领取优惠卷")
public class UserCouponController {

    private final UserCouponService userCouponService;
    /**
     * 领券中心 - 可领取的优惠券列表（附带当前用户已领取数量）
     * @param type 优惠券类型（0=满减, 1=折扣），可选
     * @param keyword 搜索关键词，可选
     * @param timeStatus 时间状态（ongoing=进行中, upcoming=即将开始, all=全部），默认 ongoing
     */
    @GetMapping("/available")
    public Result<List<AvailableCouponVO>> getAvailableCoupons(
            @RequestParam(required = false) Integer type,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false, defaultValue = "ongoing") String timeStatus,
            @CurrentUserId Long userId) {
        return Result.success(userCouponService.getAvailableCouponsWithClaim(userId, type, keyword, timeStatus));
    }

    /**
     * 领取优惠券
     */
    @PostMapping("/receive")
    public Result<?> receiveCoupon(@RequestBody @Valid CouponReceiveDTO dto,
                                   @CurrentUserId Long userId) {
        userCouponService.receiveCoupon(userId, dto.getCouponId());
        return Result.success("领取成功");
    }

    /**
     * 我的优惠券（未使用）
     */
    @GetMapping("/my")
    public Result<List<UserCouponVO>> getMyCoupons(@RequestParam(required = false) Integer status,
                                                   @CurrentUserId Long userId) {
        return Result.success(userCouponService.getMyCoupons(userId, status));
    }


    /**
     * 获取当前订单可用的优惠券列表（根据订单金额筛选）
     * @param totalAmount 订单原价总金额（由前端传入）
     * @param userId 用户ID
     */
    @GetMapping("/usable")
    public Result<List<UserCouponVO>> getUsableCoupons(@RequestParam BigDecimal totalAmount,
                                                       @CurrentUserId Long userId) {
        List<UserCouponVO> list = userCouponService.getUsableCoupons(userId, totalAmount);
        return Result.success(list);
    }

    /**
     * 领取节日活动优惠券（需满足签到天数）
     */
    @PostMapping("/claim-festival")
    public Result<?> claimFestivalCoupon(@RequestBody @Valid FestivalCouponClaimDTO dto,
                                         @CurrentUserId Long userId) {
        userCouponService.claimFestivalCoupon(userId, dto.getPlanId());
        return Result.success("领取成功");
    }

}