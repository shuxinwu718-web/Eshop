package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shopsphere.eshop.config.RabbitMQConfig;
import com.shopsphere.eshop.constant.TrackStatus;
import com.shopsphere.eshop.entity.Order;
import com.shopsphere.eshop.entity.OrderShipment;
import com.shopsphere.eshop.entity.ShipmentTrack;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.OrderMapper;
import com.shopsphere.eshop.mapper.OrderShipmentMapper;
import com.shopsphere.eshop.mapper.ShipmentTrackMapper;
import com.shopsphere.eshop.mq.LogisticsTrackMessage;
import com.shopsphere.eshop.service.ShipmentTrackService;
import com.shopsphere.eshop.vo.ShipmentTrackVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.core.MessageProperties;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 模拟物流轨迹实现：
 * 发货时生成首条轨迹（已揽收），通过 RabbitMQ 延迟消息逐级推进
 * 已揽收→运输中→派送中→已签收，最后自动确认收货（订单 2→3）。
 *
 * 幂等：shipment_track(shipment_id, track_status) 唯一键 + 消费侧状态校验。
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ShipmentTrackServiceImpl implements ShipmentTrackService {

    private final ShipmentTrackMapper shipmentTrackMapper;
    private final OrderShipmentMapper orderShipmentMapper;
    private final OrderMapper orderMapper;
    private final ApplicationEventPublisher eventPublisher;
    private final RabbitTemplate rabbitTemplate;
    private final ObjectMapper objectMapper;

    // ===== 模拟物流配置（application.yml simulation.logistics） =====
    @Value("${simulation.logistics.enable:true}")
    private boolean simulationEnabled;

    /** 已揽收 → 运输中 延迟（分钟） */
    @Value("${simulation.logistics.pickup-minutes:1}")
    private long pickupMinutes;

    /** 运输中 → 派送中 延迟（分钟） */
    @Value("${simulation.logistics.transit-minutes:1}")
    private long transitMinutes;

    /** 派送中 → 已签收 延迟（分钟） */
    @Value("${simulation.logistics.delivering-minutes:1}")
    private long deliveringMinutes;

    /** 兜底补投时使用的短延迟（毫秒） */
    private static final long RECOVER_DELAY_MS = 5000L;

    // ============================================================
    // 轨迹推进
    // ============================================================

    @Override
    @Transactional
    public void initFirstTrack(OrderShipment shipment) {
        if (!simulationEnabled || shipment == null || shipment.getId() == null) {
            return;
        }
        // 首条轨迹：包裹已揽收（幂等：唯一键 + 已存在则跳过）
        if (hasTrack(shipment.getId(), TrackStatus.PICKED_UP)) {
            return;
        }
        insertTrack(shipment.getId(), shipment.getOrderId(), TrackStatus.PICKED_UP,
                "包裹已揽收", "商家已发货，" + shipment.getShippingName() + " 已揽收包裹");

        // 投递下一条：运输中
        sendDelayMessage(shipment.getId(), TrackStatus.IN_TRANSIT, minutesToMillis(pickupMinutes));
        log.info("模拟物流已揽收并投递运输中任务，shipmentId: {}", shipment.getId());
    }

    @Override
    @Transactional
    public void createTrack(Long shipmentId, Integer nextStatus) {
        if (!simulationEnabled) {
            return;
        }
        OrderShipment shipment = orderShipmentMapper.selectById(shipmentId);
        if (shipment == null || shipment.getDeliveryStatus() == null || shipment.getDeliveryStatus() != 1) {
            // 发货单不存在 / 未发货 / 已签收：直接忽略（重复消息或状态已前进）
            log.debug("忽略物流推进，shipmentId: {}, nextStatus: {}", shipmentId, nextStatus);
            return;
        }
        Order order = orderMapper.selectById(shipment.getOrderId());
        if (order == null || order.getOrderStatus() == null || order.getOrderStatus() != 2) {
            // 订单未处于已发货状态（如已取消/已退款/已完成）：不推进
            log.debug("忽略物流推进（订单状态不符），shipmentId: {}, orderStatus: {}",
                    shipmentId, order == null ? null : order.getOrderStatus());
            return;
        }
        // 幂等：该状态轨迹已存在则跳过
        if (hasTrack(shipmentId, nextStatus)) {
            log.debug("轨迹已存在，跳过推进，shipmentId: {}, status: {}", shipmentId, nextStatus);
            return;
        }

        // 生成轨迹节点
        insertTrack(shipmentId, shipment.getOrderId(), nextStatus,
                titleOf(nextStatus), descOf(nextStatus));

        if (nextStatus < TrackStatus.RECEIVED) {
            // 续发下一条延迟消息
            long delay = minutesToMillis(delayForStatus(nextStatus));
            sendDelayMessage(shipmentId, nextStatus + 1, delay);
            log.info("模拟物流推进至 {}，续投下一条（{}ms 后），shipmentId: {}",
                    titleOf(nextStatus), delay, shipmentId);
        } else {
            // 最后一个节点：发布事件触发自动确认收货（复用现有 CAS 签收 + 全签收→订单完成）
            log.info("模拟物流已签收，发布自动确认收货事件，shipmentId: {}", shipmentId);
            eventPublisher.publishEvent(new ShipmentReceivedEvent(shipmentId));
        }
    }

    // ============================================================
    // 查询
    // ============================================================

    @Override
    public ShipmentTrackVO getShipmentTrack(Long shipmentId, Long userId) {
        OrderShipment shipment = orderShipmentMapper.selectById(shipmentId);
        if (shipment == null) {
            throw new BusinessException("发货单不存在");
        }
        Order order = orderMapper.selectById(shipment.getOrderId());
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }
        return buildVO(shipment);
    }

    @Override
    public List<ShipmentTrackVO> getOrderTracks(Long orderId, Long userId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }
        List<OrderShipment> shipments = orderShipmentMapper.selectList(
                new LambdaQueryWrapper<OrderShipment>().eq(OrderShipment::getOrderId, orderId));
        List<ShipmentTrackVO> result = new ArrayList<>();
        for (OrderShipment shipment : shipments) {
            result.add(buildVO(shipment));
        }
        return result;
    }

    // ============================================================
    // 启动兜底：按发货时间推算缺失轨迹并补投延迟消息
    // ============================================================

    @Override
    public void recoverMissingTracks() {
        if (!simulationEnabled) {
            return;
        }
        // 已发货未签收（delivery_status=1）且已填写发货时间 的待推进发货单
        List<OrderShipment> pending = orderShipmentMapper.selectList(
                new LambdaQueryWrapper<OrderShipment>()
                        .eq(OrderShipment::getDeliveryStatus, 1)
                        .isNotNull(OrderShipment::getShippingTime));
        for (OrderShipment shipment : pending) {
            int expected = expectedStatus(shipment);
            // 只补投「下一个缺失」的节点（已生成的节点不动）
            int next = currentStatus(shipment.getId()) + 1;
            if (next <= expected && next <= TrackStatus.RECEIVED) {
                sendDelayMessage(shipment.getId(), next, RECOVER_DELAY_MS);
                log.info("兜底补投物流轨迹任务，shipmentId: {}, status: {}", shipment.getId(), next);
            }
        }
    }

    /** 按发货时间 + 各段延迟推算当前应推进到的最高轨迹状态 */
    private int expectedStatus(OrderShipment shipment) {
        LocalDateTime shipped = shipment.getShippingTime();
        long elapsed = ChronoUnit.MINUTES.between(shipped, LocalDateTime.now());
        long toTransit = pickupMinutes;
        long toDelivering = toTransit + transitMinutes;
        long toReceived = toDelivering + deliveringMinutes;
        if (elapsed >= toReceived) {
            return TrackStatus.RECEIVED;
        }
        if (elapsed >= toDelivering) {
            return TrackStatus.DELIVERING;
        }
        if (elapsed >= toTransit) {
            return TrackStatus.IN_TRANSIT;
        }
        return TrackStatus.PICKED_UP;
    }

    /** 当前已推进到的最高轨迹状态（无轨迹返回 0） */
    private int currentStatus(Long shipmentId) {
        List<Integer> statuses = shipmentTrackMapper.selectStatusesByShipmentId(shipmentId);
        if (statuses.isEmpty()) {
            return 0;
        }
        return statuses.stream().mapToInt(Integer::intValue).max().orElse(0);
    }

    // ============================================================
    // 内部工具
    // ============================================================

    private boolean hasTrack(Long shipmentId, int status) {
        return shipmentTrackMapper.selectStatusesByShipmentId(shipmentId).contains(status);
    }

    private void insertTrack(Long shipmentId, Long orderId, int status, String title, String description) {
        ShipmentTrack track = new ShipmentTrack();
        track.setShipmentId(shipmentId);
        track.setOrderId(orderId);
        track.setTrackStatus(status);
        track.setTitle(title);
        track.setDescription(description);
        shipmentTrackMapper.insert(track);
    }

    /** 投递延迟消息到现有 order.delayed.exchange（x-delayed-message 交换机） */
    private void sendDelayMessage(Long shipmentId, int nextStatus, long delayMillis) {
        try {
            LogisticsTrackMessage msg = new LogisticsTrackMessage(shipmentId, nextStatus);
            byte[] body = objectMapper.writeValueAsBytes(msg);
            MessageProperties properties = new MessageProperties();
            properties.setDelay((int) delayMillis);
            properties.setContentType(MessageProperties.CONTENT_TYPE_JSON);
            rabbitTemplate.send(RabbitMQConfig.DELAYED_EXCHANGE,
                    RabbitMQConfig.LOGISTICS_TRACK_ROUTING_KEY, new Message(body, properties));
        } catch (Exception e) {
            // 发送失败不影响主流程，兜底启动时会补投
            log.error("物流轨迹延迟消息发送失败，shipmentId: {}, nextStatus: {}", shipmentId, nextStatus, e);
        }
    }

    private ShipmentTrackVO buildVO(OrderShipment shipment) {
        ShipmentTrackVO vo = new ShipmentTrackVO();
        vo.setShipmentId(shipment.getId());
        vo.setOrderId(shipment.getOrderId());
        vo.setShippingName(shipment.getShippingName());
        vo.setShippingNo(shipment.getShippingNo());
        vo.setDeliveryStatus(shipment.getDeliveryStatus());

        List<ShipmentTrack> tracks = shipmentTrackMapper.selectByShipmentId(shipment.getId());
        List<ShipmentTrackVO.TrackItemVO> items = tracks.stream().map(t -> {
            ShipmentTrackVO.TrackItemVO item = new ShipmentTrackVO.TrackItemVO();
            item.setStatus(t.getTrackStatus());
            item.setTitle(t.getTitle());
            item.setDescription(t.getDescription());
            item.setTime(t.getCreateTime());
            return item;
        }).collect(Collectors.toList());
        vo.setTracks(items);
        vo.setLatestTrackStatus(items.isEmpty() ? null : items.get(items.size() - 1).getStatus());
        return vo;
    }

    private String titleOf(int status) {
        return switch (status) {
            case TrackStatus.PICKED_UP -> "包裹已揽收";
            case TrackStatus.IN_TRANSIT -> "运输中";
            case TrackStatus.DELIVERING -> "派送中";
            case TrackStatus.RECEIVED -> "包裹已签收";
            default -> "物流更新";
        };
    }

    private String descOf(int status) {
        return switch (status) {
            case TrackStatus.PICKED_UP -> "商家已发货，快递员已揽收包裹";
            case TrackStatus.IN_TRANSIT -> "包裹已从出发地发往目的地中转中心";
            case TrackStatus.DELIVERING -> "包裹已到达目的地，快递员正在为您派送";
            case TrackStatus.RECEIVED -> "包裹已被签收，感谢您的购买";
            default -> "";
        };
    }

    private long delayForStatus(int status) {
        return switch (status) {
            case TrackStatus.PICKED_UP -> pickupMinutes;
            case TrackStatus.IN_TRANSIT -> transitMinutes;
            case TrackStatus.DELIVERING -> deliveringMinutes;
            default -> 1;
        };
    }

    private long minutesToMillis(long minutes) {
        return minutes * 60 * 1000L;
    }

    /**
     * 已签收事件：由 OrderServiceImpl 监听并执行自动确认收货，
     * 解耦轨迹推进与订单状态机，避免 ShipmentTrackService ↔ OrderService 循环依赖。
     */
    public static class ShipmentReceivedEvent {
        private final Long shipmentId;

        public ShipmentReceivedEvent(Long shipmentId) {
            this.shipmentId = shipmentId;
        }

        public Long getShipmentId() {
            return shipmentId;
        }
    }
}
