-- 商家小店设计配置表
CREATE TABLE IF NOT EXISTS `store_design` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `merchant_id` BIGINT NOT NULL COMMENT '商家ID',
    `background_color` VARCHAR(20) NOT NULL DEFAULT '#667eea' COMMENT '店铺头背景色',
    `banner_url` VARCHAR(500) DEFAULT NULL COMMENT '店铺头像URL',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `uk_merchant_id` (`merchant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家小店设计配置';
