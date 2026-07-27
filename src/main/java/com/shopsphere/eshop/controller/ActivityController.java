package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.entity.Coupon;
import com.shopsphere.eshop.service.ActivityService;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import com.shopsphere.eshop.vo.FestivalCouponVO;
import com.shopsphere.eshop.vo.SigninMilestoneVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/user/activities")
@RequiredArgsConstructor
@Tag(name = "用户活动管理", description = "签到、抽奖、限时秒券等活动接口")
public class ActivityController {

    private final ActivityService activityService;
    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;
    @PostMapping("/signin")
    public Result<?> signIn(@RequestHeader("Authorization") String authHeader) {
        Long userId = jwtUtil.getUserIdFromToken(tokenUtils.extractToken(authHeader));
        Coupon coupon = activityService.signIn(userId);
        if (coupon != null) {
            return Result.success("签到成功，获得优惠券：" + coupon.getName());
        }
        return Result.success("签到成功");
    }

    /**
     * 获取用户的签到记录（已签到的日期列表）
     */
    @GetMapping("/signin/records")
    public Result<List<String>> getSignInRecords(@RequestHeader("Authorization") String authHeader) {
        Long userId = jwtUtil.getUserIdFromToken(tokenUtils.extractToken(authHeader));
        List<String> records = activityService.getSignInRecords(userId);
        return Result.success(records);
    }

    /**
     * 获取今日签到状态及连续签到天数
     */
    @GetMapping("/signin/status")
    public Result<Map<String, Object>> getSignInStatus(@RequestHeader("Authorization") String authHeader) {
        Long userId = jwtUtil.getUserIdFromToken(tokenUtils.extractToken(authHeader));
        Map<String, Object> status = activityService.getSignInStatus(userId);
        return Result.success(status);
    }

    /**
     * 获取签到里程碑配置（含用户领取状态）
     */
    @GetMapping("/signin/milestones")
    public Result<List<SigninMilestoneVO>> getMilestones(@RequestHeader("Authorization") String authHeader) {
        Long userId = jwtUtil.getUserIdFromToken(tokenUtils.extractToken(authHeader));
        return Result.success(activityService.getMilestones(userId));
    }

    /**
     * 获取进行中的节日活动（含用户签到进度）
     */
    @GetMapping("/festival-coupons")
    public Result<List<FestivalCouponVO>> getFestivalCoupons(@RequestHeader("Authorization") String authHeader) {
        Long userId = jwtUtil.getUserIdFromToken(tokenUtils.extractToken(authHeader));
        return Result.success(activityService.getFestivalCoupons(userId));
    }

}