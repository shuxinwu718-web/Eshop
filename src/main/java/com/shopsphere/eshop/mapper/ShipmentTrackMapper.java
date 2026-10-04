package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.ShipmentTrack;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 物流轨迹 Mapper（模拟物流）
 */
@Mapper
public interface ShipmentTrackMapper extends BaseMapper<ShipmentTrack> {

    /** 按发货单查询轨迹（正序） */
    default List<ShipmentTrack> selectByShipmentId(Long shipmentId) {
        return selectList(new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<ShipmentTrack>()
                .eq(ShipmentTrack::getShipmentId, shipmentId)
                .orderByAsc(ShipmentTrack::getTrackStatus));
    }

    /** 按订单查询轨迹（正序） */
    default List<ShipmentTrack> selectByOrderId(Long orderId) {
        return selectList(new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<ShipmentTrack>()
                .eq(ShipmentTrack::getOrderId, orderId)
                .orderByAsc(ShipmentTrack::getTrackStatus));
    }

    /** 查询某发货单已生成的轨迹状态集合（幂等校验用） */
    default List<Integer> selectStatusesByShipmentId(Long shipmentId) {
        return selectList(new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<ShipmentTrack>()
                .eq(ShipmentTrack::getShipmentId, shipmentId)
                .select(ShipmentTrack::getTrackStatus))
                .stream().map(ShipmentTrack::getTrackStatus).collect(java.util.stream.Collectors.toList());
    }
}
