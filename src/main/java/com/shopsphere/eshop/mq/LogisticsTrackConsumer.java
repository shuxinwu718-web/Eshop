package com.shopsphere.eshop.mq;

import com.rabbitmq.client.Channel;
import com.shopsphere.eshop.service.ShipmentTrackService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.amqp.support.AmqpHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;

import static com.shopsphere.eshop.config.RabbitMQConfig.LOGISTICS_TRACK_QUEUE;

/**
 * 模拟物流轨迹推进消费者
 *
 * 监听延迟交换机投递的轨迹推进消息，生成对应轨迹节点；
 * 处理失败的场景（如 DB 临时故障）basicNack 重新入队重试；
 * 重复消息由消费侧状态校验 + shipment_track 唯一键天然幂等。
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class LogisticsTrackConsumer {

    private final ShipmentTrackService shipmentTrackService;

    @RabbitListener(queues = LOGISTICS_TRACK_QUEUE, ackMode = "MANUAL")
    public void handleLogisticsTrack(LogisticsTrackMessage msg, Channel channel,
                                     @Header(AmqpHeaders.DELIVERY_TAG) long deliveryTag) {
        try {
            shipmentTrackService.createTrack(msg.getShipmentId(), msg.getNextStatus());
            channel.basicAck(deliveryTag, false);
        } catch (Exception e) {
            log.error("模拟物流轨迹推进失败，shipmentId: {}, nextStatus: {}",
                    msg.getShipmentId(), msg.getNextStatus(), e);
            try {
                // 失败重新入队重试（重复消费由幂等逻辑兜底）
                channel.basicNack(deliveryTag, false, true);
            } catch (Exception ex) {
                log.error("物流轨迹消息重新入队失败", ex);
            }
        }
    }
}
