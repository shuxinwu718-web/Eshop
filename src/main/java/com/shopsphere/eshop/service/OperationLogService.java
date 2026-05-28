package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.LogQueryDTO;
import com.shopsphere.eshop.entity.OperationLog;

public interface OperationLogService {
    Page<OperationLog> getPage(LogQueryDTO dto);
}
