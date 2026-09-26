-- 支付流水表：对接支付宝沙箱/正式支付
-- 作用：1) out_trade_no 唯一约束保证幂等（回调重复通知不重复入账）
--       2) 记录支付宝交易号 trade_no，供查单对账 / 退款使用
--       3) 订单已超时取消但用户实际支付成功（竞态）时，凭此表人工/自动补偿
CREATE TABLE IF NOT EXISTS `payment_transaction` (
    `id`              BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `out_trade_no`    VARCHAR(64)  NOT NULL COMMENT '商户订单号（order.orderNo）',
    `order_id`        BIGINT       NOT NULL COMMENT '订单ID',
    `user_id`         BIGINT       NOT NULL COMMENT '支付用户ID',
    `amount`          DECIMAL(10, 2) NOT NULL COMMENT '订单实付金额',
    `trade_no`        VARCHAR(64)  DEFAULT NULL COMMENT '支付宝交易号（回调/查单获得）',
    `buyer_logon_id`  VARCHAR(64)  DEFAULT NULL COMMENT '买家支付宝账号（脱敏）',
    `status`          TINYINT      NOT NULL DEFAULT 0 COMMENT '0待支付 1支付成功 2已关闭 3需退款(支付时订单已取消)',
    `notify_time`     DATETIME     DEFAULT NULL COMMENT '支付宝最后一次通知时间',
    `create_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_out_trade_no` (`out_trade_no`),
    KEY `idx_order_id` (`order_id`),
    KEY `idx_status_create` (`status`, `create_time`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '支付流水表（支付宝）';
