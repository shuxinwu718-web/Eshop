package com.shopsphere.eshop.service;

import com.shopsphere.eshop.entity.OrderShipment;
import com.shopsphere.eshop.vo.ShipmentTrackVO;

import java.util.List;

/**
 * 模拟物流轨迹服务
 */
public interface ShipmentTrackService {

    /**
     * 发货时初始化首条轨迹（已揽收），并投递下一条延迟消息。
     * 由商家发货逻辑在事务内调用。
     */
    void initFirstTrack(OrderShipment shipment);

    /**
     * 消费延迟消息时生成指定轨迹节点；status&lt;4 续发下一条延迟消息，status=4 触发自动确认收货。
     * 幂等：唯一键 + 前置状态校验。
     */
    void createTrack(Long shipmentId, Integer nextStatus);

    /**
     * 用户查询单个发货单的物流轨迹（校验订单归属）
     */
    ShipmentTrackVO getShipmentTrack(Long shipmentId, Long userId);

    /**
     * 用户查询某订单下所有发货单的轨迹组（校验订单归属）
     */
    List<ShipmentTrackVO> getOrderTracks(Long orderId, Long userId);

    /**
     * 启动兜底：扫描已发货但轨迹缺失（或未推完）的发货单，按发货时间推算补投延迟消息。
     * 防止延迟消息全部丢失导致轨迹/自动收货停滞。
     */
    void recoverMissingTracks();
}
