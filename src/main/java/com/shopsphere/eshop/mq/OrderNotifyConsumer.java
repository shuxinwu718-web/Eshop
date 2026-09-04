package com.shopsphere.eshop.mq;

import com.rabbitmq.client.Channel;
import com.shopsphere.eshop.service.NoticeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.amqp.support.AmqpHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;

import static com.shopsphere.eshop.config.RabbitMQConfig.ORDER_NOTIFY_QUEUE;

@Component
@RequiredArgsConstructor
@Slf4j
public class OrderNotifyConsumer {

    private final NoticeService noticeService;

    @RabbitListener(queues = ORDER_NOTIFY_QUEUE, ackMode = "MANUAL")
    public void handleOrderCreated(OrderCreatedMessage msg, Channel channel,
                                   @Header(AmqpHeaders.DELIVERY_TAG) long deliveryTag) {
        try {
            log.info("收到订单通知任务，订单号: {}, 商家数: {}",
                    msg.getOrderNo(), msg.getMerchantIds().size());

            // 1. 通知所有商家
            for (Long merchantId : msg.getMerchantIds()) {
                noticeService.createAndPublish(
                        "新订单通知",
                        "您有新的订单，订单号：" + msg.getOrderNo(),
                        3,
                        merchantId,
                        "new_order",
                        msg.getOrderId()
                );
            }

            // 2. 通知用户
            noticeService.createAndPublish(
                    "订单创建成功",
                    "您的订单 " + msg.getOrderNo() + " 已创建成功，请尽快支付",
                    3,
                    msg.getUserId(),
                    "order_created",
                    msg.getOrderId()
            );

            log.info("订单通知完成，订单号: {}", msg.getOrderNo());
            channel.basicAck(deliveryTag, false);

        } catch (Exception e) {
            log.error("订单通知失败，订单号: {}", msg.getOrderNo(), e);
            try {
                channel.basicNack(deliveryTag, false, true);
            } catch (Exception ex) {
                log.error("消息重新入队失败", ex);
            }
        }
    }
}