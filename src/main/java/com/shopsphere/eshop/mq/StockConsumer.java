package com.shopsphere.eshop.mq;

import com.rabbitmq.client.Channel;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.entity.ProductSku;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.mapper.ProductSkuMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.amqp.support.AmqpHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import static com.shopsphere.eshop.config.RabbitMQConfig.STOCK_QUEUE;

@Component
@RequiredArgsConstructor
@Slf4j
public class StockConsumer {

    private final ProductMapper productMapper;
    private final ProductSkuMapper productSkuMapper;

    @RabbitListener(queues = STOCK_QUEUE, ackMode = "MANUAL")
    @Transactional
    public void handlePaySuccess(PaySuccessMessage msg, Channel channel,
                                 @Header(AmqpHeaders.DELIVERY_TAG) long deliveryTag) {
        try {
            log.info("收到扣库存任务，订单ID: {}, 商品ID: {}, SKU: {}, 数量: {}",
                    msg.getOrderId(), msg.getProductId(), msg.getSkuId(), msg.getQuantity());

            boolean success = false;

            if (msg.getSkuId() != null) {
                // SKU 扣库存
                int affected = productSkuMapper.deductStock(msg.getSkuId(), msg.getQuantity());
                if (affected > 0) {
                    success = true;
                    log.info("SKU库存扣减成功，SKU ID: {}", msg.getSkuId());
                } else {
                    log.warn("SKU库存不足，SKU ID: {}", msg.getSkuId());
                }
            } else {
                // 普通商品扣库存
                int affected = productMapper.deductStock(msg.getProductId(), msg.getQuantity());
                if (affected > 0) {
                    success = true;
                    log.info("商品库存扣减成功，商品ID: {}", msg.getProductId());
                } else {
                    log.warn("商品库存不足，商品ID: {}", msg.getProductId());
                }
            }

            if (!success) {
                // 库存不足，不重试，记录告警，人工介入
                channel.basicNack(deliveryTag, false, false);
                log.error("库存扣减失败（库存不足），订单ID: {}, 商品ID: {}", msg.getOrderId(), msg.getProductId());
                return;
            }

            // 清除 Redis 缓存
            // 这里可以调用 redisTemplate.delete("product:detail:" + msg.getProductId());

            channel.basicAck(deliveryTag, false);
            log.info("扣库存任务完成，订单ID: {}", msg.getOrderId());

        } catch (Exception e) {
            log.error("扣库存异常，订单ID: {}", msg.getOrderId(), e);
            try {
                channel.basicNack(deliveryTag, false, true);
            } catch (Exception ex) {
                log.error("消息重新入队失败", ex);
            }
        }
    }
}