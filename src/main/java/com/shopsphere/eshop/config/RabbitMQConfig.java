package com.shopsphere.eshop.config;

import org.springframework.amqp.core.*;
import org.springframework.amqp.rabbit.config.SimpleRabbitListenerContainerFactory;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.HashMap;
import java.util.Map;

@Configuration
public class RabbitMQConfig {

    // ===== 邮件相关常量 =====
    public static final String EMAIL_EXCHANGE = "email.exchange";
    public static final String EMAIL_QUEUE = "email.queue";
    public static final String EMAIL_ROUTING_KEY = "email.send";

    // ===== 订单相关常量（新增） =====
    public static final String ORDER_EXCHANGE = "order.exchange";
    public static final String STOCK_QUEUE = "stock.queue";
    public static final String ORDER_PAY_ROUTING_KEY = "order.pay";

    // ===== 🆕 延迟消息相关（订单超时取消） =====
    public static final String DELAYED_EXCHANGE = "order.delayed.exchange";
    public static final String ORDER_TIMEOUT_QUEUE = "order.timeout.queue";
    public static final String ORDER_TIMEOUT_ROUTING_KEY = "order.timeout";


    // ===== 订单通知相关常量 =====
    public static final String ORDER_NOTIFY_EXCHANGE = "order.notify.exchange";
    public static final String ORDER_NOTIFY_QUEUE = "order.notify.queue";
    public static final String ORDER_NOTIFY_ROUTING_KEY = "order.notify";


    // ===== 订单支付通知相关常量 =====
    public static final String ORDER_PAID_EXCHANGE = "order.paid.exchange";
    public static final String ORDER_PAID_QUEUE = "order.paid.queue";
    public static final String ORDER_PAID_ROUTING_KEY = "order.paid";

    // ===== 日志相关常量 =====
    public static final String LOG_EXCHANGE = "log.exchange";
    public static final String LOG_QUEUE = "log.queue";
    public static final String LOG_ROUTING_KEY = "log.visit";

    // ===== 邮件相关 Bean =====
    @Bean
    public DirectExchange emailExchange() {
        return new DirectExchange(EMAIL_EXCHANGE, true, false);
    }

    @Bean
    public Queue emailQueue() {
        return new Queue(EMAIL_QUEUE, true);
    }

    @Bean
    public Binding emailBinding(Queue emailQueue, DirectExchange emailExchange) {
        return BindingBuilder.bind(emailQueue).to(emailExchange).with(EMAIL_ROUTING_KEY);
    }

    // ===== 订单相关 Bean（新增） =====
    @Bean
    public DirectExchange orderExchange() {
        return new DirectExchange(ORDER_EXCHANGE, true, false);
    }

    @Bean
    public Queue stockQueue() {
        return new Queue(STOCK_QUEUE, true);
    }

    @Bean
    public Binding stockBinding(Queue stockQueue, DirectExchange orderExchange) {
        return BindingBuilder.bind(stockQueue).to(orderExchange).with(ORDER_PAY_ROUTING_KEY);
    }

    // ===== 🆕 延迟消息 Bean（订单超时取消） =====
    @Bean
    public CustomExchange delayedExchange() {
        Map<String, Object> args = new HashMap<>();
        args.put("x-delayed-type", "direct");  // 交换机类型：direct
        return new CustomExchange(DELAYED_EXCHANGE, "x-delayed-message", true, false, args);
    }

    @Bean
    public Queue orderTimeoutQueue() {
        return new Queue(ORDER_TIMEOUT_QUEUE, true);
    }

    @Bean
    public Binding orderTimeoutBinding(Queue orderTimeoutQueue, CustomExchange delayedExchange) {
        return BindingBuilder.bind(orderTimeoutQueue).to(delayedExchange).with(ORDER_TIMEOUT_ROUTING_KEY).noargs();
    }

    // ===== 订单通知相关 Bean =====
    @Bean
    public DirectExchange orderNotifyExchange() {
        return new DirectExchange(ORDER_NOTIFY_EXCHANGE, true, false);
    }

    @Bean
    public Queue orderNotifyQueue() {
        return new Queue(ORDER_NOTIFY_QUEUE, true);
    }

    @Bean
    public Binding orderNotifyBinding(Queue orderNotifyQueue, DirectExchange orderNotifyExchange) {
        return BindingBuilder.bind(orderNotifyQueue).to(orderNotifyExchange).with(ORDER_NOTIFY_ROUTING_KEY);
    }

    // ===== 订单支付通知相关 Bean =====
    @Bean
    public DirectExchange orderPaidExchange() {
        return new DirectExchange(ORDER_PAID_EXCHANGE, true, false);
    }

    @Bean
    public Queue orderPaidQueue() {
        return new Queue(ORDER_PAID_QUEUE, true);
    }

    @Bean
    public Binding orderPaidBinding(Queue orderPaidQueue, DirectExchange orderPaidExchange) {
        return BindingBuilder.bind(orderPaidQueue).to(orderPaidExchange).with(ORDER_PAID_ROUTING_KEY);
    }


    // ===== 日志相关 Bean =====
    @Bean
    public DirectExchange logExchange() {
        return new DirectExchange(LOG_EXCHANGE, true, false);
    }

    @Bean
    public Queue logQueue() {
        return new Queue(LOG_QUEUE, true);
    }

    @Bean
    public Binding logBinding(Queue logQueue, DirectExchange logExchange) {
        return BindingBuilder.bind(logQueue).to(logExchange).with(LOG_ROUTING_KEY);
    }

    // ===== 通用配置 =====
    @Bean
    public MessageConverter messageConverter() {
        return new Jackson2JsonMessageConverter();
    }

    @Bean
    public RabbitTemplate rabbitTemplate(ConnectionFactory connectionFactory,
                                         MessageConverter messageConverter) {
        RabbitTemplate rabbitTemplate = new RabbitTemplate(connectionFactory);
        rabbitTemplate.setMessageConverter(messageConverter);
        return rabbitTemplate;
    }

    @Bean
    public SimpleRabbitListenerContainerFactory rabbitListenerContainerFactory(
            ConnectionFactory connectionFactory,
            MessageConverter messageConverter) {
        SimpleRabbitListenerContainerFactory factory = new SimpleRabbitListenerContainerFactory();
        factory.setConnectionFactory(connectionFactory);
        factory.setMessageConverter(messageConverter);
        factory.setAcknowledgeMode(AcknowledgeMode.MANUAL);
        return factory;
    }
}