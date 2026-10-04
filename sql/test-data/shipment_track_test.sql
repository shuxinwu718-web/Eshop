-- ============================================================
-- 模拟物流 测试数据脚本
-- ------------------------------------------------------------
-- 用途：一键造出 3 个演示场景，覆盖物流轨迹的不同状态，
--       对应前端「物流跟踪」页（/order/track/:shipmentId）：
--
--   场景1 TESTLOG001 已签收·已完成
--         完整 4 节点轨迹 + 自动确认收货结果，静态可查，无需后端。
--
--   场景2 TESTLOG002 推进中（已揽收→运输中→派送中）
--         后端运行中打开本场景，启动兜底会在约 5s 补投「已签收」，
--         演示轨迹实时推进 + 自动确认收货。
--
--   场景3 TESTLOG003 已发货·无轨迹（兜底自愈演示）
--         演示 LogisticsRecoveryRunner 启动扫描：按发货时间推算
--         缺失轨迹并补投，约 3 分钟内依次生成完整轨迹并自动签收。
--
-- 前置条件：shipment_track 表已创建
--   （先执行 src/main/resources/db/V20261002__create_shipment_track.sql）
--
-- 买家：star（user_id=6，登录演示）；商家：bob（seller_id=5）
-- 时间线按默认配置推算（simulation.logistics.* 各段 1 分钟）。
--
-- 幂等：按固定订单号清理旧数据后重建，可重复执行。
--
-- 执行方式：
--   本地  mysql -uroot -p123456 eshops < 本文件
--   容器  docker exec -i eshop-mysql mysql -uroot -p123456 eshops < 本文件
--
-- 注意：docker-compose 仅自动导入挂载目录「根目录」的 .sql（首次空卷启动），
--       本脚本位于 test-data/ 子目录，不会被自动执行，需手动运行。
-- ============================================================

SET NAMES utf8mb4;

-- ============================================================
-- 0. 清理旧测试数据（按订单号，先删子表再删主表）
-- ============================================================
DELETE FROM `shipment_track`
 WHERE order_id IN (
   SELECT id FROM `order`
    WHERE order_no IN ('TESTLOG001', 'TESTLOG002', 'TESTLOG003'));

DELETE FROM `order_item`
 WHERE order_id IN (
   SELECT id FROM `order`
    WHERE order_no IN ('TESTLOG001', 'TESTLOG002', 'TESTLOG003'));

DELETE FROM `order_shipment`
 WHERE order_id IN (
   SELECT id FROM `order`
    WHERE order_no IN ('TESTLOG001', 'TESTLOG002', 'TESTLOG003'));

DELETE FROM `order`
 WHERE order_no IN ('TESTLOG001', 'TESTLOG002', 'TESTLOG003');

-- ============================================================
-- 1. 场景一：已签收·已完成（完整 4 节点轨迹，静态可查）
-- ============================================================
INSERT INTO `order`
  (order_no, user_id, total_amount, pay_amount, type, pay_status, order_status,
   receiver_name, receiver_phone, receiver_address, remark,
   create_time, pay_time, finish_time, deleted)
VALUES
  ('TESTLOG001', 6, 6200.00, 6200.00, 1, 1, 3,
   '星', '13887654321', '广东省深圳市福田区华强北3号', '',
   DATE_SUB(NOW(), INTERVAL 10 MINUTE), DATE_SUB(NOW(), INTERVAL 9 MINUTE),
   DATE_SUB(NOW(), INTERVAL 3 MINUTE), 0);
SET @oid1 = LAST_INSERT_ID();

INSERT INTO `order_shipment`
  (order_id, seller_id, delivery_status, shipping_name, shipping_no,
   shipping_time, received_time, total_amount, create_time)
VALUES
  (@oid1, 5, 2, '顺丰速运', 'SF136000000001',
   DATE_SUB(NOW(), INTERVAL 8 MINUTE), DATE_SUB(NOW(), INTERVAL 3 MINUTE),
   6200.00, DATE_SUB(NOW(), INTERVAL 10 MINUTE));
SET @sid1 = LAST_INSERT_ID();

INSERT INTO `order_item`
  (order_id, shipment_id, product_id, sku_id, sku_specs,
   product_name, product_image, price, quantity)
VALUES
  (@oid1, @sid1, 2, 3, '存储:256GB, 颜色:雅丹黑',
   '华为 Mate 60 Pro', '/uploads/2026-05-17/ac3a98e5-0469-4b3c-afad-d029a5f4420a.jpg', 6200.00, 1);

-- 完整轨迹（时间轴倒排：签收最近）
INSERT INTO `shipment_track` (shipment_id, order_id, track_status, title, description, create_time) VALUES
  (@sid1, @oid1, 1, '包裹已揽收', '商家已发货，顺丰速运 已揽收包裹', DATE_SUB(NOW(), INTERVAL 8 MINUTE)),
  (@sid1, @oid1, 2, '运输中',     '包裹已从出发地发往目的地中转中心', DATE_SUB(NOW(), INTERVAL 6 MINUTE)),
  (@sid1, @oid1, 3, '派送中',     '包裹已到达目的地，快递员正在为您派送', DATE_SUB(NOW(), INTERVAL 4 MINUTE)),
  (@sid1, @oid1, 4, '包裹已签收', '包裹已被签收，感谢您的购买', DATE_SUB(NOW(), INTERVAL 3 MINUTE));

-- ============================================================
-- 2. 场景二：推进中（已揽收→运输中→派送中，待自动签收）
-- ============================================================
INSERT INTO `order`
  (order_no, user_id, total_amount, pay_amount, type, pay_status, order_status,
   receiver_name, receiver_phone, receiver_address, remark,
   create_time, pay_time, finish_time, deleted)
VALUES
  ('TESTLOG002', 6, 16.00, 16.00, 1, 1, 2,
   '星', '13887654321', '广东省深圳市福田区华强北3号', '',
   DATE_SUB(NOW(), INTERVAL 4 MINUTE), DATE_SUB(NOW(), INTERVAL 4 MINUTE), NULL, 0);
SET @oid2 = LAST_INSERT_ID();

INSERT INTO `order_shipment`
  (order_id, seller_id, delivery_status, shipping_name, shipping_no,
   shipping_time, received_time, total_amount, create_time)
VALUES
  (@oid2, 5, 1, '圆通速递', 'YT136000000002',
   DATE_SUB(NOW(), INTERVAL 3 MINUTE), NULL,
   16.00, DATE_SUB(NOW(), INTERVAL 4 MINUTE));
SET @sid2 = LAST_INSERT_ID();

INSERT INTO `order_item`
  (order_id, shipment_id, product_id, sku_id, sku_specs,
   product_name, product_image, price, quantity)
VALUES
  (@oid2, @sid2, 16, 50, '袋数:1, 包数/袋:20',
   '纸巾', '/uploads/2026-08-01/f379b151-7bc3-4876-a268-ae461a66e4f2.jpg', 16.00, 1);

-- 已生成 3 条轨迹；后端运行时启动兜底将补投「已签收」并自动确认收货
INSERT INTO `shipment_track` (shipment_id, order_id, track_status, title, description, create_time) VALUES
  (@sid2, @oid2, 1, '包裹已揽收', '商家已发货，圆通速递 已揽收包裹', DATE_SUB(NOW(), INTERVAL 3 MINUTE)),
  (@sid2, @oid2, 2, '运输中',     '包裹已从出发地发往目的地中转中心', DATE_SUB(NOW(), INTERVAL 2 MINUTE)),
  (@sid2, @oid2, 3, '派送中',     '包裹已到达目的地，快递员正在为您派送', DATE_SUB(NOW(), INTERVAL 1 MINUTE));

-- ============================================================
-- 3. 场景三：已发货·无轨迹（启动兜底自愈演示）
-- ============================================================
INSERT INTO `order`
  (order_no, user_id, total_amount, pay_amount, type, pay_status, order_status,
   receiver_name, receiver_phone, receiver_address, remark,
   create_time, pay_time, finish_time, deleted)
VALUES
  ('TESTLOG003', 6, 25.00, 25.00, 1, 1, 2,
   '星', '13887654321', '广东省深圳市福田区华强北3号', '',
   DATE_SUB(NOW(), INTERVAL 5 MINUTE), DATE_SUB(NOW(), INTERVAL 5 MINUTE), NULL, 0);
SET @oid3 = LAST_INSERT_ID();

INSERT INTO `order_shipment`
  (order_id, seller_id, delivery_status, shipping_name, shipping_no,
   shipping_time, received_time, total_amount, create_time)
VALUES
  (@oid3, 5, 1, '中通快递', 'ZTO136000000003',
   DATE_SUB(NOW(), INTERVAL 4 MINUTE), NULL,
   25.00, DATE_SUB(NOW(), INTERVAL 5 MINUTE));
SET @sid3 = LAST_INSERT_ID();

INSERT INTO `order_item`
  (order_id, shipment_id, product_id, sku_id, sku_specs,
   product_name, product_image, price, quantity)
VALUES
  (@oid3, @sid3, 15, 42, '个数:10',
   ' “软绵绵”面包', '/uploads/2026-07-29/217e8f09-f7ce-4676-a33d-f307d29ae4db.jpg', 25.00, 1);

-- 不插入任何轨迹：由 LogisticsRecoveryRunner 启动时按发货时间兜底补投

-- ============================================================
-- 4. 校验：回显结果
-- ============================================================
SELECT s.id AS shipment_id, s.order_id, o.order_no, s.shipping_name, s.shipping_no,
       s.delivery_status AS 发货状态, o.order_status AS 订单状态
  FROM `order_shipment` s
  JOIN `order` o ON o.id = s.order_id
 WHERE o.order_no IN ('TESTLOG001', 'TESTLOG002', 'TESTLOG003')
 ORDER BY o.order_no;

SELECT s.order_no, t.shipment_id, t.track_status AS 轨迹状态, t.title, t.description, t.create_time
  FROM `shipment_track` t
  JOIN `order` o ON o.id = t.order_id
 WHERE o.order_no IN ('TESTLOG001', 'TESTLOG002', 'TESTLOG003')
 ORDER BY t.shipment_id, t.track_status;
