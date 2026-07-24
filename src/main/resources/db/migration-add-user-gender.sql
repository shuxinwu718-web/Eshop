-- ============================================================
-- 用户表新增 gender 性别字段
-- 0-未知 1-男 2-女
-- ============================================================
ALTER TABLE `user`
  ADD COLUMN `gender` tinyint NOT NULL DEFAULT 0 COMMENT '性别 0-未知 1-男 2-女' AFTER `avatar`;
