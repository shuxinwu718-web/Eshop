package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.annotation.Log;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.constant.OperationType;
import com.shopsphere.eshop.dto.MarketingActivitySaveDTO;
import com.shopsphere.eshop.service.MarketingActivityService;
import com.shopsphere.eshop.vo.MarketingActivityVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

/**
 * 管理员 平台营销活动管理（通用任务制：签到/下单/收藏，达标发优惠券）
 */
@RestController
@RequestMapping("/admin/marketing-activity")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
@Tag(name = "管理员营销活动", description = "平台营销活动的CRUD")
public class AdminMarketingActivityController {

    private final MarketingActivityService marketingActivityService;

    @GetMapping("/page")
    public Result<Page<MarketingActivityVO>> pageQuery(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status) {
        return Result.success(marketingActivityService.pageQuery(pageNum, pageSize, keyword, status));
    }

    @GetMapping("/{id}")
    public Result<MarketingActivityVO> getById(@PathVariable Long id) {
        return Result.success(marketingActivityService.getById(id));
    }

    @PostMapping
    @Log(value = "新增营销活动", type = OperationType.ADD_MARKETING_ACTIVITY, targetType = "MarketingActivity")
    public Result<?> add(@Valid @RequestBody MarketingActivitySaveDTO dto) {
        marketingActivityService.add(dto);
        return Result.success("添加成功");
    }

    @PutMapping
    @Log(value = "修改营销活动", type = OperationType.UPDATE_MARKETING_ACTIVITY, targetType = "MarketingActivity")
    public Result<?> update(@Valid @RequestBody MarketingActivitySaveDTO dto) {
        marketingActivityService.update(dto);
        return Result.success("修改成功");
    }

    @DeleteMapping("/{id}")
    @Log(value = "删除营销活动", type = OperationType.DELETE_MARKETING_ACTIVITY, targetType = "MarketingActivity")
    public Result<?> delete(@PathVariable Long id) {
        marketingActivityService.delete(id);
        return Result.success("删除成功");
    }

    @PutMapping("/status/{id}")
    @Log(value = "修改营销活动状态", type = OperationType.CHANGE_STATUS, targetType = "MarketingActivity")
    public Result<?> changeStatus(@PathVariable Long id, @RequestParam Integer status) {
        marketingActivityService.changeStatus(id, status);
        return Result.success("状态更新成功");
    }
}
