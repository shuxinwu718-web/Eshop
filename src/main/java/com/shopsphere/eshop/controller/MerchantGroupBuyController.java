package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.GroupBuyActivitySaveDTO;
import com.shopsphere.eshop.service.GroupBuyService;
import com.shopsphere.eshop.vo.GroupBuyActivityVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/merchant/group-buy")
@RequiredArgsConstructor
@Tag(name = "商家拼团管理", description = "商家创建/编辑/启停自己的拼团活动")
public class MerchantGroupBuyController {

    private final GroupBuyService groupBuyService;

    @GetMapping("/activities")
    public Result<Page<GroupBuyActivityVO>> page(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String keyword,
            @CurrentUserId Long merchantId) {
        return Result.success(groupBuyService.merchantPage(merchantId, pageNum, pageSize, keyword));
    }

    @PostMapping("/activity")
    public Result<?> create(@Valid @RequestBody GroupBuyActivitySaveDTO dto,
                            @CurrentUserId Long merchantId) {
        groupBuyService.createActivity(dto, merchantId);
        return Result.success("创建成功");
    }

    @PutMapping("/activity")
    public Result<?> update(@Valid @RequestBody GroupBuyActivitySaveDTO dto,
                            @CurrentUserId Long merchantId) {
        groupBuyService.updateActivity(dto, merchantId);
        return Result.success("修改成功");
    }

    /** 状态变更：1启动 / 2暂停 / 3终止（终止时对进行中团自动退款并通知） */
    @PutMapping("/activity/status/{id}")
    public Result<?> changeStatus(@PathVariable Long id,
                                  @RequestParam Integer status,
                                  @CurrentUserId Long merchantId) {
        groupBuyService.changeActivityStatus(id, status, merchantId);
        return Result.success("操作成功");
    }
}
