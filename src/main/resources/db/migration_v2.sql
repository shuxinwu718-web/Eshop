-- ============================================================
-- 订单模块重构：引入 order_shipment（发货单）表
-- ============================================================

-- 1. 创建发货单表
CREATE TABLE `order_shipment` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL COMMENT '关联订单ID',
  `seller_id` bigint NOT NULL COMMENT '商家ID',
  `delivery_status` tinyint NOT NULL DEFAULT '0' COMMENT '发货状态 0-待发货 1-已发货 2-已收货',
  `shipping_name` varchar(50) DEFAULT NULL COMMENT '快递公司',
  `shipping_no` varchar(50) DEFAULT NULL COMMENT '快递单号',
  `shipping_time` datetime DEFAULT NULL COMMENT '发货时间',
  `received_time` datetime DEFAULT NULL COMMENT '收货时间',
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '本单商品总额',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order` (`order_id`),
  KEY `idx_seller` (`seller_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='发货单（按商家拆分的履约单元）';

-- 2. 从现有 order_item 迁移数据到 order_shipment
-- 按 (order_id, seller_id) 分组，每个分组创建一个发货单
INSERT INTO `order_shipment` (`order_id`, `seller_id`, `delivery_status`, `shipping_name`, `shipping_no`, `shipping_time`, `total_amount`)
SELECT
    oi.`order_id`,
    oi.`seller_id`,
    -- 如果所有 item 都已填写 shippingNo 则视为已发货
    CASE WHEN MAX(IF(oi.`shippingNo` IS NOT NULL AND oi.`shippingNo` != '', 1, 0)) = 1 THEN 1 ELSE 0 END AS delivery_status,
    MAX(oi.`shippingName`) AS shipping_name,
    MAX(oi.`shippingNo`) AS shipping_no,
    -- 用主订单的发货时间作为参考
    MAX(o.`delivery_time`) AS shipping_time,
    SUM(oi.`price` * oi.`quantity`) AS total_amount
FROM `order_item` oi
JOIN `order` o ON oi.`order_id` = o.`id`
GROUP BY oi.`order_id`, oi.`seller_id`;

-- 3. 给 order_item 新增 shipment_id 列
ALTER TABLE `order_item`
  ADD COLUMN `shipment_id` bigint DEFAULT NULL COMMENT '所属发货单ID' AFTER `order_id`,
  ADD INDEX `idx_shipment` (`shipment_id`);

-- 4. 回填 order_item.shipment_id
UPDATE `order_item` oi
JOIN `order_shipment` os ON oi.`order_id` = os.`order_id` AND oi.`seller_id` = os.`seller_id`
SET oi.`shipment_id` = os.`id`;

-- 5. 设置 shipment_id 为非空（数据迁移完成后）
ALTER TABLE `order_item`
  MODIFY COLUMN `shipment_id` bigint NOT NULL;

-- 6. 从 order_item 删除迁移走的字段
ALTER TABLE `order_item`
  DROP COLUMN `seller_id`,
  DROP COLUMN `shippingName`,
  DROP COLUMN `shippingNo`;

-- 7. 从 order 表删除不再需要的字段
-- delivery_status 由 order_shipment 承担
-- delivery_time 和 shipping_time 合并为 order_shipment.shipping_time
ALTER TABLE `order`
  DROP COLUMN `delivery_status`,
  DROP COLUMN `delivery_time`,
  DROP COLUMN `shipping_time`;

-- 8. 同步更新 order 表的 order_status 语义统一
-- 0-待支付 1-已支付/待发货 2-已完成 3-已关闭 4-已取消
--（仅调整注释，不改列）
