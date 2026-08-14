-- 商品介绍（富文本）功能：版本控制 + 审核
-- 执行前提：product.description 需扩容为 longtext（见下方 ALTER）

-- 1. 扩容商品描述列为 longtext（存储富文本 HTML）
ALTER TABLE `product` MODIFY COLUMN `description` LONGTEXT COMMENT '商品介绍（富文本 HTML，审核通过后写入）';

-- 2. 商品介绍版本表
CREATE TABLE IF NOT EXISTS `product_intro_version` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `version_no` int NOT NULL COMMENT '版本号（每次提交审核递增）',
  `content` longtext NOT NULL COMMENT '富文本 HTML 正文',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0-草稿 1-待审核 2-已通过 3-已驳回',
  `audit_remark` varchar(500) DEFAULT NULL COMMENT '驳回原因/审核意见',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_product_status` (`product_id`, `status`),
  KEY `idx_product_version` (`product_id`, `version_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品介绍版本';
