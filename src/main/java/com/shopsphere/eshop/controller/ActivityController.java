package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.entity.Coupon;
import com.shopsphere.eshop.service.ActivityService;
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
    @PostMapping("/signin")
    public Result<?> signIn(@CurrentUserId Long userId) {
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
    public Result<List<String>> getSignInRecords(@CurrentUserId Long userId) {
        List<String> records = activityService.getSignInRecords(userId);
        return Result.success(records);
    }

    /**
     * 获取今日签到状态及连续签到天数
     */
    @GetMapping("/signin/status")
    public Result<Map<String, Object>> getSignInStatus(@CurrentUserId Long userId) {
        Map<String, Object> status = activityService.getSignInStatus(userId);
        return Result.success(status);
    }

    /**
     * 获取签到里程碑配置（含用户领取状态）
     */
    @GetMapping("/signin/milestones")
    public Result<List<SigninMilestoneVO>> getMilestones(@CurrentUserId Long userId) {
        return Result.success(activityService.getMilestones(userId));
    }

    /**
     * 获取进行中的节日活动（含用户签到进度）
     * 游客（未登录）也可浏览，已领取状态视为未领取
     */
    @GetMapping("/festival-coupons")
    public Result<List<FestivalCouponVO>> getFestivalCoupons(@CurrentUserId Long userId) {
        return Result.success(activityService.getFestivalCoupons(userId));
    }

}