-- 订单支付方式：结算页选定并落库，收银台据此预选；改选需同步回订单
-- 1=微信（模拟） 2=支付宝（沙箱/正式），默认支付宝
ALTER TABLE `order`
    ADD COLUMN `pay_method` TINYINT NOT NULL DEFAULT 2 COMMENT '支付方式 1微信 2支付宝' AFTER `pay_status`;
