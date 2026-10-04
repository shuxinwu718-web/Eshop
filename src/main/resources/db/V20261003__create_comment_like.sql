-- 评论点赞表：支持点赞/取消点赞（toggle），UNIQUE(comment_id, user_id) 保证同一用户对同一评论只存一条
CREATE TABLE IF NOT EXISTS `comment_like` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
  `comment_id` BIGINT NOT NULL COMMENT '评论ID',
  `user_id` BIGINT NOT NULL COMMENT '点赞用户ID',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '点赞时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_comment_user` (`comment_id`, `user_id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论点赞表';
