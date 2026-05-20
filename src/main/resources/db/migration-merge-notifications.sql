-- =============================================
-- Merge merchant_notification into sys_notice
-- =============================================

-- 1. Add biz columns to sys_notice
ALTER TABLE sys_notice
    ADD COLUMN biz_type VARCHAR(32) NULL COMMENT '业务类型: new_order/order_paid/order_cancelled/new_message/reply_message',
    ADD COLUMN biz_id   BIGINT      NULL COMMENT '业务ID (订单ID/留言ID)';

-- 2. Migrate existing merchant_notification data to sys_notice
INSERT INTO sys_notice (title, content, type, level, target_type, target_user_ids, publisher_id, publisher_name, status, publish_time, create_time, biz_type, biz_id)
SELECT n.title, n.content, 3, 0, 2, n.merchant_id, 0, '系统', 1, n.create_time, n.create_time, n.type, n.order_id
FROM merchant_notification n;

-- 3. Drop the old table
DROP TABLE merchant_notification;
