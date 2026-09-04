package com.shopsphere.eshop.mq;

import com.rabbitmq.client.Channel;
import com.shopsphere.eshop.entity.VisitLog;
import com.shopsphere.eshop.mapper.VisitLogMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.amqp.support.AmqpHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;

import java.io.IOException;

import static com.shopsphere.eshop.config.RabbitMQConfig.LOG_QUEUE;

@Component
@RequiredArgsConstructor
@Slf4j
public class VisitLogConsumer {

    private final VisitLogMapper visitLogMapper;

    @RabbitListener(queues = LOG_QUEUE, ackMode = "MANUAL")
    public void handleVisitLog(VisitLogMessage msg, Channel channel,
                               @Header(AmqpHeaders.DELIVERY_TAG) long deliveryTag) throws IOException {
        try {
            VisitLog visitLog = new VisitLog();
            visitLog.setUserId(msg.getUserId());
            visitLog.setIp(msg.getIp());
            visitLog.setUserAgent(msg.getUserAgent());
            visitLog.setRequestUri(msg.getRequestUri());
            visitLog.setVisitTime(msg.getVisitTime());

            visitLogMapper.insert(visitLog);
            channel.basicAck(deliveryTag, false);
        } catch (Exception e) {
            log.error("访问日志写入失败", e);
            channel.basicNack(deliveryTag, false, false);
        }
    }
}