/*
 Navicat Premium Dump SQL

 Source Server         : .
 Source Server Type    : MySQL
 Source Server Version : 80046 (8.0.46)
 Source Host           : localhost:3306
 Source Schema         : eshops

 Target Server Type    : MySQL
 Target Server Version : 80046 (8.0.46)
 File Encoding         : 65001

 Date: 05/08/2026 11:14:25
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `receiver_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '收货人电话',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `detail_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_default` tinyint NULL DEFAULT 0 COMMENT '0-非默认 1-默认',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '收货地址表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (1, 3, '张三', '13812345678', '广东省', '深圳市', '南山区', '科技园南区1号', 1, '2026-05-11 17:00:11', '2026-05-11 17:00:11');
INSERT INTO `address` VALUES (2, 3, '张三', '13812345678', '广东省', '广州市', '天河区', '珠江新城2号', 0, '2026-05-11 17:00:11', '2026-05-11 17:00:11');
INSERT INTO `address` VALUES (3, 6, '星', '13887654321', '广东省', '深圳市', '福田区', '华强北3号', 1, '2026-05-11 17:00:11', '2026-05-15 10:50:53');
INSERT INTO `address` VALUES (4, 6, '星', '13536911064', '广东', '汕头', '潮南', '峡山街道', 0, '2026-05-15 10:51:46', '2026-05-15 10:51:46');
INSERT INTO `address` VALUES (5, 5, '鲍勃', '13536911064', '广东', '肇庆', '端州', '肇庆学院', 1, '2026-05-15 16:32:04', '2026-05-15 16:32:04');
INSERT INTO `address` VALUES (6, 2, '摩羯', '1235822154', '广东', '汕头', '潮南', '峡山街道', 1, '2026-05-17 16:50:36', '2026-05-17 16:50:36');
INSERT INTO `address` VALUES (7, 10, '吴', '13536911064', '广东省', '汕头市', '潮南区', '峡山街道', 1, '2026-05-19 22:07:04', '2026-05-19 22:07:04');
INSERT INTO `address` VALUES (8, 4, '李四', '13536911064', '广东', '汕头', '潮南', '峡山街道', 1, '2026-05-21 23:02:27', '2026-05-21 23:02:27');
INSERT INTO `address` VALUES (9, 13, '吴', '1232132123', '广东', '汕头', '潮南', '呜呜呜呜', 1, '2026-05-30 17:14:13', '2026-05-30 17:14:13');
INSERT INTO `address` VALUES (10, 8, 'WU', '123215313', '广东', '汕头', '潮南', '峡山街道金狮商场513', 1, '2026-08-01 10:14:17', '2026-08-01 10:14:17');
INSERT INTO `address` VALUES (11, 14, 't', '13800000008', 'gd', 'sz', 'ns', 'x1', 0, '2026-08-01 10:37:54', '2026-08-01 10:37:54');
INSERT INTO `address` VALUES (13, 14, 't', '13800000008', 'gd', 'sz', 'ns', 'x1', 1, '2026-08-01 10:38:33', '2026-08-01 10:38:33');

-- ----------------------------
-- Table structure for cart
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `sku_id` bigint NULL DEFAULT NULL COMMENT '选中的SKU ID（无规格商品为NULL）',
  `sku_specs` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'SKU规格描述，如\"颜色:黑色, 尺码:41\"',
  `quantity` int NOT NULL DEFAULT 1,
  `selected` tinyint NULL DEFAULT 1,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_product_sku`(`user_id` ASC, `product_id` ASC, `sku_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart
-- ----------------------------
INSERT INTO `cart` VALUES (52, 5, 3, 9, '{\"存储\": \"256GB\", \"颜色\": \"白色钛\"}', 1, 1, '2026-07-29 15:36:16', '2026-07-29 15:36:16');
INSERT INTO `cart` VALUES (57, 14, 1, 46, '{\"存储\": \"512GB\"}', 2, 1, '2026-08-01 10:36:24', '2026-08-01 10:36:24');
INSERT INTO `cart` VALUES (58, 14, 2, 3, '{\"存储\": \"256GB\", \"颜色\": \"雅丹黑\"}', 1, 1, '2026-08-01 10:40:05', '2026-08-01 10:40:05');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `parent_id` bigint NULL DEFAULT 0,
  `level` tinyint NULL DEFAULT 1,
  `sort` int NULL DEFAULT 0,
  `status` tinyint NULL DEFAULT 1,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, '数码产品', 0, 1, 1, 1, '2026-05-11 17:00:11', '2026-05-11 17:00:11', 0);
INSERT INTO `category` VALUES (2, '手机通讯', 1, 2, 2, 1, '2026-05-11 17:00:11', '2026-05-11 17:00:11', 0);
INSERT INTO `category` VALUES (3, '电脑办公', 1, 2, 3, 1, '2026-05-11 17:00:11', '2026-05-11 17:00:11', 0);
INSERT INTO `category` VALUES (4, '服装鞋帽', 0, 1, 4, 1, '2026-05-11 17:00:11', '2026-05-11 17:00:11', 0);
INSERT INTO `category` VALUES (5, '男装', 4, 2, 5, 1, '2026-05-11 17:00:11', '2026-05-11 17:00:11', 0);
INSERT INTO `category` VALUES (6, '运动', 0, 1, 1, 1, '2026-05-13 17:39:56', '2026-05-13 17:39:56', 0);
INSERT INTO `category` VALUES (8, '羽毛球', 6, 2, 0, 1, '2026-05-13 17:41:33', '2026-05-13 17:41:33', 0);
INSERT INTO `category` VALUES (9, '跑步', 6, 2, 1, 1, '2026-05-16 16:48:42', '2026-05-16 16:48:42', 0);
INSERT INTO `category` VALUES (10, '保健品', 0, 1, 0, 1, '2026-05-20 16:28:00', '2026-05-20 16:28:00', 0);
INSERT INTO `category` VALUES (11, '知识', 0, 1, 0, 1, '2026-05-21 22:24:36', '2026-05-21 22:24:36', 0);
INSERT INTO `category` VALUES (12, '计算机类书籍', 11, 2, 0, 1, '2026-05-21 22:24:49', '2026-05-21 22:24:49', 0);
INSERT INTO `category` VALUES (13, '食品', 0, 1, 0, 1, '2026-05-21 22:28:05', '2026-05-21 22:28:05', 0);
INSERT INTO `category` VALUES (14, '家用', 0, 1, 0, 1, '2026-05-21 22:28:37', '2026-05-21 22:28:37', 0);
INSERT INTO `category` VALUES (15, '护肤品', 0, 1, 0, 1, '2026-08-01 09:24:17', '2026-08-01 09:24:17', 0);

-- ----------------------------
-- Table structure for coupon
-- ----------------------------
DROP TABLE IF EXISTS `coupon`;
CREATE TABLE `coupon`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '优惠券名称',
  `type` tinyint NOT NULL DEFAULT 0 COMMENT '类型: 0=满减券, 1=折扣券',
  `value` decimal(10, 2) NOT NULL COMMENT '面值/折扣率',
  `min_amount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '最低使用金额',
  `max_discount` decimal(10, 2) NULL DEFAULT NULL COMMENT '最高抵扣(折扣券)',
  `stock` int NULL DEFAULT 0 COMMENT '库存',
  `limit_per_user` int NULL DEFAULT 1 COMMENT '每人限领',
  `start_time` datetime NULL DEFAULT NULL COMMENT '生效时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '失效时间',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态: 0=下架, 1=上架',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0,
  `obtain_type` tinyint NOT NULL DEFAULT 0 COMMENT '获取方式：0-普通领取（显示在领券中心） 1-签到 2-新人礼包 3-秒杀 4-其他活动',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_time`(`start_time` ASC, `end_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '优惠券定义' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of coupon
-- ----------------------------
INSERT INTO `coupon` VALUES (1, '无与伦比', 0, 5.50, 15.00, NULL, 498, 1, '2026-05-01 00:00:00', '2026-06-15 00:00:00', 1, '', '2026-05-19 13:16:10', '2026-05-19 13:16:10', 0, 0);
INSERT INTO `coupon` VALUES (2, '8.5折扣劵', 1, 8.50, 80.00, NULL, 494, 5, '2026-05-01 00:00:00', '2026-06-15 00:00:00', 1, '', '2026-05-19 13:38:26', '2026-05-19 13:38:26', 0, 0);
INSERT INTO `coupon` VALUES (3, '签到折扣卷', 1, 8.00, 50.00, NULL, 998, 2, '2026-05-01 00:00:00', '2026-06-30 00:00:00', 1, '', '2026-05-19 19:57:23', '2026-05-21 19:06:34', 0, 1);
INSERT INTO `coupon` VALUES (4, '14天签到满减劵', 0, 10.00, 30.00, NULL, 1000, 2, '2026-05-01 00:00:00', '2026-06-30 00:00:00', 1, '', '2026-05-19 20:40:09', '2026-05-21 19:06:59', 0, 1);
INSERT INTO `coupon` VALUES (5, '新人10元满减劵', 0, 10.00, 30.00, NULL, 1000, 5, '2026-05-01 00:00:00', '2030-06-30 00:00:00', 1, '', '2026-05-19 21:33:28', '2026-05-21 19:06:40', 0, 2);
INSERT INTO `coupon` VALUES (6, '8折新人折扣劵', 1, 8.00, 40.00, NULL, 1000, 5, '2026-05-01 00:00:00', '2030-06-30 00:00:00', 1, '', '2026-05-19 21:34:19', '2026-05-21 19:06:56', 0, 2);
INSERT INTO `coupon` VALUES (7, '618大促折扣劵', 1, 8.00, 15.00, NULL, 500, 1, '2026-06-09 00:00:00', '2026-06-25 00:00:00', 1, '', '2026-05-21 17:49:46', '2026-05-21 17:49:46', 0, 0);
INSERT INTO `coupon` VALUES (8, '双11满减券', 0, 50.00, 500.00, NULL, 500, 1, '2026-11-04 00:00:00', '2026-11-18 00:00:00', 1, '', '2026-05-21 17:59:17', '2026-05-21 17:59:17', 0, 0);
INSERT INTO `coupon` VALUES (9, '双11折扣券', 1, 8.00, 100.00, NULL, 1500, 5, '2026-11-04 00:00:00', '2026-11-18 00:00:00', 1, '', '2026-05-21 18:00:23', '2026-05-21 18:00:23', 0, 0);
INSERT INTO `coupon` VALUES (10, 'CSC', 0, 2.00, 2.00, NULL, 21, 1, NULL, NULL, 1, '', '2026-05-21 20:11:44', '2026-05-21 20:11:44', 0, 3);

-- ----------------------------
-- Table structure for favorite
-- ----------------------------
DROP TABLE IF EXISTS `favorite`;
CREATE TABLE `favorite`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_product`(`user_id` ASC, `product_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_product`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of favorite
-- ----------------------------
INSERT INTO `favorite` VALUES (1, 6, 8, '2026-05-15 12:50:57');
INSERT INTO `favorite` VALUES (3, 5, 2, '2026-05-15 16:23:53');
INSERT INTO `favorite` VALUES (4, 6, 9, '2026-05-20 18:24:29');
INSERT INTO `favorite` VALUES (6, 6, 13, '2026-05-20 18:34:41');
INSERT INTO `favorite` VALUES (9, 2, 12, '2026-05-20 19:09:30');
INSERT INTO `favorite` VALUES (10, 5, 4, '2026-05-21 11:15:17');
INSERT INTO `favorite` VALUES (11, 6, 12, '2026-07-22 16:37:31');

-- ----------------------------
-- Table structure for festival_coupon_plan
-- ----------------------------
DROP TABLE IF EXISTS `festival_coupon_plan`;
CREATE TABLE `festival_coupon_plan`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `coupon_id` bigint NOT NULL COMMENT '鍏宠仈浼樻儬鍒告ā鏉縄D',
  `festival_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '鑺傛棩鍚嶇О',
  `festival_icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '鑺傛棩鍥炬爣(emoji)',
  `start_date` date NOT NULL COMMENT '娲诲姩寮??鏃ユ湡',
  `end_date` date NOT NULL COMMENT '娲诲姩缁撴潫鏃ユ湡',
  `required_signin_days` int NOT NULL DEFAULT 0 COMMENT '鎵?渶杩炵画绛惧埌澶╂暟',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '娲诲姩鎻忚堪鏂囨?',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '0-鍋滅敤 1-鍚?敤',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_coupon_id`(`coupon_id` ASC) USING BTREE,
  INDEX `idx_date_range`(`start_date` ASC, `end_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '鑺傛棩浼樻儬鍒告椿鍔ㄨ?鍒' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of festival_coupon_plan
-- ----------------------------
INSERT INTO `festival_coupon_plan` VALUES (1, 11, '618购物节', '🎉', '2026-06-01', '2026-06-30', 3, '连续签到3天，领取618专属满减券！', 1, '2026-07-24 11:03:03', '2026-07-24 11:34:17');
INSERT INTO `festival_coupon_plan` VALUES (2, 12, '双11狂欢', '🎊', '2026-11-01', '2026-11-15', 7, '连续签到7天，领取双11超值折扣券！', 1, '2026-07-24 11:03:03', '2026-07-24 11:34:17');
INSERT INTO `festival_coupon_plan` VALUES (3, 13, '周年庆', '🎂', '2026-08-01', '2026-08-15', 5, '连续签到5天，领取店庆专属优惠券！', 1, '2026-07-24 11:03:03', '2026-07-24 11:34:17');

-- ----------------------------
-- Table structure for merchant_apply
-- ----------------------------
DROP TABLE IF EXISTS `merchant_apply`;
CREATE TABLE `merchant_apply`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '申请人用户ID',
  `business_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '店铺名称',
  `business_license` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '营业执照图片URL',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系人姓名',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系人电话',
  `business_scope` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '经营范围',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '经营地址',
  `status` tinyint NULL DEFAULT 0 COMMENT '审核状态 0-待审核 1-通过 2-拒绝',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核备注（拒绝原因）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家入驻申请表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of merchant_apply
-- ----------------------------
INSERT INTO `merchant_apply` VALUES (1, 5, '百宝商店', '/uploads/2026-05-17/5f7b2b83-e2a2-484e-bd43-60cc1418b656.jpg', '鲍勃', '13536911064', '百货', '汕头峡山小学附近', 1, '', '2026-05-17 18:52:17', '2026-05-17 18:52:17');
INSERT INTO `merchant_apply` VALUES (2, 6, 'wwwww', '/uploads/2026-05-17/47126939-e207-4274-ba2b-f982a0f9999a.jpg', 'wwww', '13536911064', 'wwww', 'wwww', 1, NULL, '2026-05-17 19:52:55', '2026-05-17 20:40:36');
INSERT INTO `merchant_apply` VALUES (3, 3, '鸿庭保', '/uploads/2026-05-16/8852042a-e0ed-41ae-aeb5-a304e77c25de.jpg', '张三', '13536911064', 'wwww', 'wwww', 1, '', '2026-05-17 20:19:06', '2026-05-17 20:19:06');

-- ----------------------------
-- Table structure for merchant_message
-- ----------------------------
DROP TABLE IF EXISTS `merchant_message`;
CREATE TABLE `merchant_message`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `merchant_id` bigint NOT NULL COMMENT '商家用户ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NULL DEFAULT NULL COMMENT '关联商品ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '留言内容',
  `is_read` tinyint NULL DEFAULT 0 COMMENT '是否已读 0未读 1已读',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `reply_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '商家回复',
  `reply_time` datetime NULL DEFAULT NULL COMMENT '回复时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_merchant`(`merchant_id` ASC, `is_read` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家留言' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of merchant_message
-- ----------------------------
INSERT INTO `merchant_message` VALUES (1, 2, 6, 2, '可以送优惠卷吗', 1, '2026-07-22 16:39:20', NULL, NULL);

-- ----------------------------
-- Table structure for operation_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `operator_id` bigint NOT NULL COMMENT '操作人ID（管理员ID）',
  `operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作人用户名',
  `operation_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作类型（如 DELETE_PRODUCT, FREEZE_USER）',
  `target_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '目标类型（如 Product, User, Order）',
  `target_id` bigint NULL DEFAULT NULL COMMENT '目标ID',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作内容描述',
  `request_url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求URL',
  `request_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '请求参数（JSON格式）',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_operator_id`(`operator_id` ASC) USING BTREE,
  INDEX `idx_operation_type`(`operation_type` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_log
-- ----------------------------
INSERT INTO `operation_log` VALUES (1, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 16:36:41');
INSERT INTO `operation_log` VALUES (2, 1, 'admin', 'FREEZE_USER', 'User', NULL, '冻结用户', '/api/user/admin/freeze/6', '[6]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 16:36:46');
INSERT INTO `operation_log` VALUES (3, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 16:36:46');
INSERT INTO `operation_log` VALUES (4, 1, 'admin', 'FREEZE_USER', 'User', NULL, '冻结用户', '/api/user/admin/freeze/5', '[5]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 16:36:49');
INSERT INTO `operation_log` VALUES (5, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 16:36:49');
INSERT INTO `operation_log` VALUES (6, 1, 'admin', 'UNFREEZE_USER', 'User', NULL, '解冻用户', '/api/user/admin/unfreeze/5', '[5]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 16:36:54');
INSERT INTO `operation_log` VALUES (7, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 16:36:54');
INSERT INTO `operation_log` VALUES (8, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 16:59:05');
INSERT INTO `operation_log` VALUES (9, 1, 'admin', 'UNFREEZE_USER', 'User', NULL, '解冻用户', '/api/user/admin/unfreeze/8', '[8]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 16:59:08');
INSERT INTO `operation_log` VALUES (10, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 16:59:08');
INSERT INTO `operation_log` VALUES (11, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 17:04:41');
INSERT INTO `operation_log` VALUES (12, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 17:29:11');
INSERT INTO `operation_log` VALUES (13, 1, 'admin', 'Add_Coupon', 'CouponSaveDTO', NULL, '新增优惠卷', '/admin/coupon', '[{\"id\":null,\"name\":\"CSC\",\"type\":0,\"value\":2,\"minAmount\":2,\"maxDiscount\":null,\"stock\":21,\"limitPerUser\":1,\"obtainType\":3,\"startTime\":null,\"endTime\":null,\"status\":null,\"description\":\"\"}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 20:11:44');
INSERT INTO `operation_log` VALUES (14, 1, 'admin', 'ADD_SECKILL_SESSION', 'SeckillSession', NULL, '新增秒杀场次', '/admin/seckill', '[{\"id\":null,\"couponId\":10,\"sessionName\":\"521秒杀劵\",\"startTime\":\"2026-05-21T00:00:00\",\"endTime\":\"2026-05-21T00:00:01\",\"seckillStock\":20,\"limitPerUser\":1}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 20:15:46');
INSERT INTO `operation_log` VALUES (15, 1, 'admin', 'PREHEAT_SECKILL', 'SeckillSession', 1, '预热秒杀库存', '/admin/seckill/preheat/1', '[1]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 20:17:06');
INSERT INTO `operation_log` VALUES (16, 1, 'admin', 'ADD_SECKILL_SESSION', 'SeckillSession', NULL, '新增秒杀场次', '/admin/seckill', '[{\"id\":null,\"couponId\":10,\"sessionName\":\"521秒杀券2\",\"startTime\":\"2026-05-21T20:23:00\",\"endTime\":\"2026-05-21T23:25:00\",\"seckillStock\":10,\"limitPerUser\":1}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 20:21:06');
INSERT INTO `operation_log` VALUES (17, 1, 'admin', 'PREHEAT_SECKILL', 'SeckillSession', 2, '预热秒杀库存', '/admin/seckill/preheat/2', '[2]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 20:21:09');
INSERT INTO `operation_log` VALUES (18, 1, 'admin', 'PREHEAT_SECKILL', 'SeckillSession', 2, '预热秒杀库存', '/admin/seckill/preheat/2', '[2]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 20:21:12');
INSERT INTO `operation_log` VALUES (19, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 22:01:06');
INSERT INTO `operation_log` VALUES (20, 1, 'admin', 'UNFREEZE_USER', 'User', 6, '解冻用户', '/api/user/admin/unfreeze/6', '[6]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 22:01:14');
INSERT INTO `operation_log` VALUES (21, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 22:01:14');
INSERT INTO `operation_log` VALUES (22, 1, 'admin', 'Add_Category', 'Category', NULL, '添加分类', '/api/category', '[{\"id\":11,\"name\":\"知识\",\"parentId\":null,\"level\":1,\"sortOrder\":0,\"createTime\":\"2026-05-21T22:24:36.0245219\",\"updateTime\":\"2026-05-21T22:24:36.0245219\",\"deleted\":null,\"children\":[]}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 22:24:36');
INSERT INTO `operation_log` VALUES (23, 1, 'admin', 'Add_Category', 'Category', NULL, '添加分类', '/api/category', '[{\"id\":12,\"name\":\"计算机类书籍\",\"parentId\":11,\"level\":2,\"sortOrder\":0,\"createTime\":\"2026-05-21T22:24:48.9377517\",\"updateTime\":\"2026-05-21T22:24:48.9377517\",\"deleted\":null,\"children\":[]}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 22:24:49');
INSERT INTO `operation_log` VALUES (24, 1, 'admin', 'Add_Category', 'Category', NULL, '添加分类', '/api/category', '[{\"id\":13,\"name\":\"食品\",\"parentId\":null,\"level\":1,\"sortOrder\":0,\"createTime\":\"2026-05-21T22:28:04.9132111\",\"updateTime\":\"2026-05-21T22:28:04.9132111\",\"deleted\":null,\"children\":[]}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 22:28:05');
INSERT INTO `operation_log` VALUES (25, 1, 'admin', 'Add_Category', 'Category', NULL, '添加分类', '/api/category', '[{\"id\":14,\"name\":\"家用\",\"parentId\":null,\"level\":1,\"sortOrder\":0,\"createTime\":\"2026-05-21T22:28:37.3482963\",\"updateTime\":\"2026-05-21T22:28:37.3482963\",\"deleted\":null,\"children\":[]}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-21 22:28:37');
INSERT INTO `operation_log` VALUES (26, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 08:27:14');
INSERT INTO `operation_log` VALUES (27, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 08:27:21');
INSERT INTO `operation_log` VALUES (28, 1, 'admin', 'KICK_USER', 'User', 1, '强制下线', '/api/user/admin/kick/1', '[1]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 08:27:26');
INSERT INTO `operation_log` VALUES (29, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 08:41:52');
INSERT INTO `operation_log` VALUES (30, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 08:41:54');
INSERT INTO `operation_log` VALUES (31, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 08:42:21');
INSERT INTO `operation_log` VALUES (32, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 08:43:46');
INSERT INTO `operation_log` VALUES (33, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 08:43:48');
INSERT INTO `operation_log` VALUES (34, 1, 'admin', 'KICK_USER', 'User', 6, '强制下线', '/api/user/admin/kick/6', '[6]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 08:43:54');
INSERT INTO `operation_log` VALUES (35, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 08:43:54');
INSERT INTO `operation_log` VALUES (36, 1, 'admin', 'KICK_USER', 'User', 5, '强制下线', '/api/user/admin/kick/5', '[5]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 08:44:19');
INSERT INTO `operation_log` VALUES (37, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 08:44:19');
INSERT INTO `operation_log` VALUES (38, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 08:46:24');
INSERT INTO `operation_log` VALUES (39, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 08:48:21');
INSERT INTO `operation_log` VALUES (40, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 08:48:23');
INSERT INTO `operation_log` VALUES (41, 1, 'admin', 'KICK_USER', 'User', 6, '强制下线', '/api/user/admin/kick/6', '[6]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 08:48:26');
INSERT INTO `operation_log` VALUES (42, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 08:48:26');
INSERT INTO `operation_log` VALUES (43, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 08:48:46');
INSERT INTO `operation_log` VALUES (44, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 08:49:27');
INSERT INTO `operation_log` VALUES (45, 1, 'admin', 'KICK_USER', 'User', 5, '强制下线', '/api/user/admin/kick/5', '[5]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 08:49:30');
INSERT INTO `operation_log` VALUES (46, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 08:49:30');
INSERT INTO `operation_log` VALUES (47, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 08:52:16');
INSERT INTO `operation_log` VALUES (48, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 08:52:20');
INSERT INTO `operation_log` VALUES (49, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 09:12:28');
INSERT INTO `operation_log` VALUES (50, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 09:12:30');
INSERT INTO `operation_log` VALUES (51, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 QQBrowser/21.1.8663.400', '2026-05-22 09:15:24');
INSERT INTO `operation_log` VALUES (52, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 15:29:58');
INSERT INTO `operation_log` VALUES (53, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 15:30:01');
INSERT INTO `operation_log` VALUES (54, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 15:36:33');
INSERT INTO `operation_log` VALUES (55, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 15:36:35');
INSERT INTO `operation_log` VALUES (56, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 15:37:10');
INSERT INTO `operation_log` VALUES (57, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 15:37:19');
INSERT INTO `operation_log` VALUES (58, 1, 'admin', 'KICK_USER', 'User', 6, '强制下线', '/api/user/admin/kick/6', '[6]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 15:37:32');
INSERT INTO `operation_log` VALUES (59, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2026-05-22 15:37:32');
INSERT INTO `operation_log` VALUES (60, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 19:40:42');
INSERT INTO `operation_log` VALUES (61, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 19:42:58');
INSERT INTO `operation_log` VALUES (62, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 20:00:54');
INSERT INTO `operation_log` VALUES (63, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 20:02:32');
INSERT INTO `operation_log` VALUES (64, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 20:03:18');
INSERT INTO `operation_log` VALUES (65, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 20:03:25');
INSERT INTO `operation_log` VALUES (66, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 20:03:28');
INSERT INTO `operation_log` VALUES (67, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 20:03:36');
INSERT INTO `operation_log` VALUES (68, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 20:03:45');
INSERT INTO `operation_log` VALUES (69, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 20:06:03');
INSERT INTO `operation_log` VALUES (70, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 20:06:03');
INSERT INTO `operation_log` VALUES (71, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 20:06:04');
INSERT INTO `operation_log` VALUES (72, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 20:06:04');
INSERT INTO `operation_log` VALUES (73, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 20:07:51');
INSERT INTO `operation_log` VALUES (74, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 20:09:04');
INSERT INTO `operation_log` VALUES (75, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 20:09:09');
INSERT INTO `operation_log` VALUES (76, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-28 20:09:20');
INSERT INTO `operation_log` VALUES (77, 1, 'admin', 'ADD_SECKILL_SESSION', 'SeckillSession', NULL, '新增秒杀场次', '/admin/seckill', '[{\"id\":null,\"couponId\":10,\"sessionName\":\"预热功能测试\",\"startTime\":\"2026-05-30T20:45:00\",\"endTime\":\"2026-05-31T00:00:00\",\"seckillStock\":5,\"limitPerUser\":1}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-30 20:44:40');
INSERT INTO `operation_log` VALUES (78, 1, 'admin', 'PREHEAT_SECKILL', 'SeckillSession', 3, '预热秒杀库存', '/admin/seckill/preheat/3', '[3]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-30 20:44:50');
INSERT INTO `operation_log` VALUES (79, 1, 'admin', 'PREHEAT_SECKILL', 'SeckillSession', 3, '预热秒杀库存', '/admin/seckill/preheat/3', '[3]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-30 20:45:00');
INSERT INTO `operation_log` VALUES (80, 1, 'admin', 'PREHEAT_SECKILL', 'SeckillSession', 3, '预热秒杀库存', '/admin/seckill/preheat/3', '[3]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-30 20:48:13');
INSERT INTO `operation_log` VALUES (81, 1, 'admin', 'PREHEAT_SECKILL', 'SeckillSession', 3, '预热秒杀库存', '/admin/seckill/preheat/3', '[3]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-30 20:48:26');
INSERT INTO `operation_log` VALUES (82, 1, 'admin', 'CANCEL_SECKILL_SESSION', 'SeckillSession', 3, '撤销秒杀场次', '/admin/seckill/cancel/3', '[3]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-30 20:50:17');
INSERT INTO `operation_log` VALUES (83, 1, 'admin', 'ADD_SECKILL_SESSION', 'SeckillSession', NULL, '新增秒杀场次', '/admin/seckill', '[{\"id\":null,\"couponId\":10,\"sessionName\":\"功能预热\",\"startTime\":\"2026-05-30T20:52:00\",\"endTime\":\"2026-05-31T00:00:00\",\"seckillStock\":10,\"limitPerUser\":1}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-30 20:51:56');
INSERT INTO `operation_log` VALUES (84, 1, 'admin', 'PREHEAT_SECKILL', 'SeckillSession', 4, '预热秒杀库存', '/admin/seckill/preheat/4', '[4]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-30 20:52:03');
INSERT INTO `operation_log` VALUES (85, 1, 'admin', 'UPDATE_SECKILL_SESSION', 'SeckillSession', NULL, '修改秒杀场次', '/admin/seckill', '[{\"id\":4,\"couponId\":10,\"sessionName\":\"功能预热\",\"startTime\":\"2026-05-30T20:53:00\",\"endTime\":\"2026-05-31T00:00:00\",\"seckillStock\":10,\"limitPerUser\":1}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-30 20:52:33');
INSERT INTO `operation_log` VALUES (86, 1, 'admin', 'UPDATE_SECKILL_SESSION', 'SeckillSession', NULL, '修改秒杀场次', '/admin/seckill', '[{\"id\":4,\"couponId\":10,\"sessionName\":\"功能预热\",\"startTime\":\"2026-05-30T20:53:00\",\"endTime\":\"2026-05-31T00:00:00\",\"seckillStock\":10,\"limitPerUser\":1}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-30 20:53:01');
INSERT INTO `operation_log` VALUES (87, 1, 'admin', 'UPDATE_SECKILL_SESSION', 'SeckillSession', NULL, '修改秒杀场次', '/admin/seckill', '[{\"id\":4,\"couponId\":10,\"sessionName\":\"功能预热\",\"startTime\":\"2026-05-30T20:55:00\",\"endTime\":\"2026-05-31T00:00:00\",\"seckillStock\":10,\"limitPerUser\":1}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-30 20:53:15');
INSERT INTO `operation_log` VALUES (88, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-30 20:54:55');
INSERT INTO `operation_log` VALUES (89, 1, 'admin', 'ADD_SECKILL_SESSION', 'SeckillSession', NULL, '新增秒杀场次', '/admin/seckill', '[{\"id\":null,\"couponId\":10,\"sessionName\":\"531热销\",\"startTime\":\"2026-05-31T00:00:00\",\"endTime\":\"2026-05-31T23:59:59\",\"seckillStock\":30,\"limitPerUser\":1}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-30 20:55:53');
INSERT INTO `operation_log` VALUES (90, 5, 'bob', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-30 21:00:25');
INSERT INTO `operation_log` VALUES (91, 1, 'admin', 'Change_Status', 'Product', 13, '修改商品状态', '/api/product/status/13', '[13,0]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-07-22 16:36:24');
INSERT INTO `operation_log` VALUES (92, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-07-22 16:36:45');
INSERT INTO `operation_log` VALUES (93, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2026-07-22 16:36:49');
INSERT INTO `operation_log` VALUES (94, 6, 'star', 'Cancle_Order', 'Order', 30, '取消订单', '/api/order/cancel/30', '[30,\"Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiVVNFUiIsInN2ZXIiOjUsInVzZXJJZCI6Niwic3ViIjoic3RhciIsImlhdCI6MTc4NDcwOTQzOSwiZXhwIjoxNzg0NzIzODM5fQ.2jaLHSp7R9PLVXHsATA6YfCQpnWHWkZV-XNiovalWoY\"]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-07-22 16:38:31');
INSERT INTO `operation_log` VALUES (95, 1, 'admin', 'AUDIT_REFUND', 'Refund', NULL, '审核退款申请', '/api/admin/refund/audit', '[{\"refundId\":7,\"status\":2,\"remark\":\"\",\"operatorRole\":\"ADMIN\"},\"Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiQURNSU4iLCJzdmVyIjoyNiwidXNlcklkIjoxLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc4NTI5MTU3OSwiZXhwIjoxNzg1MzA1OTc5fQ.HjXh4RfBu6DGoZtu4V-S9qt8nLeiFsR95j-wzJvfEE0\"]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-07-29 10:19:49');
INSERT INTO `operation_log` VALUES (96, 1, 'admin', 'AUDIT_REFUND', 'Refund', NULL, '审核退款申请', '/api/admin/refund/audit', '[{\"refundId\":7,\"status\":4,\"remark\":\"管理员执行退款\",\"operatorRole\":\"ADMIN\"},\"Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiQURNSU4iLCJzdmVyIjoyNiwidXNlcklkIjoxLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc4NTI5MTU3OSwiZXhwIjoxNzg1MzA1OTc5fQ.HjXh4RfBu6DGoZtu4V-S9qt8nLeiFsR95j-wzJvfEE0\"]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-07-29 10:19:52');
INSERT INTO `operation_log` VALUES (97, 1, 'admin', 'AUDIT_REFUND', 'Refund', NULL, '审核退款申请', '/api/admin/refund/audit', '[{\"refundId\":8,\"status\":2,\"remark\":\"\",\"operatorRole\":\"ADMIN\"},\"Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiQURNSU4iLCJzdmVyIjoyNywidXNlcklkIjoxLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc4NTI5NzE4NCwiZXhwIjoxNzg1MzExNTg0fQ.hDkRgmh5Vp8xB-kCqvp0oOHY9CQ-8lT7DfdSV5ekKAI\"]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-07-29 11:53:17');
INSERT INTO `operation_log` VALUES (98, 1, 'admin', 'AUDIT_REFUND', 'Refund', NULL, '审核退款申请', '/api/admin/refund/audit', '[{\"refundId\":8,\"status\":4,\"remark\":\"管理员执行退款\",\"operatorRole\":\"ADMIN\"},\"Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiQURNSU4iLCJzdmVyIjoyNywidXNlcklkIjoxLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc4NTI5NzE4NCwiZXhwIjoxNzg1MzExNTg0fQ.hDkRgmh5Vp8xB-kCqvp0oOHY9CQ-8lT7DfdSV5ekKAI\"]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-07-29 11:53:19');
INSERT INTO `operation_log` VALUES (99, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-07-29 15:06:24');
INSERT INTO `operation_log` VALUES (100, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-08-01 09:22:59');
INSERT INTO `operation_log` VALUES (101, 1, 'admin', 'Add_Category', 'Category', NULL, '添加分类', '/api/category', '[{\"id\":15,\"name\":\"护肤品\",\"parentId\":null,\"level\":1,\"sortOrder\":0,\"status\":null,\"createTime\":\"2026-08-01T09:24:17.2396792\",\"updateTime\":\"2026-08-01T09:24:17.2396792\",\"deleted\":null,\"children\":[]}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-08-01 09:24:17');
INSERT INTO `operation_log` VALUES (102, 1, 'admin', 'ADD_SECKILL_SESSION', 'SeckillSession', NULL, '新增秒杀场次', '/admin/seckill', '[{\"id\":null,\"couponId\":1,\"sessionName\":\"81大促\",\"startTime\":\"2026-08-01T10:00:00\",\"endTime\":\"2026-08-01T12:00:00\",\"seckillStock\":20,\"limitPerUser\":1}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-08-01 09:26:37');
INSERT INTO `operation_log` VALUES (103, 1, 'admin', 'PREHEAT_SECKILL', 'SeckillSession', 6, '预热秒杀库存', '/admin/seckill/preheat/6', '[6]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-08-01 09:26:42');

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_id` bigint NOT NULL,
  `total_amount` decimal(10, 2) NOT NULL,
  `pay_amount` decimal(10, 2) NULL DEFAULT NULL,
  `type` tinyint NULL DEFAULT 1,
  `pay_status` tinyint NULL DEFAULT 0,
  `order_status` tinyint NULL DEFAULT 0,
  `receiver_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `receiver_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `receiver_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `pay_time` datetime NULL DEFAULT NULL,
  `finish_time` datetime NULL DEFAULT NULL,
  `cancel_time` datetime NULL DEFAULT NULL,
  `deleted` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES (33, '1785231745150d32c679a', 5, 25.00, 25.00, 1, 0, 4, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-28 17:42:25', NULL, NULL, '2026-07-29 09:10:00', 0);
INSERT INTO `order` VALUES (34, '1785288307763c1ac3bb6', 5, 8.00, 6.00, 1, 1, 1, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-29 09:25:08', '2026-07-29 09:25:32', NULL, NULL, 0);
INSERT INTO `order` VALUES (35, '1785291448957944bf3ff', 5, 7999.00, 7999.00, 1, 1, 6, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-29 10:17:29', '2026-07-29 10:17:36', NULL, NULL, 0);
INSERT INTO `order` VALUES (36, '178529228815605585f78', 5, 25.00, 23.00, 1, 1, 3, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-29 10:31:28', '2026-07-29 10:31:34', '2026-07-29 10:32:12', NULL, 0);
INSERT INTO `order` VALUES (37, '17852938863125423eb47', 5, 25.00, 25.00, 1, 1, 1, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-29 10:58:06', '2026-07-29 10:58:14', NULL, NULL, 0);
INSERT INTO `order` VALUES (38, '17852941854690fda4ec3', 5, 25.00, 25.00, 1, 1, 1, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-29 11:03:05', '2026-07-29 11:03:11', NULL, NULL, 0);
INSERT INTO `order` VALUES (39, '1785295068774c0058901', 5, 200.00, 200.00, 1, 1, 1, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-29 11:17:49', '2026-07-29 11:17:54', NULL, NULL, 0);
INSERT INTO `order` VALUES (40, '1785296648140c71b68f0', 5, 3000.00, 3000.00, 1, 1, 6, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-29 11:44:08', '2026-07-29 11:44:14', NULL, NULL, 0);
INSERT INTO `order` VALUES (41, '1785312408401ea0735a5', 6, 849.00, 849.00, 1, 1, 1, '星', '13887654321', '广东省深圳市福田区华强北3号', '', '2026-07-29 16:06:48', '2026-07-29 16:06:54', NULL, NULL, 0);
INSERT INTO `order` VALUES (42, '1785550466941bb56cd7a', 8, 25.00, 23.00, 1, 1, 1, 'WU', '123215313', '广东汕头潮南峡山街道金狮商场513', '', '2026-08-01 10:14:27', '2026-08-01 10:14:32', NULL, NULL, 0);
INSERT INTO `order` VALUES (43, '1785552005639f291d4bf', 14, 6499.00, 6499.00, 1, 0, 4, 't', '13800000008', 'gdsznsx1', NULL, '2026-08-01 10:40:06', NULL, NULL, '2026-08-01 11:15:00', 0);

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `shipment_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `sku_id` bigint NULL DEFAULT NULL COMMENT '选中的SKU ID',
  `sku_specs` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规格组合描述',
  `product_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `product_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `price` decimal(10, 2) NOT NULL,
  `quantity` int NOT NULL,
  `total_price` decimal(10, 2) GENERATED ALWAYS AS ((`price` * `quantity`)) STORED NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_shipment`(`shipment_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_item
-- ----------------------------
INSERT INTO `order_item` VALUES (42, 33, 54, 14, NULL, NULL, '笔', '/uploads/2026-07-28/fd6252cd-def3-49db-90bc-217d67904724.jpg', 25.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (43, 34, 55, 11, NULL, NULL, '袜子', '/uploads/2026-05-17/0864dd02-c8dc-4428-b3aa-e7a5c6f1164d.jpg', 8.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (44, 35, 56, 3, NULL, NULL, 'Apple iPhone 15 Pro', '/uploads/2026-05-16/79404ffc-8d49-47d2-81f6-8e4d168838fb.jpg', 7999.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (45, 36, 57, 14, NULL, NULL, '笔', '/uploads/2026-07-28/fd6252cd-def3-49db-90bc-217d67904724.jpg', 25.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (46, 37, 58, 15, 42, '个数:10', ' “软绵绵”面包', '/uploads/2026-07-29/217e8f09-f7ce-4676-a33d-f307d29ae4db.jpg', 25.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (47, 38, 59, 14, NULL, NULL, '笔', '/uploads/2026-07-28/fd6252cd-def3-49db-90bc-217d67904724.jpg', 25.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (48, 39, 60, 15, 44, '个数:10', ' “软绵绵”面包', '/uploads/2026-07-29/217e8f09-f7ce-4676-a33d-f307d29ae4db.jpg', 20.00, 10, DEFAULT);
INSERT INTO `order_item` VALUES (49, 40, 61, 15, 45, '个数:20', ' “软绵绵”面包', '/uploads/2026-07-29/217e8f09-f7ce-4676-a33d-f307d29ae4db.jpg', 30.00, 100, DEFAULT);
INSERT INTO `order_item` VALUES (50, 41, 62, 6, NULL, NULL, '罗技 MX Master 3S 鼠标', '', 599.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (51, 41, 62, 12, 36, '颜色:白色', '自行车', '/uploads/2026-05-17/b1697f80-8579-47bc-8248-0bdf55c17ab9.jpeg', 150.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (52, 41, 62, 10, 30, '尺码:42', '球鞋', '/uploads/2026-05-17/d369112f-db52-434e-88cd-fa9c07168f19.jpeg', 100.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (53, 42, 63, 14, NULL, NULL, '笔', '/uploads/2026-07-28/fd6252cd-def3-49db-90bc-217d67904724.jpg', 25.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (54, 43, 64, 2, 3, '存储:256GB, 颜色:雅丹黑', '华为 Mate 60 Pro', '/uploads/2026-05-17/ac3a98e5-0469-4b3c-afad-d029a5f4420a.jpg', 6499.00, 1, DEFAULT);

-- ----------------------------
-- Table structure for order_shipment
-- ----------------------------
DROP TABLE IF EXISTS `order_shipment`;
CREATE TABLE `order_shipment`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL COMMENT '关联订单ID',
  `seller_id` bigint NOT NULL COMMENT '商家ID',
  `delivery_status` tinyint NOT NULL DEFAULT 0 COMMENT '发货状态 0-待发货 1-已发货 2-已收货',
  `shipping_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '快递公司',
  `shipping_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '快递单号',
  `shipping_time` datetime NULL DEFAULT NULL COMMENT '发货时间',
  `received_time` datetime NULL DEFAULT NULL COMMENT '收货时间',
  `total_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '本单商品总额',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE,
  INDEX `idx_seller`(`seller_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '发货单（按商家拆分的履约单元）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_shipment
-- ----------------------------
INSERT INTO `order_shipment` VALUES (54, 33, 5, 0, NULL, NULL, NULL, NULL, 25.00, '2026-07-28 17:42:25');
INSERT INTO `order_shipment` VALUES (55, 34, 3, 0, NULL, NULL, NULL, NULL, 8.00, '2026-07-29 09:25:08');
INSERT INTO `order_shipment` VALUES (56, 35, 2, 0, NULL, NULL, NULL, NULL, 7999.00, '2026-07-29 10:17:29');
INSERT INTO `order_shipment` VALUES (57, 36, 5, 2, '顺风', 'QW252512', '2026-07-29 10:31:59', '2026-07-29 10:32:12', 25.00, '2026-07-29 10:31:28');
INSERT INTO `order_shipment` VALUES (58, 37, 5, 0, NULL, NULL, NULL, NULL, 25.00, '2026-07-29 10:58:06');
INSERT INTO `order_shipment` VALUES (59, 38, 5, 0, NULL, NULL, NULL, NULL, 25.00, '2026-07-29 11:03:05');
INSERT INTO `order_shipment` VALUES (60, 39, 5, 0, NULL, NULL, NULL, NULL, 200.00, '2026-07-29 11:17:49');
INSERT INTO `order_shipment` VALUES (61, 40, 5, 1, '顺风', '12312312', '2026-07-29 11:54:25', NULL, 3000.00, '2026-07-29 11:44:08');
INSERT INTO `order_shipment` VALUES (62, 41, 3, 0, NULL, NULL, NULL, NULL, 849.00, '2026-07-29 16:06:48');
INSERT INTO `order_shipment` VALUES (63, 42, 5, 0, NULL, NULL, NULL, NULL, 25.00, '2026-08-01 10:14:27');
INSERT INTO `order_shipment` VALUES (64, 43, 2, 0, NULL, NULL, NULL, NULL, 6499.00, '2026-08-01 10:40:06');

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name_pinyin` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `category_id` bigint NULL DEFAULT NULL,
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `price` decimal(10, 2) NOT NULL,
  `stock` int NOT NULL DEFAULT 0,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` tinyint NULL DEFAULT 1 COMMENT '0-下架 1-上架',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0,
  `sales` int NULL DEFAULT 0 COMMENT '销量',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_merchant`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES (1, '小米14 Ultra 白色限量版', 'xiao mi 1 4   U l t r a   bai se xian liang ban', 2, 2, 6999.00, 0, '白色陶瓷机身，徕卡四摄，限量版', '/uploads/2026-07-29/a37dd820-d69a-4083-a448-2c8076a695e0.png', 1, '2026-05-11 17:02:05', '2026-07-29 11:01:45', 0, 0);
INSERT INTO `product` VALUES (2, '华为 Mate 60 Pro', 'hua wei   M a t e   6 0   P r o', 2, 2, 6999.00, 27, '卫星通话，鸿蒙OS，玄武架构，超光变主摄', '/uploads/2026-05-17/ac3a98e5-0469-4b3c-afad-d029a5f4420a.jpg', 1, '2026-05-11 17:02:05', '2026-07-29 11:01:47', 0, 5);
INSERT INTO `product` VALUES (3, 'Apple iPhone 15 Pro', 'A p p l e   i P h o n e   1 5   P r o', 2, 2, 7999.00, 19, 'A17 Pro芯片，钛金属边框，4800万主摄', '/uploads/2026-05-16/79404ffc-8d49-47d2-81f6-8e4d168838fb.jpg', 1, '2026-05-11 17:02:05', '2026-07-29 11:01:49', 0, 2);
INSERT INTO `product` VALUES (4, '联想拯救者 Y9000P 笔记本电脑', 'lianxiang', 3, 2, 8999.00, 14, 'i9-13900HX RTX4060 2.5K屏 240Hz', 'https://picsum.photos/800/400?random=4', 1, '2026-05-11 17:02:05', '2026-07-29 11:01:51', 0, 1);
INSERT INTO `product` VALUES (5, '耐克 Air Max 90 运动鞋', 'nai ke   A i r   M a x   9 0   yun dong xie', 5, 3, 129.00, 95, '经典复古，透气缓震，橡胶大底', '/uploads/2026-05-21/82f0d924-4cf7-44ad-b2e9-59fb8cfea61f.jpg', 1, '2026-05-11 17:02:05', '2026-07-29 11:01:52', 0, 4);
INSERT INTO `product` VALUES (6, '罗技 MX Master 3S 鼠标', 'luo ji   M X   M a s t e r   3 S   shu biao', 3, 3, 599.00, 59, '8000DPI，静音滚轮，跨设备控制', '/uploads/2026-07-29/84494e85-4fdd-4b88-80e4-2d04103f17a0.png', 1, '2026-05-11 17:02:05', '2026-07-29 11:30:10', 0, 0);
INSERT INTO `product` VALUES (7, '华为 FreeBuds Pro 3', 'hua wei   F r e e B u d s   P r o   3', 2, 2, 1499.00, 200, '超强降噪，星闪连接，智慧动态降噪3.0', '/uploads/2026-07-29/643fd90a-df07-4b62-b9c3-0e2bfe0c65bc.png', 1, '2026-05-11 20:35:46', '2026-07-29 11:30:15', 0, 0);
INSERT INTO `product` VALUES (8, '惠普电脑 暗影精灵', 'hui pu dian nao   an ying jing ling', 3, 2, 7562.00, 23, '办公娱乐的不二之选', '/uploads/2026-05-16/423db857-b9da-4dd8-ae9d-a5c180ad87a8.jpg', 1, '2026-05-13 17:38:00', '2026-07-29 11:01:54', 0, 2);
INSERT INTO `product` VALUES (9, '羽毛球', 'yu mao qiu', 8, 3, 80.00, 149, '耐打。飞行稳定', '/uploads/2026-05-21/488894a5-fd55-4ab2-af2a-1a90cf4b9cb2.jpg', 1, '2026-05-16 20:09:51', '2026-07-29 11:01:56', 0, 1);
INSERT INTO `product` VALUES (10, '球鞋', 'qiu xie', 9, 3, 100.00, 347, '跑步舒适', '/uploads/2026-05-17/d369112f-db52-434e-88cd-fa9c07168f19.jpeg', 1, '2026-05-17 17:20:04', '2026-07-29 11:01:58', 0, 3);
INSERT INTO `product` VALUES (11, '袜子', 'wa zi', 8, 3, 8.00, 500, '舒适易干', '/uploads/2026-05-17/0864dd02-c8dc-4428-b3aa-e7a5c6f1164d.jpg', 1, '2026-05-17 17:21:28', '2026-07-29 11:01:59', 0, 1);
INSERT INTO `product` VALUES (12, '自行车', 'zi xing che', 6, 3, 150.00, 17, '出行便利，锻炼身体的不二之选', '/uploads/2026-05-17/b1697f80-8579-47bc-8248-0bdf55c17ab9.jpeg', 1, '2026-05-17 17:22:42', '2026-07-29 11:02:05', 0, 4);
INSERT INTO `product` VALUES (13, '【180粒/瓶98%高纯度加强版】加拿大原装正品进口深海鱼油Omega3', '【 1 8 0 li / ping 9 8 % gao chun du jia qiang ban 】 jia na da yuan zhuang zheng pin jin kou shen hai yu you O m e g a 3', 10, 5, 79.90, 99, '【180粒/瓶98%高纯度加强版】加拿大原装正品进口深海鱼油Omega3', '/uploads/2026-05-20/ddec6125-7563-4bc4-80bb-a88ff4d51bb1.jpg', 1, '2026-05-20 16:30:03', '2026-07-29 11:03:33', 0, 0);
INSERT INTO `product` VALUES (14, '笔', 'bi', 14, 5, 25.00, 1997, '20支限量优惠', '/uploads/2026-07-28/fd6252cd-def3-49db-90bc-217d67904724.jpg', 1, '2026-07-28 17:41:52', '2026-07-28 17:41:52', 0, 3);
INSERT INTO `product` VALUES (15, ' “软绵绵”面包', '  “ ruan mian mian ” mian bao', 13, 5, 25.00, 389, '健康好吃', '/uploads/2026-07-29/217e8f09-f7ce-4676-a33d-f307d29ae4db.jpg', 1, '2026-07-29 10:36:11', '2026-07-29 11:35:28', 0, 111);
INSERT INTO `product` VALUES (16, '纸巾', 'zhi jin', 14, 5, 20.00, 1000, '纸质舒适便宜', '/uploads/2026-08-01/f379b151-7bc3-4876-a268-ae461a66e4f2.jpg', 1, '2026-08-01 09:37:49', '2026-08-01 09:37:49', 0, 0);
INSERT INTO `product` VALUES (17, '7A抗菌男士毛巾', '7 A kang jun nan shi mao jin', 14, 5, 15.80, 330, '7A抗菌男士毛巾洗脸洗澡超强吸水不易掉毛高档男款瞬吸速干A类', '/uploads/2026-08-01/9440dce2-ba39-4b26-80e0-715f1308f254.jpg', 1, '2026-08-01 09:53:44', '2026-08-01 09:53:44', 0, 0);

-- ----------------------------
-- Table structure for product_comment
-- ----------------------------
DROP TABLE IF EXISTS `product_comment`;
CREATE TABLE `product_comment`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `rating` tinyint NOT NULL DEFAULT 0 COMMENT '评分1-5',
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '评论内容',
  `images` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片URL列表，JSON数组格式',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-隐藏 1-正常',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父评论ID（0为顶级评论），用于楼中楼',
  `reply_user_id` bigint NULL DEFAULT NULL COMMENT '被回复的用户ID',
  `reply_content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '回复内容',
  `like_count` int NULL DEFAULT 0 COMMENT '点赞数',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product`(`product_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_parent`(`parent_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_comment
-- ----------------------------
INSERT INTO `product_comment` VALUES (1, 1, 1, 5, '非常好用，性价比高！', NULL, 1, 0, NULL, NULL, 0, '2026-05-14 21:49:55', '2026-05-14 21:49:55', 0);
INSERT INTO `product_comment` VALUES (2, 1, 2, 4, '还不错，物流很快。', NULL, 1, 0, NULL, NULL, 0, '2026-05-14 21:49:55', '2026-05-14 21:49:55', 0);
INSERT INTO `product_comment` VALUES (3, 2, 1, 3, '一般般，没有想象中好。', NULL, 1, 0, NULL, NULL, 0, '2026-05-14 21:49:55', '2026-05-14 21:49:55', 0);
INSERT INTO `product_comment` VALUES (4, 8, 5, 5, '真不错，推荐', NULL, 1, 0, NULL, NULL, 0, '2026-05-15 18:17:36', '2026-05-15 18:17:36', 0);
INSERT INTO `product_comment` VALUES (5, 11, 6, 5, '袜子不错', NULL, 1, 0, NULL, NULL, 0, '2026-05-24 16:11:34', '2026-05-24 16:11:34', 0);
INSERT INTO `product_comment` VALUES (6, 1, 6, 0, NULL, NULL, 1, 1, 1, '好的', 0, '2026-05-24 16:20:10', '2026-05-24 16:20:10', 0);
INSERT INTO `product_comment` VALUES (7, 1, 6, 0, NULL, NULL, 1, 1, 1, '好的', 0, '2026-05-24 16:20:30', '2026-05-24 16:20:30', 0);
INSERT INTO `product_comment` VALUES (8, 9, 13, 5, '球很耐打，飞行也不错，适合普通球友', NULL, 1, 0, NULL, NULL, 0, '2026-05-30 17:13:31', '2026-05-30 17:13:31', 0);
INSERT INTO `product_comment` VALUES (9, 2, 6, 0, NULL, NULL, 1, 3, 1, '就是有点小贵', 0, '2026-07-22 16:39:39', '2026-07-22 16:39:39', 0);

-- ----------------------------
-- Table structure for product_image
-- ----------------------------
DROP TABLE IF EXISTS `product_image`;
CREATE TABLE `product_image`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '图片URL',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品图片表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_image
-- ----------------------------
INSERT INTO `product_image` VALUES (8, 8, '/uploads/2026-05-16/c4984547-78f6-4706-b91c-e5963bba0f09.jpg', 0);
INSERT INTO `product_image` VALUES (9, 8, '/uploads/2026-05-16/21c2d29f-c58b-46f9-8525-4aed91bbac94.jpg', 1);
INSERT INTO `product_image` VALUES (10, 8, '/uploads/2026-05-16/b609ec31-4783-4ad1-b505-78eab0ba6256.jpg', 2);
INSERT INTO `product_image` VALUES (11, 8, '/uploads/2026-05-16/3622cc17-af83-4943-ba75-5b432e6d082d.jpg', 3);
INSERT INTO `product_image` VALUES (12, 8, '/uploads/2026-05-16/8c630e6c-49f2-4705-86fb-8e75cae21af0.jpg', 4);
INSERT INTO `product_image` VALUES (13, 8, '/uploads/2026-05-16/4d20a1a7-ff53-4814-985e-48e6fc7f48bc.jpg', 5);
INSERT INTO `product_image` VALUES (16, 3, '/uploads/2026-05-16/4e443c9a-2879-4cfb-9179-83de0f75e383.jpg', 0);
INSERT INTO `product_image` VALUES (17, 3, '/uploads/2026-05-16/6e80ad14-a9e3-41f3-adcd-e40c602f8371.jpg', 1);
INSERT INTO `product_image` VALUES (18, 3, '/uploads/2026-05-16/afa2067e-c5cb-4176-a92f-714775c70e97.jpg', 2);
INSERT INTO `product_image` VALUES (19, 10, '/uploads/2026-05-17/d3f1227c-9d84-4d87-852e-9125d96c5dd7.jpeg', 0);
INSERT INTO `product_image` VALUES (20, 11, '/uploads/2026-05-17/22bb51b6-c15e-4518-ba16-8329b042e320.jpg', 0);
INSERT INTO `product_image` VALUES (21, 12, '/uploads/2026-05-17/d7e2991c-eb90-405b-9e26-e6e1da3038bb.jpeg', 0);
INSERT INTO `product_image` VALUES (22, 2, '/uploads/2026-05-16/f1bb6a29-1311-4b16-8407-15a82fb609f8.jpg', 0);
INSERT INTO `product_image` VALUES (23, 2, '/uploads/2026-05-16/9c256373-44f4-48da-83c1-c9b692ca0e39.jpg', 1);
INSERT INTO `product_image` VALUES (24, 13, '/uploads/2026-05-20/6f205f1d-9135-4e56-99ff-e7ffb8c65ed3.jpg', 0);
INSERT INTO `product_image` VALUES (25, 13, '/uploads/2026-05-20/fb8ba99b-7ea9-4cc7-86e4-02bd824acdb8.jpg', 1);
INSERT INTO `product_image` VALUES (26, 13, '/uploads/2026-05-20/b46b45ec-657d-4ee2-b018-7a681133ca9e.jpg', 2);
INSERT INTO `product_image` VALUES (27, 5, '/uploads/2026-05-21/85b29c57-775e-4050-9d6b-61f549268085.jpg', 0);
INSERT INTO `product_image` VALUES (28, 5, '/uploads/2026-05-21/d624acf2-97bc-447b-b073-d6763ad2160a.jpg', 1);
INSERT INTO `product_image` VALUES (29, 5, '/uploads/2026-05-21/39f0bad9-8f08-4de6-a070-b3333ce8b518.jpg', 2);
INSERT INTO `product_image` VALUES (30, 5, '/uploads/2026-05-21/a8b68cb7-ae49-4a9d-beb8-e8884e48d345.jpg', 3);
INSERT INTO `product_image` VALUES (31, 9, '/uploads/2026-05-16/ac230f77-ca0c-4f02-b767-a9d9aaaab103.jpg', 0);
INSERT INTO `product_image` VALUES (32, 9, '/uploads/2026-05-16/8852042a-e0ed-41ae-aeb5-a304e77c25de.jpg', 1);
INSERT INTO `product_image` VALUES (38, 14, '/uploads/2026-07-28/2774359c-638b-45a0-8c88-f2ff9dd7896b.jpg', 0);
INSERT INTO `product_image` VALUES (43, 15, '/uploads/2026-07-29/59071ca1-ebe5-4c05-9da1-c446eca712e8.jpg', 0);
INSERT INTO `product_image` VALUES (44, 7, '/uploads/2026-07-29/01b63987-a7bd-4dd8-9a64-73eaeaf7b9c8.png', 0);
INSERT INTO `product_image` VALUES (45, 7, '/uploads/2026-07-29/e209650b-2a9c-47ab-9688-c888d2d139cb.png', 1);
INSERT INTO `product_image` VALUES (46, 1, '/uploads/2026-07-29/d249c5b2-3950-40f4-ad1c-9884297e5b19.png', 0);
INSERT INTO `product_image` VALUES (47, 6, '/uploads/2026-07-29/4a1c8108-0884-4cdb-8c3b-ff07d8c457a9.png', 0);
INSERT INTO `product_image` VALUES (48, 6, '/uploads/2026-07-29/0c9f8c80-7982-4d93-b88c-22733adfb07f.png', 1);
INSERT INTO `product_image` VALUES (49, 16, '/uploads/2026-08-01/39439d2f-fdeb-4517-83b9-1b39c71a5443.jpg', 0);
INSERT INTO `product_image` VALUES (50, 17, '/uploads/2026-08-01/cf3c1638-003c-4d01-addc-25dfe9f38292.jpg', 0);

-- ----------------------------
-- Table structure for product_size_chart
-- ----------------------------
DROP TABLE IF EXISTS `product_size_chart`;
CREATE TABLE `product_size_chart`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `chart_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '尺寸表' COMMENT '尺寸表标题',
  `columns_json` json NOT NULL COMMENT '列头定义',
  `rows_json` json NOT NULL COMMENT '行数据',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_product`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_size_chart
-- ----------------------------
INSERT INTO `product_size_chart` VALUES (1, 14, '尺寸表', '[\"大小\"]', '[[\"20cm\"], [\"30cm\"]]');
INSERT INTO `product_size_chart` VALUES (2, 15, '面包个数对照表', '[\"个数\", \"价格\"]', '[[\"10个\", \"20\"], [\"20个\", \"30\"]]');

-- ----------------------------
-- Table structure for product_sku
-- ----------------------------
DROP TABLE IF EXISTS `product_sku`;
CREATE TABLE `product_sku`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `specs` json NOT NULL COMMENT '规格组合',
  `price` decimal(10, 2) NOT NULL COMMENT 'SKU售价',
  `stock` int NOT NULL DEFAULT 0 COMMENT 'SKU库存',
  `sku_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'SKU编码',
  `image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'SKU专属图片',
  `sales` int NULL DEFAULT 0 COMMENT 'SKU销量',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 60 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_sku
-- ----------------------------
INSERT INTO `product_sku` VALUES (3, 2, '{\"存储\": \"256GB\", \"颜色\": \"雅丹黑\"}', 6499.00, 10, 'HWM60P-BK-256', NULL, 2);
INSERT INTO `product_sku` VALUES (4, 2, '{\"存储\": \"512GB\", \"颜色\": \"雅丹黑\"}', 6999.00, 8, 'HWM60P-BK-512', NULL, 2);
INSERT INTO `product_sku` VALUES (5, 2, '{\"存储\": \"256GB\", \"颜色\": \"白沙银\"}', 6499.00, 5, 'HWM60P-SV-256', NULL, 1);
INSERT INTO `product_sku` VALUES (6, 2, '{\"存储\": \"512GB\", \"颜色\": \"白沙银\"}', 6999.00, 4, 'HWM60P-SV-512', NULL, 0);
INSERT INTO `product_sku` VALUES (7, 3, '{\"存储\": \"256GB\", \"颜色\": \"原色钛\"}', 7999.00, 8, 'IP15P-NT-256', NULL, 1);
INSERT INTO `product_sku` VALUES (8, 3, '{\"存储\": \"512GB\", \"颜色\": \"原色钛\"}', 8999.00, 5, 'IP15P-NT-512', NULL, 1);
INSERT INTO `product_sku` VALUES (9, 3, '{\"存储\": \"256GB\", \"颜色\": \"白色钛\"}', 7999.00, 4, 'IP15P-WT-256', NULL, 0);
INSERT INTO `product_sku` VALUES (10, 3, '{\"存储\": \"512GB\", \"颜色\": \"白色钛\"}', 8999.00, 2, 'IP15P-WT-512', NULL, 0);
INSERT INTO `product_sku` VALUES (11, 4, '{\"配置\": \"i9+4060\"}', 8999.00, 8, 'Y9K-i9-4060', NULL, 1);
INSERT INTO `product_sku` VALUES (12, 4, '{\"配置\": \"i9+4070\"}', 10999.00, 6, 'Y9K-i9-4070', NULL, 0);
INSERT INTO `product_sku` VALUES (13, 5, '{\"尺码\": \"39\", \"颜色\": \"黑白\"}', 129.00, 10, 'AM90-BW-39', NULL, 1);
INSERT INTO `product_sku` VALUES (14, 5, '{\"尺码\": \"40\", \"颜色\": \"黑白\"}', 129.00, 15, 'AM90-BW-40', NULL, 1);
INSERT INTO `product_sku` VALUES (15, 5, '{\"尺码\": \"41\", \"颜色\": \"黑白\"}', 129.00, 12, 'AM90-BW-41', NULL, 1);
INSERT INTO `product_sku` VALUES (16, 5, '{\"尺码\": \"42\", \"颜色\": \"黑白\"}', 129.00, 8, 'AM90-BW-42', NULL, 1);
INSERT INTO `product_sku` VALUES (17, 5, '{\"尺码\": \"43\", \"颜色\": \"黑白\"}', 129.00, 0, 'AM90-BW-43', NULL, 0);
INSERT INTO `product_sku` VALUES (18, 5, '{\"尺码\": \"39\", \"颜色\": \"红白\"}', 129.00, 8, 'AM90-RW-39', NULL, 0);
INSERT INTO `product_sku` VALUES (19, 5, '{\"尺码\": \"40\", \"颜色\": \"红白\"}', 129.00, 12, 'AM90-RW-40', NULL, 0);
INSERT INTO `product_sku` VALUES (20, 5, '{\"尺码\": \"41\", \"颜色\": \"红白\"}', 129.00, 14, 'AM90-RW-41', NULL, 0);
INSERT INTO `product_sku` VALUES (21, 5, '{\"尺码\": \"42\", \"颜色\": \"红白\"}', 129.00, 10, 'AM90-RW-42', NULL, 0);
INSERT INTO `product_sku` VALUES (22, 5, '{\"尺码\": \"43\", \"颜色\": \"红白\"}', 129.00, 6, 'AM90-RW-43', NULL, 0);
INSERT INTO `product_sku` VALUES (23, 8, '{\"配置\": \"i5+4060\"}', 7562.00, 15, 'OMEN-i5-4060', NULL, 2);
INSERT INTO `product_sku` VALUES (24, 8, '{\"配置\": \"i7+4060\"}', 8999.00, 8, 'OMEN-i7-4060', NULL, 0);
INSERT INTO `product_sku` VALUES (25, 9, '{\"规格\": \"6只装\"}', 45.00, 80, 'BMT-6', NULL, 1);
INSERT INTO `product_sku` VALUES (26, 9, '{\"规格\": \"12只装\"}', 80.00, 69, 'BMT-12', NULL, 0);
INSERT INTO `product_sku` VALUES (27, 10, '{\"尺码\": \"39\"}', 100.00, 70, 'SHOE-39', NULL, 1);
INSERT INTO `product_sku` VALUES (28, 10, '{\"尺码\": \"40\"}', 100.00, 60, 'SHOE-40', NULL, 1);
INSERT INTO `product_sku` VALUES (29, 10, '{\"尺码\": \"41\"}', 100.00, 80, 'SHOE-41', NULL, 0);
INSERT INTO `product_sku` VALUES (30, 10, '{\"尺码\": \"42\"}', 100.00, 89, 'SHOE-42', NULL, 1);
INSERT INTO `product_sku` VALUES (31, 10, '{\"尺码\": \"43\"}', 100.00, 48, 'SHOE-43', NULL, 0);
INSERT INTO `product_sku` VALUES (32, 11, '{\"颜色\": \"黑色\"}', 8.00, 200, 'SOCK-BK', NULL, 1);
INSERT INTO `product_sku` VALUES (33, 11, '{\"颜色\": \"白色\"}', 8.00, 150, 'SOCK-WT', NULL, 0);
INSERT INTO `product_sku` VALUES (34, 11, '{\"颜色\": \"灰色\"}', 8.00, 150, 'SOCK-GY', NULL, 0);
INSERT INTO `product_sku` VALUES (35, 12, '{\"颜色\": \"黑色\"}', 150.00, 6, 'BIKE-BK', NULL, 1);
INSERT INTO `product_sku` VALUES (36, 12, '{\"颜色\": \"白色\"}', 150.00, 5, 'BIKE-WT', NULL, 2);
INSERT INTO `product_sku` VALUES (37, 12, '{\"颜色\": \"红色\"}', 150.00, 6, 'BIKE-RD', NULL, 1);
INSERT INTO `product_sku` VALUES (44, 15, '{\"个数\": \"10\"}', 20.00, 189, NULL, NULL, 11);
INSERT INTO `product_sku` VALUES (45, 15, '{\"个数\": \"20\"}', 30.00, 200, NULL, NULL, 100);
INSERT INTO `product_sku` VALUES (46, 1, '{\"存储\": \"512GB\"}', 6999.00, 0, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (47, 1, '{\"存储\": \"1TB\"}', 6999.00, 0, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (48, 6, '{\"颜色\": \"黑\"}', 599.00, 29, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (49, 6, '{\"颜色\": \"白\"}', 599.00, 30, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (50, 16, '{\"袋数\": \"1\", \"包数/袋\": \"20\"}', 24.00, 200, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (51, 16, '{\"袋数\": \"2\", \"包数/袋\": \"20\"}', 48.00, 300, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (52, 16, '{\"袋数\": \"1\", \"包数/袋\": \"30\"}', 30.00, 200, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (53, 16, '{\"袋数\": \"2\", \"包数/袋\": \"30\"}', 60.00, 300, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (54, 17, '{\"尺寸\": \"热销组合 【两条装：灰色 + 条纹】各一条\"}', 34.70, 50, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (55, 17, '{\"尺寸\": \"热销组合【4条装：灰色 + 条纹】各两条\"}', 50.80, 80, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (56, 17, '{\"尺寸\": \"男士专用 【2条装 ：条纹】有效抑菌-阴干不臭\"}', 34.70, 50, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (57, 17, '{\"尺寸\": \"男士专用 【2条装 ：灰色】有效抑菌-阴干不臭\"}', 15.80, 50, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (58, 17, '{\"尺寸\": \"男士专用 【1条装 ：条纹】有效抑菌-阴干不臭\"}', 15.80, 50, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (59, 17, '{\"尺寸\": \"男士专用 【1条装 ：灰色】有效抑菌-阴干不臭\"}', 15.80, 50, NULL, NULL, 0);

-- ----------------------------
-- Table structure for product_spec
-- ----------------------------
DROP TABLE IF EXISTS `product_spec`;
CREATE TABLE `product_spec`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `spec_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '规格名称（颜色/尺码/容量/配置...）',
  `spec_values` json NOT NULL COMMENT '可选值列表',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_spec
-- ----------------------------
INSERT INTO `product_spec` VALUES (2, 2, '颜色', '[\"雅丹黑\", \"白沙银\"]', 0);
INSERT INTO `product_spec` VALUES (3, 2, '存储', '[\"256GB\", \"512GB\"]', 1);
INSERT INTO `product_spec` VALUES (4, 3, '颜色', '[\"原色钛\", \"白色钛\"]', 0);
INSERT INTO `product_spec` VALUES (5, 3, '存储', '[\"256GB\", \"512GB\"]', 1);
INSERT INTO `product_spec` VALUES (6, 4, '配置', '[\"i9+4060\", \"i9+4070\"]', 0);
INSERT INTO `product_spec` VALUES (7, 5, '颜色', '[\"黑白\", \"红白\"]', 0);
INSERT INTO `product_spec` VALUES (8, 5, '尺码', '[\"39\", \"40\", \"41\", \"42\", \"43\"]', 1);
INSERT INTO `product_spec` VALUES (9, 8, '配置', '[\"i5+4060\", \"i7+4060\"]', 0);
INSERT INTO `product_spec` VALUES (10, 9, '规格', '[\"6只装\", \"12只装\"]', 0);
INSERT INTO `product_spec` VALUES (11, 10, '尺码', '[\"39\", \"40\", \"41\", \"42\", \"43\"]', 0);
INSERT INTO `product_spec` VALUES (12, 11, '颜色', '[\"黑色\", \"白色\", \"灰色\"]', 0);
INSERT INTO `product_spec` VALUES (13, 12, '颜色', '[\"黑色\", \"白色\", \"红色\"]', 0);
INSERT INTO `product_spec` VALUES (24, 15, '个数', '[\"10\", \"20\"]', 0);
INSERT INTO `product_spec` VALUES (25, 1, '存储', '[\"512GB\", \"1TB\"]', 0);
INSERT INTO `product_spec` VALUES (26, 6, '颜色', '[\"黑\", \"白\"]', 0);
INSERT INTO `product_spec` VALUES (27, 16, '包数/袋', '[\"20\", \"30\"]', 0);
INSERT INTO `product_spec` VALUES (28, 16, '袋数', '[\"1\", \"2\"]', 1);
INSERT INTO `product_spec` VALUES (29, 17, '尺寸', '[\"热销组合 【两条装：灰色 + 条纹】各一条\", \"热销组合【4条装：灰色 + 条纹】各两条\", \"男士专用 【2条装 ：条纹】有效抑菌-阴干不臭\", \"男士专用 【2条装 ：灰色】有效抑菌-阴干不臭\", \"男士专用 【1条装 ：条纹】有效抑菌-阴干不臭\", \"男士专用 【1条装 ：灰色】有效抑菌-阴干不臭\"]', 0);

-- ----------------------------
-- Table structure for promotion_activity
-- ----------------------------
DROP TABLE IF EXISTS `promotion_activity`;
CREATE TABLE `promotion_activity`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '活动名称',
  `type` tinyint NOT NULL COMMENT '活动类型：1-签到 2-抽奖 3-任务 4-限时抢券',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `coupon_id` bigint NOT NULL COMMENT '关联的优惠券ID',
  `total_quota` int NULL DEFAULT NULL COMMENT '总配额（null表示不限）',
  `daily_limit` int NULL DEFAULT NULL COMMENT '每日领取限制（null表示不限）',
  `per_user_limit` int NULL DEFAULT 1 COMMENT '每人总领取限制',
  `config` json NULL COMMENT '活动配置（如签到天数、抽奖概率等）',
  `status` tinyint NULL DEFAULT 1 COMMENT '0-禁用 1-启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_coupon`(`coupon_id` ASC) USING BTREE,
  INDEX `idx_time`(`start_time` ASC, `end_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of promotion_activity
-- ----------------------------

-- ----------------------------
-- Table structure for refund_application
-- ----------------------------
DROP TABLE IF EXISTS `refund_application`;
CREATE TABLE `refund_application`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `user_id` bigint NOT NULL COMMENT '申请人用户ID',
  `reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '退款原因',
  `reason_category_id` bigint NULL DEFAULT NULL COMMENT '退款原因分类ID',
  `status` tinyint NULL DEFAULT 0 COMMENT '0-待商户审核 1-待管理员审核 2-已通过 3-已拒绝 4-退款执行中 5-已退款',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核备注（拒绝原因）',
  `refund_amount` decimal(10, 2) NOT NULL COMMENT '退款金额（实付金额）',
  `apply_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `audit_time` datetime NULL DEFAULT NULL,
  `merchant_audit_time` datetime NULL DEFAULT NULL COMMENT '商户审核时间',
  `admin_audit_time` datetime NULL DEFAULT NULL COMMENT '管理员审核时间',
  `refund_time` datetime NULL DEFAULT NULL COMMENT '退款执行时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_reason_category`(`reason_category_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '退款申请表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of refund_application
-- ----------------------------
INSERT INTO `refund_application` VALUES (4, 34, 6, '', NULL, 5, NULL, 129.00, '2026-07-24 11:08:03', '2026-07-26 17:29:48', '2026-07-26 17:14:21', '2026-07-26 17:29:48', '2026-07-26 17:29:54');
INSERT INTO `refund_application` VALUES (7, 35, 5, '', 1, 5, NULL, 7999.00, '2026-07-29 10:17:43', '2026-07-29 10:19:49', '2026-07-29 10:18:56', '2026-07-29 10:19:49', '2026-07-29 10:19:52');
INSERT INTO `refund_application` VALUES (8, 40, 5, '', 3, 5, NULL, 3000.00, '2026-07-29 11:52:33', '2026-07-29 11:53:17', '2026-07-29 11:52:50', '2026-07-29 11:53:17', '2026-07-29 11:53:19');

-- ----------------------------
-- Table structure for refund_progress_log
-- ----------------------------
DROP TABLE IF EXISTS `refund_progress_log`;
CREATE TABLE `refund_progress_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `refund_id` bigint NOT NULL COMMENT '退款申请ID',
  `node_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '节点名称：申请提交/商户审核/管理员审核/退款执行/退款完成',
  `operator` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作人',
  `operator_role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作人角色：USER/MERCHANT/ADMIN',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_refund_id`(`refund_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '退款进度日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of refund_progress_log
-- ----------------------------
INSERT INTO `refund_progress_log` VALUES (1, 4, '商户审核', '商户5', 'MERCHANT', '通过', '2026-07-26 17:14:21');
INSERT INTO `refund_progress_log` VALUES (2, 4, '管理员审核', '管理员1', 'ADMIN', '通过', '2026-07-26 17:29:48');
INSERT INTO `refund_progress_log` VALUES (3, 4, '退款执行', '管理员1', 'ADMIN', '开始退款', '2026-07-26 17:29:54');
INSERT INTO `refund_progress_log` VALUES (4, 4, '退款完成', '管理员1', 'ADMIN', '退款已执行', '2026-07-26 17:29:54');
INSERT INTO `refund_progress_log` VALUES (23, 7, '申请提交', '用户5', 'USER', NULL, '2026-07-29 10:17:43');
INSERT INTO `refund_progress_log` VALUES (24, 7, '商户审核', '商户2', 'MERCHANT', '通过', '2026-07-29 10:18:56');
INSERT INTO `refund_progress_log` VALUES (25, 7, '管理员审核', '管理员1', 'ADMIN', '通过', '2026-07-29 10:19:49');
INSERT INTO `refund_progress_log` VALUES (26, 7, '退款执行', '管理员1', 'ADMIN', '开始退款', '2026-07-29 10:19:52');
INSERT INTO `refund_progress_log` VALUES (27, 7, '退款完成', '管理员1', 'ADMIN', '退款已执行', '2026-07-29 10:19:52');
INSERT INTO `refund_progress_log` VALUES (28, 8, '申请提交', '用户5', 'USER', NULL, '2026-07-29 11:52:33');
INSERT INTO `refund_progress_log` VALUES (29, 8, '商户审核', '商户5', 'MERCHANT', '通过', '2026-07-29 11:52:50');
INSERT INTO `refund_progress_log` VALUES (30, 8, '管理员审核', '管理员1', 'ADMIN', '通过', '2026-07-29 11:53:17');
INSERT INTO `refund_progress_log` VALUES (31, 8, '退款执行', '管理员1', 'ADMIN', '开始退款', '2026-07-29 11:53:19');
INSERT INTO `refund_progress_log` VALUES (32, 8, '退款完成', '管理员1', 'ADMIN', '退款已执行', '2026-07-29 11:53:19');

-- ----------------------------
-- Table structure for refund_reason_category
-- ----------------------------
DROP TABLE IF EXISTS `refund_reason_category`;
CREATE TABLE `refund_reason_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类描述',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NULL DEFAULT 1 COMMENT '0-禁用 1-启用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '退款原因分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of refund_reason_category
-- ----------------------------
INSERT INTO `refund_reason_category` VALUES (1, '商品质量问题', '收到商品有瑕疵/损坏/与描述不符', 1, 1);
INSERT INTO `refund_reason_category` VALUES (2, '发货问题', '未按时发货/发错商品/漏发', 2, 1);
INSERT INTO `refund_reason_category` VALUES (3, '不想要了', '7天无理由退货', 3, 1);
INSERT INTO `refund_reason_category` VALUES (4, '价格问题', '购买后降价/有更优价格', 4, 1);
INSERT INTO `refund_reason_category` VALUES (5, '其他原因', '其他退款理由', 5, 1);

-- ----------------------------
-- Table structure for refund_satisfaction
-- ----------------------------
DROP TABLE IF EXISTS `refund_satisfaction`;
CREATE TABLE `refund_satisfaction`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `refund_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `rating` tinyint NOT NULL COMMENT '评分 1-5',
  `feedback` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '反馈意见',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_refund`(`refund_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '退款满意度反馈' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of refund_satisfaction
-- ----------------------------

-- ----------------------------
-- Table structure for seckill_session
-- ----------------------------
DROP TABLE IF EXISTS `seckill_session`;
CREATE TABLE `seckill_session`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `coupon_id` bigint NOT NULL COMMENT '关联优惠券ID',
  `session_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '秒杀场次名称',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `seckill_stock` int NOT NULL DEFAULT 0 COMMENT '秒杀独立库存',
  `limit_per_user` int NOT NULL DEFAULT 1 COMMENT '每人限领',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0-待开始 1-进行中 2-已结束 3-已撤销',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_coupon_id`(`coupon_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_start_time`(`start_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '秒杀场次表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of seckill_session
-- ----------------------------
INSERT INTO `seckill_session` VALUES (1, 10, '521秒杀劵', '2026-05-21 00:00:00', '2026-05-21 00:00:01', 20, 1, 2, '2026-05-21 20:15:45', '2026-05-21 20:15:45', 0);
INSERT INTO `seckill_session` VALUES (2, 10, '521秒杀券2', '2026-05-21 20:23:00', '2026-05-21 23:25:00', 3, 1, 2, '2026-05-21 20:21:06', '2026-05-21 20:21:06', 0);
INSERT INTO `seckill_session` VALUES (3, 10, '预热功能测试', '2026-05-30 20:45:00', '2026-05-31 00:00:00', 5, 1, 3, '2026-05-30 20:44:40', '2026-05-30 20:44:40', 0);
INSERT INTO `seckill_session` VALUES (4, 10, '功能预热', '2026-05-30 20:55:00', '2026-05-31 00:00:00', 9, 1, 2, '2026-05-30 20:51:56', '2026-05-30 20:51:56', 0);
INSERT INTO `seckill_session` VALUES (5, 10, '531热销', '2026-05-31 00:00:00', '2026-05-31 23:59:59', 30, 1, 2, '2026-05-30 20:55:53', '2026-05-30 20:55:53', 0);
INSERT INTO `seckill_session` VALUES (6, 1, '81大促', '2026-08-01 10:00:00', '2026-08-01 12:00:00', 19, 1, 2, '2026-08-01 09:26:37', '2026-08-01 09:26:37', 0);

-- ----------------------------
-- Table structure for store_design
-- ----------------------------
DROP TABLE IF EXISTS `store_design`;
CREATE TABLE `store_design`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `background_color` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '#667eea' COMMENT '店铺头背景色',
  `banner_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '店铺头像URL',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_merchant_id`(`merchant_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家小店设计配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of store_design
-- ----------------------------
INSERT INTO `store_design` VALUES (1, 3, '#667eea', '/uploads/2026-07-24/5b9a9956-eac0-4608-8773-415580dd94eb.jpg', '2026-07-24 17:51:33', '2026-07-24 17:51:33');
INSERT INTO `store_design` VALUES (2, 2, '#e6a23c', '/uploads/2026-07-26/196b37f6-2f1e-46f5-91b8-5fe5cd591c5f.png', '2026-07-26 16:39:27', '2026-07-26 16:39:27');
INSERT INTO `store_design` VALUES (3, 5, '#667eea', '/uploads/2026-07-28/71d1edf5-fd8f-448c-b3cd-2380c6f61861.png', '2026-07-28 11:23:05', '2026-07-28 11:23:05');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知标题',
  `type` tinyint NULL DEFAULT 0 COMMENT '通知类型（0=系统公告 1=活动通知 2=订单提醒）',
  `level` tinyint NULL DEFAULT 0 COMMENT '通知等级（0=普通 1=重要 2=紧急）',
  `target_type` tinyint NOT NULL DEFAULT 1 COMMENT '目标类型（1-全体，2-指定用户）',
  `target_user_ids` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '指定用户ID，逗号分隔',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知内容（HTML）',
  `publisher_id` bigint NULL DEFAULT NULL COMMENT '发布人ID（关联user表）',
  `publisher_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '发布人姓名',
  `publish_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `revoke_time` datetime NULL DEFAULT NULL COMMENT '撤回时间',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态：0-草稿 1-已发布 2-已撤回',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `biz_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '涓氬姟绫诲瀷: new_order/order_paid/order_cancelled/new_message/reply_message',
  `biz_id` bigint NULL DEFAULT NULL COMMENT '涓氬姟ID (璁㈠崟ID/鐣欒█ID)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_publish_time`(`publish_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 156 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '📢 系统通知：电商平台上线公告', 0, 1, 1, NULL, '<h2 style=\"text-align: start;\">一、平台简介</h2><p style=\"text-align: start;\">欢迎来到 ShopSphere 电商平台！ 我们致力于为用户提供便捷、安全、高效的在线购物体验，同时为商家提供强大的店铺管理和营销工具。无论是买家还是卖家，都能在这里找到所需。</p><h2 style=\"text-align: start;\">二、已上线功能</h2><p style=\"text-align: start;\">👤 用户端 商品浏览与搜索：支持分类筛选、关键词搜索、商品详情查看。</p><p style=\"text-align: start;\">购物车：添加/删除商品、修改数量、一键结算。</p><p style=\"text-align: start;\">订单管理：下单、支付、取消订单、确认收货、查看历史订单。</p><p style=\"text-align: start;\">个人中心：资料修改、收货地址管理、我的收藏、我的通知。</p><p style=\"text-align: start;\">商家入驻申请：用户可提交申请成为商家，管理员审核通过后自动升级角色。</p><p style=\"text-align: start;\">🏪 商家端 商品管理：发布/编辑/上下架商品，支持封面图和相册图片上传。</p><p style=\"text-align: start;\">订单处理：查看订单明细、发货（填写快递单号）。</p><p style=\"text-align: start;\">统计数据：查看销售额、订单量趋势。</p><p style=\"text-align: start;\">我的入驻信息：查看审核状态及店铺资料。</p><p style=\"text-align: start;\">🔧 管理后台 用户管理：查询、冻结/解封用户（冻结后无法登录）。</p><p style=\"text-align: start;\">商品与分类管理：全平台商品审核、分类维护。</p><p style=\"text-align: start;\">订单管理：查看所有订单，处理售后（规划中）。</p><p style=\"text-align: start;\">商家入驻审核：查看申请资料，通过或拒绝，通过后自动变为商家角色。</p><p style=\"text-align: start;\">系统通知：发布通知（全体或指定用户），支持富文本内容，用户端可查看已读状态。</p><h2 style=\"text-align: start;\">三、待上线功能</h2><p style=\"text-align: start;\">🛒 优惠券系统：满减、折扣券，管理员可配置，用户结算时使用。</p><ul><li style=\"text-align: start;\">💬 商品评论与晒单：用户可评价商品，上传图片。</li></ul><ol><li style=\"text-align: start;\">📦 物流跟踪：集成快递接口，实时查询物流信息。</li></ol><p style=\"text-align: start;\">🔔 消息推送：WebSocket 实时通知订单状态变更。</p><p style=\"text-align: start;\">📊 数据大屏：实时展示平台交易额、用户活跃度等指标。</p><h2 style=\"text-align: start;\">四、欢迎使用</h2><p style=\"text-align: start;\">感谢你选择 ShopSphere！ 如果你在使用过程中遇到任何问题，或有改进建议，欢迎通过客服邮箱 support@shopsphere.com 联系我们。 祝您购物愉快，生意兴隆！</p><p style=\"text-align: start;\"><br></p><p style=\"text-align: start;\"><br></p><p style=\"text-align: start;\"><br></p><p style=\"text-align: start;\"><br></p>', 1, 'admin', '2026-05-18 17:32:19', NULL, 1, '2026-05-18 17:32:19', '2026-05-18 17:33:30', NULL, NULL);
INSERT INTO `sys_notice` VALUES (2, '新订单通知', 3, 0, 2, '2', '您有新的订单，订单号：177927785661587337b5f', 0, '系统', '2026-05-20 19:50:57', NULL, 1, '2026-05-20 19:50:57', '2026-05-20 22:21:23', 'new_order', 22);
INSERT INTO `sys_notice` VALUES (3, '订单取消通知', 3, 0, 2, '2', '订单 177927785661587337b5f 已被用户取消', 0, '系统', '2026-05-20 19:52:53', NULL, 1, '2026-05-20 19:52:53', '2026-05-20 22:21:26', 'order_cancelled', 22);
INSERT INTO `sys_notice` VALUES (4, '新订单通知', 3, 0, 2, '2', '您有新的订单，订单号：177927804713662b93d51', 0, '系统', '2026-05-20 19:54:07', NULL, 1, '2026-05-20 19:54:07', '2026-05-20 22:21:27', 'new_order', 23);
INSERT INTO `sys_notice` VALUES (5, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：177927804713662b93d51', 0, '系统', '2026-05-20 19:54:07', NULL, 1, '2026-05-20 19:54:07', '2026-05-20 22:21:29', 'new_order', 23);
INSERT INTO `sys_notice` VALUES (6, '订单付款通知', 3, 0, 2, '2', '订单 177927804713662b93d51 已付款，请尽快发货', 0, '系统', '2026-05-20 19:54:13', NULL, 1, '2026-05-20 19:54:13', '2026-05-20 22:21:30', 'order_paid', 23);
INSERT INTO `sys_notice` VALUES (7, '订单付款通知', 3, 0, 2, '3', '订单 177927804713662b93d51 已付款，请尽快发货', 0, '系统', '2026-05-20 19:54:13', NULL, 1, '2026-05-20 19:54:13', '2026-05-20 22:21:32', 'order_paid', 23);
INSERT INTO `sys_notice` VALUES (9, '订单取消通知', 3, 0, 2, '2', '订单 1778940313220024b6ed7 已被用户取消', 0, '系统', '2026-05-20 22:14:20', NULL, 1, '2026-05-20 22:14:20', '2026-05-20 22:14:19', 'order_cancelled', 14);
INSERT INTO `sys_notice` VALUES (10, '订单已取消', 3, 0, 2, '5', '您的订单 1778940313220024b6ed7 已取消', 0, '系统', '2026-05-20 22:14:20', NULL, 1, '2026-05-20 22:14:20', '2026-05-20 22:14:19', 'order_cancelled', 14);
INSERT INTO `sys_notice` VALUES (11, '订单取消通知', 3, 0, 2, '2', '订单 1779007584705738606d5 已被用户取消', 0, '系统', '2026-05-20 22:14:23', NULL, 1, '2026-05-20 22:14:23', '2026-05-20 22:14:22', 'order_cancelled', 15);
INSERT INTO `sys_notice` VALUES (12, '订单取消通知', 3, 0, 2, '3', '订单 1779007584705738606d5 已被用户取消', 0, '系统', '2026-05-20 22:14:23', NULL, 1, '2026-05-20 22:14:23', '2026-05-20 22:14:22', 'order_cancelled', 15);
INSERT INTO `sys_notice` VALUES (13, '订单已取消', 3, 0, 2, '5', '您的订单 1779007584705738606d5 已取消', 0, '系统', '2026-05-20 22:14:23', NULL, 1, '2026-05-20 22:14:23', '2026-05-20 22:14:22', 'order_cancelled', 15);
INSERT INTO `sys_notice` VALUES (14, '新订单通知', 3, 0, 2, '2', '您有新的订单，订单号：17792864992082160aa7c', 0, '系统', '2026-05-20 22:14:59', NULL, 1, '2026-05-20 22:14:59', '2026-05-20 22:14:59', 'new_order', 24);
INSERT INTO `sys_notice` VALUES (15, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：17792864992082160aa7c', 0, '系统', '2026-05-20 22:14:59', NULL, 1, '2026-05-20 22:14:59', '2026-05-20 22:14:59', 'new_order', 24);
INSERT INTO `sys_notice` VALUES (16, '订单付款通知', 3, 0, 2, '2', '订单 17792864992082160aa7c 已付款，请尽快发货', 0, '系统', '2026-05-20 22:15:06', NULL, 1, '2026-05-20 22:15:06', '2026-05-20 22:15:06', 'order_paid', 24);
INSERT INTO `sys_notice` VALUES (17, '订单付款通知', 3, 0, 2, '3', '订单 17792864992082160aa7c 已付款，请尽快发货', 0, '系统', '2026-05-20 22:15:06', NULL, 1, '2026-05-20 22:15:06', '2026-05-20 22:15:06', 'order_paid', 24);
INSERT INTO `sys_notice` VALUES (18, '订单支付成功', 3, 0, 2, '5', '您的订单 17792864992082160aa7c 已支付成功，请等待发货', 0, '系统', '2026-05-20 22:15:06', NULL, 1, '2026-05-20 22:15:06', '2026-05-20 22:15:06', 'order_paid', 24);
INSERT INTO `sys_notice` VALUES (19, '订单超时取消通知', 3, 0, 2, '2', '订单 202605110001 因超时未支付已被系统自动取消', 0, '系统', '2026-05-21 09:10:02', NULL, 1, '2026-05-21 09:10:02', '2026-05-21 09:10:01', 'order_cancelled', 1);
INSERT INTO `sys_notice` VALUES (20, '订单已取消', 3, 0, 2, '1', '您的订单 202605110001 因超时未支付已被系统自动取消', 0, '系统', '2026-05-21 09:10:02', NULL, 1, '2026-05-21 09:10:02', '2026-05-21 09:10:01', 'order_cancelled', 1);
INSERT INTO `sys_notice` VALUES (21, '订单超时取消通知', 3, 0, 2, '2', '订单 202605110003 因超时未支付已被系统自动取消', 0, '系统', '2026-05-21 09:10:02', NULL, 1, '2026-05-21 09:10:02', '2026-05-21 09:10:01', 'order_cancelled', 3);
INSERT INTO `sys_notice` VALUES (22, '订单已取消', 3, 0, 2, '4', '您的订单 202605110003 因超时未支付已被系统自动取消', 0, '系统', '2026-05-21 09:10:02', NULL, 1, '2026-05-21 09:10:02', '2026-05-21 09:10:01', 'order_cancelled', 3);
INSERT INTO `sys_notice` VALUES (23, '订单超时取消通知', 3, 0, 2, '3', '订单 1779007859973635a9de7 因超时未支付已被系统自动取消', 0, '系统', '2026-05-21 09:10:02', NULL, 1, '2026-05-21 09:10:02', '2026-05-21 09:10:01', 'order_cancelled', 16);
INSERT INTO `sys_notice` VALUES (24, '订单已取消', 3, 0, 2, '2', '您的订单 1779007859973635a9de7 因超时未支付已被系统自动取消', 0, '系统', '2026-05-21 09:10:02', NULL, 1, '2026-05-21 09:10:02', '2026-05-21 09:10:01', 'order_cancelled', 16);
INSERT INTO `sys_notice` VALUES (25, '订单超时取消通知', 3, 0, 2, '5', '订单 17792733236527498e6ce 因超时未支付已被系统自动取消', 0, '系统', '2026-05-21 09:10:02', NULL, 1, '2026-05-21 09:10:02', '2026-05-21 09:10:02', 'order_cancelled', 20);
INSERT INTO `sys_notice` VALUES (26, '订单已取消', 3, 0, 2, '6', '您的订单 17792733236527498e6ce 因超时未支付已被系统自动取消', 0, '系统', '2026-05-21 09:10:02', NULL, 1, '2026-05-21 09:10:02', '2026-05-21 09:10:02', 'order_cancelled', 20);
INSERT INTO `sys_notice` VALUES (27, '订单超时取消通知', 3, 0, 2, '3', '订单 1779273515931f3125de4 因超时未支付已被系统自动取消', 0, '系统', '2026-05-21 09:10:02', NULL, 1, '2026-05-21 09:10:02', '2026-05-21 09:10:02', 'order_cancelled', 21);
INSERT INTO `sys_notice` VALUES (28, '订单已取消', 3, 0, 2, '6', '您的订单 1779273515931f3125de4 因超时未支付已被系统自动取消', 0, '系统', '2026-05-21 09:10:02', NULL, 1, '2026-05-21 09:10:02', '2026-05-21 09:10:02', 'order_cancelled', 21);
INSERT INTO `sys_notice` VALUES (29, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：1779325842289788ec08a', 0, '系统', '2026-05-21 09:10:42', NULL, 1, '2026-05-21 09:10:42', '2026-05-21 09:10:42', 'new_order', 25);
INSERT INTO `sys_notice` VALUES (30, '订单付款通知', 3, 0, 2, '3', '订单 1779325842289788ec08a 已付款，请尽快发货', 0, '系统', '2026-05-21 09:10:53', NULL, 1, '2026-05-21 09:10:53', '2026-05-21 09:10:53', 'order_paid', 25);
INSERT INTO `sys_notice` VALUES (31, '订单支付成功', 3, 0, 2, '6', '您的订单 1779325842289788ec08a 已支付成功，请等待发货', 0, '系统', '2026-05-21 09:10:53', NULL, 1, '2026-05-21 09:10:53', '2026-05-21 09:10:53', 'order_paid', 25);
INSERT INTO `sys_notice` VALUES (32, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：177932587738290a62c2f', 0, '系统', '2026-05-21 09:11:17', NULL, 1, '2026-05-21 09:11:17', '2026-05-21 09:11:17', 'new_order', 26);
INSERT INTO `sys_notice` VALUES (33, '订单超时取消通知', 3, 0, 2, '3', '订单 177932587738290a62c2f 因超时未支付已被系统自动取消', 0, '系统', '2026-05-21 09:45:00', NULL, 1, '2026-05-21 09:45:00', '2026-05-21 09:45:00', 'order_cancelled', 26);
INSERT INTO `sys_notice` VALUES (34, '订单已取消', 3, 0, 2, '6', '您的订单 177932587738290a62c2f 因超时未支付已被系统自动取消', 0, '系统', '2026-05-21 09:45:00', NULL, 1, '2026-05-21 09:45:00', '2026-05-21 09:45:00', 'order_cancelled', 26);
INSERT INTO `sys_notice` VALUES (35, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：1779327974807f9646e14', 0, '系统', '2026-05-21 09:46:15', NULL, 1, '2026-05-21 09:46:15', '2026-05-21 09:46:14', 'new_order', 27);
INSERT INTO `sys_notice` VALUES (36, '新的退款申请', 2, 0, 2, '1', '订单 1779325842289788ec08a 申请退款，金额 8.00', 0, '系统', '2026-05-21 09:58:37', NULL, 1, '2026-05-21 09:58:37', '2026-05-21 09:58:37', 'refund_apply', 1);
INSERT INTO `sys_notice` VALUES (37, '订单超时取消通知', 3, 0, 2, '3', '订单 1779327974807f9646e14 因超时未支付已被系统自动取消', 0, '系统', '2026-05-21 10:20:00', NULL, 1, '2026-05-21 10:20:00', '2026-05-21 10:20:00', 'order_cancelled', 27);
INSERT INTO `sys_notice` VALUES (38, '订单已取消', 3, 0, 2, '6', '您的订单 1779327974807f9646e14 因超时未支付已被系统自动取消', 0, '系统', '2026-05-21 10:20:00', NULL, 1, '2026-05-21 10:20:00', '2026-05-21 10:20:00', 'order_cancelled', 27);
INSERT INTO `sys_notice` VALUES (39, '退款审核通过', 1, 0, 2, '6', '您的订单 1779325842289788ec08a 退款已通过，金额 8.00 元将原路返回', 0, '系统', '2026-05-21 10:30:00', NULL, 1, '2026-05-21 10:30:00', '2026-05-21 10:29:59', 'refund_success', 1);
INSERT INTO `sys_notice` VALUES (40, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：1779375752811819bdd3f', 0, '系统', '2026-05-21 23:02:33', NULL, 1, '2026-05-21 23:02:33', '2026-05-21 23:02:32', 'new_order', 28);
INSERT INTO `sys_notice` VALUES (41, '新订单通知', 3, 0, 2, '2', '您有新的订单，订单号：1779375752811819bdd3f', 0, '系统', '2026-05-21 23:02:33', NULL, 1, '2026-05-21 23:02:33', '2026-05-21 23:02:32', 'new_order', 28);
INSERT INTO `sys_notice` VALUES (42, '订单付款通知', 3, 0, 2, '2', '订单 1779375752811819bdd3f 已付款，请尽快发货', 0, '系统', '2026-05-21 23:02:46', NULL, 1, '2026-05-21 23:02:46', '2026-05-21 23:02:45', 'order_paid', 28);
INSERT INTO `sys_notice` VALUES (43, '订单付款通知', 3, 0, 2, '3', '订单 1779375752811819bdd3f 已付款，请尽快发货', 0, '系统', '2026-05-21 23:02:46', NULL, 1, '2026-05-21 23:02:46', '2026-05-21 23:02:45', 'order_paid', 28);
INSERT INTO `sys_notice` VALUES (44, '订单支付成功', 3, 0, 2, '4', '您的订单 1779375752811819bdd3f 已支付成功，请等待发货', 0, '系统', '2026-05-21 23:02:46', NULL, 1, '2026-05-21 23:02:46', '2026-05-21 23:02:45', 'order_paid', 28);
INSERT INTO `sys_notice` VALUES (45, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：1780132461623d621e20b', 0, '系统', '2026-05-30 17:14:22', NULL, 1, '2026-05-30 17:14:22', '2026-05-30 17:14:21', 'new_order', 29);
INSERT INTO `sys_notice` VALUES (46, '订单付款通知', 3, 0, 2, '3', '订单 1780132461623d621e20b 已付款，请尽快发货', 0, '系统', '2026-05-30 17:14:29', NULL, 1, '2026-05-30 17:14:29', '2026-05-30 17:14:28', 'order_paid', 29);
INSERT INTO `sys_notice` VALUES (47, '订单支付成功', 3, 0, 2, '13', '您的订单 1780132461623d621e20b 已支付成功，请等待发货', 0, '系统', '2026-05-30 17:14:29', NULL, 1, '2026-05-30 17:14:29', '2026-05-30 17:14:28', 'order_paid', 29);
INSERT INTO `sys_notice` VALUES (48, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：17847095063805cf8d0c0', 0, '系统', '2026-07-22 16:38:26', NULL, 1, '2026-07-22 16:38:26', '2026-07-22 16:38:26', 'new_order', 30);
INSERT INTO `sys_notice` VALUES (49, '订单超时取消通知', 3, 0, 2, '3', '订单 17847095063805cf8d0c0 因超时未支付已被系统自动取消', 0, '系统', '2026-07-22 16:38:30', NULL, 1, '2026-07-22 16:38:30', '2026-07-22 16:38:30', 'order_cancelled', 30);
INSERT INTO `sys_notice` VALUES (50, '订单已取消', 3, 0, 2, '6', '您的订单 17847095063805cf8d0c0 因超时未支付已被系统自动取消', 0, '系统', '2026-07-22 16:38:30', NULL, 1, '2026-07-22 16:38:30', '2026-07-22 16:38:30', 'order_cancelled', 30);
INSERT INTO `sys_notice` VALUES (51, '新留言通知', 3, 0, 2, '2', '用户对商品「华为 Mate 60 Pro」留言：可以送优惠卷吗', 0, '系统', '2026-07-22 16:39:20', NULL, 1, '2026-07-22 16:39:20', '2026-07-22 16:39:20', 'new_message', NULL);
INSERT INTO `sys_notice` VALUES (52, '新订单通知', 3, 0, 2, '2', '您有新的订单，订单号：17847096222185a685e67', 0, '系统', '2026-07-22 16:40:22', NULL, 1, '2026-07-22 16:40:22', '2026-07-22 16:40:22', 'new_order', 31);
INSERT INTO `sys_notice` VALUES (53, '订单付款通知', 3, 0, 2, '2', '订单 17847096222185a685e67 已付款，请尽快发货', 0, '系统', '2026-07-22 16:40:42', NULL, 1, '2026-07-22 16:40:42', '2026-07-22 16:40:42', 'order_paid', 31);
INSERT INTO `sys_notice` VALUES (54, '订单支付成功', 3, 0, 2, '6', '您的订单 17847096222185a685e67 已支付成功，请等待发货', 0, '系统', '2026-07-22 16:40:42', NULL, 1, '2026-07-22 16:40:42', '2026-07-22 16:40:42', 'order_paid', 31);
INSERT INTO `sys_notice` VALUES (55, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：1784794963559d1e8a4ec', 0, '系统', '2026-07-23 16:22:44', NULL, 1, '2026-07-23 16:22:44', '2026-07-23 16:22:43', 'new_order', 32);
INSERT INTO `sys_notice` VALUES (56, '新的退款申请', 2, 0, 2, '1', '订单 17847096222185a685e67 申请退款，金额 6999.00', 0, '系统', '2026-07-23 16:24:47', NULL, 1, '2026-07-23 16:24:47', '2026-07-23 16:24:47', 'refund_apply', 2);
INSERT INTO `sys_notice` VALUES (57, '订单付款通知', 3, 0, 2, '3', '订单 1784794963559d1e8a4ec 已付款，请尽快发货', 0, '系统', '2026-07-23 16:25:51', NULL, 1, '2026-07-23 16:25:51', '2026-07-23 16:25:50', 'order_paid', 32);
INSERT INTO `sys_notice` VALUES (58, '订单支付成功', 3, 0, 2, '6', '您的订单 1784794963559d1e8a4ec 已支付成功，请等待发货', 0, '系统', '2026-07-23 16:25:51', NULL, 1, '2026-07-23 16:25:51', '2026-07-23 16:25:50', 'order_paid', 32);
INSERT INTO `sys_notice` VALUES (59, '新的退款申请', 2, 0, 2, '1', '订单 1784794963559d1e8a4ec 申请退款，金额 129.00', 0, '系统', '2026-07-23 16:25:54', NULL, 1, '2026-07-23 16:25:54', '2026-07-23 16:25:54', 'refund_apply', 3);
INSERT INTO `sys_notice` VALUES (60, '新订单通知', 3, 0, 2, '2', '您有新的订单，订单号：17848610375331e6ddd3e', 0, '系统', '2026-07-24 10:43:58', NULL, 1, '2026-07-24 10:43:58', '2026-07-24 10:43:57', 'new_order', 33);
INSERT INTO `sys_notice` VALUES (61, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：17848624643704d0e8999', 0, '系统', '2026-07-24 11:07:44', NULL, 1, '2026-07-24 11:07:44', '2026-07-24 11:07:44', 'new_order', 34);
INSERT INTO `sys_notice` VALUES (62, '订单付款通知', 3, 0, 2, '3', '订单 17848624643704d0e8999 已付款，请尽快发货', 0, '系统', '2026-07-24 11:07:51', NULL, 1, '2026-07-24 11:07:51', '2026-07-24 11:07:50', 'order_paid', 34);
INSERT INTO `sys_notice` VALUES (63, '订单支付成功', 3, 0, 2, '6', '您的订单 17848624643704d0e8999 已支付成功，请等待发货', 0, '系统', '2026-07-24 11:07:51', NULL, 1, '2026-07-24 11:07:51', '2026-07-24 11:07:50', 'order_paid', 34);
INSERT INTO `sys_notice` VALUES (64, '新的退款申请', 2, 0, 2, '1', '订单 17848624643704d0e8999 申请退款，金额 129.00', 0, '系统', '2026-07-24 11:08:03', NULL, 1, '2026-07-24 11:08:03', '2026-07-24 11:08:03', 'refund_apply', 4);
INSERT INTO `sys_notice` VALUES (65, '订单超时取消通知', 3, 0, 2, '2', '订单 17848610375331e6ddd3e 因超时未支付已被系统自动取消', 0, '系统', '2026-07-24 11:08:28', NULL, 1, '2026-07-24 11:08:28', '2026-07-24 11:08:27', 'order_cancelled', 33);
INSERT INTO `sys_notice` VALUES (66, '订单已取消', 3, 0, 2, '6', '您的订单 17848610375331e6ddd3e 因超时未支付已被系统自动取消', 0, '系统', '2026-07-24 11:08:28', NULL, 1, '2026-07-24 11:08:28', '2026-07-24 11:08:27', 'order_cancelled', 33);
INSERT INTO `sys_notice` VALUES (67, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：1784877740563768cebb7', 0, '系统', '2026-07-24 15:22:21', NULL, 1, '2026-07-24 15:22:21', '2026-07-24 15:22:20', 'new_order', 35);
INSERT INTO `sys_notice` VALUES (68, '订单付款通知', 3, 0, 2, '3', '订单 1784877740563768cebb7 已付款，请尽快发货', 0, '系统', '2026-07-24 15:22:27', NULL, 1, '2026-07-24 15:22:27', '2026-07-24 15:22:26', 'order_paid', 35);
INSERT INTO `sys_notice` VALUES (69, '订单支付成功', 3, 0, 2, '8', '您的订单 1784877740563768cebb7 已支付成功，请等待发货', 0, '系统', '2026-07-24 15:22:27', NULL, 1, '2026-07-24 15:22:27', '2026-07-24 15:22:26', 'order_paid', 35);
INSERT INTO `sys_notice` VALUES (70, '新订单通知', 3, 0, 2, '2', '您有新的订单，订单号：178487824734000737a03', 0, '系统', '2026-07-24 15:30:47', NULL, 1, '2026-07-24 15:30:47', '2026-07-24 15:30:47', 'new_order', 36);
INSERT INTO `sys_notice` VALUES (71, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：17848783339953f0387ae', 0, '系统', '2026-07-24 15:32:14', NULL, 1, '2026-07-24 15:32:14', '2026-07-24 15:32:14', 'new_order', 37);
INSERT INTO `sys_notice` VALUES (72, '新订单通知', 3, 0, 2, '5', '您有新的订单，订单号：17848783339953f0387ae', 0, '系统', '2026-07-24 15:32:14', NULL, 1, '2026-07-24 15:32:14', '2026-07-24 15:32:14', 'new_order', 37);
INSERT INTO `sys_notice` VALUES (73, '新订单通知', 3, 0, 2, '2', '您有新的订单，订单号：17848783339953f0387ae', 0, '系统', '2026-07-24 15:32:14', NULL, 1, '2026-07-24 15:32:14', '2026-07-24 15:32:14', 'new_order', 37);
INSERT INTO `sys_notice` VALUES (74, '订单超时取消通知', 3, 0, 2, '2', '订单 178487824734000737a03 因超时未支付已被系统自动取消', 0, '系统', '2026-07-24 16:10:00', NULL, 1, '2026-07-24 16:10:00', '2026-07-24 16:10:00', 'order_cancelled', 36);
INSERT INTO `sys_notice` VALUES (75, '订单已取消', 3, 0, 2, '8', '您的订单 178487824734000737a03 因超时未支付已被系统自动取消', 0, '系统', '2026-07-24 16:10:00', NULL, 1, '2026-07-24 16:10:00', '2026-07-24 16:10:00', 'order_cancelled', 36);
INSERT INTO `sys_notice` VALUES (76, '订单超时取消通知', 3, 0, 2, '2', '订单 17848783339953f0387ae 因超时未支付已被系统自动取消', 0, '系统', '2026-07-24 16:10:00', NULL, 1, '2026-07-24 16:10:00', '2026-07-24 16:10:00', 'order_cancelled', 37);
INSERT INTO `sys_notice` VALUES (77, '订单超时取消通知', 3, 0, 2, '3', '订单 17848783339953f0387ae 因超时未支付已被系统自动取消', 0, '系统', '2026-07-24 16:10:00', NULL, 1, '2026-07-24 16:10:00', '2026-07-24 16:10:00', 'order_cancelled', 37);
INSERT INTO `sys_notice` VALUES (78, '订单超时取消通知', 3, 0, 2, '5', '订单 17848783339953f0387ae 因超时未支付已被系统自动取消', 0, '系统', '2026-07-24 16:10:00', NULL, 1, '2026-07-24 16:10:00', '2026-07-24 16:10:00', 'order_cancelled', 37);
INSERT INTO `sys_notice` VALUES (79, '订单已取消', 3, 0, 2, '8', '您的订单 17848783339953f0387ae 因超时未支付已被系统自动取消', 0, '系统', '2026-07-24 16:10:00', NULL, 1, '2026-07-24 16:10:00', '2026-07-24 16:10:00', 'order_cancelled', 37);
INSERT INTO `sys_notice` VALUES (80, '新订单通知', 3, 0, 2, '5', '您有新的订单，订单号：1784881863798dc5fc602', 0, '系统', '2026-07-24 16:31:04', NULL, 1, '2026-07-24 16:31:04', '2026-07-24 16:31:04', 'new_order', 38);
INSERT INTO `sys_notice` VALUES (81, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：1784881863798dc5fc602', 0, '系统', '2026-07-24 16:31:04', NULL, 1, '2026-07-24 16:31:04', '2026-07-24 16:31:04', 'new_order', 38);
INSERT INTO `sys_notice` VALUES (82, '新订单通知', 3, 0, 2, '2', '您有新的订单，订单号：1784881863798dc5fc602', 0, '系统', '2026-07-24 16:31:04', NULL, 1, '2026-07-24 16:31:04', '2026-07-24 16:31:04', 'new_order', 38);
INSERT INTO `sys_notice` VALUES (83, '订单付款通知', 3, 0, 2, '2', '订单 1784881863798dc5fc602 已付款，请尽快发货', 0, '系统', '2026-07-24 16:31:14', NULL, 1, '2026-07-24 16:31:14', '2026-07-24 16:31:13', 'order_paid', 38);
INSERT INTO `sys_notice` VALUES (84, '订单付款通知', 3, 0, 2, '3', '订单 1784881863798dc5fc602 已付款，请尽快发货', 0, '系统', '2026-07-24 16:31:14', NULL, 1, '2026-07-24 16:31:14', '2026-07-24 16:31:13', 'order_paid', 38);
INSERT INTO `sys_notice` VALUES (85, '订单付款通知', 3, 0, 2, '5', '订单 1784881863798dc5fc602 已付款，请尽快发货', 0, '系统', '2026-07-24 16:31:14', NULL, 1, '2026-07-24 16:31:14', '2026-07-24 16:31:13', 'order_paid', 38);
INSERT INTO `sys_notice` VALUES (86, '订单支付成功', 3, 0, 2, '11', '您的订单 1784881863798dc5fc602 已支付成功，请等待发货', 0, '系统', '2026-07-24 16:31:14', NULL, 1, '2026-07-24 16:31:14', '2026-07-24 16:31:13', 'order_paid', 38);
INSERT INTO `sys_notice` VALUES (87, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：178488317096819d7d85c', 0, '系统', '2026-07-24 16:52:51', NULL, 1, '2026-07-24 16:52:51', '2026-07-24 16:52:51', 'new_order', 39);
INSERT INTO `sys_notice` VALUES (88, '新订单通知', 3, 0, 2, '2', '您有新的订单，订单号：178488317096819d7d85c', 0, '系统', '2026-07-24 16:52:51', NULL, 1, '2026-07-24 16:52:51', '2026-07-24 16:52:51', 'new_order', 39);
INSERT INTO `sys_notice` VALUES (89, '订单付款通知', 3, 0, 2, '2', '订单 178488317096819d7d85c 已付款，请尽快发货', 0, '系统', '2026-07-24 16:53:00', NULL, 1, '2026-07-24 16:53:00', '2026-07-24 16:53:00', 'order_paid', 39);
INSERT INTO `sys_notice` VALUES (90, '订单付款通知', 3, 0, 2, '3', '订单 178488317096819d7d85c 已付款，请尽快发货', 0, '系统', '2026-07-24 16:53:00', NULL, 1, '2026-07-24 16:53:00', '2026-07-24 16:53:00', 'order_paid', 39);
INSERT INTO `sys_notice` VALUES (91, '订单支付成功', 3, 0, 2, '11', '您的订单 178488317096819d7d85c 已支付成功，请等待发货', 0, '系统', '2026-07-24 16:53:00', NULL, 1, '2026-07-24 16:53:00', '2026-07-24 16:53:00', 'order_paid', 39);
INSERT INTO `sys_notice` VALUES (92, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：1785057591491a70712c8', 0, '系统', '2026-07-26 17:19:52', NULL, 1, '2026-07-26 17:19:52', '2026-07-26 17:19:51', 'new_order', 40);
INSERT INTO `sys_notice` VALUES (93, '订单付款通知', 3, 0, 2, '3', '订单 1785057591491a70712c8 已付款，请尽快发货', 0, '系统', '2026-07-26 17:19:57', NULL, 1, '2026-07-26 17:19:57', '2026-07-26 17:19:57', 'order_paid', 40);
INSERT INTO `sys_notice` VALUES (94, '订单支付成功', 3, 0, 2, '11', '您的订单 1785057591491a70712c8 已支付成功，请等待发货', 0, '系统', '2026-07-26 17:19:57', NULL, 1, '2026-07-26 17:19:57', '2026-07-26 17:19:57', 'order_paid', 40);
INSERT INTO `sys_notice` VALUES (95, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：178505776290635b81616', 0, '系统', '2026-07-26 17:22:43', NULL, 1, '2026-07-26 17:22:43', '2026-07-26 17:22:42', 'new_order', 41);
INSERT INTO `sys_notice` VALUES (96, '订单超时取消通知', 3, 0, 2, '3', '订单 178505776290635b81616 因超时未支付已被系统自动取消', 0, '系统', '2026-07-26 17:23:03', NULL, 1, '2026-07-26 17:23:03', '2026-07-26 17:23:03', 'order_cancelled', 41);
INSERT INTO `sys_notice` VALUES (97, '订单已取消', 3, 0, 2, '11', '您的订单 178505776290635b81616 因超时未支付已被系统自动取消', 0, '系统', '2026-07-26 17:23:03', NULL, 1, '2026-07-26 17:23:03', '2026-07-26 17:23:03', 'order_cancelled', 41);
INSERT INTO `sys_notice` VALUES (98, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：178505782845911ed742e', 0, '系统', '2026-07-26 17:23:48', NULL, 1, '2026-07-26 17:23:48', '2026-07-26 17:23:48', 'new_order', 42);
INSERT INTO `sys_notice` VALUES (99, '订单超时取消通知', 3, 0, 2, '3', '订单 178505782845911ed742e 因超时未支付已被系统自动取消', 0, '系统', '2026-07-26 17:24:01', NULL, 1, '2026-07-26 17:24:01', '2026-07-26 17:24:00', 'order_cancelled', 42);
INSERT INTO `sys_notice` VALUES (100, '订单已取消', 3, 0, 2, '11', '您的订单 178505782845911ed742e 因超时未支付已被系统自动取消', 0, '系统', '2026-07-26 17:24:01', NULL, 1, '2026-07-26 17:24:01', '2026-07-26 17:24:00', 'order_cancelled', 42);
INSERT INTO `sys_notice` VALUES (101, '退款已通过', 1, 0, 2, '6', '您的订单 17848624643704d0e8999 退款已审核通过，即将执行退款', 0, '系统', '2026-07-26 17:29:48', NULL, 1, '2026-07-26 17:29:48', '2026-07-26 17:29:47', 'refund_approved', 4);
INSERT INTO `sys_notice` VALUES (102, '退款成功', 1, 0, 2, '6', '您的订单 17848624643704d0e8999 已退款 129.00 元', 0, '系统', '2026-07-26 17:29:54', NULL, 1, '2026-07-26 17:29:54', '2026-07-26 17:29:53', 'refund_success', 4);
INSERT INTO `sys_notice` VALUES (103, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：17850587929905a609aa0', 0, '系统', '2026-07-26 17:39:53', NULL, 1, '2026-07-26 17:39:53', '2026-07-26 17:39:53', 'new_order', 43);
INSERT INTO `sys_notice` VALUES (104, '订单付款通知', 3, 0, 2, '3', '订单 17850587929905a609aa0 已付款，请尽快发货', 0, '系统', '2026-07-26 17:40:00', NULL, 1, '2026-07-26 17:40:00', '2026-07-26 17:39:59', 'order_paid', 43);
INSERT INTO `sys_notice` VALUES (105, '订单支付成功', 3, 0, 2, '6', '您的订单 17850587929905a609aa0 已支付成功，请等待发货', 0, '系统', '2026-07-26 17:40:00', NULL, 1, '2026-07-26 17:40:00', '2026-07-26 17:39:59', 'order_paid', 43);
INSERT INTO `sys_notice` VALUES (106, '新的退款申请', 2, 0, 2, '1', '订单 17850587929905a609aa0 申请退款，金额 8.00', 0, '系统', '2026-07-26 17:40:13', NULL, 1, '2026-07-26 17:40:13', '2026-07-26 17:40:13', 'refund_apply', 5);
INSERT INTO `sys_notice` VALUES (107, '退款已通过', 1, 0, 2, '6', '您的订单 17850587929905a609aa0 退款已审核通过，即将执行退款', 0, '系统', '2026-07-26 17:41:20', NULL, 1, '2026-07-26 17:41:20', '2026-07-26 17:41:20', 'refund_approved', 5);
INSERT INTO `sys_notice` VALUES (108, '退款成功', 1, 0, 2, '6', '您的订单 17850587929905a609aa0 已退款 8.00 元', 0, '系统', '2026-07-26 17:41:25', NULL, 1, '2026-07-26 17:41:25', '2026-07-26 17:41:24', 'refund_success', 5);
INSERT INTO `sys_notice` VALUES (109, '退款被拒绝', 1, 0, 2, '6', '您的订单 1784794963559d1e8a4ec 退款申请被商户拒绝', 0, '系统', '2026-07-26 18:40:33', NULL, 1, '2026-07-26 18:40:33', '2026-07-26 18:40:33', 'refund_reject', 3);
INSERT INTO `sys_notice` VALUES (110, '新的退款申请', 2, 0, 2, '1', '订单 1784794963559d1e8a4ec 申请退款，金额 129.00', 0, '系统', '2026-07-26 18:43:20', NULL, 1, '2026-07-26 18:43:20', '2026-07-26 18:43:19', 'refund_apply', 6);
INSERT INTO `sys_notice` VALUES (111, '退款已通过', 1, 0, 2, '6', '您的订单 1784794963559d1e8a4ec 退款已审核通过，即将执行退款', 0, '系统', '2026-07-26 18:49:04', NULL, 1, '2026-07-26 18:49:04', '2026-07-26 18:49:03', 'refund_approved', 6);
INSERT INTO `sys_notice` VALUES (112, '退款成功', 1, 0, 2, '6', '您的订单 1784794963559d1e8a4ec 已退款 129.00 元', 0, '系统', '2026-07-26 18:49:09', NULL, 1, '2026-07-26 18:49:09', '2026-07-26 18:49:08', 'refund_success', 6);
INSERT INTO `sys_notice` VALUES (113, '退款已通过', 1, 0, 2, '6', '您的订单 17847096222185a685e67 退款已审核通过，即将执行退款', 0, '系统', '2026-07-26 18:49:20', NULL, 1, '2026-07-26 18:49:20', '2026-07-26 18:49:20', 'refund_approved', 2);
INSERT INTO `sys_notice` VALUES (114, '退款已通过', 1, 0, 2, '6', '您的订单 1779325842289788ec08a 退款已审核通过，即将执行退款', 0, '系统', '2026-07-26 18:49:23', NULL, 1, '2026-07-26 18:49:23', '2026-07-26 18:49:22', 'refund_approved', 1);
INSERT INTO `sys_notice` VALUES (115, '退款成功', 1, 0, 2, '6', '您的订单 1779325842289788ec08a 已退款 8.00 元', 0, '系统', '2026-07-26 18:49:26', NULL, 1, '2026-07-26 18:49:26', '2026-07-26 18:49:26', 'refund_success', 1);
INSERT INTO `sys_notice` VALUES (116, '退款成功', 1, 0, 2, '6', '您的订单 17847096222185a685e67 已退款 6999.00 元', 0, '系统', '2026-07-26 18:49:29', NULL, 1, '2026-07-26 18:49:29', '2026-07-26 18:49:28', 'refund_success', 2);
INSERT INTO `sys_notice` VALUES (117, '商家回复了您的留言', 3, 0, 2, '6', '有活动就送', 0, '系统', '2026-07-26 18:55:33', NULL, 1, '2026-07-26 18:55:33', '2026-07-26 18:55:32', 'reply_message', 1);
INSERT INTO `sys_notice` VALUES (118, '新订单通知', 3, 0, 2, '5', '您有新的订单，订单号：1785231745150d32c679a', 0, '系统', '2026-07-28 17:42:25', NULL, 1, '2026-07-28 17:42:25', '2026-07-28 17:42:25', 'new_order', 33);
INSERT INTO `sys_notice` VALUES (119, '订单超时取消通知', 3, 0, 2, '5', '订单 1785231745150d32c679a 因超时未支付已被系统自动取消', 0, '系统', '2026-07-29 09:10:00', NULL, 1, '2026-07-29 09:10:00', '2026-07-29 09:10:00', 'order_cancelled', 33);
INSERT INTO `sys_notice` VALUES (120, '订单已取消', 3, 0, 2, '5', '您的订单 1785231745150d32c679a 因超时未支付已被系统自动取消', 0, '系统', '2026-07-29 09:10:00', NULL, 1, '2026-07-29 09:10:00', '2026-07-29 09:10:00', 'order_cancelled', 33);
INSERT INTO `sys_notice` VALUES (121, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：1785288307763c1ac3bb6', 0, '系统', '2026-07-29 09:25:08', NULL, 1, '2026-07-29 09:25:08', '2026-07-29 09:25:07', 'new_order', 34);
INSERT INTO `sys_notice` VALUES (122, '订单付款通知', 3, 0, 2, '3', '订单 1785288307763c1ac3bb6 已付款，请尽快发货', 0, '系统', '2026-07-29 09:25:32', NULL, 1, '2026-07-29 09:25:32', '2026-07-29 09:25:31', 'order_paid', 34);
INSERT INTO `sys_notice` VALUES (123, '订单支付成功', 3, 0, 2, '5', '您的订单 1785288307763c1ac3bb6 已支付成功，请等待发货', 0, '系统', '2026-07-29 09:25:32', NULL, 1, '2026-07-29 09:25:32', '2026-07-29 09:25:31', 'order_paid', 34);
INSERT INTO `sys_notice` VALUES (124, '新订单通知', 3, 0, 2, '2', '您有新的订单，订单号：1785291448957944bf3ff', 0, '系统', '2026-07-29 10:17:29', NULL, 1, '2026-07-29 10:17:29', '2026-07-29 10:17:28', 'new_order', 35);
INSERT INTO `sys_notice` VALUES (125, '订单付款通知', 3, 0, 2, '2', '订单 1785291448957944bf3ff 已付款，请尽快发货', 0, '系统', '2026-07-29 10:17:36', NULL, 1, '2026-07-29 10:17:36', '2026-07-29 10:17:35', 'order_paid', 35);
INSERT INTO `sys_notice` VALUES (126, '订单支付成功', 3, 0, 2, '5', '您的订单 1785291448957944bf3ff 已支付成功，请等待发货', 0, '系统', '2026-07-29 10:17:36', NULL, 1, '2026-07-29 10:17:36', '2026-07-29 10:17:35', 'order_paid', 35);
INSERT INTO `sys_notice` VALUES (127, '新的退款申请', 2, 0, 2, '1', '订单 1785291448957944bf3ff 申请退款，金额 7999.00', 0, '系统', '2026-07-29 10:17:43', NULL, 1, '2026-07-29 10:17:43', '2026-07-29 10:17:43', 'refund_apply', 7);
INSERT INTO `sys_notice` VALUES (128, '退款已通过', 1, 0, 2, '5', '您的订单 1785291448957944bf3ff 退款已审核通过，即将执行退款', 0, '系统', '2026-07-29 10:19:49', NULL, 1, '2026-07-29 10:19:49', '2026-07-29 10:19:48', 'refund_approved', 7);
INSERT INTO `sys_notice` VALUES (129, '退款成功', 1, 0, 2, '5', '您的订单 1785291448957944bf3ff 已退款 7999.00 元', 0, '系统', '2026-07-29 10:19:52', NULL, 1, '2026-07-29 10:19:52', '2026-07-29 10:19:51', 'refund_success', 7);
INSERT INTO `sys_notice` VALUES (130, '新订单通知', 3, 0, 2, '5', '您有新的订单，订单号：178529228815605585f78', 0, '系统', '2026-07-29 10:31:28', NULL, 1, '2026-07-29 10:31:28', '2026-07-29 10:31:28', 'new_order', 36);
INSERT INTO `sys_notice` VALUES (131, '订单付款通知', 3, 0, 2, '5', '订单 178529228815605585f78 已付款，请尽快发货', 0, '系统', '2026-07-29 10:31:34', NULL, 1, '2026-07-29 10:31:34', '2026-07-29 10:31:33', 'order_paid', 36);
INSERT INTO `sys_notice` VALUES (132, '订单支付成功', 3, 0, 2, '5', '您的订单 178529228815605585f78 已支付成功，请等待发货', 0, '系统', '2026-07-29 10:31:34', NULL, 1, '2026-07-29 10:31:34', '2026-07-29 10:31:33', 'order_paid', 36);
INSERT INTO `sys_notice` VALUES (133, '新订单通知', 3, 0, 2, '5', '您有新的订单，订单号：17852938863125423eb47', 0, '系统', '2026-07-29 10:58:06', NULL, 1, '2026-07-29 10:58:06', '2026-07-29 10:58:06', 'new_order', 37);
INSERT INTO `sys_notice` VALUES (134, '订单付款通知', 3, 0, 2, '5', '订单 17852938863125423eb47 已付款，请尽快发货', 0, '系统', '2026-07-29 10:58:14', NULL, 1, '2026-07-29 10:58:14', '2026-07-29 10:58:13', 'order_paid', 37);
INSERT INTO `sys_notice` VALUES (135, '订单支付成功', 3, 0, 2, '5', '您的订单 17852938863125423eb47 已支付成功，请等待发货', 0, '系统', '2026-07-29 10:58:14', NULL, 1, '2026-07-29 10:58:14', '2026-07-29 10:58:13', 'order_paid', 37);
INSERT INTO `sys_notice` VALUES (136, '新订单通知', 3, 0, 2, '5', '您有新的订单，订单号：17852941854690fda4ec3', 0, '系统', '2026-07-29 11:03:05', NULL, 1, '2026-07-29 11:03:05', '2026-07-29 11:03:05', 'new_order', 38);
INSERT INTO `sys_notice` VALUES (137, '订单付款通知', 3, 0, 2, '5', '订单 17852941854690fda4ec3 已付款，请尽快发货', 0, '系统', '2026-07-29 11:03:11', NULL, 1, '2026-07-29 11:03:11', '2026-07-29 11:03:11', 'order_paid', 38);
INSERT INTO `sys_notice` VALUES (138, '订单支付成功', 3, 0, 2, '5', '您的订单 17852941854690fda4ec3 已支付成功，请等待发货', 0, '系统', '2026-07-29 11:03:11', NULL, 1, '2026-07-29 11:03:11', '2026-07-29 11:03:11', 'order_paid', 38);
INSERT INTO `sys_notice` VALUES (139, '新订单通知', 3, 0, 2, '5', '您有新的订单，订单号：1785295068774c0058901', 0, '系统', '2026-07-29 11:17:49', NULL, 1, '2026-07-29 11:17:49', '2026-07-29 11:17:48', 'new_order', 39);
INSERT INTO `sys_notice` VALUES (140, '订单付款通知', 3, 0, 2, '5', '订单 1785295068774c0058901 已付款，请尽快发货', 0, '系统', '2026-07-29 11:17:54', NULL, 1, '2026-07-29 11:17:54', '2026-07-29 11:17:54', 'order_paid', 39);
INSERT INTO `sys_notice` VALUES (141, '订单支付成功', 3, 0, 2, '5', '您的订单 1785295068774c0058901 已支付成功，请等待发货', 0, '系统', '2026-07-29 11:17:54', NULL, 1, '2026-07-29 11:17:54', '2026-07-29 11:17:54', 'order_paid', 39);
INSERT INTO `sys_notice` VALUES (142, '新订单通知', 3, 0, 2, '5', '您有新的订单，订单号：1785296648140c71b68f0', 0, '系统', '2026-07-29 11:44:08', NULL, 1, '2026-07-29 11:44:08', '2026-07-29 11:44:08', 'new_order', 40);
INSERT INTO `sys_notice` VALUES (143, '订单付款通知', 3, 0, 2, '5', '订单 1785296648140c71b68f0 已付款，请尽快发货', 0, '系统', '2026-07-29 11:44:14', NULL, 1, '2026-07-29 11:44:14', '2026-07-29 11:44:14', 'order_paid', 40);
INSERT INTO `sys_notice` VALUES (144, '订单支付成功', 3, 0, 2, '5', '您的订单 1785296648140c71b68f0 已支付成功，请等待发货', 0, '系统', '2026-07-29 11:44:14', NULL, 1, '2026-07-29 11:44:14', '2026-07-29 11:44:14', 'order_paid', 40);
INSERT INTO `sys_notice` VALUES (145, '新的退款申请', 2, 0, 2, '1', '订单 1785296648140c71b68f0 申请退款，金额 3000.00', 0, '系统', '2026-07-29 11:52:33', NULL, 1, '2026-07-29 11:52:33', '2026-07-29 11:52:32', 'refund_apply', 8);
INSERT INTO `sys_notice` VALUES (146, '退款已通过', 1, 0, 2, '5', '您的订单 1785296648140c71b68f0 退款已审核通过，即将执行退款', 0, '系统', '2026-07-29 11:53:17', NULL, 1, '2026-07-29 11:53:17', '2026-07-29 11:53:17', 'refund_approved', 8);
INSERT INTO `sys_notice` VALUES (147, '退款成功', 1, 0, 2, '5', '您的订单 1785296648140c71b68f0 已退款 3000.00 元', 0, '系统', '2026-07-29 11:53:19', NULL, 1, '2026-07-29 11:53:19', '2026-07-29 11:53:19', 'refund_success', 8);
INSERT INTO `sys_notice` VALUES (148, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：1785312408401ea0735a5', 0, '系统', '2026-07-29 16:06:48', NULL, 1, '2026-07-29 16:06:48', '2026-07-29 16:06:48', 'new_order', 41);
INSERT INTO `sys_notice` VALUES (149, '订单付款通知', 3, 0, 2, '3', '订单 1785312408401ea0735a5 已付款，请尽快发货', 0, '系统', '2026-07-29 16:06:54', NULL, 1, '2026-07-29 16:06:54', '2026-07-29 16:06:54', 'order_paid', 41);
INSERT INTO `sys_notice` VALUES (150, '订单支付成功', 3, 0, 2, '6', '您的订单 1785312408401ea0735a5 已支付成功，请等待发货', 0, '系统', '2026-07-29 16:06:54', NULL, 1, '2026-07-29 16:06:54', '2026-07-29 16:06:54', 'order_paid', 41);
INSERT INTO `sys_notice` VALUES (151, '新订单通知', 3, 0, 2, '5', '您有新的订单，订单号：1785550466941bb56cd7a', 0, '系统', '2026-08-01 10:14:27', NULL, 1, '2026-08-01 10:14:27', '2026-08-01 10:14:26', 'new_order', 42);
INSERT INTO `sys_notice` VALUES (152, '订单付款通知', 3, 0, 2, '5', '订单 1785550466941bb56cd7a 已付款，请尽快发货', 0, '系统', '2026-08-01 10:14:32', NULL, 1, '2026-08-01 10:14:32', '2026-08-01 10:14:32', 'order_paid', 42);
INSERT INTO `sys_notice` VALUES (153, '订单支付成功', 3, 0, 2, '8', '您的订单 1785550466941bb56cd7a 已支付成功，请等待发货', 0, '系统', '2026-08-01 10:14:32', NULL, 1, '2026-08-01 10:14:32', '2026-08-01 10:14:32', 'order_paid', 42);
INSERT INTO `sys_notice` VALUES (154, '新订单通知', 3, 0, 2, '2', '您有新的订单，订单号：1785552005639f291d4bf', 0, '系统', '2026-08-01 10:40:06', NULL, 1, '2026-08-01 10:40:06', '2026-08-01 10:40:05', 'new_order', 43);
INSERT INTO `sys_notice` VALUES (155, '订单已取消', 3, 0, 2, '14', '您的订单 1785552005639f291d4bf 因超时未支付已被系统自动取消', 0, '系统', '2026-08-01 11:15:00', NULL, 1, '2026-08-01 11:15:00', '2026-08-01 11:15:00', 'order_cancelled', 43);

-- ----------------------------
-- Table structure for sys_notice_read
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice_read`;
CREATE TABLE `sys_notice_read`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `notice_id` bigint NOT NULL COMMENT '通知ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `read_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '阅读时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_notice_user`(`notice_id` ASC, `user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 132 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知已读记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice_read
-- ----------------------------
INSERT INTO `sys_notice_read` VALUES (1, 1, 1, '2026-05-18 17:59:56');
INSERT INTO `sys_notice_read` VALUES (2, 1, 5, '2026-05-18 18:12:46');
INSERT INTO `sys_notice_read` VALUES (3, 1, 6, '2026-05-20 16:13:02');
INSERT INTO `sys_notice_read` VALUES (4, 1, 2, '2026-05-20 21:41:47');
INSERT INTO `sys_notice_read` VALUES (5, 6, 1, '2026-05-20 22:10:36');
INSERT INTO `sys_notice_read` VALUES (6, 2, 2, '2026-05-20 22:12:20');
INSERT INTO `sys_notice_read` VALUES (7, 3, 2, '2026-05-20 22:12:20');
INSERT INTO `sys_notice_read` VALUES (8, 4, 2, '2026-05-20 22:12:20');
INSERT INTO `sys_notice_read` VALUES (9, 6, 2, '2026-05-20 22:12:20');
INSERT INTO `sys_notice_read` VALUES (10, 10, 5, '2026-05-20 22:19:55');
INSERT INTO `sys_notice_read` VALUES (11, 13, 5, '2026-05-20 22:19:55');
INSERT INTO `sys_notice_read` VALUES (12, 18, 5, '2026-05-20 22:19:55');
INSERT INTO `sys_notice_read` VALUES (13, 39, 6, '2026-05-21 10:30:44');
INSERT INTO `sys_notice_read` VALUES (14, 26, 6, '2026-05-21 10:30:55');
INSERT INTO `sys_notice_read` VALUES (15, 28, 6, '2026-05-21 10:30:55');
INSERT INTO `sys_notice_read` VALUES (16, 31, 6, '2026-05-21 10:30:55');
INSERT INTO `sys_notice_read` VALUES (17, 34, 6, '2026-05-21 10:30:55');
INSERT INTO `sys_notice_read` VALUES (18, 38, 6, '2026-05-21 10:30:55');
INSERT INTO `sys_notice_read` VALUES (19, 1, 11, '2026-05-21 23:00:13');
INSERT INTO `sys_notice_read` VALUES (20, 54, 6, '2026-07-22 16:40:48');
INSERT INTO `sys_notice_read` VALUES (21, 50, 6, '2026-07-22 16:40:51');
INSERT INTO `sys_notice_read` VALUES (22, 85, 5, '2026-07-24 17:27:21');
INSERT INTO `sys_notice_read` VALUES (23, 9, 2, '2026-07-26 16:56:35');
INSERT INTO `sys_notice_read` VALUES (24, 65, 2, '2026-07-26 16:56:43');
INSERT INTO `sys_notice_read` VALUES (25, 11, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (26, 14, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (27, 16, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (28, 19, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (29, 21, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (30, 24, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (31, 41, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (32, 42, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (33, 51, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (34, 52, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (35, 53, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (36, 60, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (37, 70, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (38, 73, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (39, 74, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (40, 76, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (41, 82, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (42, 83, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (43, 88, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (44, 89, 2, '2026-07-26 16:56:47');
INSERT INTO `sys_notice_read` VALUES (45, 25, 5, '2026-07-26 17:16:01');
INSERT INTO `sys_notice_read` VALUES (46, 72, 5, '2026-07-26 17:16:01');
INSERT INTO `sys_notice_read` VALUES (47, 78, 5, '2026-07-26 17:16:01');
INSERT INTO `sys_notice_read` VALUES (48, 80, 5, '2026-07-26 17:16:01');
INSERT INTO `sys_notice_read` VALUES (49, 102, 6, '2026-07-26 17:30:38');
INSERT INTO `sys_notice_read` VALUES (50, 1, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (51, 5, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (52, 7, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (53, 12, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (54, 15, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (55, 17, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (56, 23, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (57, 27, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (58, 29, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (59, 30, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (60, 32, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (61, 33, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (62, 35, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (63, 37, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (64, 40, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (65, 43, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (66, 45, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (67, 46, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (68, 48, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (69, 49, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (70, 55, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (71, 57, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (72, 61, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (73, 62, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (74, 67, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (75, 68, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (76, 71, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (77, 77, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (78, 81, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (79, 84, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (80, 87, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (81, 90, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (82, 92, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (83, 93, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (84, 95, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (85, 96, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (86, 98, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (87, 99, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (88, 103, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (89, 104, 3, '2026-07-26 17:40:34');
INSERT INTO `sys_notice_read` VALUES (90, 108, 6, '2026-07-26 17:41:48');
INSERT INTO `sys_notice_read` VALUES (91, 117, 6, '2026-07-27 11:36:02');
INSERT INTO `sys_notice_read` VALUES (92, 58, 6, '2026-07-27 11:36:08');
INSERT INTO `sys_notice_read` VALUES (93, 63, 6, '2026-07-27 11:36:08');
INSERT INTO `sys_notice_read` VALUES (94, 66, 6, '2026-07-27 11:36:08');
INSERT INTO `sys_notice_read` VALUES (95, 101, 6, '2026-07-27 11:36:08');
INSERT INTO `sys_notice_read` VALUES (96, 105, 6, '2026-07-27 11:36:08');
INSERT INTO `sys_notice_read` VALUES (97, 107, 6, '2026-07-27 11:36:08');
INSERT INTO `sys_notice_read` VALUES (98, 109, 6, '2026-07-27 11:36:08');
INSERT INTO `sys_notice_read` VALUES (99, 111, 6, '2026-07-27 11:36:08');
INSERT INTO `sys_notice_read` VALUES (100, 112, 6, '2026-07-27 11:36:08');
INSERT INTO `sys_notice_read` VALUES (101, 113, 6, '2026-07-27 11:36:08');
INSERT INTO `sys_notice_read` VALUES (102, 114, 6, '2026-07-27 11:36:08');
INSERT INTO `sys_notice_read` VALUES (103, 115, 6, '2026-07-27 11:36:08');
INSERT INTO `sys_notice_read` VALUES (104, 116, 6, '2026-07-27 11:36:08');
INSERT INTO `sys_notice_read` VALUES (105, 118, 5, '2026-07-29 10:32:36');
INSERT INTO `sys_notice_read` VALUES (106, 119, 5, '2026-07-29 10:32:36');
INSERT INTO `sys_notice_read` VALUES (107, 120, 5, '2026-07-29 10:32:36');
INSERT INTO `sys_notice_read` VALUES (108, 123, 5, '2026-07-29 10:32:36');
INSERT INTO `sys_notice_read` VALUES (109, 126, 5, '2026-07-29 10:32:36');
INSERT INTO `sys_notice_read` VALUES (110, 128, 5, '2026-07-29 10:32:36');
INSERT INTO `sys_notice_read` VALUES (111, 129, 5, '2026-07-29 10:32:36');
INSERT INTO `sys_notice_read` VALUES (112, 130, 5, '2026-07-29 10:32:36');
INSERT INTO `sys_notice_read` VALUES (113, 131, 5, '2026-07-29 10:32:36');
INSERT INTO `sys_notice_read` VALUES (114, 132, 5, '2026-07-29 10:32:36');
INSERT INTO `sys_notice_read` VALUES (115, 133, 5, '2026-07-29 11:56:01');
INSERT INTO `sys_notice_read` VALUES (116, 134, 5, '2026-07-29 11:56:01');
INSERT INTO `sys_notice_read` VALUES (117, 135, 5, '2026-07-29 11:56:01');
INSERT INTO `sys_notice_read` VALUES (118, 136, 5, '2026-07-29 11:56:01');
INSERT INTO `sys_notice_read` VALUES (119, 137, 5, '2026-07-29 11:56:01');
INSERT INTO `sys_notice_read` VALUES (120, 138, 5, '2026-07-29 11:56:01');
INSERT INTO `sys_notice_read` VALUES (121, 139, 5, '2026-07-29 11:56:01');
INSERT INTO `sys_notice_read` VALUES (122, 140, 5, '2026-07-29 11:56:01');
INSERT INTO `sys_notice_read` VALUES (123, 141, 5, '2026-07-29 11:56:01');
INSERT INTO `sys_notice_read` VALUES (124, 142, 5, '2026-07-29 11:56:01');
INSERT INTO `sys_notice_read` VALUES (125, 143, 5, '2026-07-29 11:56:01');
INSERT INTO `sys_notice_read` VALUES (126, 144, 5, '2026-07-29 11:56:01');
INSERT INTO `sys_notice_read` VALUES (127, 146, 5, '2026-07-29 11:56:01');
INSERT INTO `sys_notice_read` VALUES (128, 147, 5, '2026-07-29 11:56:01');
INSERT INTO `sys_notice_read` VALUES (129, 154, 2, '2026-08-01 10:45:27');
INSERT INTO `sys_notice_read` VALUES (130, 125, 2, '2026-08-01 10:45:28');
INSERT INTO `sys_notice_read` VALUES (131, 124, 2, '2026-08-01 10:45:29');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `gender` tinyint NOT NULL DEFAULT 0 COMMENT '性别 0-未知 1-男 2-女',
  `status` tinyint NULL DEFAULT 0 COMMENT '0-正常 1-冻结',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'USER' COMMENT 'USER,ADMIN,MERCHANT',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '管理员', '$2a$10$i6AE41VyU/KKu48U/v.jKOMf6ssmc6DL3SD0rb4ohlBXzQXONCGFi', '13592816121', 'shuxinwu718@gmail.com', '/uploads/2026-05-14/cef55406-696b-4f91-967a-22941568e1ba.jpg', 1, 0, 'ADMIN', '2026-05-11 17:00:11', '2026-05-14 15:58:04', 0);
INSERT INTO `user` VALUES (2, 'mojie', '摩羯', '$2a$10$QbQeL/84Net9QIKuwFREbO1BVp0txkC8hgM2RkKl6sXxNVKr71MM.', '13900000001', 'merchant1@shop.com', '/uploads/2026-05-16/93689360-9834-4ad6-9425-4c7bea98861e.jpg', 0, 0, 'MERCHANT', '2026-05-11 17:00:11', '2026-05-16 21:30:43', 0);
INSERT INTO `user` VALUES (3, 'zhangsan', '张三', '$2a$10$QbQeL/84Net9QIKuwFREbO1BVp0txkC8hgM2RkKl6sXxNVKr71MM.', '13536911064', 'zhangsan@example.com', '/uploads/2026-05-16/70f6270f-3d69-427b-b532-93aec03323a0.jpg', 0, 0, 'MERCHANT', '2026-05-11 17:00:11', '2026-05-14 15:58:11', 0);
INSERT INTO `user` VALUES (4, 'lisi', '李四', '$2a$10$QbQeL/84Net9QIKuwFREbO1BVp0txkC8hgM2RkKl6sXxNVKr71MM.', '13887654321', 'lisi@example.com', '/uploads/2026-05-21/1a1dac26-1d74-4467-93e8-a1691c57cd87.jpg', 0, 0, 'USER', '2026-05-11 17:00:11', '2026-05-14 15:58:15', 0);
INSERT INTO `user` VALUES (5, 'bob', '鲍勃', '$2a$10$QbQeL/84Net9QIKuwFREbO1BVp0txkC8hgM2RkKl6sXxNVKr71MM.', NULL, '13536911064@163.com', '/uploads/2026-05-15/08da718c-8ad8-430a-8eed-5b27b027e88b.jpg', 1, 0, 'MERCHANT', '2026-05-11 17:09:25', '2026-05-14 15:58:24', 0);
INSERT INTO `user` VALUES (6, 'star', '星', '$2a$10$/qaCymXjQwyDo0IuYLTxIe5DKAn8n/BOyJz8YFKVqoiGCWIAovS5e', '13415066768', '2368151277@qq.com', '/uploads/2026-05-15/8fb8b7fe-a218-4683-a8ec-43406dc4c49f.jpg', 0, 0, 'USER', '2026-05-11 17:18:14', '2026-05-14 15:58:30', 0);
INSERT INTO `user` VALUES (7, 'testuser', '特素', '$2a$10$dpAa.7zFF7LRub.0F8mM..YB7uhbLRYnu.AvHyQTnXVTbmmoL.Bki', '13800138000', 'test@test.com', NULL, 0, 0, 'USER', '2026-05-13 12:43:40', '2026-05-14 15:59:02', 0);
INSERT INTO `user` VALUES (8, 'mike', '麦克', '$2a$10$lEQDzr1ffXUv3Cs5vilJ3.B6nKbxr8ImhUYhHV0pukaOUhRvIjuFC', '', '1325481524@qq.com', NULL, 1, 0, 'USER', '2026-05-13 13:07:28', '2026-05-14 15:58:35', 0);
INSERT INTO `user` VALUES (9, 'test', '策士', '$2a$10$QbQeL/84Net9QIKuwFREbO1BVp0txkC8hgM2RkKl6sXxNVKr71MM.', NULL, 'test@test.com', NULL, 0, 1, 'USER', '2026-05-13 18:37:39', '2026-05-21 23:04:13', 0);
INSERT INTO `user` VALUES (10, 'xingo', NULL, '$2a$10$2rRK4kaNjMkiq.qTzIlENuJctsgSHx2qNKfSR5ds4pf8ssAs6ORZO', '', '125813546@qq.com', '/uploads/2026-05-19/3619e192-8bd3-4449-8b0a-63a7ea113c70.png', 0, 0, 'USER', '2026-05-19 21:35:17', '2026-05-19 21:35:17', 0);
INSERT INTO `user` VALUES (11, 'fuge', '福哥', '$2a$10$jfR3BccI17T0XtkNK7zk2.41UMWHpRbSzCQMzAB84VF05nDzX9l9m', '', '89521254@qq.com', '/uploads/2026-05-21/d213a49f-bc33-41cc-9c55-0de422770cb5.jpg', 0, 0, 'USER', '2026-05-21 22:59:08', '2026-05-21 22:59:08', 0);
INSERT INTO `user` VALUES (13, 'github_shuxinwu718-web', '吴树鑫', '$2a$10$5yO8hpCRNC1gR4een/HUoOwqdhH/PkIRp5x0e/BaSfRVLuOFkJK3G', '13536911064', NULL, '/uploads/2026-05-30/f80820d2-0d9e-4fa7-8540-9098f1e02424.jpg', 1, 1, 'USER', '2026-05-30 16:24:45', '2026-05-30 16:24:45', 0);
INSERT INTO `user` VALUES (14, 'sku_test_08', NULL, '$2a$10$b7783.ZNEGXV2DJZuHPpOe1Ol00xfTmuKgLW7MSQGV94CWF91Wv0C', '13800000008', 'skutest08@test.com', NULL, 0, 0, 'USER', '2026-08-01 10:34:45', '2026-08-01 10:34:45', 0);

-- ----------------------------
-- Table structure for user_activity_record
-- ----------------------------
DROP TABLE IF EXISTS `user_activity_record`;
CREATE TABLE `user_activity_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `activity_id` bigint NOT NULL,
  `coupon_id` bigint NOT NULL COMMENT '领取的优惠券ID（关联coupon表）',
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'ACTIVITY' COMMENT '来源：ACTIVITY-活动领取，SIGNIN-签到，LOTTERY-抽奖',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_activity`(`user_id` ASC, `activity_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_activity_record
-- ----------------------------

-- ----------------------------
-- Table structure for user_coupon
-- ----------------------------
DROP TABLE IF EXISTS `user_coupon`;
CREATE TABLE `user_coupon`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `coupon_id` bigint NOT NULL COMMENT '优惠券ID',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '使用订单号',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态: 0=未使用, 1=已使用, 2=已过期',
  `get_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '领取时间',
  `use_time` datetime NULL DEFAULT NULL COMMENT '使用时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_coupon`(`coupon_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户优惠券' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_coupon
-- ----------------------------
INSERT INTO `user_coupon` VALUES (1, 6, 3, NULL, 2, '2026-05-19 20:40:24', NULL, '2026-05-19 20:40:24', '2026-05-19 20:40:24');
INSERT INTO `user_coupon` VALUES (7, 6, 3, NULL, 2, '2026-05-19 21:05:53', NULL, '2026-05-19 21:05:53', '2026-05-19 21:05:53');
INSERT INTO `user_coupon` VALUES (8, 10, 5, NULL, 0, '2026-05-19 21:35:17', NULL, '2026-05-19 21:35:17', '2026-05-19 21:35:17');
INSERT INTO `user_coupon` VALUES (9, 10, 5, NULL, 0, '2026-05-19 21:35:17', NULL, '2026-05-19 21:35:17', '2026-05-19 21:35:17');
INSERT INTO `user_coupon` VALUES (10, 10, 5, '177919975947816af0536', 1, '2026-05-19 21:35:17', '2026-05-19 22:09:20', '2026-05-19 21:35:17', '2026-05-19 21:35:17');
INSERT INTO `user_coupon` VALUES (11, 10, 6, NULL, 0, '2026-05-19 21:35:17', NULL, '2026-05-19 21:35:17', '2026-05-19 21:35:17');
INSERT INTO `user_coupon` VALUES (12, 10, 6, NULL, 0, '2026-05-19 21:35:17', NULL, '2026-05-19 21:35:17', '2026-05-19 21:35:17');
INSERT INTO `user_coupon` VALUES (13, 10, 3, NULL, 0, '2026-05-21 18:18:33', NULL, '2026-05-21 18:18:33', '2026-05-21 18:18:33');
INSERT INTO `user_coupon` VALUES (14, 10, 3, NULL, 0, '2026-05-21 18:18:37', NULL, '2026-05-21 18:18:37', '2026-05-21 18:18:37');
INSERT INTO `user_coupon` VALUES (15, 10, 10, NULL, 0, '2026-05-21 21:12:06', NULL, '2026-05-21 21:12:06', '2026-05-21 21:12:06');
INSERT INTO `user_coupon` VALUES (16, 5, 10, '1785288307763c1ac3bb6', 1, '2026-05-21 21:12:48', '2026-07-29 09:25:08', '2026-05-21 21:12:48', '2026-05-21 21:12:48');
INSERT INTO `user_coupon` VALUES (17, 2, 10, NULL, 0, '2026-05-21 21:23:20', NULL, '2026-05-21 21:23:20', '2026-05-21 21:23:20');
INSERT INTO `user_coupon` VALUES (18, 5, 1, NULL, 2, '2026-05-21 21:57:04', NULL, '2026-05-21 21:57:04', '2026-05-21 21:57:04');
INSERT INTO `user_coupon` VALUES (19, 5, 2, NULL, 2, '2026-05-21 21:57:05', NULL, '2026-05-21 21:57:05', '2026-05-21 21:57:05');
INSERT INTO `user_coupon` VALUES (20, 11, 5, '178505776290635b81616', 1, '2026-05-21 22:59:08', '2026-07-26 17:22:43', '2026-05-21 22:59:08', '2026-05-21 22:59:08');
INSERT INTO `user_coupon` VALUES (21, 11, 5, NULL, 0, '2026-05-21 22:59:08', NULL, '2026-05-21 22:59:08', '2026-05-21 22:59:08');
INSERT INTO `user_coupon` VALUES (22, 11, 5, NULL, 0, '2026-05-21 22:59:08', NULL, '2026-05-21 22:59:08', '2026-05-21 22:59:08');
INSERT INTO `user_coupon` VALUES (23, 11, 6, NULL, 0, '2026-05-21 22:59:08', NULL, '2026-05-21 22:59:08', '2026-05-21 22:59:08');
INSERT INTO `user_coupon` VALUES (24, 11, 6, NULL, 0, '2026-05-21 22:59:08', NULL, '2026-05-21 22:59:08', '2026-05-21 22:59:08');
INSERT INTO `user_coupon` VALUES (25, 11, 10, '178505782845911ed742e', 1, '2026-05-21 23:00:20', '2026-07-26 17:23:48', '2026-05-21 23:00:20', '2026-05-21 23:00:20');
INSERT INTO `user_coupon` VALUES (26, 4, 10, NULL, 0, '2026-05-21 23:01:23', NULL, '2026-05-21 23:01:23', '2026-05-21 23:01:23');
INSERT INTO `user_coupon` VALUES (27, 7, 10, NULL, 0, '2026-05-21 23:03:16', NULL, '2026-05-21 23:03:16', '2026-05-21 23:03:16');
INSERT INTO `user_coupon` VALUES (28, 8, 10, '1785550466941bb56cd7a', 1, '2026-05-21 23:03:33', '2026-08-01 10:14:27', '2026-05-21 23:03:33', '2026-05-21 23:03:33');
INSERT INTO `user_coupon` VALUES (29, 6, 1, NULL, 2, '2026-05-24 15:55:08', NULL, '2026-05-24 15:55:08', '2026-05-24 15:55:08');
INSERT INTO `user_coupon` VALUES (30, 6, 2, NULL, 2, '2026-05-24 15:55:12', NULL, '2026-05-24 15:55:12', '2026-05-24 15:55:12');
INSERT INTO `user_coupon` VALUES (31, 6, 2, NULL, 2, '2026-05-24 15:55:13', NULL, '2026-05-24 15:55:13', '2026-05-24 15:55:13');
INSERT INTO `user_coupon` VALUES (32, 6, 2, NULL, 2, '2026-05-24 15:55:14', NULL, '2026-05-24 15:55:14', '2026-05-24 15:55:14');
INSERT INTO `user_coupon` VALUES (33, 6, 2, NULL, 2, '2026-05-24 15:55:15', NULL, '2026-05-24 15:55:15', '2026-05-24 15:55:15');
INSERT INTO `user_coupon` VALUES (34, 6, 2, NULL, 2, '2026-05-24 15:55:15', NULL, '2026-05-24 15:55:15', '2026-05-24 15:55:15');
INSERT INTO `user_coupon` VALUES (35, 5, 10, '178529228815605585f78', 1, '2026-05-30 20:56:21', '2026-07-29 10:31:28', '2026-05-30 20:56:21', '2026-05-30 20:56:21');
INSERT INTO `user_coupon` VALUES (36, 8, 1, NULL, 2, '2026-08-01 10:07:33', NULL, '2026-08-01 10:07:33', '2026-08-01 10:07:33');
INSERT INTO `user_coupon` VALUES (37, 14, 5, NULL, 0, '2026-08-01 10:34:45', NULL, '2026-08-01 10:34:45', '2026-08-01 10:34:45');
INSERT INTO `user_coupon` VALUES (38, 14, 5, NULL, 0, '2026-08-01 10:34:45', NULL, '2026-08-01 10:34:45', '2026-08-01 10:34:45');
INSERT INTO `user_coupon` VALUES (39, 14, 5, NULL, 0, '2026-08-01 10:34:45', NULL, '2026-08-01 10:34:45', '2026-08-01 10:34:45');
INSERT INTO `user_coupon` VALUES (40, 14, 6, NULL, 0, '2026-08-01 10:34:45', NULL, '2026-08-01 10:34:45', '2026-08-01 10:34:45');
INSERT INTO `user_coupon` VALUES (41, 14, 6, NULL, 0, '2026-08-01 10:34:45', NULL, '2026-08-01 10:34:45', '2026-08-01 10:34:45');

-- ----------------------------
-- Table structure for user_signin_record
-- ----------------------------
DROP TABLE IF EXISTS `user_signin_record`;
CREATE TABLE `user_signin_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `sign_date` date NOT NULL COMMENT '签到日期',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_date`(`user_id` ASC, `sign_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户签到记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_signin_record
-- ----------------------------
INSERT INTO `user_signin_record` VALUES (1, 6, '2026-05-16', '2026-05-19 20:38:04');
INSERT INTO `user_signin_record` VALUES (2, 6, '2026-05-18', '2026-05-19 20:37:29');
INSERT INTO `user_signin_record` VALUES (3, 6, '2026-05-17', '2026-05-19 20:37:42');
INSERT INTO `user_signin_record` VALUES (4, 6, '2026-05-15', '2026-05-19 20:38:20');
INSERT INTO `user_signin_record` VALUES (5, 6, '2026-05-14', '2026-05-19 20:38:33');
INSERT INTO `user_signin_record` VALUES (6, 6, '2026-05-13', '2026-05-19 20:38:48');
INSERT INTO `user_signin_record` VALUES (13, 6, '2026-05-19', '2026-05-19 21:05:53');
INSERT INTO `user_signin_record` VALUES (14, 10, '2026-05-20', '2026-05-20 11:41:31');
INSERT INTO `user_signin_record` VALUES (15, 6, '2026-05-20', '2026-05-20 16:12:55');
INSERT INTO `user_signin_record` VALUES (16, 2, '2026-05-20', '2026-05-20 19:11:52');
INSERT INTO `user_signin_record` VALUES (17, 6, '2026-05-21', '2026-05-21 10:31:12');
INSERT INTO `user_signin_record` VALUES (18, 10, '2026-05-21', '2026-05-21 18:18:48');
INSERT INTO `user_signin_record` VALUES (19, 5, '2026-05-21', '2026-05-21 21:57:26');
INSERT INTO `user_signin_record` VALUES (20, 6, '2026-05-24', '2026-05-24 15:55:59');
INSERT INTO `user_signin_record` VALUES (21, 6, '2026-07-22', '2026-07-22 16:40:09');
INSERT INTO `user_signin_record` VALUES (22, 6, '2026-07-23', '2026-07-23 16:22:26');
INSERT INTO `user_signin_record` VALUES (23, 6, '2026-07-24', '2026-07-24 10:28:54');
INSERT INTO `user_signin_record` VALUES (24, 5, '2026-07-24', '2026-07-24 11:40:51');
INSERT INTO `user_signin_record` VALUES (25, 3, '2026-07-24', '2026-07-24 15:14:34');
INSERT INTO `user_signin_record` VALUES (26, 2, '2026-07-26', '2026-07-26 16:57:10');
INSERT INTO `user_signin_record` VALUES (27, 5, '2026-07-26', '2026-07-26 16:57:45');
INSERT INTO `user_signin_record` VALUES (28, 6, '2026-07-26', '2026-07-26 16:58:11');
INSERT INTO `user_signin_record` VALUES (29, 6, '2026-07-28', '2026-07-28 11:11:37');
INSERT INTO `user_signin_record` VALUES (30, 5, '2026-07-28', '2026-07-28 11:22:05');
INSERT INTO `user_signin_record` VALUES (31, 5, '2026-07-29', '2026-07-29 15:20:27');
INSERT INTO `user_signin_record` VALUES (32, 6, '2026-08-01', '2026-08-01 09:27:26');
INSERT INTO `user_signin_record` VALUES (33, 8, '2026-08-01', '2026-08-01 10:09:27');
INSERT INTO `user_signin_record` VALUES (34, 6, '2026-08-03', '2026-08-03 15:27:08');

-- ----------------------------
-- Table structure for user_signin_reward
-- ----------------------------
DROP TABLE IF EXISTS `user_signin_reward`;
CREATE TABLE `user_signin_reward`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `reward_type` tinyint NOT NULL COMMENT '1-优惠券',
  `reward_id` bigint NOT NULL COMMENT '优惠券模板ID',
  `signin_consecutive_days` int NOT NULL COMMENT '触发时的连续签到天数',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_signin_reward
-- ----------------------------
INSERT INTO `user_signin_reward` VALUES (7, 6, 1, 3, 7, '2026-05-19 21:05:53');

-- ----------------------------
-- Table structure for visit_log
-- ----------------------------
DROP TABLE IF EXISTS `visit_log`;
CREATE TABLE `visit_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID（未登录则为NULL）',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '访问IP',
  `user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'User-Agent',
  `request_uri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求URI',
  `visit_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '访问时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_visit_time`(`visit_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3877 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户访问日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of visit_log
-- ----------------------------
INSERT INTO `visit_log` VALUES (3591, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 12:00:24');
INSERT INTO `visit_log` VALUES (3592, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 12:00:24');
INSERT INTO `visit_log` VALUES (3593, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/15/all', '2026-07-29 12:00:28');
INSERT INTO `visit_log` VALUES (3594, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/15', '2026-07-29 12:00:28');
INSERT INTO `visit_log` VALUES (3595, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/15/images', '2026-07-29 12:00:28');
INSERT INTO `visit_log` VALUES (3596, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-07-29 12:00:28');
INSERT INTO `visit_log` VALUES (3597, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/add', '2026-07-29 12:00:32');
INSERT INTO `visit_log` VALUES (3598, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/admin/page', '2026-07-29 14:52:20');
INSERT INTO `visit_log` VALUES (3599, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/35', '2026-07-29 14:52:29');
INSERT INTO `visit_log` VALUES (3600, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/40', '2026-07-29 14:52:34');
INSERT INTO `visit_log` VALUES (3601, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/39', '2026-07-29 14:52:38');
INSERT INTO `visit_log` VALUES (3602, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/admin/page', '2026-07-29 14:52:53');
INSERT INTO `visit_log` VALUES (3603, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/admin/page', '2026-07-29 14:52:55');
INSERT INTO `visit_log` VALUES (3604, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/admin/page', '2026-07-29 14:53:03');
INSERT INTO `visit_log` VALUES (3605, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/user/page', '2026-07-29 14:56:03');
INSERT INTO `visit_log` VALUES (3606, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/user/page', '2026-07-29 14:56:19');
INSERT INTO `visit_log` VALUES (3607, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/admin/page', '2026-07-29 14:58:09');
INSERT INTO `visit_log` VALUES (3608, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/admin/page', '2026-07-29 14:58:49');
INSERT INTO `visit_log` VALUES (3609, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/admin/page', '2026-07-29 14:59:03');
INSERT INTO `visit_log` VALUES (3610, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/admin/page', '2026-07-29 15:01:14');
INSERT INTO `visit_log` VALUES (3611, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/admin/page', '2026-07-29 15:01:21');
INSERT INTO `visit_log` VALUES (3612, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/40', '2026-07-29 15:03:00');
INSERT INTO `visit_log` VALUES (3613, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/40', '2026-07-29 15:04:19');
INSERT INTO `visit_log` VALUES (3614, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/admin/page', '2026-07-29 15:05:55');
INSERT INTO `visit_log` VALUES (3615, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/admin/page', '2026-07-29 15:06:01');
INSERT INTO `visit_log` VALUES (3616, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/page', '2026-07-29 15:06:05');
INSERT INTO `visit_log` VALUES (3617, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/admin/page', '2026-07-29 15:09:52');
INSERT INTO `visit_log` VALUES (3618, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/admin/40', '2026-07-29 15:09:58');
INSERT INTO `visit_log` VALUES (3619, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/admin/page', '2026-07-29 15:14:35');
INSERT INTO `visit_log` VALUES (3620, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 15:15:09');
INSERT INTO `visit_log` VALUES (3621, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 15:15:09');
INSERT INTO `visit_log` VALUES (3622, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/15', '2026-07-29 15:15:36');
INSERT INTO `visit_log` VALUES (3623, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/15/all', '2026-07-29 15:15:36');
INSERT INTO `visit_log` VALUES (3624, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-07-29 15:15:36');
INSERT INTO `visit_log` VALUES (3625, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/15/images', '2026-07-29 15:15:36');
INSERT INTO `visit_log` VALUES (3626, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 15:36:04');
INSERT INTO `visit_log` VALUES (3627, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 15:36:05');
INSERT INTO `visit_log` VALUES (3628, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/3', '2026-07-29 15:36:10');
INSERT INTO `visit_log` VALUES (3629, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/3/images', '2026-07-29 15:36:11');
INSERT INTO `visit_log` VALUES (3630, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/3/all', '2026-07-29 15:36:11');
INSERT INTO `visit_log` VALUES (3631, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-07-29 15:36:11');
INSERT INTO `visit_log` VALUES (3632, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/add', '2026-07-29 15:36:16');
INSERT INTO `visit_log` VALUES (3633, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-07-29 15:36:19');
INSERT INTO `visit_log` VALUES (3634, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:05:45');
INSERT INTO `visit_log` VALUES (3635, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:05:46');
INSERT INTO `visit_log` VALUES (3636, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-07-29 16:05:50');
INSERT INTO `visit_log` VALUES (3637, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/10', '2026-07-29 16:05:50');
INSERT INTO `visit_log` VALUES (3638, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/10/images', '2026-07-29 16:05:50');
INSERT INTO `visit_log` VALUES (3639, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/10/all', '2026-07-29 16:05:50');
INSERT INTO `visit_log` VALUES (3640, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/add', '2026-07-29 16:05:55');
INSERT INTO `visit_log` VALUES (3641, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:05:58');
INSERT INTO `visit_log` VALUES (3642, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:05:58');
INSERT INTO `visit_log` VALUES (3643, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-07-29 16:06:01');
INSERT INTO `visit_log` VALUES (3644, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/12/all', '2026-07-29 16:06:01');
INSERT INTO `visit_log` VALUES (3645, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/12/images', '2026-07-29 16:06:01');
INSERT INTO `visit_log` VALUES (3646, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/12', '2026-07-29 16:06:01');
INSERT INTO `visit_log` VALUES (3647, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/add', '2026-07-29 16:06:06');
INSERT INTO `visit_log` VALUES (3648, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:06:09');
INSERT INTO `visit_log` VALUES (3649, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:06:09');
INSERT INTO `visit_log` VALUES (3650, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-07-29 16:06:12');
INSERT INTO `visit_log` VALUES (3651, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/6', '2026-07-29 16:06:12');
INSERT INTO `visit_log` VALUES (3652, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/6/all', '2026-07-29 16:06:12');
INSERT INTO `visit_log` VALUES (3653, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/6/images', '2026-07-29 16:06:12');
INSERT INTO `visit_log` VALUES (3654, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/add', '2026-07-29 16:06:18');
INSERT INTO `visit_log` VALUES (3655, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-07-29 16:06:20');
INSERT INTO `visit_log` VALUES (3656, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-07-29 16:06:24');
INSERT INTO `visit_log` VALUES (3657, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/address/list', '2026-07-29 16:06:24');
INSERT INTO `visit_log` VALUES (3658, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/create', '2026-07-29 16:06:48');
INSERT INTO `visit_log` VALUES (3659, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/clear', '2026-07-29 16:06:49');
INSERT INTO `visit_log` VALUES (3660, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/user/page', '2026-07-29 16:06:49');
INSERT INTO `visit_log` VALUES (3661, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/pay/41', '2026-07-29 16:06:54');
INSERT INTO `visit_log` VALUES (3662, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/user/page', '2026-07-29 16:06:55');
INSERT INTO `visit_log` VALUES (3663, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/41', '2026-07-29 16:07:00');
INSERT INTO `visit_log` VALUES (3664, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/user/page', '2026-07-29 16:07:03');
INSERT INTO `visit_log` VALUES (3665, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/address/list', '2026-07-29 16:07:05');
INSERT INTO `visit_log` VALUES (3666, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-07-29 16:07:05');
INSERT INTO `visit_log` VALUES (3667, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-07-29 16:07:06');
INSERT INTO `visit_log` VALUES (3668, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:07:07');
INSERT INTO `visit_log` VALUES (3669, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:07:07');
INSERT INTO `visit_log` VALUES (3670, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-07-29 16:07:13');
INSERT INTO `visit_log` VALUES (3671, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/4/all', '2026-07-29 16:07:13');
INSERT INTO `visit_log` VALUES (3672, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/4', '2026-07-29 16:07:13');
INSERT INTO `visit_log` VALUES (3673, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/4/images', '2026-07-29 16:07:13');
INSERT INTO `visit_log` VALUES (3674, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:07:18');
INSERT INTO `visit_log` VALUES (3675, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:07:19');
INSERT INTO `visit_log` VALUES (3676, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/1', '2026-07-29 16:07:20');
INSERT INTO `visit_log` VALUES (3677, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-07-29 16:07:20');
INSERT INTO `visit_log` VALUES (3678, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/1/all', '2026-07-29 16:07:20');
INSERT INTO `visit_log` VALUES (3679, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/1/images', '2026-07-29 16:07:20');
INSERT INTO `visit_log` VALUES (3680, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:07:26');
INSERT INTO `visit_log` VALUES (3681, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:07:27');
INSERT INTO `visit_log` VALUES (3682, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/4', '2026-07-29 16:07:28');
INSERT INTO `visit_log` VALUES (3683, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/4/images', '2026-07-29 16:07:28');
INSERT INTO `visit_log` VALUES (3684, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-07-29 16:07:28');
INSERT INTO `visit_log` VALUES (3685, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/4/all', '2026-07-29 16:07:28');
INSERT INTO `visit_log` VALUES (3686, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:07:30');
INSERT INTO `visit_log` VALUES (3687, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:07:30');
INSERT INTO `visit_log` VALUES (3688, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/6/images', '2026-07-29 16:07:33');
INSERT INTO `visit_log` VALUES (3689, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/6', '2026-07-29 16:07:33');
INSERT INTO `visit_log` VALUES (3690, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/6/all', '2026-07-29 16:07:33');
INSERT INTO `visit_log` VALUES (3691, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-07-29 16:07:33');
INSERT INTO `visit_log` VALUES (3692, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:07:36');
INSERT INTO `visit_log` VALUES (3693, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:07:36');
INSERT INTO `visit_log` VALUES (3694, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-07-29 16:07:38');
INSERT INTO `visit_log` VALUES (3695, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/7', '2026-07-29 16:07:38');
INSERT INTO `visit_log` VALUES (3696, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/7/all', '2026-07-29 16:07:38');
INSERT INTO `visit_log` VALUES (3697, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/7/images', '2026-07-29 16:07:38');
INSERT INTO `visit_log` VALUES (3698, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:07:40');
INSERT INTO `visit_log` VALUES (3699, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:07:41');
INSERT INTO `visit_log` VALUES (3700, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:07:44');
INSERT INTO `visit_log` VALUES (3701, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:08:03');
INSERT INTO `visit_log` VALUES (3702, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:08:03');
INSERT INTO `visit_log` VALUES (3703, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:15:28');
INSERT INTO `visit_log` VALUES (3704, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:15:28');
INSERT INTO `visit_log` VALUES (3705, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:15:34');
INSERT INTO `visit_log` VALUES (3706, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/7', '2026-07-29 16:15:36');
INSERT INTO `visit_log` VALUES (3707, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-07-29 16:15:36');
INSERT INTO `visit_log` VALUES (3708, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/7/all', '2026-07-29 16:15:36');
INSERT INTO `visit_log` VALUES (3709, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/7/images', '2026-07-29 16:15:36');
INSERT INTO `visit_log` VALUES (3710, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:16:46');
INSERT INTO `visit_log` VALUES (3711, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:16:46');
INSERT INTO `visit_log` VALUES (3712, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:19:55');
INSERT INTO `visit_log` VALUES (3713, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:19:55');
INSERT INTO `visit_log` VALUES (3714, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-07-29 16:20:00');
INSERT INTO `visit_log` VALUES (3715, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/6/images', '2026-07-29 16:20:00');
INSERT INTO `visit_log` VALUES (3716, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/6/all', '2026-07-29 16:20:00');
INSERT INTO `visit_log` VALUES (3717, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/6', '2026-07-29 16:20:00');
INSERT INTO `visit_log` VALUES (3718, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:20:04');
INSERT INTO `visit_log` VALUES (3719, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:20:04');
INSERT INTO `visit_log` VALUES (3720, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:20:08');
INSERT INTO `visit_log` VALUES (3721, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:20:11');
INSERT INTO `visit_log` VALUES (3722, 3, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:20:31');
INSERT INTO `visit_log` VALUES (3723, 3, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:20:31');
INSERT INTO `visit_log` VALUES (3724, 3, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:24:41');
INSERT INTO `visit_log` VALUES (3725, 3, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:24:41');
INSERT INTO `visit_log` VALUES (3726, 3, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:24:44');
INSERT INTO `visit_log` VALUES (3727, 3, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/6', '2026-07-29 16:24:50');
INSERT INTO `visit_log` VALUES (3728, 3, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/6/images', '2026-07-29 16:24:50');
INSERT INTO `visit_log` VALUES (3729, 3, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-07-29 16:24:50');
INSERT INTO `visit_log` VALUES (3730, 3, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/6/all', '2026-07-29 16:24:50');
INSERT INTO `visit_log` VALUES (3731, 3, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:25:07');
INSERT INTO `visit_log` VALUES (3732, 3, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:25:08');
INSERT INTO `visit_log` VALUES (3733, 3, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-07-29 16:25:33');
INSERT INTO `visit_log` VALUES (3734, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-07-29 16:25:48');
INSERT INTO `visit_log` VALUES (3735, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-07-29 16:25:57');
INSERT INTO `visit_log` VALUES (3736, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:31:41');
INSERT INTO `visit_log` VALUES (3737, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:31:41');
INSERT INTO `visit_log` VALUES (3738, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-29 16:31:44');
INSERT INTO `visit_log` VALUES (3739, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-29 16:31:44');
INSERT INTO `visit_log` VALUES (3740, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-07-31 18:00:06');
INSERT INTO `visit_log` VALUES (3741, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-07-31 18:00:06');
INSERT INTO `visit_log` VALUES (3742, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-07-31 18:00:12');
INSERT INTO `visit_log` VALUES (3743, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/page', '2026-08-01 09:23:08');
INSERT INTO `visit_log` VALUES (3744, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:27:21');
INSERT INTO `visit_log` VALUES (3745, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-01 09:27:21');
INSERT INTO `visit_log` VALUES (3746, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-01 09:27:28');
INSERT INTO `visit_log` VALUES (3747, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:27:28');
INSERT INTO `visit_log` VALUES (3748, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-01 09:27:39');
INSERT INTO `visit_log` VALUES (3749, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-01 09:27:41');
INSERT INTO `visit_log` VALUES (3750, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:27:52');
INSERT INTO `visit_log` VALUES (3751, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-01 09:27:52');
INSERT INTO `visit_log` VALUES (3752, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:27:56');
INSERT INTO `visit_log` VALUES (3753, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:27:58');
INSERT INTO `visit_log` VALUES (3754, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-01 09:28:11');
INSERT INTO `visit_log` VALUES (3755, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-01 09:28:13');
INSERT INTO `visit_log` VALUES (3756, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-01 09:37:53');
INSERT INTO `visit_log` VALUES (3757, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:37:53');
INSERT INTO `visit_log` VALUES (3758, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:37:56');
INSERT INTO `visit_log` VALUES (3759, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-08-01 09:38:02');
INSERT INTO `visit_log` VALUES (3760, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/15/images', '2026-08-01 09:38:02');
INSERT INTO `visit_log` VALUES (3761, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/15', '2026-08-01 09:38:02');
INSERT INTO `visit_log` VALUES (3762, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/15/all', '2026-08-01 09:38:02');
INSERT INTO `visit_log` VALUES (3763, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:38:05');
INSERT INTO `visit_log` VALUES (3764, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-01 09:38:05');
INSERT INTO `visit_log` VALUES (3765, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:38:16');
INSERT INTO `visit_log` VALUES (3766, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-08-01 09:38:17');
INSERT INTO `visit_log` VALUES (3767, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/16', '2026-08-01 09:38:17');
INSERT INTO `visit_log` VALUES (3768, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/16/all', '2026-08-01 09:38:17');
INSERT INTO `visit_log` VALUES (3769, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/16/images', '2026-08-01 09:38:17');
INSERT INTO `visit_log` VALUES (3770, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/add', '2026-08-01 09:38:32');
INSERT INTO `visit_log` VALUES (3771, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-01 09:38:48');
INSERT INTO `visit_log` VALUES (3772, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:38:48');
INSERT INTO `visit_log` VALUES (3773, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-01 09:44:22');
INSERT INTO `visit_log` VALUES (3774, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:44:22');
INSERT INTO `visit_log` VALUES (3775, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:44:25');
INSERT INTO `visit_log` VALUES (3776, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-01 09:53:52');
INSERT INTO `visit_log` VALUES (3777, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:53:52');
INSERT INTO `visit_log` VALUES (3778, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:53:55');
INSERT INTO `visit_log` VALUES (3779, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-08-01 09:54:03');
INSERT INTO `visit_log` VALUES (3780, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/17/images', '2026-08-01 09:54:04');
INSERT INTO `visit_log` VALUES (3781, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/17/all', '2026-08-01 09:54:04');
INSERT INTO `visit_log` VALUES (3782, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/17', '2026-08-01 09:54:04');
INSERT INTO `visit_log` VALUES (3783, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/merchant/5', '2026-08-01 09:54:06');
INSERT INTO `visit_log` VALUES (3784, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-08-01 09:54:10');
INSERT INTO `visit_log` VALUES (3785, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/17/images', '2026-08-01 09:54:11');
INSERT INTO `visit_log` VALUES (3786, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/17/all', '2026-08-01 09:54:11');
INSERT INTO `visit_log` VALUES (3787, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/17', '2026-08-01 09:54:11');
INSERT INTO `visit_log` VALUES (3788, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-01 09:54:33');
INSERT INTO `visit_log` VALUES (3789, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:54:33');
INSERT INTO `visit_log` VALUES (3790, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:54:41');
INSERT INTO `visit_log` VALUES (3791, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:54:54');
INSERT INTO `visit_log` VALUES (3792, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:54:56');
INSERT INTO `visit_log` VALUES (3793, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 09:54:58');
INSERT INTO `visit_log` VALUES (3794, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/12', '2026-08-01 09:55:11');
INSERT INTO `visit_log` VALUES (3795, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/history', '2026-08-01 09:55:11');
INSERT INTO `visit_log` VALUES (3796, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/comments/product/12/all', '2026-08-01 09:55:11');
INSERT INTO `visit_log` VALUES (3797, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/12/images', '2026-08-01 09:55:11');
INSERT INTO `visit_log` VALUES (3798, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/es/search', '2026-08-01 09:55:23');
INSERT INTO `visit_log` VALUES (3799, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/hot', '2026-08-01 09:55:23');
INSERT INTO `visit_log` VALUES (3800, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/es/search', '2026-08-01 09:55:38');
INSERT INTO `visit_log` VALUES (3801, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/17', '2026-08-01 09:55:41');
INSERT INTO `visit_log` VALUES (3802, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/history', '2026-08-01 09:55:42');
INSERT INTO `visit_log` VALUES (3803, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/comments/product/17/all', '2026-08-01 09:55:42');
INSERT INTO `visit_log` VALUES (3804, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/17/images', '2026-08-01 09:55:42');
INSERT INTO `visit_log` VALUES (3805, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/merchant/5', '2026-08-01 09:55:50');
INSERT INTO `visit_log` VALUES (3806, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/list', '2026-08-01 09:56:04');
INSERT INTO `visit_log` VALUES (3807, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/es/search', '2026-08-01 09:56:16');
INSERT INTO `visit_log` VALUES (3808, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/hot', '2026-08-01 09:56:17');
INSERT INTO `visit_log` VALUES (3809, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/es/search', '2026-08-01 09:56:21');
INSERT INTO `visit_log` VALUES (3810, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/17', '2026-08-01 09:56:24');
INSERT INTO `visit_log` VALUES (3811, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/comments/product/17/all', '2026-08-01 09:56:24');
INSERT INTO `visit_log` VALUES (3812, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/17/images', '2026-08-01 09:56:24');
INSERT INTO `visit_log` VALUES (3813, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/history', '2026-08-01 09:56:24');
INSERT INTO `visit_log` VALUES (3814, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/add', '2026-08-01 09:56:32');
INSERT INTO `visit_log` VALUES (3815, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/es/search', '2026-08-01 09:56:36');
INSERT INTO `visit_log` VALUES (3816, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/hot', '2026-08-01 09:56:36');
INSERT INTO `visit_log` VALUES (3817, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/hot', '2026-08-01 10:03:30');
INSERT INTO `visit_log` VALUES (3818, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/es/search', '2026-08-01 10:03:30');
INSERT INTO `visit_log` VALUES (3819, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-01 10:13:11');
INSERT INTO `visit_log` VALUES (3820, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 10:13:11');
INSERT INTO `visit_log` VALUES (3821, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/14', '2026-08-01 10:13:19');
INSERT INTO `visit_log` VALUES (3822, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/14/all', '2026-08-01 10:13:19');
INSERT INTO `visit_log` VALUES (3823, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-08-01 10:13:19');
INSERT INTO `visit_log` VALUES (3824, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/14/images', '2026-08-01 10:13:19');
INSERT INTO `visit_log` VALUES (3825, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/add', '2026-08-01 10:13:22');
INSERT INTO `visit_log` VALUES (3826, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-01 10:13:26');
INSERT INTO `visit_log` VALUES (3827, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/address/list', '2026-08-01 10:13:29');
INSERT INTO `visit_log` VALUES (3828, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-01 10:13:29');
INSERT INTO `visit_log` VALUES (3829, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/address/list', '2026-08-01 10:13:31');
INSERT INTO `visit_log` VALUES (3830, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/address/list', '2026-08-01 10:14:17');
INSERT INTO `visit_log` VALUES (3831, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-01 10:14:20');
INSERT INTO `visit_log` VALUES (3832, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/address/list', '2026-08-01 10:14:22');
INSERT INTO `visit_log` VALUES (3833, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-01 10:14:22');
INSERT INTO `visit_log` VALUES (3834, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/create', '2026-08-01 10:14:27');
INSERT INTO `visit_log` VALUES (3835, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/clear', '2026-08-01 10:14:27');
INSERT INTO `visit_log` VALUES (3836, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-01 10:14:28');
INSERT INTO `visit_log` VALUES (3837, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/pay/42', '2026-08-01 10:14:32');
INSERT INTO `visit_log` VALUES (3838, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-01 10:14:32');
INSERT INTO `visit_log` VALUES (3839, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 10:14:36');
INSERT INTO `visit_log` VALUES (3840, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-01 10:14:36');
INSERT INTO `visit_log` VALUES (3841, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/14', '2026-08-01 10:14:38');
INSERT INTO `visit_log` VALUES (3842, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-08-01 10:14:38');
INSERT INTO `visit_log` VALUES (3843, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/14/images', '2026-08-01 10:14:38');
INSERT INTO `visit_log` VALUES (3844, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/14/all', '2026-08-01 10:14:38');
INSERT INTO `visit_log` VALUES (3845, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/14', '2026-08-01 10:15:40');
INSERT INTO `visit_log` VALUES (3846, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/history', '2026-08-01 10:15:40');
INSERT INTO `visit_log` VALUES (3847, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/14/images', '2026-08-01 10:15:40');
INSERT INTO `visit_log` VALUES (3848, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/comments/product/14/all', '2026-08-01 10:15:40');
INSERT INTO `visit_log` VALUES (3849, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-01 10:18:20');
INSERT INTO `visit_log` VALUES (3850, NULL, '0:0:0:0:0:0:0:1', 'curl/8.19.0', '/api/product/list', '2026-08-01 10:32:52');
INSERT INTO `visit_log` VALUES (3851, 14, '0:0:0:0:0:0:0:1', 'curl/8.19.0', '/api/product/1', '2026-08-01 10:35:04');
INSERT INTO `visit_log` VALUES (3852, 14, '0:0:0:0:0:0:0:1', 'curl/8.19.0', '/api/cart/add', '2026-08-01 10:36:24');
INSERT INTO `visit_log` VALUES (3853, 14, '0:0:0:0:0:0:0:1', 'curl/8.19.0', '/api/cart/list', '2026-08-01 10:36:24');
INSERT INTO `visit_log` VALUES (3854, 14, '0:0:0:0:0:0:0:1', 'curl/8.19.0', '/api/address/list', '2026-08-01 10:37:19');
INSERT INTO `visit_log` VALUES (3855, 14, '0:0:0:0:0:0:0:1', 'curl/8.19.0', '/api/order/create', '2026-08-01 10:37:20');
INSERT INTO `visit_log` VALUES (3856, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-01 10:38:11');
INSERT INTO `visit_log` VALUES (3857, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/address/list', '2026-08-01 10:38:13');
INSERT INTO `visit_log` VALUES (3858, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/address/list', '2026-08-01 10:38:25');
INSERT INTO `visit_log` VALUES (3859, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/address/12', '2026-08-01 10:38:28');
INSERT INTO `visit_log` VALUES (3860, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/address/list', '2026-08-01 10:38:29');
INSERT INTO `visit_log` VALUES (3861, 14, '0:0:0:0:0:0:0:1', 'curl/8.19.0', '/api/address/list', '2026-08-01 10:38:48');
INSERT INTO `visit_log` VALUES (3862, 14, '0:0:0:0:0:0:0:1', 'curl/8.19.0', '/api/order/create', '2026-08-01 10:38:48');
INSERT INTO `visit_log` VALUES (3863, 14, '0:0:0:0:0:0:0:1', 'curl/8.19.0', '/api/address/list', '2026-08-01 10:40:05');
INSERT INTO `visit_log` VALUES (3864, 14, '0:0:0:0:0:0:0:1', 'curl/8.19.0', '/api/cart/add', '2026-08-01 10:40:05');
INSERT INTO `visit_log` VALUES (3865, 14, '0:0:0:0:0:0:0:1', 'curl/8.19.0', '/api/order/create', '2026-08-01 10:40:06');
INSERT INTO `visit_log` VALUES (3866, 14, '0:0:0:0:0:0:0:1', 'curl/8.19.0', '/api/order/user/page', '2026-08-01 10:40:06');
INSERT INTO `visit_log` VALUES (3867, 14, '0:0:0:0:0:0:0:1', 'curl/8.19.0', '/api/order/43', '2026-08-01 10:40:18');
INSERT INTO `visit_log` VALUES (3868, 14, '0:0:0:0:0:0:0:1', 'curl/8.19.0', '/api/order/43', '2026-08-01 10:40:55');
INSERT INTO `visit_log` VALUES (3869, 2, '0:0:0:0:0:0:0:1', 'curl/8.19.0', '/api/product/2', '2026-08-01 10:42:52');
INSERT INTO `visit_log` VALUES (3870, 2, '0:0:0:0:0:0:0:1', 'Python-urllib/3.14', '/api/product/2', '2026-08-01 10:43:11');
INSERT INTO `visit_log` VALUES (3871, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-01 10:45:46');
INSERT INTO `visit_log` VALUES (3872, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-01 10:47:20');
INSERT INTO `visit_log` VALUES (3873, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-01 10:47:20');
INSERT INTO `visit_log` VALUES (3874, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/page', '2026-08-03 15:26:03');
INSERT INTO `visit_log` VALUES (3875, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-03 15:26:47');
INSERT INTO `visit_log` VALUES (3876, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-03 15:26:47');

SET FOREIGN_KEY_CHECKS = 1;
