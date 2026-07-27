-- ============================================================
-- 退款系统增强：新增表 + RefundApplication 扩字段
-- ============================================================

-- A1. 退款原因分类
CREATE TABLE IF NOT EXISTS `refund_reason_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `description` varchar(200) DEFAULT NULL COMMENT '分类描述',
  `sort` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '0-禁用 1-启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='退款原因分类';

INSERT IGNORE INTO `refund_reason_category` (`id`, `name`, `description`, `sort`) VALUES
(1, '商品质量问题', '收到商品有瑕疵/损坏/与描述不符', 1),
(2, '发货问题', '未按时发货/发错商品/漏发', 2),
(3, '不想要了', '7天无理由退货', 3),
(4, '价格问题', '购买后降价/有更优价格', 4),
(5, '其他原因', '其他退款理由', 5);

-- A2. 退款进度日志
CREATE TABLE IF NOT EXISTS `refund_progress_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `refund_id` bigint NOT NULL COMMENT '退款申请ID',
  `node_name` varchar(50) NOT NULL COMMENT '节点名称：申请提交/商户审核/管理员审核/退款执行/退款完成',
  `operator` varchar(50) NOT NULL COMMENT '操作人',
  `operator_role` varchar(20) NOT NULL COMMENT '操作人角色：USER/MERCHANT/ADMIN',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_refund_id` (`refund_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='退款进度日志';

-- A3. 退款满意度反馈
CREATE TABLE IF NOT EXISTS `refund_satisfaction` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `refund_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `rating` tinyint NOT NULL COMMENT '评分 1-5',
  `feedback` varchar(500) DEFAULT NULL COMMENT '反馈意见',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_refund` (`refund_id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='退款满意度反馈';

-- A4. 支付记录表（模拟）
CREATE TABLE IF NOT EXISTS `payment_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `order_no` varchar(32) NOT NULL,
  `user_id` bigint NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `pay_method` varchar(20) DEFAULT NULL COMMENT '模拟支付方式：wechat/alipay',
  `trade_no` varchar(64) DEFAULT NULL COMMENT '模拟交易号',
  `status` tinyint DEFAULT '0' COMMENT '0-待支付 1-已支付 2-已退款',
  `pay_time` datetime DEFAULT NULL,
  `refund_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_order` (`order_id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='支付记录表';

-- ============================================================
-- RefundApplication 扩字段（ALTER TABLE 方式）
-- ============================================================
ALTER TABLE `refund_application`
  ADD COLUMN `reason_category_id` bigint DEFAULT NULL COMMENT '退款原因分类ID' AFTER `reason`,
  ADD COLUMN `merchant_audit_time` datetime DEFAULT NULL COMMENT '商户审核时间' AFTER `audit_time`,
  ADD COLUMN `admin_audit_time` datetime DEFAULT NULL COMMENT '管理员审核时间' AFTER `merchant_audit_time`,
  ADD COLUMN `refund_time` datetime DEFAULT NULL COMMENT '退款执行时间' AFTER `admin_audit_time`,
  ADD INDEX `idx_reason_category` (`reason_category_id`);
