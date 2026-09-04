package com.shopsphere.eshop.mq;

import com.rabbitmq.client.Channel;
import com.shopsphere.eshop.service.NoticeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.amqp.support.AmqpHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;

import static com.shopsphere.eshop.config.RabbitMQConfig.ORDER_PAID_QUEUE;

@Component
@RequiredArgsConstructor
@Slf4j
public class OrderPaidConsumer {

    private final NoticeService noticeService;

    @RabbitListener(queues = ORDER_PAID_QUEUE, ackMode = "MANUAL")
    public void handleOrderPaid(OrderPaidMessage msg, Channel channel,
                                @Header(AmqpHeaders.DELIVERY_TAG) long deliveryTag) {
        try {
            log.info("收到支付通知任务，订单号: {}, 商家数: {}",
                    msg.getOrderNo(), msg.getMerchantIds().size());

            // 1. 通知所有商家
            for (Long merchantId : msg.getMerchantIds()) {
                noticeService.createAndPublish(
                        "订单付款通知",
                        "订单 " + msg.getOrderNo() + " 已付款，请尽快发货",
                        3,
                        merchantId,
                        "order_paid",
                        msg.getOrderId()
                );
            }

            // 2. 通知用户
            noticeService.createAndPublish(
                    "订单支付成功",
                    "您的订单 " + msg.getOrderNo() + " 已支付成功，请等待发货",
                    3,
                    msg.getUserId(),
                    "order_paid",
                    msg.getOrderId()
            );

            log.info("支付通知完成，订单号: {}", msg.getOrderNo());
            channel.basicAck(deliveryTag, false);

        } catch (Exception e) {
            log.error("支付通知失败，订单号: {}", msg.getOrderNo(), e);
            try {
                channel.basicNack(deliveryTag, false, true);
            } catch (Exception ex) {
                log.error("消息重新入队失败", ex);
            }
        }
    }
}