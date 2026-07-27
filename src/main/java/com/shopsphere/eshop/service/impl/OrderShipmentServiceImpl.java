package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.shopsphere.eshop.entity.Order;
import com.shopsphere.eshop.entity.OrderShipment;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.OrderMapper;
import com.shopsphere.eshop.mapper.OrderShipmentMapper;
import com.shopsphere.eshop.service.OrderShipmentService;
import com.shopsphere.eshop.vo.MerchantShipmentVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderShipmentServiceImpl implements OrderShipmentService {

    private final OrderShipmentMapper orderShipmentMapper;
    private final OrderMapper orderMapper;

    @Override
    public Page<MerchantShipmentVO> getMerchantShipments(Long sellerId, Integer pageNum, Integer pageSize) {
        Page<MerchantShipmentVO> page = new Page<>(pageNum, pageSize, false);
        Page<MerchantShipmentVO> result = orderShipmentMapper.selectMerchantShipments(page, sellerId);
        Long total = orderShipmentMapper.selectCount(
                new LambdaQueryWrapper<OrderShipment>().eq(OrderShipment::getSellerId, sellerId)
        );
        result.setTotal(total);
        return result;
    }

    @Override
    public List<MerchantShipmentVO> getMerchantOrderShipments(Long orderId, Long sellerId) {
        return orderShipmentMapper.selectMerchantOrderShipments(orderId, sellerId);
    }

    @Override
    @Transactional
    public void shipShipment(Long shipmentId, Long sellerId, String shippingName, String shippingNo) {
        int updated = orderShipmentMapper.updateShipmentShipping(shipmentId, sellerId, shippingName, shippingNo);
        if (updated == 0) {
            throw new BusinessException("发货失败，发货单不存在、无权操作或已发货");
        }

        // 发货成功后，如果父订单仍是待发货(1)，则更新为已发货(2)
        OrderShipment shipment = orderShipmentMapper.selectById(shipmentId);
        if (shipment != null) {
            orderMapper.update(null, new LambdaUpdateWrapper<Order>()
                    .eq(Order::getId, shipment.getOrderId())
                    .eq(Order::getOrderStatus, 1)
                    .set(Order::getOrderStatus, 2));
        }
    }
}
