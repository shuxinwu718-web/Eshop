package com.shopsphere.eshop.mq;

import com.rabbitmq.client.Channel;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.amqp.support.AmqpHeaders;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;

import static com.shopsphere.eshop.config.RabbitMQConfig.EMAIL_QUEUE;

@Component
@RequiredArgsConstructor
@Slf4j
public class EmailConsumer {

    private final JavaMailSender javaMailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    @RabbitListener(queues = EMAIL_QUEUE, ackMode = "MANUAL")  // 👈 改成手动确认
    public void handleEmailSend(EmailMessage msg,
                                Channel channel,                                    // 👈 新增
                                @Header(AmqpHeaders.DELIVERY_TAG) long deliveryTag  // 👈 新增
    ) {
        log.info("收到邮件发送任务: {}", msg.getEmail());
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(msg.getEmail());
            message.setSubject(msg.getSubject());
            message.setText(msg.getText());
            javaMailSender.send(message);

            log.info("邮件发送成功: {}", msg.getEmail());

            // ✅ 关键：手动确认，告诉 RabbitMQ 这条消息已处理完成
            channel.basicAck(deliveryTag, false);

        } catch (Exception e) {
            log.error("邮件发送失败，邮箱: {}, 错误: {}", msg.getEmail(), e.getMessage(), e);
            try {
                // 失败时：拒绝消息并重新入队
                channel.basicNack(deliveryTag, false, true);
            } catch (Exception ex) {
                log.error("消息重新入队失败", ex);
            }
        }
    }
}