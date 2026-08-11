-- ============================================================
-- 拼团功能表结构（方案A：绑定单规格，参团同规格数量1）
-- 创建人：Eshop 2026-08-10
-- 说明：3 张表
--   1. group_buy_activity  拼团活动（商家创建，管理员查看/取消）
--   2. group_buy_group     拼团团（每个团一行，leader 开团）
--   3. group_buy_member    拼团成员（每个参团用户一行，含开团人）
-- ============================================================

CREATE TABLE IF NOT EXISTS `group_buy_activity` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `merchant_id` BIGINT NOT NULL COMMENT '商家ID',
  `product_id` BIGINT NOT NULL COMMENT '商品ID',
  `sku_id` BIGINT DEFAULT NULL COMMENT 'SKU ID（无规格商品为 NULL，绑定单规格拼团价）',
  `group_price` DECIMAL(10,2) NOT NULL COMMENT '拼团价',
  `target_count` INT NOT NULL DEFAULT 2 COMMENT '成团人数（2/3/5）',
  `duration_hours` INT NOT NULL DEFAULT 24 COMMENT '拼团有效期（小时，开团后该团成团截止时间）',
  `start_time` DATETIME NOT NULL COMMENT '活动开始时间',
  `end_time` DATETIME NOT NULL COMMENT '活动结束时间',
  `total_stock` INT NOT NULL DEFAULT 0 COMMENT '活动可成团次数（成团时原子扣减 1，不下单扣减）',
  `sold_count` INT NOT NULL DEFAULT 0 COMMENT '已成团份数',
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态：0草稿 1进行中 2已暂停 3已终止',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_product` (`product_id`),
  KEY `idx_merchant_status` (`merchant_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='拼团活动表';

CREATE TABLE IF NOT EXISTS `group_buy_group` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '团ID',
  `activity_id` BIGINT NOT NULL COMMENT '活动ID',
  `group_no` VARCHAR(32) NOT NULL COMMENT '团号',
  `leader_id` BIGINT NOT NULL COMMENT '开团用户ID',
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态：0拼团中 1已成团 2拼团失败已退款 3已取消',
  `expire_time` DATETIME NOT NULL COMMENT '成团截止时间',
  `success_time` DATETIME DEFAULT NULL COMMENT '成团时间',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_activity_status` (`activity_id`, `status`),
  KEY `idx_leader` (`leader_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='拼团团表';

CREATE TABLE IF NOT EXISTS `group_buy_member` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '成员ID',
  `group_id` BIGINT NOT NULL COMMENT '团ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `order_id` BIGINT NOT NULL COMMENT '订单ID',
  `role` TINYINT NOT NULL DEFAULT 0 COMMENT '角色：1开团 0参团',
  `pay_status` TINYINT NOT NULL DEFAULT 0 COMMENT '支付状态：0待支付 1已支付',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_group` (`group_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='拼团成员表';
