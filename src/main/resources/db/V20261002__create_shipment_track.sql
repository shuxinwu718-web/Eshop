-- ============================================================
-- V20261002: 模拟物流轨迹表
-- 说明：商家发货后自动生成模拟轨迹（已揽收→运输中→派送中→已签收），
--       并支持发货后自动确认收货（订单状态机 2→3）。
-- 执行方式：本地 MySQL 直接执行，或 docker exec 导入，见 README。
-- ============================================================

CREATE TABLE IF NOT EXISTS `shipment_track` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `shipment_id` BIGINT NOT NULL COMMENT '发货单ID（order_shipment.id）',
  `order_id` BIGINT NOT NULL COMMENT '冗余订单ID，便于按订单查询',
  `track_status` TINYINT NOT NULL COMMENT '轨迹状态：1已揽收 2运输中 3派送中 4已签收',
  `title` VARCHAR(100) NOT NULL COMMENT '节点标题，如「包裹已揽收」',
  `description` VARCHAR(255) DEFAULT NULL COMMENT '节点详情，如运输中转描述',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '轨迹时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_shipment_status` (`shipment_id`, `track_status`),
  KEY `idx_order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='物流轨迹表（模拟）';
