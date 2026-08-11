package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.service.GroupBuyService;
import com.shopsphere.eshop.vo.GroupBuyActivityVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin/group-buy")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
@Tag(name = "管理员拼团管理", description = "管理员仅查看/取消拼团活动")
public class AdminGroupBuyController {

    private final GroupBuyService groupBuyService;

    @GetMapping("/page")
    public Result<Page<GroupBuyActivityVO>> page(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String keyword) {
        return Result.success(groupBuyService.adminPage(pageNum, pageSize, keyword));
    }

    /** 取消活动（违规/异常时介入），对进行中团自动退款并通知用户 */
    @PutMapping("/cancel/{id}")
    public Result<?> cancel(@PathVariable Long id) {
        groupBuyService.adminCancelActivity(id);
        return Result.success("活动已取消，相关用户已收到退款通知");
    }
}
