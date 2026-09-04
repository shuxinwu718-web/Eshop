package com.shopsphere.eshop.mq;

import com.rabbitmq.client.Channel;
import com.shopsphere.eshop.entity.Order;
import com.shopsphere.eshop.mapper.OrderMapper;
import com.shopsphere.eshop.service.OrderService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.amqp.support.AmqpHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;

import static com.shopsphere.eshop.config.RabbitMQConfig.ORDER_TIMEOUT_QUEUE;

@Component
@RequiredArgsConstructor
@Slf4j
public class OrderTimeoutConsumer {

    private final OrderMapper orderMapper;
    private final OrderService orderService;

    @RabbitListener(queues = ORDER_TIMEOUT_QUEUE, ackMode = "MANUAL")
    public void handleOrderTimeout(OrderTimeoutMessage msg, Channel channel,
                                   @Header(AmqpHeaders.DELIVERY_TAG) long deliveryTag) {
        try {
            Long orderId = msg.getOrderId();
            log.info("收到订单超时取消任务，订单ID: {}", orderId);

            // 1. 查询订单
            Order order = orderMapper.selectById(orderId);
            if (order == null) {
                log.warn("订单不存在，订单ID: {}", orderId);
                channel.basicAck(deliveryTag, false);
                return;
            }

            // 2. 只有待支付状态才需要取消
            if (order.getOrderStatus() != 0) {
                log.info("订单已支付或已取消，无需处理，订单ID: {}, 当前状态: {}", orderId, order.getOrderStatus());
                channel.basicAck(deliveryTag, false);
                return;
            }

            // 3. 执行取消（调用你已有的取消逻辑）
            orderService.cancelOrderInternal(order);

            log.info("订单超时自动取消成功，订单ID: {}, 订单号: {}", orderId, order.getOrderNo());
            channel.basicAck(deliveryTag, false);

        } catch (Exception e) {
            log.error("订单超时取消失败，订单ID: {}", msg.getOrderId(), e);
            try {
                // 失败时重新入队重试
                channel.basicNack(deliveryTag, false, true);
            } catch (Exception ex) {
                log.error("消息重新入队失败", ex);
            }
        }
    }
}