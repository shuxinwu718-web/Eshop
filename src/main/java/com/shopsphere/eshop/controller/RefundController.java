package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.entity.RefundReasonCategory;
import com.shopsphere.eshop.service.OrderService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/refund")
@RequiredArgsConstructor
@Tag(name = "退款公共接口")
public class RefundController {

    private final OrderService orderService;

    @GetMapping("/reason-categories")
    public Result<List<RefundReasonCategory>> getReasonCategories() {
        return Result.success(orderService.getReasonCategories());
    }
}
