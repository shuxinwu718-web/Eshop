package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.service.MarketingActivityService;
import com.shopsphere.eshop.vo.MarketingActivityVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 用户端 平台营销活动（活动中心）
 */
@RestController
@RequestMapping("/api/marketing-activity")
@RequiredArgsConstructor
@Tag(name = "营销活动", description = "活动中心：进行中活动列表、详情、领取任务奖励")
public class MarketingActivityController {

    private final MarketingActivityService marketingActivityService;

    /** 进行中活动列表（登录后返回任务进度与领取状态） */
    @GetMapping("/active")
    public Result<List<MarketingActivityVO>> listActive(@CurrentUserId Long userId) {
        return Result.success(marketingActivityService.listActive(userId));
    }

    /** 活动详情（含任务与用户进度） */
    @GetMapping("/{id}")
    public Result<MarketingActivityVO> detail(@PathVariable Long id, @CurrentUserId Long userId) {
        return Result.success(marketingActivityService.getDetail(id, userId));
    }

    /** 领取任务奖励 */
    @PostMapping("/{activityId}/claim/{taskId}")
    public Result<?> claimReward(@PathVariable Long activityId,
                                 @PathVariable Long taskId,
                                 @CurrentUserId Long userId) {
        marketingActivityService.claimReward(userId, activityId, taskId);
        return Result.success("领取成功");
    }
}
