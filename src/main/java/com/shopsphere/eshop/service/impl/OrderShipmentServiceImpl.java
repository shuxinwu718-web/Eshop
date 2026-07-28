package com.shopsphere.eshop.service.impl;

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
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OrderShipmentServiceImpl implements OrderShipmentService {

    private final OrderShipmentMapper orderShipmentMapper;
    private final OrderMapper orderMapper;

    @Override
    public Page<MerchantShipmentVO> getMerchantShipments(Long sellerId, Integer pageNum, Integer pageSize) {
        // 第一步：用简单的单表查询分页获取发货单ID（避免JOIN导致的分页不准确）
        Page<OrderShipment> idPage = new Page<>(pageNum, pageSize, true);
        LambdaQueryWrapper<OrderShipment> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(OrderShipment::getSellerId, sellerId)
               .orderByDesc(OrderShipment::getCreateTime);
        Page<OrderShipment> shipmentPage = orderShipmentMapper.selectPage(idPage, wrapper);

        Page<MerchantShipmentVO> result = new Page<>(pageNum, pageSize);
        result.setTotal(shipmentPage.getTotal());

        List<Long> ids = shipmentPage.getRecords().stream()
                .map(OrderShipment::getId)
                .collect(Collectors.toList());

        if (!ids.isEmpty()) {
            List<MerchantShipmentVO> list = orderShipmentMapper.selectShipmentsByIds(ids, sellerId);
            result.setRecords(list);
        }

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
