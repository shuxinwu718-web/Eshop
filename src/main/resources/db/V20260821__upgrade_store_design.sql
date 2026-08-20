-- ============================================================
-- V20260821 店铺主页装修模块：store_design 表扩展
-- 1. announcement：店铺公告
-- 2. draft_layout：草稿楼层配置 JSON（null 表示无草稿）
-- 3. layout：已发布楼层配置 JSON（用户端读取）
-- 用存储过程做条件 DDL（MySQL 8.0 不支持 ADD COLUMN IF NOT EXISTS），幂等可重复执行
-- ============================================================

DROP PROCEDURE IF EXISTS `upgrade_store_design`;
DELIMITER $$
CREATE PROCEDURE `upgrade_store_design`()
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'store_design' AND COLUMN_NAME = 'announcement'
  ) THEN
    ALTER TABLE `store_design`
      ADD COLUMN `announcement` varchar(500) DEFAULT NULL COMMENT '店铺公告' AFTER `banner_url`;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'store_design' AND COLUMN_NAME = 'draft_layout'
  ) THEN
    ALTER TABLE `store_design`
      ADD COLUMN `draft_layout` LONGTEXT DEFAULT NULL COMMENT '装修草稿楼层配置JSON' AFTER `announcement`;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'store_design' AND COLUMN_NAME = 'layout'
  ) THEN
    ALTER TABLE `store_design`
      ADD COLUMN `layout` LONGTEXT DEFAULT NULL COMMENT '已发布楼层配置JSON（用户端渲染）' AFTER `draft_layout`;
  END IF;
END$$
DELIMITER ;
CALL `upgrade_store_design`();
DROP PROCEDURE IF EXISTS `upgrade_store_design`;
