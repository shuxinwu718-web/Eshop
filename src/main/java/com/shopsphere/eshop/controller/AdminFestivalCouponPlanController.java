package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.annotation.Log;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.constant.OperationType;
import com.shopsphere.eshop.dto.FestivalCouponPlanDTO;
import com.shopsphere.eshop.service.FestivalCouponPlanService;
import com.shopsphere.eshop.vo.FestivalCouponPlanVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

/**
 * 管理员 节日优惠券活动计划管理
 */
@RestController
@RequestMapping("/admin/festival-plan")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
@Tag(name = "管理员节日活动计划", description = "节日优惠券签到活动计划的CRUD")
public class AdminFestivalCouponPlanController {

    private final FestivalCouponPlanService festivalCouponPlanService;

    @GetMapping("/page")
    public Result<Page<FestivalCouponPlanVO>> pageQuery(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status) {
        return Result.success(festivalCouponPlanService.pageQuery(pageNum, pageSize, keyword, status));
    }

    @GetMapping("/{id}")
    public Result<FestivalCouponPlanVO> getById(@PathVariable Long id) {
        return Result.success(festivalCouponPlanService.getById(id));
    }

    @PostMapping
    @Log(value = "新增节日活动计划", type = OperationType.ADD_FESTIVAL_PLAN, targetType = "FestivalCouponPlan")
    public Result<?> addPlan(@Valid @RequestBody FestivalCouponPlanDTO dto) {
        festivalCouponPlanService.addPlan(dto);
        return Result.success("添加成功");
    }

    @PutMapping
    @Log(value = "修改节日活动计划", type = OperationType.UPDATE_FESTIVAL_PLAN, targetType = "FestivalCouponPlan")
    public Result<?> updatePlan(@Valid @RequestBody FestivalCouponPlanDTO dto) {
        festivalCouponPlanService.updatePlan(dto);
        return Result.success("修改成功");
    }

    @DeleteMapping("/{id}")
    @Log(value = "删除节日活动计划", type = OperationType.DELETE_FESTIVAL_PLAN, targetType = "FestivalCouponPlan")
    public Result<?> deletePlan(@PathVariable Long id) {
        festivalCouponPlanService.deletePlan(id);
        return Result.success("删除成功");
    }

    @PutMapping("/status/{id}")
    @Log(value = "修改节日活动计划状态", type = OperationType.CHANGE_STATUS, targetType = "FestivalCouponPlan")
    public Result<?> changeStatus(@PathVariable Long id, @RequestParam Integer status) {
        festivalCouponPlanService.changeStatus(id, status);
        return Result.success("状态更新成功");
    }
}
