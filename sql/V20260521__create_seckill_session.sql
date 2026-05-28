-- 秒杀场次表
CREATE TABLE IF NOT EXISTS `seckill_session` (
    `id`            BIGINT       NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    `coupon_id`     BIGINT       NOT NULL COMMENT '关联优惠券ID',
    `session_name`  VARCHAR(100) NOT NULL COMMENT '秒杀场次名称',
    `start_time`    DATETIME     NOT NULL COMMENT '开始时间',
    `end_time`      DATETIME     NOT NULL COMMENT '结束时间',
    `seckill_stock` INT          NOT NULL DEFAULT 0 COMMENT '秒杀独立库存',
    `limit_per_user` INT         NOT NULL DEFAULT 1 COMMENT '每人限领',
    `status`        TINYINT      NOT NULL DEFAULT 0 COMMENT '状态: 0-待开始 1-进行中 2-已结束 3-已撤销',
    `create_time`   DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`   DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`       TINYINT      DEFAULT 0 COMMENT '逻辑删除',
    INDEX `idx_coupon_id` (`coupon_id`),
    INDEX `idx_status` (`status`),
    INDEX `idx_start_time` (`start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='秒杀场次表';
