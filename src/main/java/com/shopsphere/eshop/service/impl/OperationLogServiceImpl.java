package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.LogQueryDTO;
import com.shopsphere.eshop.entity.OperationLog;
import com.shopsphere.eshop.mapper.OperationLogMapper;
import com.shopsphere.eshop.service.OperationLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
@Service
@RequiredArgsConstructor
public class OperationLogServiceImpl implements OperationLogService {


    private final OperationLogMapper logMapper;

    public Page<OperationLog> getPage(LogQueryDTO dto) {
        Page<OperationLog> page = new Page<>(dto.getPageNum(), dto.getPageSize());
        LambdaQueryWrapper<OperationLog> wrapper = new LambdaQueryWrapper<>();
        if (dto.getOperatorId() != null) {
            wrapper.eq(OperationLog::getOperatorId, dto.getOperatorId());
        }
        if (StringUtils.hasText(dto.getOperationType())) {
            wrapper.eq(OperationLog::getOperationType, dto.getOperationType());
        }
        if (StringUtils.hasText(dto.getTargetType())) {
            wrapper.eq(OperationLog::getTargetType, dto.getTargetType());
        }
        if (StringUtils.hasText(dto.getStartTime())) {
            wrapper.ge(OperationLog::getCreateTime, LocalDateTime.parse(dto.getStartTime()));
        }
        if (StringUtils.hasText(dto.getEndTime())) {
            wrapper.le(OperationLog::getCreateTime, LocalDateTime.parse(dto.getEndTime()));
        }
        wrapper.orderByDesc(OperationLog::getCreateTime);
        return logMapper.selectPage(page, wrapper);
    }
}
