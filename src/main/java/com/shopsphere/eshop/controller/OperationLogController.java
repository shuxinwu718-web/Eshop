package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.LogQueryDTO;
import com.shopsphere.eshop.entity.OperationLog;
import com.shopsphere.eshop.service.OperationLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin/logs")
@PreAuthorize("hasRole('ADMIN')")
@RequiredArgsConstructor
public class OperationLogController {

    private final OperationLogService logService;

    @GetMapping("/page")
    public Result<Page<OperationLog>> getPage(LogQueryDTO queryDTO) {
        Page<OperationLog> page = logService.getPage(queryDTO);
        return Result.success(page);
    }
}