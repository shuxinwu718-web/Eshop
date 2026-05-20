package com.shopsphere.eshop.service.impl;

import com.shopsphere.eshop.mapper.OrderItemMapper;
import com.shopsphere.eshop.mapper.OrderMapper;
import com.shopsphere.eshop.service.OrderItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrderItemServiceImpl implements OrderItemService {

    private final OrderItemMapper orderItemMapper;
    private final OrderMapper orderMapper;
}
