-- 客服会话模块：会话表 + 消息表
-- 作用：1) 支持用户与商家双向多轮对话（旧 merchant_message 仅单轮，只读保留）
--       2) 会话表冗余 last_message/last_msg_time/双向未读，列表页免 JOIN 一次查完
--       3) chat_message.id 自增即游标，历史消息用 (conversation_id, id) 倒序游标分页
CREATE TABLE IF NOT EXISTS `chat_conversation` (
    `id`               BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id`          BIGINT       NOT NULL COMMENT '买家用户ID',
    `merchant_id`      BIGINT       NOT NULL COMMENT '商家用户ID',
    `product_id`       BIGINT       DEFAULT NULL COMMENT '关联商品ID（从商品页发起时携带，可为空=纯咨询）',
    `last_message`     VARCHAR(255) DEFAULT NULL COMMENT '最后一条消息摘要（列表预览）',
    `last_sender`      TINYINT      DEFAULT NULL COMMENT '最后一条发送方 1用户 2商家',
    `last_msg_time`    DATETIME     DEFAULT NULL COMMENT '最后消息时间（会话列表排序键）',
    `user_unread`      INT          NOT NULL DEFAULT 0 COMMENT '用户未读数（商家发的未读）',
    `merchant_unread`  INT          NOT NULL DEFAULT 0 COMMENT '商家未读数（用户发的未读）',
    `create_time`      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_merchant` (`user_id`, `merchant_id`),
    KEY `idx_merchant_time` (`merchant_id`, `last_msg_time`),
    KEY `idx_user_time` (`user_id`, `last_msg_time`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '客服会话表';

CREATE TABLE IF NOT EXISTS `chat_message` (
    `id`               BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键（同时作游标分页游标）',
    `conversation_id`  BIGINT       NOT NULL COMMENT '所属会话ID',
    `sender_id`        BIGINT       NOT NULL COMMENT '发送者ID',
    `sender_type`      TINYINT      NOT NULL COMMENT '1用户 2商家',
    `content`          VARCHAR(500) NOT NULL COMMENT '消息内容（纯文本）',
    `is_read`          TINYINT      NOT NULL DEFAULT 0 COMMENT '0未读 1已读',
    `create_time`      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_conv_id` (`conversation_id`, `id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '客服聊天消息表';