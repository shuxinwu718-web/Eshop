package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.GroupBuyOrderDTO;
import com.shopsphere.eshop.service.GroupBuyService;
import com.shopsphere.eshop.vo.GroupBuyActivityVO;
import com.shopsphere.eshop.vo.GroupBuyGroupVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/group-buy")
@RequiredArgsConstructor
@Tag(name = "拼团", description = "用户发起拼团/参与拼团")
public class GroupBuyController {

    private final GroupBuyService groupBuyService;

    /** 商品进行中的拼团活动（含进行中团列表）。未登录 currentUserId 为 null（匿名读缓存） */
    @GetMapping("/product/{productId}")
    public Result<List<GroupBuyActivityVO>> getProductActivities(@PathVariable Long productId,
                                                                 @CurrentUserId Long userId) {
        return Result.success(groupBuyService.getProductActivities(productId, userId));
    }

    /** 团详情 */
    @GetMapping("/groups/{groupId}")
    public Result<GroupBuyGroupVO> getGroupDetail(@PathVariable Long groupId,
                                                  @CurrentUserId Long userId) {
        return Result.success(groupBuyService.getGroupDetail(groupId, userId));
    }

    /** 开团：返回团ID（随后跳转支付） */
    @PostMapping("/start/{activityId}")
    public Result<Long> startGroup(@PathVariable Long activityId,
                                   @Valid @RequestBody GroupBuyOrderDTO dto,
                                   @CurrentUserId Long userId) {
        return Result.success(groupBuyService.startGroup(activityId, dto, userId));
    }

    /** 参团：返回团ID（随后跳转支付） */
    @PostMapping("/join/{groupId}")
    public Result<Long> joinGroup(@PathVariable Long groupId,
                                  @Valid @RequestBody GroupBuyOrderDTO dto,
                                  @CurrentUserId Long userId) {
        return Result.success(groupBuyService.joinGroup(groupId, dto, userId));
    }

    /** 我的拼团记录 */
    @GetMapping("/my")
    public Result<List<GroupBuyGroupVO>> myGroups(@CurrentUserId Long userId) {
        return Result.success(groupBuyService.myGroups(userId));
    }
}
