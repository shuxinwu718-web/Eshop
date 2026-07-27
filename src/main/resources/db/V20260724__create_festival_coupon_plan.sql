-- ============================================================
-- 节日优惠券活动计划表
-- 用于配置节日签到活动，与 coupon 表关联
-- ============================================================
CREATE TABLE IF NOT EXISTS `festival_coupon_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `coupon_id` bigint NOT NULL COMMENT '关联优惠券模板ID',
  `festival_name` varchar(100) NOT NULL COMMENT '节日名称',
  `festival_icon` varchar(50) DEFAULT NULL COMMENT '节日图标(emoji)',
  `start_date` date NOT NULL COMMENT '活动开始日期',
  `end_date` date NOT NULL COMMENT '活动结束日期',
  `required_signin_days` int NOT NULL DEFAULT 0 COMMENT '所需连续签到天数',
  `description` varchar(500) DEFAULT NULL COMMENT '活动描述文案',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '0-停用 1-启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_coupon_id` (`coupon_id`),
  KEY `idx_date_range` (`start_date`, `end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='节日优惠券活动计划';

-- ============================================================
-- 种子数据：示例节日活动
-- ============================================================
INSERT INTO `festival_coupon_plan` (`coupon_id`, `festival_name`, `festival_icon`, `start_date`, `end_date`, `required_signin_days`, `description`, `status`)
VALUES
  (5, '618购物节', '🎉', '2026-06-01', '2026-06-30', 3, '连续签到3天，领取618专属满减券！', 1),
  (6, '双11狂欢', '🎊', '2026-11-01', '2026-11-15', 7, '连续签到7天，领取双11超值折扣券！', 1),
  (7, '周年庆', '🎂', '2026-08-01', '2026-08-15', 5, '连续签到5天，领取店庆专属优惠券！', 1);
