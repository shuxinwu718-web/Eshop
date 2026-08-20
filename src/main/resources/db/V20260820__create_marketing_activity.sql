-- ============================================================
-- V20260820 平台营销活动模块（通用任务制 + 优惠券奖励）
-- 1. marketing_activity：营销活动主表
-- 2. marketing_task：活动任务（签到/下单/收藏，达标发优惠券）
-- 3. user_activity_record：用户活动领取流水（营销奖励按任务防重）
-- ============================================================

CREATE TABLE IF NOT EXISTS `marketing_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `activity_name` varchar(100) NOT NULL COMMENT '活动名称',
  `activity_icon` varchar(50) DEFAULT NULL COMMENT '活动图标(emoji)',
  `description` varchar(500) DEFAULT NULL COMMENT '活动说明',
  `start_time` datetime DEFAULT NULL COMMENT '活动开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '活动结束时间',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '0停用 1启用',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序（越小越靠前）',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_time_range` (`start_time`,`end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='平台营销活动';

CREATE TABLE IF NOT EXISTS `marketing_task` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `activity_id` bigint NOT NULL COMMENT '所属活动ID',
  `task_type` varchar(30) NOT NULL COMMENT '任务类型: SIGNIN_DAYS-累计签到天数 ORDER_COUNT-已支付订单数 COLLECT_COUNT-收藏商品数',
  `task_name` varchar(100) DEFAULT NULL COMMENT '任务名称',
  `target_value` int NOT NULL DEFAULT '1' COMMENT '目标值（如签到5天/下单3笔/收藏2件）',
  `reward_coupon_id` bigint NOT NULL COMMENT '奖励优惠券ID',
  `reward_icon` varchar(50) DEFAULT NULL COMMENT '奖励展示图标(emoji)',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序（越小越靠前）',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_activity_id` (`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='营销活动任务';

-- 用户活动领取流水（若开发库已存在旧版表则跳过，兼容两种库状态）
CREATE TABLE IF NOT EXISTS `user_activity_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `activity_id` bigint NOT NULL,
  `coupon_id` bigint NOT NULL COMMENT '领取的优惠券ID（关联coupon表）',
  `task_id` bigint DEFAULT NULL COMMENT '营销任务ID（营销活动奖励防重）',
  `source` varchar(50) DEFAULT 'ACTIVITY' COMMENT '来源：ACTIVITY-活动领取，SIGNIN-签到，LOTTERY-抽奖，MARKETING-营销活动',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_activity` (`user_id`,`activity_id`),
  KEY `idx_user_task` (`user_id`,`activity_id`,`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户活动领取记录';

-- 兼容已存在旧版 user_activity_record（无 task_id 列）的库：用存储过程做条件 DDL（MySQL 8.0 不支持 ADD COLUMN IF NOT EXISTS）
DROP PROCEDURE IF EXISTS `upgrade_user_activity_record`;
DELIMITER $$
CREATE PROCEDURE `upgrade_user_activity_record`()
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user_activity_record' AND COLUMN_NAME = 'task_id'
  ) THEN
    ALTER TABLE `user_activity_record`
      ADD COLUMN `task_id` bigint DEFAULT NULL COMMENT '营销任务ID（营销活动奖励防重）' AFTER `coupon_id`;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user_activity_record' AND INDEX_NAME = 'idx_user_task'
  ) THEN
    ALTER TABLE `user_activity_record` ADD KEY `idx_user_task` (`user_id`,`activity_id`,`task_id`);
  END IF;
END$$
DELIMITER ;
CALL `upgrade_user_activity_record`();
DROP PROCEDURE IF EXISTS `upgrade_user_activity_record`;
