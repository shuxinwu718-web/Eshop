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

 Date: 11/08/2026 16:35:06
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
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '收货地址表' ROW_FORMAT = Dynamic;

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
INSERT INTO `address` VALUES (14, 7, 'WU', '13536911064', 'GD', 'ST', 'XS', 'SG', 1, '2026-08-11 11:58:54', '2026-08-11 11:58:54');

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
) ENGINE = InnoDB AUTO_INCREMENT = 73 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart
-- ----------------------------
INSERT INTO `cart` VALUES (57, 14, 1, 46, '{\"存储\": \"512GB\"}', 2, 1, '2026-08-01 10:36:24', '2026-08-01 10:36:24');
INSERT INTO `cart` VALUES (58, 14, 2, 3, '{\"存储\": \"256GB\", \"颜色\": \"雅丹黑\"}', 1, 1, '2026-08-01 10:40:05', '2026-08-01 10:40:05');
INSERT INTO `cart` VALUES (59, 4, 1, NULL, NULL, 4, 1, '2026-08-06 17:55:41', '2026-08-06 17:55:41');
INSERT INTO `cart` VALUES (66, 6, 15, 45, '{\"个数\": \"20\"}', 1, 1, '2026-08-10 18:00:26', '2026-08-10 18:00:26');
INSERT INTO `cart` VALUES (67, 6, 8, 24, '{\"配置\": \"i7+4060\"}', 1, 1, '2026-08-10 18:00:52', '2026-08-10 18:00:52');
INSERT INTO `cart` VALUES (68, 6, 12, 36, '{\"颜色\": \"白色\"}', 1, 1, '2026-08-10 18:00:59', '2026-08-10 18:00:59');
INSERT INTO `cart` VALUES (69, 6, 7, NULL, NULL, 1, 1, '2026-08-10 18:01:12', '2026-08-10 18:01:12');
INSERT INTO `cart` VALUES (70, 6, 14, NULL, NULL, 5, 1, '2026-08-10 18:01:31', '2026-08-10 18:01:31');
INSERT INTO `cart` VALUES (71, 6, 11, 32, '{\"颜色\": \"黑色\"}', 1, 1, '2026-08-10 18:01:39', '2026-08-10 18:01:39');
INSERT INTO `cart` VALUES (72, 6, 11, 34, '{\"颜色\": \"灰色\"}', 1, 1, '2026-08-10 18:01:40', '2026-08-10 18:01:40');

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
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '优惠券定义' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of favorite
-- ----------------------------
INSERT INTO `favorite` VALUES (1, 6, 8, '2026-05-15 12:50:57');
INSERT INTO `favorite` VALUES (4, 6, 9, '2026-05-20 18:24:29');
INSERT INTO `favorite` VALUES (6, 6, 13, '2026-05-20 18:34:41');
INSERT INTO `favorite` VALUES (9, 2, 12, '2026-05-20 19:09:30');
INSERT INTO `favorite` VALUES (10, 5, 4, '2026-05-21 11:15:17');
INSERT INTO `favorite` VALUES (11, 6, 12, '2026-07-22 16:37:31');
INSERT INTO `favorite` VALUES (12, 5, 2, '2026-08-11 11:14:01');

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
-- Table structure for group_buy_activity
-- ----------------------------
DROP TABLE IF EXISTS `group_buy_activity`;
CREATE TABLE `group_buy_activity`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `sku_id` bigint NULL DEFAULT NULL COMMENT 'SKU ID（无规格商品为 NULL，绑定单规格拼团价）',
  `group_price` decimal(10, 2) NOT NULL COMMENT '拼团价',
  `target_count` int NOT NULL DEFAULT 2 COMMENT '成团人数（2/3/5）',
  `duration_hours` int NOT NULL DEFAULT 24 COMMENT '拼团有效期（小时，开团后该团成团截止时间）',
  `start_time` datetime NOT NULL COMMENT '活动开始时间',
  `end_time` datetime NOT NULL COMMENT '活动结束时间',
  `total_stock` int NOT NULL DEFAULT 0 COMMENT '拼团可售库存（原子扣减）',
  `sold_count` int NOT NULL DEFAULT 0 COMMENT '已成团份数',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0草稿 1进行中 2已暂停 3已终止',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product`(`product_id` ASC) USING BTREE,
  INDEX `idx_merchant_status`(`merchant_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '拼团活动表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of group_buy_activity
-- ----------------------------
INSERT INTO `group_buy_activity` VALUES (1, 2, 2, 3, 6300.00, 2, 48, '2026-08-12 00:00:00', '2026-08-14 00:00:00', 5, 0, 3, '2026-08-11 11:12:32', '2026-08-11 11:25:18', 0);
INSERT INTO `group_buy_activity` VALUES (2, 2, 2, 3, 6200.00, 2, 24, '2026-08-11 00:00:00', '2026-08-12 00:00:00', 0, 1, 1, '2026-08-11 11:26:47', '2026-08-11 11:56:59', 0);
INSERT INTO `group_buy_activity` VALUES (3, 5, 16, 50, 16.00, 2, 24, '2026-08-11 00:00:00', '2026-08-12 00:00:00', 10, 1, 1, '2026-08-11 14:40:16', '2026-08-11 14:40:16', 0);

-- ----------------------------
-- Table structure for group_buy_group
-- ----------------------------
DROP TABLE IF EXISTS `group_buy_group`;
CREATE TABLE `group_buy_group`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '团ID',
  `activity_id` bigint NOT NULL COMMENT '活动ID',
  `group_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '团号',
  `leader_id` bigint NOT NULL COMMENT '开团用户ID',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态：0拼团中 1已成团 2拼团失败已退款 3已取消',
  `expire_time` datetime NOT NULL COMMENT '成团截止时间',
  `success_time` datetime NULL DEFAULT NULL COMMENT '成团时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_activity_status`(`activity_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_leader`(`leader_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '拼团团表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of group_buy_group
-- ----------------------------
INSERT INTO `group_buy_group` VALUES (1, 2, 'T1786418844871791', 5, 1, '2026-08-12 11:27:25', '2026-08-11 11:43:20', '2026-08-11 11:27:25', '2026-08-11 11:27:24', 0);
INSERT INTO `group_buy_group` VALUES (3, 2, 'T1786419954351941', 6, 3, '2026-08-12 11:45:54', NULL, '2026-08-11 11:45:54', '2026-08-11 11:45:54', 0);
INSERT INTO `group_buy_group` VALUES (4, 2, 'T1786420620046670', 6, 0, '2026-08-12 11:57:00', NULL, '2026-08-11 11:57:00', '2026-08-11 11:57:00', 0);
INSERT INTO `group_buy_group` VALUES (5, 3, 'T1786430450294271', 8, 1, '2026-08-12 14:40:50', '2026-08-11 14:42:02', '2026-08-11 14:40:50', '2026-08-11 14:40:50', 0);
INSERT INTO `group_buy_group` VALUES (6, 3, 'T1786430532885395', 6, 3, '2026-08-12 14:42:13', NULL, '2026-08-11 14:42:13', '2026-08-11 14:42:12', 0);

-- ----------------------------
-- Table structure for group_buy_member
-- ----------------------------
DROP TABLE IF EXISTS `group_buy_member`;
CREATE TABLE `group_buy_member`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '成员ID',
  `group_id` bigint NOT NULL COMMENT '团ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `role` tinyint NOT NULL DEFAULT 0 COMMENT '角色：1开团 0参团',
  `pay_status` tinyint NOT NULL DEFAULT 0 COMMENT '支付状态：0待支付 1已支付',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  `deleted` tinyint NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_group`(`group_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '拼团成员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of group_buy_member
-- ----------------------------
INSERT INTO `group_buy_member` VALUES (1, 1, 5, 72, 1, 0, '2026-08-11 11:27:25', 0);
INSERT INTO `group_buy_member` VALUES (2, 2, 5, 73, 1, 1, '2026-08-11 11:28:01', 0);
INSERT INTO `group_buy_member` VALUES (3, 1, 8, 74, 0, 1, '2026-08-11 11:41:28', 0);
INSERT INTO `group_buy_member` VALUES (4, 1, 6, 75, 0, 1, '2026-08-11 11:43:08', 0);
INSERT INTO `group_buy_member` VALUES (5, 3, 6, 76, 1, 0, '2026-08-11 11:45:54', 1);
INSERT INTO `group_buy_member` VALUES (6, 4, 6, 77, 1, 1, '2026-08-11 11:57:00', 0);
INSERT INTO `group_buy_member` VALUES (7, 5, 8, 78, 1, 1, '2026-08-11 14:40:50', 0);
INSERT INTO `group_buy_member` VALUES (8, 5, 6, 79, 0, 1, '2026-08-11 14:41:48', 0);
INSERT INTO `group_buy_member` VALUES (9, 6, 6, 80, 1, 0, '2026-08-11 14:42:13', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 119 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志表' ROW_FORMAT = Dynamic;

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
INSERT INTO `operation_log` VALUES (104, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-07 09:34:35');
INSERT INTO `operation_log` VALUES (105, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":2,\"pageSize\":10,\"username\":\"\",\"phone\":\"\",\"email\":\"\",\"status\":null}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-07 09:34:38');
INSERT INTO `operation_log` VALUES (106, 1, 'admin', 'VIEW_ONLINE_USERS', 'User', NULL, '查看在线用户', '/api/user/admin/online', '', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-07 09:35:02');
INSERT INTO `operation_log` VALUES (107, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":null,\"phone\":null,\"email\":null,\"status\":null}]', '127.0.0.1', NULL, '2026-08-07 15:51:52');
INSERT INTO `operation_log` VALUES (108, 1, 'admin', 'QUERY_USERS', 'User', NULL, '分页查询用户列表', '/api/user/admin/page', '[{\"pageNum\":1,\"pageSize\":10,\"username\":null,\"phone\":null,\"email\":null,\"status\":null}]', '127.0.0.1', NULL, '2026-08-07 15:52:54');
INSERT INTO `operation_log` VALUES (109, 1, 'admin', 'ADD_SECKILL_SESSION', 'SeckillSession', NULL, '新增秒杀场次', '/admin/seckill', '[{\"id\":null,\"seckillType\":1,\"couponId\":null,\"productId\":16,\"skuId\":null,\"seckillPrice\":9.9,\"sessionName\":\"????-????\",\"startTime\":\"2026-08-07T17:53:00\",\"endTime\":\"2026-08-07T23:59:59\",\"seckillStock\":50,\"limitPerUser\":1}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '2026-08-07 17:51:17');
INSERT INTO `operation_log` VALUES (110, 4, 'lisi', 'CANCEL_ORDER', 'Order', 65, '取消订单', '/api/order/cancel/65', '[65,\"Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiVVNFUiIsInN2ZXIiOjExLCJ1c2VySWQiOjQsInN1YiI6Imxpc2kiLCJpYXQiOjE3ODYwOTYzMDksImV4cCI6MTc4NjExMDcwOX0.KyTaIi43eIBCE8DWVnaOcWbAqW0AER5zEfShU1wB9Ho\"]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '2026-08-07 17:53:54');
INSERT INTO `operation_log` VALUES (111, 1, 'admin', 'ADD_SECKILL_SESSION', 'SeckillSession', NULL, '新增秒杀场次', '/admin/seckill', '[{\"id\":null,\"seckillType\":0,\"couponId\":1,\"productId\":null,\"skuId\":null,\"seckillPrice\":null,\"sessionName\":\"????-??\",\"startTime\":\"2026-08-07T17:55:00\",\"endTime\":\"2026-08-07T23:59:59\",\"seckillStock\":10,\"limitPerUser\":1}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '2026-08-07 17:54:10');
INSERT INTO `operation_log` VALUES (112, 1, 'admin', 'ADD_SECKILL_SESSION', 'SeckillSession', NULL, '新增秒杀场次', '/admin/seckill', '[{\"id\":null,\"seckillType\":1,\"couponId\":null,\"productId\":17,\"skuId\":55,\"seckillPrice\":14.8,\"sessionName\":\"生活大甩卖\",\"startTime\":\"2026-08-08T09:34:00\",\"endTime\":\"2026-08-08T23:00:00\",\"seckillStock\":20,\"limitPerUser\":1}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-08 09:33:37');
INSERT INTO `operation_log` VALUES (113, 1, 'admin', 'PREHEAT_SECKILL', 'SeckillSession', 9, '预热秒杀库存', '/admin/seckill/preheat/9', '[9]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-08 09:33:42');
INSERT INTO `operation_log` VALUES (114, 1, 'admin', 'ADD_SECKILL_SESSION', 'SeckillSession', NULL, '新增秒杀场次', '/admin/seckill', '[{\"id\":null,\"seckillType\":0,\"couponId\":2,\"productId\":null,\"skuId\":null,\"seckillPrice\":null,\"sessionName\":\"88大促卷\",\"startTime\":\"2026-08-08T10:30:00\",\"endTime\":\"2026-08-09T00:00:00\",\"seckillStock\":30,\"limitPerUser\":2}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-08 10:22:39');
INSERT INTO `operation_log` VALUES (115, 1, 'admin', 'ADD_SECKILL_SESSION', 'SeckillSession', NULL, '新增秒杀场次', '/admin/seckill', '[{\"id\":null,\"seckillType\":1,\"couponId\":null,\"productId\":13,\"skuId\":null,\"seckillPrice\":70,\"sessionName\":\"大促\",\"startTime\":\"2026-08-08T10:25:00\",\"endTime\":\"2026-08-09T00:00:00\",\"seckillStock\":10,\"limitPerUser\":1}]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-08 10:23:53');
INSERT INTO `operation_log` VALUES (116, 1, 'admin', 'PREHEAT_SECKILL', 'SeckillSession', 10, '预热秒杀库存', '/admin/seckill/preheat/10', '[10]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-08 10:24:01');
INSERT INTO `operation_log` VALUES (117, 1, 'admin', 'PREHEAT_SECKILL', 'SeckillSession', 11, '预热秒杀库存', '/admin/seckill/preheat/11', '[11]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-08 10:24:02');
INSERT INTO `operation_log` VALUES (118, 6, 'star', 'CANCEL_ORDER', 'Order', 76, '取消订单', '/api/order/cancel/76', '[76,\"Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiVVNFUiIsInN2ZXIiOjMwLCJ1c2VySWQiOjYsInN1YiI6InN0YXIiLCJpYXQiOjE3ODY0MTk3ODMsImV4cCI6MTc4NjQzNDE4M30.ZZp3ogtuF0zojw1V6kjLpAheudSO2al5vMZVCreqbyk\"]', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-11 11:46:13');

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
  `seckill_session_id` bigint NULL DEFAULT NULL COMMENT '秒杀场次ID（秒杀商品订单来源标记）',
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
) ENGINE = InnoDB AUTO_INCREMENT = 81 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES (33, '1785231745150d32c679a', 5, 25.00, 25.00, 1, NULL, 0, 4, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-28 17:42:25', NULL, NULL, '2026-07-29 09:10:00', 0);
INSERT INTO `order` VALUES (34, '1785288307763c1ac3bb6', 5, 8.00, 6.00, 1, NULL, 1, 1, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-29 09:25:08', '2026-07-29 09:25:32', NULL, NULL, 0);
INSERT INTO `order` VALUES (35, '1785291448957944bf3ff', 5, 7999.00, 7999.00, 1, NULL, 1, 6, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-29 10:17:29', '2026-07-29 10:17:36', NULL, NULL, 0);
INSERT INTO `order` VALUES (36, '178529228815605585f78', 5, 25.00, 23.00, 1, NULL, 1, 3, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-29 10:31:28', '2026-07-29 10:31:34', '2026-07-29 10:32:12', NULL, 0);
INSERT INTO `order` VALUES (37, '17852938863125423eb47', 5, 25.00, 25.00, 1, NULL, 1, 1, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-29 10:58:06', '2026-07-29 10:58:14', NULL, NULL, 0);
INSERT INTO `order` VALUES (38, '17852941854690fda4ec3', 5, 25.00, 25.00, 1, NULL, 1, 1, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-29 11:03:05', '2026-07-29 11:03:11', NULL, NULL, 0);
INSERT INTO `order` VALUES (39, '1785295068774c0058901', 5, 200.00, 200.00, 1, NULL, 1, 1, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-29 11:17:49', '2026-07-29 11:17:54', NULL, NULL, 0);
INSERT INTO `order` VALUES (40, '1785296648140c71b68f0', 5, 3000.00, 3000.00, 1, NULL, 1, 6, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-07-29 11:44:08', '2026-07-29 11:44:14', NULL, NULL, 0);
INSERT INTO `order` VALUES (41, '1785312408401ea0735a5', 6, 849.00, 849.00, 1, NULL, 1, 1, '星', '13887654321', '广东省深圳市福田区华强北3号', '', '2026-07-29 16:06:48', '2026-07-29 16:06:54', NULL, NULL, 0);
INSERT INTO `order` VALUES (42, '1785550466941bb56cd7a', 8, 25.00, 23.00, 1, NULL, 1, 1, 'WU', '123215313', '广东汕头潮南峡山街道金狮商场513', '', '2026-08-01 10:14:27', '2026-08-01 10:14:32', NULL, NULL, 0);
INSERT INTO `order` VALUES (43, '1785552005639f291d4bf', 14, 6499.00, 6499.00, 1, NULL, 0, 4, 't', '13800000008', 'gdsznsx1', NULL, '2026-08-01 10:40:06', NULL, NULL, '2026-08-01 11:15:00', 0);
INSERT INTO `order` VALUES (64, '1786090206080679b6638', 5, 16998.00, 16998.00, 1, NULL, 1, 3, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', '', '2026-08-07 16:10:06', '2026-08-07 16:10:32', '2026-08-07 16:12:55', NULL, 0);
INSERT INTO `order` VALUES (66, '1786152882423e3aaccb6', 6, 14.80, 14.80, 1, 9, 0, 4, '星', '13887654321', '广东省深圳市福田区华强北3号', NULL, '2026-08-08 09:34:42', NULL, NULL, '2026-08-08 10:05:00', 0);
INSERT INTO `order` VALUES (67, '1786154884831a05e6101', 8, 14.80, 14.80, 1, 9, 0, 4, 'WU', '123215313', '广东汕头潮南峡山街道金狮商场513', NULL, '2026-08-08 10:08:05', NULL, NULL, '2026-08-08 10:40:00', 0);
INSERT INTO `order` VALUES (68, '17861549740929d88b48f', 8, 1628.00, 1628.00, 1, NULL, 0, 4, 'WU', '123215313', '广东汕头潮南峡山街道金狮商场513', '', '2026-08-08 10:09:34', NULL, NULL, '2026-08-08 10:40:00', 0);
INSERT INTO `order` VALUES (69, '1786155207302c0405b9b', 2, 14.80, 14.80, 1, 9, 1, 1, '摩羯', '1235822154', '广东汕头潮南峡山街道', NULL, '2026-08-08 10:13:27', '2026-08-08 10:18:13', NULL, NULL, 0);
INSERT INTO `order` VALUES (70, '1786155925140a3273a82', 6, 70.00, 70.00, 1, 11, 0, 4, '星', '13887654321', '广东省深圳市福田区华强北3号', NULL, '2026-08-08 10:25:25', NULL, NULL, '2026-08-08 11:00:00', 0);
INSERT INTO `order` VALUES (71, '17861563569468c944b84', 6, 14.80, 14.80, 1, 9, 0, 4, '星', '13887654321', '广东省深圳市福田区华强北3号', NULL, '2026-08-08 10:32:37', NULL, NULL, '2026-08-08 11:05:00', 0);
INSERT INTO `order` VALUES (72, '1786418844837444e65d5', 5, 6200.00, 6200.00, 2, NULL, 0, 4, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', NULL, '2026-08-11 11:27:25', NULL, NULL, '2026-08-11 12:00:00', 0);
INSERT INTO `order` VALUES (73, '1786418881220cd6b7743', 5, 6200.00, 6200.00, 2, NULL, 1, 1, '鲍勃', '13536911064', '广东肇庆端州肇庆学院', NULL, '2026-08-11 11:28:01', '2026-08-11 11:42:20', NULL, NULL, 0);
INSERT INTO `order` VALUES (74, '178641968777532aadc82', 8, 6200.00, 6200.00, 2, NULL, 1, 1, 'WU', '123215313', '广东汕头潮南峡山街道金狮商场513', NULL, '2026-08-11 11:41:28', '2026-08-11 11:41:35', NULL, NULL, 0);
INSERT INTO `order` VALUES (75, '1786419788227ed97ddf6', 6, 6200.00, 6200.00, 2, NULL, 1, 1, '星', '13887654321', '广东省深圳市福田区华强北3号', NULL, '2026-08-11 11:43:08', '2026-08-11 11:43:20', NULL, NULL, 0);
INSERT INTO `order` VALUES (76, '1786419954335d353b3b6', 6, 6200.00, 6200.00, 2, NULL, 0, 4, '星', '13887654321', '广东省深圳市福田区华强北3号', NULL, '2026-08-11 11:45:54', NULL, NULL, '2026-08-11 11:46:13', 0);
INSERT INTO `order` VALUES (77, '17864206200109346157b', 6, 6200.00, 6200.00, 2, NULL, 1, 1, '星', '13887654321', '广东省深圳市福田区华强北3号', NULL, '2026-08-11 11:57:00', '2026-08-11 11:57:19', NULL, NULL, 0);
INSERT INTO `order` VALUES (78, '17864304502468f138a7a', 8, 16.00, 16.00, 2, NULL, 1, 1, 'WU', '123215313', '广东汕头潮南峡山街道金狮商场513', NULL, '2026-08-11 14:40:50', '2026-08-11 14:41:06', NULL, NULL, 0);
INSERT INTO `order` VALUES (79, '1786430507541ba1b10c3', 6, 16.00, 16.00, 2, NULL, 1, 1, '星', '13887654321', '广东省深圳市福田区华强北3号', NULL, '2026-08-11 14:41:48', '2026-08-11 14:42:01', NULL, NULL, 0);
INSERT INTO `order` VALUES (80, '178643053285336ba5118', 6, 16.00, 16.00, 2, NULL, 0, 4, '星', '13887654321', '广东省深圳市福田区华强北3号', NULL, '2026-08-11 14:42:13', NULL, NULL, '2026-08-11 15:15:00', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 94 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

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
INSERT INTO `order_item` VALUES (75, 64, 85, 4, 11, '配置:i9+4060', '联想拯救者 Y9000P 笔记本电脑', 'https://picsum.photos/800/400?random=4', 8999.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (76, 64, 85, 3, 9, '存储:256GB, 颜色:白色钛', 'Apple iPhone 15 Pro', '/uploads/2026-05-16/79404ffc-8d49-47d2-81f6-8e4d168838fb.jpg', 7999.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (78, 66, 87, 17, 55, '尺寸:热销组合【4条装：灰色 + 条纹】各两条', '7A抗菌男士毛巾', '/uploads/2026-08-01/9440dce2-ba39-4b26-80e0-715f1308f254.jpg', 14.80, 1, DEFAULT);
INSERT INTO `order_item` VALUES (79, 67, 88, 17, 55, '尺寸:热销组合【4条装：灰色 + 条纹】各两条', '7A抗菌男士毛巾', '/uploads/2026-08-01/9440dce2-ba39-4b26-80e0-715f1308f254.jpg', 14.80, 1, DEFAULT);
INSERT INTO `order_item` VALUES (80, 68, 89, 5, 19, '尺码:40, 颜色:红白', '耐克 Air Max 90 运动鞋', '/uploads/2026-05-21/82f0d924-4cf7-44ad-b2e9-59fb8cfea61f.jpg', 129.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (81, 68, 90, 7, NULL, NULL, '华为 FreeBuds Pro 3', '/uploads/2026-07-29/643fd90a-df07-4b62-b9c3-0e2bfe0c65bc.png', 1499.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (82, 69, 91, 17, 55, '尺寸:热销组合【4条装：灰色 + 条纹】各两条', '7A抗菌男士毛巾', '/uploads/2026-08-01/9440dce2-ba39-4b26-80e0-715f1308f254.jpg', 14.80, 1, DEFAULT);
INSERT INTO `order_item` VALUES (83, 70, 92, 13, NULL, NULL, '【180粒/瓶98%高纯度加强版】加拿大原装正品进口深海鱼油Omega3', '/uploads/2026-05-20/ddec6125-7563-4bc4-80bb-a88ff4d51bb1.jpg', 70.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (84, 71, 93, 17, 55, '尺寸:热销组合【4条装：灰色 + 条纹】各两条', '7A抗菌男士毛巾', '/uploads/2026-08-01/9440dce2-ba39-4b26-80e0-715f1308f254.jpg', 14.80, 1, DEFAULT);
INSERT INTO `order_item` VALUES (85, 72, 94, 2, 3, '存储:256GB, 颜色:雅丹黑', '华为 Mate 60 Pro', '/uploads/2026-05-17/ac3a98e5-0469-4b3c-afad-d029a5f4420a.jpg', 6200.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (86, 73, 95, 2, 3, '存储:256GB, 颜色:雅丹黑', '华为 Mate 60 Pro', '/uploads/2026-05-17/ac3a98e5-0469-4b3c-afad-d029a5f4420a.jpg', 6200.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (87, 74, 96, 2, 3, '存储:256GB, 颜色:雅丹黑', '华为 Mate 60 Pro', '/uploads/2026-05-17/ac3a98e5-0469-4b3c-afad-d029a5f4420a.jpg', 6200.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (88, 75, 97, 2, 3, '存储:256GB, 颜色:雅丹黑', '华为 Mate 60 Pro', '/uploads/2026-05-17/ac3a98e5-0469-4b3c-afad-d029a5f4420a.jpg', 6200.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (89, 76, 98, 2, 3, '存储:256GB, 颜色:雅丹黑', '华为 Mate 60 Pro', '/uploads/2026-05-17/ac3a98e5-0469-4b3c-afad-d029a5f4420a.jpg', 6200.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (90, 77, 99, 2, 3, '存储:256GB, 颜色:雅丹黑', '华为 Mate 60 Pro', '/uploads/2026-05-17/ac3a98e5-0469-4b3c-afad-d029a5f4420a.jpg', 6200.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (91, 78, 100, 16, 50, '袋数:1, 包数/袋:20', '纸巾', '/uploads/2026-08-01/f379b151-7bc3-4876-a268-ae461a66e4f2.jpg', 16.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (92, 79, 101, 16, 50, '袋数:1, 包数/袋:20', '纸巾', '/uploads/2026-08-01/f379b151-7bc3-4876-a268-ae461a66e4f2.jpg', 16.00, 1, DEFAULT);
INSERT INTO `order_item` VALUES (93, 80, 102, 16, 50, '袋数:1, 包数/袋:20', '纸巾', '/uploads/2026-08-01/f379b151-7bc3-4876-a268-ae461a66e4f2.jpg', 16.00, 1, DEFAULT);

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
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '发货单（按商家拆分的履约单元）' ROW_FORMAT = Dynamic;

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
INSERT INTO `order_shipment` VALUES (85, 64, 2, 2, '顺丰快递', 'wdqw15616512', '2026-08-07 16:12:16', '2026-08-07 16:12:55', 16998.00, '2026-08-07 16:10:06');
INSERT INTO `order_shipment` VALUES (87, 66, 5, 0, NULL, NULL, NULL, NULL, 14.80, '2026-08-08 09:34:42');
INSERT INTO `order_shipment` VALUES (88, 67, 5, 0, NULL, NULL, NULL, NULL, 14.80, '2026-08-08 10:08:05');
INSERT INTO `order_shipment` VALUES (89, 68, 3, 0, NULL, NULL, NULL, NULL, 129.00, '2026-08-08 10:09:34');
INSERT INTO `order_shipment` VALUES (90, 68, 2, 0, NULL, NULL, NULL, NULL, 1499.00, '2026-08-08 10:09:34');
INSERT INTO `order_shipment` VALUES (91, 69, 5, 0, NULL, NULL, NULL, NULL, 14.80, '2026-08-08 10:13:27');
INSERT INTO `order_shipment` VALUES (92, 70, 5, 0, NULL, NULL, NULL, NULL, 70.00, '2026-08-08 10:25:25');
INSERT INTO `order_shipment` VALUES (93, 71, 5, 0, NULL, NULL, NULL, NULL, 14.80, '2026-08-08 10:32:37');
INSERT INTO `order_shipment` VALUES (94, 72, 2, 0, NULL, NULL, NULL, NULL, 6200.00, '2026-08-11 11:27:25');
INSERT INTO `order_shipment` VALUES (95, 73, 2, 0, NULL, NULL, NULL, NULL, 6200.00, '2026-08-11 11:28:01');
INSERT INTO `order_shipment` VALUES (96, 74, 2, 0, NULL, NULL, NULL, NULL, 6200.00, '2026-08-11 11:41:28');
INSERT INTO `order_shipment` VALUES (97, 75, 2, 0, NULL, NULL, NULL, NULL, 6200.00, '2026-08-11 11:43:08');
INSERT INTO `order_shipment` VALUES (98, 76, 2, 0, NULL, NULL, NULL, NULL, 6200.00, '2026-08-11 11:45:54');
INSERT INTO `order_shipment` VALUES (99, 77, 2, 0, NULL, NULL, NULL, NULL, 6200.00, '2026-08-11 11:57:00');
INSERT INTO `order_shipment` VALUES (100, 78, 5, 0, NULL, NULL, NULL, NULL, 16.00, '2026-08-11 14:40:50');
INSERT INTO `order_shipment` VALUES (101, 79, 5, 0, NULL, NULL, NULL, NULL, 16.00, '2026-08-11 14:41:48');
INSERT INTO `order_shipment` VALUES (102, 80, 5, 0, NULL, NULL, NULL, NULL, 16.00, '2026-08-11 14:42:13');

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
  `views` int NOT NULL DEFAULT 0 COMMENT '浏览量',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_merchant`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES (1, '小米14 Ultra 白色限量版', 'xiao mi 1 4   U l t r a   bai se xian liang ban', 2, 2, 6999.00, 0, '白色陶瓷机身，徕卡四摄，限量版', '/uploads/2026-07-29/a37dd820-d69a-4083-a448-2c8076a695e0.png', 1, '2026-05-11 17:02:05', '2026-07-29 11:01:45', 0, 0, 0);
INSERT INTO `product` VALUES (2, '华为 Mate 60 Pro', 'hua wei   M a t e   6 0   P r o', 2, 2, 6999.00, 23, '卫星通话，鸿蒙OS，玄武架构，超光变主摄', '/uploads/2026-05-17/ac3a98e5-0469-4b3c-afad-d029a5f4420a.jpg', 1, '2026-05-11 17:02:05', '2026-08-11 15:50:00', 0, 9, 35);
INSERT INTO `product` VALUES (3, 'Apple iPhone 15 Pro', 'A p p l e   i P h o n e   1 5   P r o', 2, 2, 7999.00, 18, 'A17 Pro芯片，钛金属边框，4800万主摄', '/uploads/2026-05-16/79404ffc-8d49-47d2-81f6-8e4d168838fb.jpg', 1, '2026-05-11 17:02:05', '2026-07-29 11:01:49', 0, 3, 0);
INSERT INTO `product` VALUES (4, '联想拯救者 Y9000P 笔记本电脑', 'lian xiang zheng jiu zhe   Y 9 0 0 0 P   bi ji ben dian nao', 3, 2, 8999.00, 0, 'i9-13900HX RTX4060 2.5K屏 240Hz', '/uploads/2026-08-08/bef034f5-d64c-4754-bc29-c68d05200e3d.jpg', 1, '2026-05-11 17:02:05', '2026-07-29 11:01:51', 0, 0, 0);
INSERT INTO `product` VALUES (5, '耐克 Air Max 90 运动鞋', 'nai ke   A i r   M a x   9 0   yun dong xie', 5, 3, 129.00, 95, '经典复古，透气缓震，橡胶大底', '/uploads/2026-05-21/82f0d924-4cf7-44ad-b2e9-59fb8cfea61f.jpg', 1, '2026-05-11 17:02:05', '2026-07-29 11:01:52', 0, 4, 0);
INSERT INTO `product` VALUES (6, '罗技 MX Master 3S 鼠标', 'luo ji   M X   M a s t e r   3 S   shu biao', 3, 3, 599.00, 59, '8000DPI，静音滚轮，跨设备控制', '/uploads/2026-07-29/84494e85-4fdd-4b88-80e4-2d04103f17a0.png', 1, '2026-05-11 17:02:05', '2026-07-29 11:30:10', 0, 0, 0);
INSERT INTO `product` VALUES (7, '华为 FreeBuds Pro 3', 'hua wei   F r e e B u d s   P r o   3', 2, 2, 1499.00, 200, '超强降噪，星闪连接，智慧动态降噪3.0', '/uploads/2026-07-29/643fd90a-df07-4b62-b9c3-0e2bfe0c65bc.png', 1, '2026-05-11 20:35:46', '2026-08-11 10:50:00', 0, 0, 1);
INSERT INTO `product` VALUES (8, '惠普电脑 暗影精灵', 'hui pu dian nao   an ying jing ling', 3, 2, 7562.00, 23, '办公娱乐的不二之选', '/uploads/2026-05-16/423db857-b9da-4dd8-ae9d-a5c180ad87a8.jpg', 1, '2026-05-13 17:38:00', '2026-08-11 11:30:00', 0, 2, 2);
INSERT INTO `product` VALUES (9, '羽毛球', 'yu mao qiu', 8, 3, 80.00, 149, '耐打。飞行稳定', '/uploads/2026-05-21/488894a5-fd55-4ab2-af2a-1a90cf4b9cb2.jpg', 1, '2026-05-16 20:09:51', '2026-08-11 15:25:00', 0, 1, 1);
INSERT INTO `product` VALUES (10, '球鞋', 'qiu xie', 9, 3, 100.00, 347, '跑步舒适', '/uploads/2026-05-17/d369112f-db52-434e-88cd-fa9c07168f19.jpeg', 1, '2026-05-17 17:20:04', '2026-08-11 15:45:00', 0, 3, 1);
INSERT INTO `product` VALUES (11, '袜子', 'wa zi', 8, 3, 8.00, 500, '舒适易干', '/uploads/2026-05-17/0864dd02-c8dc-4428-b3aa-e7a5c6f1164d.jpg', 1, '2026-05-17 17:21:28', '2026-07-29 11:01:59', 0, 1, 0);
INSERT INTO `product` VALUES (12, '自行车', 'zi xing che', 6, 3, 150.00, 17, '出行便利，锻炼身体的不二之选', '/uploads/2026-05-17/b1697f80-8579-47bc-8248-0bdf55c17ab9.jpeg', 1, '2026-05-17 17:22:42', '2026-08-11 15:40:00', 0, 4, 6);
INSERT INTO `product` VALUES (13, '【180粒/瓶98%高纯度加强版】加拿大原装正品进口深海鱼油Omega3', '【 1 8 0 li / ping 9 8 % gao chun du jia qiang ban 】 jia na da yuan zhuang zheng pin jin kou shen hai yu you O m e g a 3', 10, 5, 79.90, 99, '【180粒/瓶98%高纯度加强版】加拿大原装正品进口深海鱼油Omega3', '/uploads/2026-05-20/ddec6125-7563-4bc4-80bb-a88ff4d51bb1.jpg', 1, '2026-05-20 16:30:03', '2026-08-11 15:45:00', 0, 0, 3);
INSERT INTO `product` VALUES (14, '笔', 'bi', 14, 5, 25.00, 1997, '20支限量优惠', '/uploads/2026-07-28/fd6252cd-def3-49db-90bc-217d67904724.jpg', 1, '2026-07-28 17:41:52', '2026-08-11 11:20:00', 0, 3, 10);
INSERT INTO `product` VALUES (15, ' “软绵绵”面包', '  “ ruan mian mian ” mian bao', 13, 5, 25.00, 389, '健康好吃', '/uploads/2026-07-29/217e8f09-f7ce-4676-a33d-f307d29ae4db.jpg', 1, '2026-07-29 10:36:11', '2026-08-11 15:45:00', 0, 111, 9);
INSERT INTO `product` VALUES (16, '纸巾', 'zhi jin', 14, 5, 20.00, 998, '纸质舒适便宜', '/uploads/2026-08-01/f379b151-7bc3-4876-a268-ae461a66e4f2.jpg', 1, '2026-08-01 09:37:49', '2026-08-11 15:50:00', 0, 2, 10);
INSERT INTO `product` VALUES (17, '7A抗菌男士毛巾', '7 A kang jun nan shi mao jin', 14, 5, 15.80, 329, '7A抗菌男士毛巾洗脸洗澡超强吸水不易掉毛高档男款瞬吸速干A类', '/uploads/2026-08-01/9440dce2-ba39-4b26-80e0-715f1308f254.jpg', 1, '2026-08-01 09:53:44', '2026-08-01 09:53:44', 0, 1, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品评论表' ROW_FORMAT = Dynamic;

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
INSERT INTO `product_comment` VALUES (10, 15, 5, 5, '面包很好吃', NULL, 1, 0, NULL, NULL, 0, '2026-08-07 16:17:51', '2026-08-07 16:17:51', 0);
INSERT INTO `product_comment` VALUES (11, 15, 5, 0, NULL, NULL, 1, 10, 5, '真的', 0, '2026-08-07 16:18:00', '2026-08-07 16:18:00', 0);
INSERT INTO `product_comment` VALUES (12, 15, 5, 0, NULL, NULL, 1, 10, 5, '111', 0, '2026-08-07 16:18:12', '2026-08-07 16:18:12', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 53 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品图片表' ROW_FORMAT = Dynamic;

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
INSERT INTO `product_image` VALUES (51, 4, '/uploads/2026-08-08/5e175da9-d9be-4f77-8a11-d3c145252e19.jpg', 0);
INSERT INTO `product_image` VALUES (52, 4, '/uploads/2026-08-08/75e73a48-ed7e-4f3d-a70c-92798767ba94.jpg', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 62 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_sku
-- ----------------------------
INSERT INTO `product_sku` VALUES (3, 2, '{\"存储\": \"256GB\", \"颜色\": \"雅丹黑\"}', 6499.00, 6, 'HWM60P-BK-256', NULL, 6);
INSERT INTO `product_sku` VALUES (4, 2, '{\"存储\": \"512GB\", \"颜色\": \"雅丹黑\"}', 6999.00, 8, 'HWM60P-BK-512', NULL, 2);
INSERT INTO `product_sku` VALUES (5, 2, '{\"存储\": \"256GB\", \"颜色\": \"白沙银\"}', 6499.00, 5, 'HWM60P-SV-256', NULL, 1);
INSERT INTO `product_sku` VALUES (6, 2, '{\"存储\": \"512GB\", \"颜色\": \"白沙银\"}', 6999.00, 4, 'HWM60P-SV-512', NULL, 0);
INSERT INTO `product_sku` VALUES (7, 3, '{\"存储\": \"256GB\", \"颜色\": \"原色钛\"}', 7999.00, 8, 'IP15P-NT-256', NULL, 1);
INSERT INTO `product_sku` VALUES (8, 3, '{\"存储\": \"512GB\", \"颜色\": \"原色钛\"}', 8999.00, 5, 'IP15P-NT-512', NULL, 1);
INSERT INTO `product_sku` VALUES (9, 3, '{\"存储\": \"256GB\", \"颜色\": \"白色钛\"}', 7999.00, 3, 'IP15P-WT-256', NULL, 1);
INSERT INTO `product_sku` VALUES (10, 3, '{\"存储\": \"512GB\", \"颜色\": \"白色钛\"}', 8999.00, 2, 'IP15P-WT-512', NULL, 0);
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
INSERT INTO `product_sku` VALUES (50, 16, '{\"袋数\": \"1\", \"包数/袋\": \"20\"}', 24.00, 198, NULL, NULL, 2);
INSERT INTO `product_sku` VALUES (51, 16, '{\"袋数\": \"2\", \"包数/袋\": \"20\"}', 48.00, 300, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (52, 16, '{\"袋数\": \"1\", \"包数/袋\": \"30\"}', 30.00, 200, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (53, 16, '{\"袋数\": \"2\", \"包数/袋\": \"30\"}', 60.00, 300, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (54, 17, '{\"尺寸\": \"热销组合 【两条装：灰色 + 条纹】各一条\"}', 34.70, 50, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (55, 17, '{\"尺寸\": \"热销组合【4条装：灰色 + 条纹】各两条\"}', 50.80, 79, NULL, NULL, 1);
INSERT INTO `product_sku` VALUES (56, 17, '{\"尺寸\": \"男士专用 【2条装 ：条纹】有效抑菌-阴干不臭\"}', 34.70, 50, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (57, 17, '{\"尺寸\": \"男士专用 【2条装 ：灰色】有效抑菌-阴干不臭\"}', 15.80, 50, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (58, 17, '{\"尺寸\": \"男士专用 【1条装 ：条纹】有效抑菌-阴干不臭\"}', 15.80, 50, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (59, 17, '{\"尺寸\": \"男士专用 【1条装 ：灰色】有效抑菌-阴干不臭\"}', 15.80, 50, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (60, 4, '{\"配置\": \"i9+4060\"}', 8999.00, 0, NULL, NULL, 0);
INSERT INTO `product_sku` VALUES (61, 4, '{\"配置\": \"i9+4070\"}', 8999.00, 0, NULL, NULL, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_spec
-- ----------------------------
INSERT INTO `product_spec` VALUES (2, 2, '颜色', '[\"雅丹黑\", \"白沙银\"]', 0);
INSERT INTO `product_spec` VALUES (3, 2, '存储', '[\"256GB\", \"512GB\"]', 1);
INSERT INTO `product_spec` VALUES (4, 3, '颜色', '[\"原色钛\", \"白色钛\"]', 0);
INSERT INTO `product_spec` VALUES (5, 3, '存储', '[\"256GB\", \"512GB\"]', 1);
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
INSERT INTO `product_spec` VALUES (30, 4, '配置', '[\"i9+4060\", \"i9+4070\"]', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '退款满意度反馈' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of refund_satisfaction
-- ----------------------------
INSERT INTO `refund_satisfaction` VALUES (5, 8, 5, 5, '面包很好吃', '2026-08-07 16:17:25');

-- ----------------------------
-- Table structure for seckill_session
-- ----------------------------
DROP TABLE IF EXISTS `seckill_session`;
CREATE TABLE `seckill_session`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `seckill_type` tinyint NOT NULL DEFAULT 0 COMMENT '0=秒杀优惠券 1=秒杀商品',
  `coupon_id` bigint NULL DEFAULT NULL,
  `product_id` bigint NULL DEFAULT NULL COMMENT '秒杀商品ID（seckill_type=1）',
  `sku_id` bigint NULL DEFAULT NULL COMMENT '指定SKU ID（seckill_type=1，可选）',
  `seckill_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '秒杀价（seckill_type=1）',
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
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '秒杀场次表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of seckill_session
-- ----------------------------
INSERT INTO `seckill_session` VALUES (1, 0, 10, NULL, NULL, NULL, '521秒杀劵', '2026-05-21 00:00:00', '2026-05-21 00:00:01', 20, 1, 2, '2026-05-21 20:15:45', '2026-05-21 20:15:45', 0);
INSERT INTO `seckill_session` VALUES (2, 0, 10, NULL, NULL, NULL, '521秒杀券2', '2026-05-21 20:23:00', '2026-05-21 23:25:00', 3, 1, 2, '2026-05-21 20:21:06', '2026-05-21 20:21:06', 0);
INSERT INTO `seckill_session` VALUES (3, 0, 10, NULL, NULL, NULL, '预热功能测试', '2026-05-30 20:45:00', '2026-05-31 00:00:00', 5, 1, 3, '2026-05-30 20:44:40', '2026-05-30 20:44:40', 0);
INSERT INTO `seckill_session` VALUES (4, 0, 10, NULL, NULL, NULL, '功能预热', '2026-05-30 20:55:00', '2026-05-31 00:00:00', 9, 1, 2, '2026-05-30 20:51:56', '2026-05-30 20:51:56', 0);
INSERT INTO `seckill_session` VALUES (5, 0, 10, NULL, NULL, NULL, '531热销', '2026-05-31 00:00:00', '2026-05-31 23:59:59', 30, 1, 2, '2026-05-30 20:55:53', '2026-05-30 20:55:53', 0);
INSERT INTO `seckill_session` VALUES (6, 0, 1, NULL, NULL, NULL, '81大促', '2026-08-01 10:00:00', '2026-08-01 12:00:00', 19, 1, 2, '2026-08-01 09:26:37', '2026-08-01 09:26:37', 0);
INSERT INTO `seckill_session` VALUES (9, 1, NULL, 17, 55, 14.80, '生活大甩卖', '2026-08-08 09:34:00', '2026-08-08 23:00:00', 19, 1, 2, '2026-08-08 09:33:37', '2026-08-08 11:05:00', 0);
INSERT INTO `seckill_session` VALUES (10, 0, 2, NULL, NULL, NULL, '88大促卷', '2026-08-08 10:30:00', '2026-08-09 00:00:00', 29, 2, 2, '2026-08-08 10:22:39', '2026-08-08 10:32:45', 0);
INSERT INTO `seckill_session` VALUES (11, 1, NULL, 13, NULL, 70.00, '大促', '2026-08-08 10:25:00', '2026-08-09 00:00:00', 10, 1, 2, '2026-08-08 10:23:53', '2026-08-08 11:00:00', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 227 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统通知表' ROW_FORMAT = Dynamic;

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
INSERT INTO `sys_notice` VALUES (176, '新订单通知', 3, 0, 2, '2', '您有新的订单，订单号：1786090206080679b6638', 0, '系统', '2026-08-07 16:10:06', NULL, 1, '2026-08-07 16:10:06', '2026-08-07 16:10:06', 'new_order', 64);
INSERT INTO `sys_notice` VALUES (177, '订单付款通知', 3, 0, 2, '2', '订单 1786090206080679b6638 已付款，请尽快发货', 0, '系统', '2026-08-07 16:10:32', NULL, 1, '2026-08-07 16:10:32', '2026-08-07 16:10:32', 'order_paid', 64);
INSERT INTO `sys_notice` VALUES (178, '订单支付成功', 3, 0, 2, '5', '您的订单 1786090206080679b6638 已支付成功，请等待发货', 0, '系统', '2026-08-07 16:10:32', NULL, 1, '2026-08-07 16:10:32', '2026-08-07 16:10:32', 'order_paid', 64);
INSERT INTO `sys_notice` VALUES (179, '新订单通知', 3, 0, 2, '5', '您有新的秒杀订单，订单号：1786096326163ee21e88c', 0, '系统', '2026-08-07 17:52:06', NULL, 1, '2026-08-07 17:52:06', '2026-08-07 17:52:06', 'new_order', 65);
INSERT INTO `sys_notice` VALUES (180, '订单超时取消通知', 3, 0, 2, '5', '订单 1786096326163ee21e88c 因超时未支付已被系统自动取消', 0, '系统', '2026-08-07 17:53:54', NULL, 1, '2026-08-07 17:53:54', '2026-08-07 17:53:54', 'order_cancelled', 65);
INSERT INTO `sys_notice` VALUES (181, '订单已取消', 3, 0, 2, '4', '您的订单 1786096326163ee21e88c 因超时未支付已被系统自动取消', 0, '系统', '2026-08-07 17:53:54', NULL, 1, '2026-08-07 17:53:54', '2026-08-07 17:53:54', 'order_cancelled', 65);
INSERT INTO `sys_notice` VALUES (182, '新订单通知', 3, 0, 2, '5', '您有新的秒杀订单，订单号：1786152882423e3aaccb6', 0, '系统', '2026-08-08 09:34:42', NULL, 1, '2026-08-08 09:34:42', '2026-08-08 09:34:42', 'new_order', 66);
INSERT INTO `sys_notice` VALUES (183, '订单已取消', 3, 0, 2, '6', '您的订单 1786152882423e3aaccb6 因超时未支付已被系统自动取消', 0, '系统', '2026-08-08 10:05:00', NULL, 1, '2026-08-08 10:05:00', '2026-08-08 10:05:00', 'order_cancelled', 66);
INSERT INTO `sys_notice` VALUES (184, '新订单通知', 3, 0, 2, '5', '您有新的秒杀订单，订单号：1786154884831a05e6101', 0, '系统', '2026-08-08 10:08:05', NULL, 1, '2026-08-08 10:08:05', '2026-08-08 10:08:04', 'new_order', 67);
INSERT INTO `sys_notice` VALUES (185, '新订单通知', 3, 0, 2, '3', '您有新的订单，订单号：17861549740929d88b48f', 0, '系统', '2026-08-08 10:09:34', NULL, 1, '2026-08-08 10:09:34', '2026-08-08 10:09:34', 'new_order', 68);
INSERT INTO `sys_notice` VALUES (186, '新订单通知', 3, 0, 2, '2', '您有新的订单，订单号：17861549740929d88b48f', 0, '系统', '2026-08-08 10:09:34', NULL, 1, '2026-08-08 10:09:34', '2026-08-08 10:09:34', 'new_order', 68);
INSERT INTO `sys_notice` VALUES (187, '新订单通知', 3, 0, 2, '5', '您有新的秒杀订单，订单号：1786155207302c0405b9b', 0, '系统', '2026-08-08 10:13:27', NULL, 1, '2026-08-08 10:13:27', '2026-08-08 10:13:27', 'new_order', 69);
INSERT INTO `sys_notice` VALUES (188, '订单付款通知', 3, 0, 2, '5', '订单 1786155207302c0405b9b 已付款，请尽快发货', 0, '系统', '2026-08-08 10:18:13', NULL, 1, '2026-08-08 10:18:13', '2026-08-08 10:18:12', 'order_paid', 69);
INSERT INTO `sys_notice` VALUES (189, '订单支付成功', 3, 0, 2, '2', '您的订单 1786155207302c0405b9b 已支付成功，请等待发货', 0, '系统', '2026-08-08 10:18:13', NULL, 1, '2026-08-08 10:18:13', '2026-08-08 10:18:12', 'order_paid', 69);
INSERT INTO `sys_notice` VALUES (190, '新订单通知', 3, 0, 2, '5', '您有新的秒杀订单，订单号：1786155925140a3273a82', 0, '系统', '2026-08-08 10:25:25', NULL, 1, '2026-08-08 10:25:25', '2026-08-08 10:25:25', 'new_order', 70);
INSERT INTO `sys_notice` VALUES (191, '新订单通知', 3, 0, 2, '5', '您有新的秒杀订单，订单号：17861563569468c944b84', 0, '系统', '2026-08-08 10:32:37', NULL, 1, '2026-08-08 10:32:37', '2026-08-08 10:32:37', 'new_order', 71);
INSERT INTO `sys_notice` VALUES (192, '订单已取消', 3, 0, 2, '8', '您的订单 1786154884831a05e6101 因超时未支付已被系统自动取消', 0, '系统', '2026-08-08 10:40:00', NULL, 1, '2026-08-08 10:40:00', '2026-08-08 10:40:00', 'order_cancelled', 67);
INSERT INTO `sys_notice` VALUES (193, '订单超时取消通知', 3, 0, 2, '2', '订单 17861549740929d88b48f 因超时未支付已被系统自动取消', 0, '系统', '2026-08-08 10:40:00', NULL, 1, '2026-08-08 10:40:00', '2026-08-08 10:40:00', 'order_cancelled', 68);
INSERT INTO `sys_notice` VALUES (194, '订单已取消', 3, 0, 2, '8', '您的订单 17861549740929d88b48f 因超时未支付已被系统自动取消', 0, '系统', '2026-08-08 10:40:00', NULL, 1, '2026-08-08 10:40:00', '2026-08-08 10:40:00', 'order_cancelled', 68);
INSERT INTO `sys_notice` VALUES (195, '订单超时取消通知', 3, 0, 2, '5', '订单 1786155925140a3273a82 因超时未支付已被系统自动取消', 0, '系统', '2026-08-08 11:00:00', NULL, 1, '2026-08-08 11:00:00', '2026-08-08 11:00:00', 'order_cancelled', 70);
INSERT INTO `sys_notice` VALUES (196, '订单已取消', 3, 0, 2, '6', '您的订单 1786155925140a3273a82 因超时未支付已被系统自动取消', 0, '系统', '2026-08-08 11:00:00', NULL, 1, '2026-08-08 11:00:00', '2026-08-08 11:00:00', 'order_cancelled', 70);
INSERT INTO `sys_notice` VALUES (197, '订单已取消', 3, 0, 2, '6', '您的订单 17861563569468c944b84 因超时未支付已被系统自动取消', 0, '系统', '2026-08-08 11:05:00', NULL, 1, '2026-08-08 11:05:00', '2026-08-08 11:05:00', 'order_cancelled', 71);
INSERT INTO `sys_notice` VALUES (198, '新订单通知', 3, 0, 2, '2', '您有新的拼团订单，订单号：1786418844837444e65d5', 0, '系统', '2026-08-11 11:27:25', NULL, 1, '2026-08-11 11:27:25', '2026-08-11 11:27:24', 'new_order', 72);
INSERT INTO `sys_notice` VALUES (199, '新订单通知', 3, 0, 2, '2', '您有新的拼团订单，订单号：1786418881220cd6b7743', 0, '系统', '2026-08-11 11:28:01', NULL, 1, '2026-08-11 11:28:01', '2026-08-11 11:28:01', 'new_order', 73);
INSERT INTO `sys_notice` VALUES (200, '新订单通知', 3, 0, 2, '2', '您有新的拼团订单，订单号：178641968777532aadc82', 0, '系统', '2026-08-11 11:41:28', NULL, 1, '2026-08-11 11:41:28', '2026-08-11 11:41:27', 'new_order', 74);
INSERT INTO `sys_notice` VALUES (201, '订单付款通知', 3, 0, 2, '2', '订单 178641968777532aadc82 已付款，请尽快发货', 0, '系统', '2026-08-11 11:41:35', NULL, 1, '2026-08-11 11:41:35', '2026-08-11 11:41:34', 'order_paid', 74);
INSERT INTO `sys_notice` VALUES (202, '订单支付成功', 3, 0, 2, '8', '您的订单 178641968777532aadc82 已支付成功，请等待发货', 0, '系统', '2026-08-11 11:41:35', NULL, 1, '2026-08-11 11:41:35', '2026-08-11 11:41:34', 'order_paid', 74);
INSERT INTO `sys_notice` VALUES (203, '订单付款通知', 3, 0, 2, '2', '订单 1786418881220cd6b7743 已付款，请尽快发货', 0, '系统', '2026-08-11 11:42:20', NULL, 1, '2026-08-11 11:42:20', '2026-08-11 11:42:20', 'order_paid', 73);
INSERT INTO `sys_notice` VALUES (204, '订单支付成功', 3, 0, 2, '5', '您的订单 1786418881220cd6b7743 已支付成功，请等待发货', 0, '系统', '2026-08-11 11:42:20', NULL, 1, '2026-08-11 11:42:20', '2026-08-11 11:42:20', 'order_paid', 73);
INSERT INTO `sys_notice` VALUES (205, '新订单通知', 3, 0, 2, '2', '您有新的拼团订单，订单号：1786419788227ed97ddf6', 0, '系统', '2026-08-11 11:43:08', NULL, 1, '2026-08-11 11:43:08', '2026-08-11 11:43:08', 'new_order', 75);
INSERT INTO `sys_notice` VALUES (206, '订单付款通知', 3, 0, 2, '2', '订单 1786419788227ed97ddf6 已付款，请尽快发货', 0, '系统', '2026-08-11 11:43:20', NULL, 1, '2026-08-11 11:43:20', '2026-08-11 11:43:20', 'order_paid', 75);
INSERT INTO `sys_notice` VALUES (207, '订单支付成功', 3, 0, 2, '6', '您的订单 1786419788227ed97ddf6 已支付成功，请等待发货', 0, '系统', '2026-08-11 11:43:20', NULL, 1, '2026-08-11 11:43:20', '2026-08-11 11:43:20', 'order_paid', 75);
INSERT INTO `sys_notice` VALUES (208, '拼团成功', 3, 0, 2, '5', '恭喜！您参与的拼团已成功，订单将尽快发货。团号：T1786418844871791', 0, '系统', '2026-08-11 11:43:20', NULL, 1, '2026-08-11 11:43:20', '2026-08-11 11:43:20', 'groupbuy_success', 1);
INSERT INTO `sys_notice` VALUES (209, '拼团成功', 3, 0, 2, '8', '恭喜！您参与的拼团已成功，订单将尽快发货。团号：T1786418844871791', 0, '系统', '2026-08-11 11:43:20', NULL, 1, '2026-08-11 11:43:20', '2026-08-11 11:43:20', 'groupbuy_success', 1);
INSERT INTO `sys_notice` VALUES (210, '拼团成功', 3, 0, 2, '6', '恭喜！您参与的拼团已成功，订单将尽快发货。团号：T1786418844871791', 0, '系统', '2026-08-11 11:43:20', NULL, 1, '2026-08-11 11:43:20', '2026-08-11 11:43:20', 'groupbuy_success', 1);
INSERT INTO `sys_notice` VALUES (211, '新订单通知', 3, 0, 2, '2', '您有新的拼团订单，订单号：1786419954335d353b3b6', 0, '系统', '2026-08-11 11:45:54', NULL, 1, '2026-08-11 11:45:54', '2026-08-11 11:45:54', 'new_order', 76);
INSERT INTO `sys_notice` VALUES (212, '订单已取消', 3, 0, 2, '6', '您的订单 1786419954335d353b3b6 因超时未支付已被系统自动取消', 0, '系统', '2026-08-11 11:46:13', NULL, 1, '2026-08-11 11:46:13', '2026-08-11 11:46:12', 'order_cancelled', 76);
INSERT INTO `sys_notice` VALUES (213, '新订单通知', 3, 0, 2, '2', '您有新的拼团订单，订单号：17864206200109346157b', 0, '系统', '2026-08-11 11:57:00', NULL, 1, '2026-08-11 11:57:00', '2026-08-11 11:57:00', 'new_order', 77);
INSERT INTO `sys_notice` VALUES (214, '订单付款通知', 3, 0, 2, '2', '订单 17864206200109346157b 已付款，请尽快发货', 0, '系统', '2026-08-11 11:57:19', NULL, 1, '2026-08-11 11:57:19', '2026-08-11 11:57:18', 'order_paid', 77);
INSERT INTO `sys_notice` VALUES (215, '订单支付成功', 3, 0, 2, '6', '您的订单 17864206200109346157b 已支付成功，请等待发货', 0, '系统', '2026-08-11 11:57:19', NULL, 1, '2026-08-11 11:57:19', '2026-08-11 11:57:18', 'order_paid', 77);
INSERT INTO `sys_notice` VALUES (216, '订单已取消', 3, 0, 2, '5', '您的订单 1786418844837444e65d5 因超时未支付已被系统自动取消', 0, '系统', '2026-08-11 12:00:00', NULL, 1, '2026-08-11 12:00:00', '2026-08-11 12:00:00', 'order_cancelled', 72);
INSERT INTO `sys_notice` VALUES (217, '新订单通知', 3, 0, 2, '5', '您有新的拼团订单，订单号：17864304502468f138a7a', 0, '系统', '2026-08-11 14:40:50', NULL, 1, '2026-08-11 14:40:50', '2026-08-11 14:40:50', 'new_order', 78);
INSERT INTO `sys_notice` VALUES (218, '订单付款通知', 3, 0, 2, '5', '订单 17864304502468f138a7a 已付款，请尽快发货', 0, '系统', '2026-08-11 14:41:06', NULL, 1, '2026-08-11 14:41:06', '2026-08-11 14:41:05', 'order_paid', 78);
INSERT INTO `sys_notice` VALUES (219, '订单支付成功', 3, 0, 2, '8', '您的订单 17864304502468f138a7a 已支付成功，请等待发货', 0, '系统', '2026-08-11 14:41:06', NULL, 1, '2026-08-11 14:41:06', '2026-08-11 14:41:05', 'order_paid', 78);
INSERT INTO `sys_notice` VALUES (220, '新订单通知', 3, 0, 2, '5', '您有新的拼团订单，订单号：1786430507541ba1b10c3', 0, '系统', '2026-08-11 14:41:48', NULL, 1, '2026-08-11 14:41:48', '2026-08-11 14:41:47', 'new_order', 79);
INSERT INTO `sys_notice` VALUES (221, '订单付款通知', 3, 0, 2, '5', '订单 1786430507541ba1b10c3 已付款，请尽快发货', 0, '系统', '2026-08-11 14:42:01', NULL, 1, '2026-08-11 14:42:01', '2026-08-11 14:42:01', 'order_paid', 79);
INSERT INTO `sys_notice` VALUES (222, '订单支付成功', 3, 0, 2, '6', '您的订单 1786430507541ba1b10c3 已支付成功，请等待发货', 0, '系统', '2026-08-11 14:42:01', NULL, 1, '2026-08-11 14:42:01', '2026-08-11 14:42:01', 'order_paid', 79);
INSERT INTO `sys_notice` VALUES (223, '拼团成功', 3, 0, 2, '8', '恭喜！您参与的拼团已成功，订单将尽快发货。团号：T1786430450294271', 0, '系统', '2026-08-11 14:42:02', NULL, 1, '2026-08-11 14:42:02', '2026-08-11 14:42:01', 'groupbuy_success', 5);
INSERT INTO `sys_notice` VALUES (224, '拼团成功', 3, 0, 2, '6', '恭喜！您参与的拼团已成功，订单将尽快发货。团号：T1786430450294271', 0, '系统', '2026-08-11 14:42:02', NULL, 1, '2026-08-11 14:42:02', '2026-08-11 14:42:01', 'groupbuy_success', 5);
INSERT INTO `sys_notice` VALUES (225, '新订单通知', 3, 0, 2, '5', '您有新的拼团订单，订单号：178643053285336ba5118', 0, '系统', '2026-08-11 14:42:13', NULL, 1, '2026-08-11 14:42:13', '2026-08-11 14:42:12', 'new_order', 80);
INSERT INTO `sys_notice` VALUES (226, '订单已取消', 3, 0, 2, '6', '您的订单 178643053285336ba5118 因超时未支付已被系统自动取消', 0, '系统', '2026-08-11 15:15:00', NULL, 1, '2026-08-11 15:15:00', '2026-08-11 15:15:00', 'order_cancelled', 80);

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
) ENGINE = InnoDB AUTO_INCREMENT = 146 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知已读记录表' ROW_FORMAT = Dynamic;

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
INSERT INTO `sys_notice_read` VALUES (132, 178, 5, '2026-08-07 16:14:39');
INSERT INTO `sys_notice_read` VALUES (133, 152, 5, '2026-08-07 16:14:40');
INSERT INTO `sys_notice_read` VALUES (134, 151, 5, '2026-08-07 16:14:43');
INSERT INTO `sys_notice_read` VALUES (135, 150, 6, '2026-08-08 10:36:27');
INSERT INTO `sys_notice_read` VALUES (136, 183, 6, '2026-08-08 10:36:28');
INSERT INTO `sys_notice_read` VALUES (137, 179, 5, '2026-08-10 11:00:28');
INSERT INTO `sys_notice_read` VALUES (138, 180, 5, '2026-08-10 11:00:28');
INSERT INTO `sys_notice_read` VALUES (139, 182, 5, '2026-08-10 11:00:28');
INSERT INTO `sys_notice_read` VALUES (140, 184, 5, '2026-08-10 11:00:28');
INSERT INTO `sys_notice_read` VALUES (141, 187, 5, '2026-08-10 11:00:28');
INSERT INTO `sys_notice_read` VALUES (142, 188, 5, '2026-08-10 11:00:28');
INSERT INTO `sys_notice_read` VALUES (143, 190, 5, '2026-08-10 11:00:28');
INSERT INTO `sys_notice_read` VALUES (144, 191, 5, '2026-08-10 11:00:28');
INSERT INTO `sys_notice_read` VALUES (145, 195, 5, '2026-08-10 11:00:28');

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
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '管理员', '$2a$10$i6AE41VyU/KKu48U/v.jKOMf6ssmc6DL3SD0rb4ohlBXzQXONCGFi', '13592816121', 'shuxinwu718@gmail.com', '/uploads/2026-05-14/cef55406-696b-4f91-967a-22941568e1ba.jpg', 1, 0, 'ADMIN', '2026-05-11 17:00:11', '2026-05-14 15:58:04', 0);
INSERT INTO `user` VALUES (2, 'mojie', '摩羯', '$2a$10$QbQeL/84Net9QIKuwFREbO1BVp0txkC8hgM2RkKl6sXxNVKr71MM.', '13900000001', 'merchant1@shop.com', '/uploads/2026-05-16/93689360-9834-4ad6-9425-4c7bea98861e.jpg', 0, 0, 'MERCHANT', '2026-05-11 17:00:11', '2026-05-16 21:30:43', 0);
INSERT INTO `user` VALUES (3, 'zhangsan', '张三', '$2a$10$QbQeL/84Net9QIKuwFREbO1BVp0txkC8hgM2RkKl6sXxNVKr71MM.', '13536911064', 'zhangsan@example.com', '/uploads/2026-05-16/70f6270f-3d69-427b-b532-93aec03323a0.jpg', 0, 0, 'MERCHANT', '2026-05-11 17:00:11', '2026-05-14 15:58:11', 0);
INSERT INTO `user` VALUES (4, 'lisi', '李四', '$2a$10$QbQeL/84Net9QIKuwFREbO1BVp0txkC8hgM2RkKl6sXxNVKr71MM.', '13887654321', 'lisi@example.com', '/uploads/2026-05-21/1a1dac26-1d74-4467-93e8-a1691c57cd87.jpg', 0, 0, 'USER', '2026-05-11 17:00:11', '2026-05-14 15:58:15', 0);
INSERT INTO `user` VALUES (5, 'bob', '鲍勃', '$2a$10$QbQeL/84Net9QIKuwFREbO1BVp0txkC8hgM2RkKl6sXxNVKr71MM.', NULL, '13536911064@163.com', '/uploads/2026-05-15/08da718c-8ad8-430a-8eed-5b27b027e88b.jpg', 1, 0, 'MERCHANT', '2026-05-11 17:09:25', '2026-05-14 15:58:24', 0);
INSERT INTO `user` VALUES (6, 'star', '星', '$2a$10$/qaCymXjQwyDo0IuYLTxIe5DKAn8n/BOyJz8YFKVqoiGCWIAovS5e', '13415066768', '2368151277@qq.com', '/uploads/2026-05-15/8fb8b7fe-a218-4683-a8ec-43406dc4c49f.jpg', 1, 0, 'USER', '2026-05-11 17:18:14', '2026-05-14 15:58:30', 0);
INSERT INTO `user` VALUES (7, 'testuser', '特素', '$2a$10$dpAa.7zFF7LRub.0F8mM..YB7uhbLRYnu.AvHyQTnXVTbmmoL.Bki', '13800138000', 'test@test.com', NULL, 0, 0, 'USER', '2026-05-13 12:43:40', '2026-05-14 15:59:02', 0);
INSERT INTO `user` VALUES (8, 'mike', '麦克', '$2a$10$lEQDzr1ffXUv3Cs5vilJ3.B6nKbxr8ImhUYhHV0pukaOUhRvIjuFC', '', '1325481524@qq.com', NULL, 1, 0, 'USER', '2026-05-13 13:07:28', '2026-05-14 15:58:35', 0);
INSERT INTO `user` VALUES (9, 'test', '策士', '$2a$10$QbQeL/84Net9QIKuwFREbO1BVp0txkC8hgM2RkKl6sXxNVKr71MM.', NULL, 'test@test.com', NULL, 0, 1, 'USER', '2026-05-13 18:37:39', '2026-05-21 23:04:13', 0);
INSERT INTO `user` VALUES (10, 'xingo', 'xingo', '$2a$10$2rRK4kaNjMkiq.qTzIlENuJctsgSHx2qNKfSR5ds4pf8ssAs6ORZO', '', '125813546@qq.com', '/uploads/2026-05-19/3619e192-8bd3-4449-8b0a-63a7ea113c70.png', 0, 0, 'USER', '2026-05-19 21:35:17', '2026-08-11 11:57:47', 0);
INSERT INTO `user` VALUES (11, 'fuge', '福哥', '$2a$10$jfR3BccI17T0XtkNK7zk2.41UMWHpRbSzCQMzAB84VF05nDzX9l9m', '', '89521254@qq.com', '/uploads/2026-05-21/d213a49f-bc33-41cc-9c55-0de422770cb5.jpg', 0, 0, 'USER', '2026-05-21 22:59:08', '2026-05-21 22:59:08', 0);
INSERT INTO `user` VALUES (13, 'github_shuxinwu718-web', '吴树鑫', '$2a$10$5yO8hpCRNC1gR4een/HUoOwqdhH/PkIRp5x0e/BaSfRVLuOFkJK3G', '13536911064', NULL, '/uploads/2026-05-30/f80820d2-0d9e-4fa7-8540-9098f1e02424.jpg', 1, 1, 'USER', '2026-05-30 16:24:45', '2026-05-30 16:24:45', 0);
INSERT INTO `user` VALUES (14, 'sku_test_08', 'sku_test_08', '$2a$10$b7783.ZNEGXV2DJZuHPpOe1Ol00xfTmuKgLW7MSQGV94CWF91Wv0C', '13800000008', 'skutest08@test.com', NULL, 0, 0, 'USER', '2026-08-01 10:34:45', '2026-08-11 11:57:53', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 56 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户优惠券' ROW_FORMAT = Dynamic;

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
INSERT INTO `user_coupon` VALUES (43, 4, 12, NULL, 0, '2026-08-07 15:51:46', NULL, '2026-08-07 15:51:46', '2026-08-07 15:51:46');
INSERT INTO `user_coupon` VALUES (44, 4, 12, NULL, 0, '2026-08-07 15:51:47', NULL, '2026-08-07 15:51:47', '2026-08-07 15:51:47');
INSERT INTO `user_coupon` VALUES (45, 4, 12, NULL, 0, '2026-08-07 15:51:47', NULL, '2026-08-07 15:51:47', '2026-08-07 15:51:47');
INSERT INTO `user_coupon` VALUES (46, 4, 12, NULL, 0, '2026-08-07 15:51:47', NULL, '2026-08-07 15:51:47', '2026-08-07 15:51:47');
INSERT INTO `user_coupon` VALUES (47, 4, 12, NULL, 0, '2026-08-07 15:51:47', NULL, '2026-08-07 15:51:47', '2026-08-07 15:51:47');
INSERT INTO `user_coupon` VALUES (49, 4, 14, NULL, 0, '2026-08-07 15:52:49', NULL, '2026-08-07 15:52:49', '2026-08-07 15:52:49');
INSERT INTO `user_coupon` VALUES (50, 4, 14, NULL, 0, '2026-08-07 15:52:49', NULL, '2026-08-07 15:52:49', '2026-08-07 15:52:49');
INSERT INTO `user_coupon` VALUES (51, 4, 14, NULL, 0, '2026-08-07 15:52:49', NULL, '2026-08-07 15:52:49', '2026-08-07 15:52:49');
INSERT INTO `user_coupon` VALUES (52, 4, 14, NULL, 0, '2026-08-07 15:52:49', NULL, '2026-08-07 15:52:49', '2026-08-07 15:52:49');
INSERT INTO `user_coupon` VALUES (53, 4, 14, NULL, 0, '2026-08-07 15:52:49', NULL, '2026-08-07 15:52:49', '2026-08-07 15:52:49');
INSERT INTO `user_coupon` VALUES (55, 6, 2, NULL, 2, '2026-08-08 10:32:45', NULL, '2026-08-08 10:32:45', '2026-08-08 10:32:45');

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
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户签到记录表' ROW_FORMAT = Dynamic;

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
INSERT INTO `user_signin_record` VALUES (35, 6, '2026-08-07', '2026-08-07 09:36:47');
INSERT INTO `user_signin_record` VALUES (36, 5, '2026-08-07', '2026-08-07 16:08:32');
INSERT INTO `user_signin_record` VALUES (37, 6, '2026-08-10', '2026-08-10 10:52:07');

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
) ENGINE = InnoDB AUTO_INCREMENT = 4802 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户访问日志表' ROW_FORMAT = Dynamic;

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
INSERT INTO `visit_log` VALUES (3877, NULL, '0:0:0:0:0:0:0:1', 'curl/8.21.0', '/api/product/es/search', '2026-08-06 17:33:45');
INSERT INTO `visit_log` VALUES (3878, 4, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/cart/list', '2026-08-06 17:35:16');
INSERT INTO `visit_log` VALUES (3879, 4, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/cart/add', '2026-08-06 17:55:41');
INSERT INTO `visit_log` VALUES (3880, 4, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/cart/add', '2026-08-06 17:55:52');
INSERT INTO `visit_log` VALUES (3881, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/list', '2026-08-06 17:56:56');
INSERT INTO `visit_log` VALUES (3882, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/list', '2026-08-06 17:57:02');
INSERT INTO `visit_log` VALUES (3883, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/list', '2026-08-06 17:57:07');
INSERT INTO `visit_log` VALUES (3884, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/list', '2026-08-06 17:57:12');
INSERT INTO `visit_log` VALUES (3885, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/list', '2026-08-06 17:57:17');
INSERT INTO `visit_log` VALUES (3886, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/list', '2026-08-06 17:57:22');
INSERT INTO `visit_log` VALUES (3887, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/list', '2026-08-06 17:57:27');
INSERT INTO `visit_log` VALUES (3888, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/list', '2026-08-06 17:57:32');
INSERT INTO `visit_log` VALUES (3889, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/list', '2026-08-06 17:57:37');
INSERT INTO `visit_log` VALUES (3890, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/list', '2026-08-06 17:57:42');
INSERT INTO `visit_log` VALUES (3891, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/list', '2026-08-06 17:57:47');
INSERT INTO `visit_log` VALUES (3892, 4, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/cart/add', '2026-08-06 17:58:03');
INSERT INTO `visit_log` VALUES (3893, 4, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/cart/add', '2026-08-06 17:58:04');
INSERT INTO `visit_log` VALUES (3894, 4, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/cart/add', '2026-08-06 17:59:55');
INSERT INTO `visit_log` VALUES (3895, 4, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/cart/add', '2026-08-06 17:59:55');
INSERT INTO `visit_log` VALUES (3896, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/page', '2026-08-07 09:34:14');
INSERT INTO `visit_log` VALUES (3897, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/admin/page', '2026-08-07 09:34:20');
INSERT INTO `visit_log` VALUES (3898, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/admin/page', '2026-08-07 09:34:26');
INSERT INTO `visit_log` VALUES (3899, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/admin/43', '2026-08-07 09:34:31');
INSERT INTO `visit_log` VALUES (3900, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 09:35:28');
INSERT INTO `visit_log` VALUES (3901, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 09:35:28');
INSERT INTO `visit_log` VALUES (3902, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 09:35:50');
INSERT INTO `visit_log` VALUES (3903, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 09:35:50');
INSERT INTO `visit_log` VALUES (3904, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-07 09:36:05');
INSERT INTO `visit_log` VALUES (3905, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/14', '2026-08-07 09:36:05');
INSERT INTO `visit_log` VALUES (3906, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/14/images', '2026-08-07 09:36:05');
INSERT INTO `visit_log` VALUES (3907, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/14/all', '2026-08-07 09:36:05');
INSERT INTO `visit_log` VALUES (3908, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 09:36:10');
INSERT INTO `visit_log` VALUES (3909, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 09:36:11');
INSERT INTO `visit_log` VALUES (3910, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/4/images', '2026-08-07 09:36:12');
INSERT INTO `visit_log` VALUES (3911, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-07 09:36:12');
INSERT INTO `visit_log` VALUES (3912, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/4/all', '2026-08-07 09:36:12');
INSERT INTO `visit_log` VALUES (3913, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/4', '2026-08-07 09:36:12');
INSERT INTO `visit_log` VALUES (3914, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 09:36:14');
INSERT INTO `visit_log` VALUES (3915, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 09:36:15');
INSERT INTO `visit_log` VALUES (3916, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-07 09:36:16');
INSERT INTO `visit_log` VALUES (3917, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 09:36:19');
INSERT INTO `visit_log` VALUES (3918, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-07 09:36:24');
INSERT INTO `visit_log` VALUES (3919, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-07 09:36:27');
INSERT INTO `visit_log` VALUES (3920, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 09:37:12');
INSERT INTO `visit_log` VALUES (3921, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 09:37:12');
INSERT INTO `visit_log` VALUES (3922, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-07 09:37:14');
INSERT INTO `visit_log` VALUES (3923, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-07 09:37:14');
INSERT INTO `visit_log` VALUES (3924, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-07 09:37:14');
INSERT INTO `visit_log` VALUES (3925, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-07 09:37:14');
INSERT INTO `visit_log` VALUES (3926, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/merchant/2', '2026-08-07 09:37:18');
INSERT INTO `visit_log` VALUES (3927, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 16:08:00');
INSERT INTO `visit_log` VALUES (3928, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 16:08:00');
INSERT INTO `visit_log` VALUES (3929, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/product/es/search', '2026-08-07 16:08:08');
INSERT INTO `visit_log` VALUES (3930, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/product/es/search', '2026-08-07 16:08:12');
INSERT INTO `visit_log` VALUES (3931, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/product/es/search', '2026-08-07 16:08:14');
INSERT INTO `visit_log` VALUES (3932, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/order/user/page', '2026-08-07 16:09:11');
INSERT INTO `visit_log` VALUES (3933, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/product/es/search', '2026-08-07 16:09:31');
INSERT INTO `visit_log` VALUES (3934, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/product/hot', '2026-08-07 16:09:32');
INSERT INTO `visit_log` VALUES (3935, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/product/4', '2026-08-07 16:09:35');
INSERT INTO `visit_log` VALUES (3936, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/comments/product/4/all', '2026-08-07 16:09:35');
INSERT INTO `visit_log` VALUES (3937, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/product/4/images', '2026-08-07 16:09:35');
INSERT INTO `visit_log` VALUES (3938, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/product/history', '2026-08-07 16:09:35');
INSERT INTO `visit_log` VALUES (3939, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/cart/add', '2026-08-07 16:09:40');
INSERT INTO `visit_log` VALUES (3940, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/cart/list', '2026-08-07 16:09:43');
INSERT INTO `visit_log` VALUES (3941, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/cart/list', '2026-08-07 16:09:47');
INSERT INTO `visit_log` VALUES (3942, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/address/list', '2026-08-07 16:09:47');
INSERT INTO `visit_log` VALUES (3943, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/address/list', '2026-08-07 16:09:52');
INSERT INTO `visit_log` VALUES (3944, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/cart/list', '2026-08-07 16:10:00');
INSERT INTO `visit_log` VALUES (3945, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/cart/list', '2026-08-07 16:10:02');
INSERT INTO `visit_log` VALUES (3946, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/address/list', '2026-08-07 16:10:02');
INSERT INTO `visit_log` VALUES (3947, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/order/create', '2026-08-07 16:10:06');
INSERT INTO `visit_log` VALUES (3948, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/cart/clear', '2026-08-07 16:10:07');
INSERT INTO `visit_log` VALUES (3949, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/order/user/page', '2026-08-07 16:10:08');
INSERT INTO `visit_log` VALUES (3950, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/order/64', '2026-08-07 16:10:14');
INSERT INTO `visit_log` VALUES (3951, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:10:25');
INSERT INTO `visit_log` VALUES (3952, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/pay/64', '2026-08-07 16:10:32');
INSERT INTO `visit_log` VALUES (3953, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:10:33');
INSERT INTO `visit_log` VALUES (3954, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:10:42');
INSERT INTO `visit_log` VALUES (3955, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:10:44');
INSERT INTO `visit_log` VALUES (3956, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/64', '2026-08-07 16:10:54');
INSERT INTO `visit_log` VALUES (3957, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 16:10:58');
INSERT INTO `visit_log` VALUES (3958, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 16:10:58');
INSERT INTO `visit_log` VALUES (3959, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/4', '2026-08-07 16:11:01');
INSERT INTO `visit_log` VALUES (3960, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-07 16:11:01');
INSERT INTO `visit_log` VALUES (3961, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/4/images', '2026-08-07 16:11:01');
INSERT INTO `visit_log` VALUES (3962, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/4/all', '2026-08-07 16:11:01');
INSERT INTO `visit_log` VALUES (3963, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/merchant/2', '2026-08-07 16:11:05');
INSERT INTO `visit_log` VALUES (3964, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/merchant/2', '2026-08-07 16:11:26');
INSERT INTO `visit_log` VALUES (3965, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:12:43');
INSERT INTO `visit_log` VALUES (3966, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:12:46');
INSERT INTO `visit_log` VALUES (3967, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/64', '2026-08-07 16:12:51');
INSERT INTO `visit_log` VALUES (3968, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/confirm-receive/64', '2026-08-07 16:12:55');
INSERT INTO `visit_log` VALUES (3969, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/64', '2026-08-07 16:12:55');
INSERT INTO `visit_log` VALUES (3970, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:12:58');
INSERT INTO `visit_log` VALUES (3971, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 16:13:42');
INSERT INTO `visit_log` VALUES (3972, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 16:13:42');
INSERT INTO `visit_log` VALUES (3973, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 16:14:06');
INSERT INTO `visit_log` VALUES (3974, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 16:14:06');
INSERT INTO `visit_log` VALUES (3975, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-07 16:14:09');
INSERT INTO `visit_log` VALUES (3976, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/11/all', '2026-08-07 16:14:09');
INSERT INTO `visit_log` VALUES (3977, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/11/images', '2026-08-07 16:14:09');
INSERT INTO `visit_log` VALUES (3978, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/11', '2026-08-07 16:14:09');
INSERT INTO `visit_log` VALUES (3979, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 16:14:13');
INSERT INTO `visit_log` VALUES (3980, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 16:14:13');
INSERT INTO `visit_log` VALUES (3981, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 16:14:16');
INSERT INTO `visit_log` VALUES (3982, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-07 16:14:18');
INSERT INTO `visit_log` VALUES (3983, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/17', '2026-08-07 16:14:18');
INSERT INTO `visit_log` VALUES (3984, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/17/all', '2026-08-07 16:14:18');
INSERT INTO `visit_log` VALUES (3985, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/17/images', '2026-08-07 16:14:18');
INSERT INTO `visit_log` VALUES (3986, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/add', '2026-08-07 16:14:24');
INSERT INTO `visit_log` VALUES (3987, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/merchant/5', '2026-08-07 16:14:28');
INSERT INTO `visit_log` VALUES (3988, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 16:15:24');
INSERT INTO `visit_log` VALUES (3989, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 16:15:24');
INSERT INTO `visit_log` VALUES (3990, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:15:32');
INSERT INTO `visit_log` VALUES (3991, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/64', '2026-08-07 16:15:53');
INSERT INTO `visit_log` VALUES (3992, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 16:16:00');
INSERT INTO `visit_log` VALUES (3993, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 16:16:00');
INSERT INTO `visit_log` VALUES (3994, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-07 16:16:01');
INSERT INTO `visit_log` VALUES (3995, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-07 16:16:02');
INSERT INTO `visit_log` VALUES (3996, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-07 16:16:02');
INSERT INTO `visit_log` VALUES (3997, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-07 16:16:02');
INSERT INTO `visit_log` VALUES (3998, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:16:59');
INSERT INTO `visit_log` VALUES (3999, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:17:06');
INSERT INTO `visit_log` VALUES (4000, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/40', '2026-08-07 16:17:29');
INSERT INTO `visit_log` VALUES (4001, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 16:17:34');
INSERT INTO `visit_log` VALUES (4002, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 16:17:34');
INSERT INTO `visit_log` VALUES (4003, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 16:17:37');
INSERT INTO `visit_log` VALUES (4004, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-07 16:17:39');
INSERT INTO `visit_log` VALUES (4005, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/15/all', '2026-08-07 16:17:39');
INSERT INTO `visit_log` VALUES (4006, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15/images', '2026-08-07 16:17:39');
INSERT INTO `visit_log` VALUES (4007, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15', '2026-08-07 16:17:39');
INSERT INTO `visit_log` VALUES (4008, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15/images', '2026-08-07 16:17:52');
INSERT INTO `visit_log` VALUES (4009, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/15/all', '2026-08-07 16:17:52');
INSERT INTO `visit_log` VALUES (4010, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15', '2026-08-07 16:17:52');
INSERT INTO `visit_log` VALUES (4011, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/reply', '2026-08-07 16:18:00');
INSERT INTO `visit_log` VALUES (4012, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15', '2026-08-07 16:18:00');
INSERT INTO `visit_log` VALUES (4013, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/15/all', '2026-08-07 16:18:00');
INSERT INTO `visit_log` VALUES (4014, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15/images', '2026-08-07 16:18:00');
INSERT INTO `visit_log` VALUES (4015, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/reply', '2026-08-07 16:18:12');
INSERT INTO `visit_log` VALUES (4016, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/15/all', '2026-08-07 16:18:12');
INSERT INTO `visit_log` VALUES (4017, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15', '2026-08-07 16:18:12');
INSERT INTO `visit_log` VALUES (4018, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15/images', '2026-08-07 16:18:12');
INSERT INTO `visit_log` VALUES (4019, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/add', '2026-08-07 16:18:39');
INSERT INTO `visit_log` VALUES (4020, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:18:55');
INSERT INTO `visit_log` VALUES (4021, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:20:38');
INSERT INTO `visit_log` VALUES (4022, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:20:42');
INSERT INTO `visit_log` VALUES (4023, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:24:29');
INSERT INTO `visit_log` VALUES (4024, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:25:14');
INSERT INTO `visit_log` VALUES (4025, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:25:23');
INSERT INTO `visit_log` VALUES (4026, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:26:56');
INSERT INTO `visit_log` VALUES (4027, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/order/user/page', '2026-08-07 16:35:51');
INSERT INTO `visit_log` VALUES (4028, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/order/user/page', '2026-08-07 16:36:03');
INSERT INTO `visit_log` VALUES (4029, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Mobile Safari/537.36', '/api/order/user/page', '2026-08-07 16:36:08');
INSERT INTO `visit_log` VALUES (4030, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/es/search', '2026-08-07 16:45:31');
INSERT INTO `visit_log` VALUES (4031, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/es/search', '2026-08-07 16:45:32');
INSERT INTO `visit_log` VALUES (4032, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/es/search', '2026-08-07 16:45:42');
INSERT INTO `visit_log` VALUES (4033, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/es/search', '2026-08-07 16:45:42');
INSERT INTO `visit_log` VALUES (4034, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/es/search', '2026-08-07 16:45:50');
INSERT INTO `visit_log` VALUES (4035, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/hot', '2026-08-07 16:50:55');
INSERT INTO `visit_log` VALUES (4036, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/1', '2026-08-07 16:50:55');
INSERT INTO `visit_log` VALUES (4037, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/1/images', '2026-08-07 16:50:55');
INSERT INTO `visit_log` VALUES (4038, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/hot', '2026-08-07 16:51:03');
INSERT INTO `visit_log` VALUES (4039, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/1', '2026-08-07 16:51:03');
INSERT INTO `visit_log` VALUES (4040, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/1/images', '2026-08-07 16:51:03');
INSERT INTO `visit_log` VALUES (4041, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/es/search', '2026-08-07 16:51:10');
INSERT INTO `visit_log` VALUES (4042, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/hot', '2026-08-07 16:51:12');
INSERT INTO `visit_log` VALUES (4043, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/es/search', '2026-08-07 16:51:14');
INSERT INTO `visit_log` VALUES (4044, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/es/search', '2026-08-07 16:51:31');
INSERT INTO `visit_log` VALUES (4045, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/hot', '2026-08-07 16:51:33');
INSERT INTO `visit_log` VALUES (4046, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/es/search', '2026-08-07 16:51:34');
INSERT INTO `visit_log` VALUES (4047, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/es/search', '2026-08-07 16:55:11');
INSERT INTO `visit_log` VALUES (4048, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-07 16:57:57');
INSERT INTO `visit_log` VALUES (4049, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 16:58:01');
INSERT INTO `visit_log` VALUES (4050, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 16:58:01');
INSERT INTO `visit_log` VALUES (4051, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/list', '2026-08-07 16:59:06');
INSERT INTO `visit_log` VALUES (4052, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/order/user/page', '2026-08-07 16:59:19');
INSERT INTO `visit_log` VALUES (4053, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/order/user/page', '2026-08-07 16:59:32');
INSERT INTO `visit_log` VALUES (4054, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-07 16:59:53');
INSERT INTO `visit_log` VALUES (4055, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/es/search', '2026-08-07 17:01:26');
INSERT INTO `visit_log` VALUES (4056, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/es/search', '2026-08-07 17:01:35');
INSERT INTO `visit_log` VALUES (4057, NULL, '0:0:0:0:0:0:0:1', 'python-requests/2.34.2', '/api/product/es/search', '2026-08-07 17:01:43');
INSERT INTO `visit_log` VALUES (4058, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 17:02:52');
INSERT INTO `visit_log` VALUES (4059, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 17:02:52');
INSERT INTO `visit_log` VALUES (4060, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/list', '2026-08-07 17:13:45');
INSERT INTO `visit_log` VALUES (4061, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/es/search', '2026-08-07 17:13:51');
INSERT INTO `visit_log` VALUES (4062, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/hot', '2026-08-07 17:13:51');
INSERT INTO `visit_log` VALUES (4063, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/order/user/page', '2026-08-07 17:20:14');
INSERT INTO `visit_log` VALUES (4064, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/hot', '2026-08-07 17:20:45');
INSERT INTO `visit_log` VALUES (4065, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/es/search', '2026-08-07 17:20:45');
INSERT INTO `visit_log` VALUES (4066, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/2', '2026-08-07 17:20:48');
INSERT INTO `visit_log` VALUES (4067, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/history', '2026-08-07 17:20:48');
INSERT INTO `visit_log` VALUES (4068, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/comments/product/2/all', '2026-08-07 17:20:48');
INSERT INTO `visit_log` VALUES (4069, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/2/images', '2026-08-07 17:20:48');
INSERT INTO `visit_log` VALUES (4070, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/merchant/2', '2026-08-07 17:20:55');
INSERT INTO `visit_log` VALUES (4071, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-07 17:22:47');
INSERT INTO `visit_log` VALUES (4072, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-07 17:22:48');
INSERT INTO `visit_log` VALUES (4073, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/page', '2026-08-07 17:41:51');
INSERT INTO `visit_log` VALUES (4074, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/page', '2026-08-07 17:47:31');
INSERT INTO `visit_log` VALUES (4075, 4, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/address/list', '2026-08-07 17:51:49');
INSERT INTO `visit_log` VALUES (4076, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-07 17:52:05');
INSERT INTO `visit_log` VALUES (4077, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-07 17:52:31');
INSERT INTO `visit_log` VALUES (4078, 4, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/order/cancel/65', '2026-08-07 17:53:54');
INSERT INTO `visit_log` VALUES (4079, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/page', '2026-08-08 09:30:36');
INSERT INTO `visit_log` VALUES (4080, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/17', '2026-08-08 09:30:47');
INSERT INTO `visit_log` VALUES (4081, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 09:34:02');
INSERT INTO `visit_log` VALUES (4082, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 09:34:02');
INSERT INTO `visit_log` VALUES (4083, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-08 09:34:42');
INSERT INTO `visit_log` VALUES (4084, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-08 09:34:56');
INSERT INTO `visit_log` VALUES (4085, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-08 09:38:33');
INSERT INTO `visit_log` VALUES (4086, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', '/api/product/page', '2026-08-08 09:47:27');
INSERT INTO `visit_log` VALUES (4087, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', '/api/product/page', '2026-08-08 09:47:33');
INSERT INTO `visit_log` VALUES (4088, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-08 10:08:05');
INSERT INTO `visit_log` VALUES (4089, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/67', '2026-08-08 10:08:06');
INSERT INTO `visit_log` VALUES (4090, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 10:08:43');
INSERT INTO `visit_log` VALUES (4091, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 10:08:43');
INSERT INTO `visit_log` VALUES (4092, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-08 10:08:46');
INSERT INTO `visit_log` VALUES (4093, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/3/images', '2026-08-08 10:08:46');
INSERT INTO `visit_log` VALUES (4094, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/3/all', '2026-08-08 10:08:46');
INSERT INTO `visit_log` VALUES (4095, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/3', '2026-08-08 10:08:46');
INSERT INTO `visit_log` VALUES (4096, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-08 10:08:49');
INSERT INTO `visit_log` VALUES (4097, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 10:08:54');
INSERT INTO `visit_log` VALUES (4098, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 10:08:54');
INSERT INTO `visit_log` VALUES (4099, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-08 10:08:56');
INSERT INTO `visit_log` VALUES (4100, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/7', '2026-08-08 10:08:56');
INSERT INTO `visit_log` VALUES (4101, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/7/all', '2026-08-08 10:08:56');
INSERT INTO `visit_log` VALUES (4102, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/7/images', '2026-08-08 10:08:56');
INSERT INTO `visit_log` VALUES (4103, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/add', '2026-08-08 10:08:59');
INSERT INTO `visit_log` VALUES (4104, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-08 10:09:01');
INSERT INTO `visit_log` VALUES (4105, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 10:09:05');
INSERT INTO `visit_log` VALUES (4106, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 10:09:05');
INSERT INTO `visit_log` VALUES (4107, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-08 10:09:07');
INSERT INTO `visit_log` VALUES (4108, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/5/all', '2026-08-08 10:09:07');
INSERT INTO `visit_log` VALUES (4109, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/5', '2026-08-08 10:09:07');
INSERT INTO `visit_log` VALUES (4110, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/5/images', '2026-08-08 10:09:07');
INSERT INTO `visit_log` VALUES (4111, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/add', '2026-08-08 10:09:11');
INSERT INTO `visit_log` VALUES (4112, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-08 10:09:13');
INSERT INTO `visit_log` VALUES (4113, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-08 10:09:18');
INSERT INTO `visit_log` VALUES (4114, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-08 10:09:18');
INSERT INTO `visit_log` VALUES (4115, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/create', '2026-08-08 10:09:34');
INSERT INTO `visit_log` VALUES (4116, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/clear', '2026-08-08 10:09:35');
INSERT INTO `visit_log` VALUES (4117, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-08 10:09:36');
INSERT INTO `visit_log` VALUES (4118, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/5/images', '2026-08-08 10:12:27');
INSERT INTO `visit_log` VALUES (4119, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-08 10:12:27');
INSERT INTO `visit_log` VALUES (4120, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/5/all', '2026-08-08 10:12:27');
INSERT INTO `visit_log` VALUES (4121, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/5', '2026-08-08 10:12:27');
INSERT INTO `visit_log` VALUES (4122, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-08 10:12:44');
INSERT INTO `visit_log` VALUES (4123, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-08 10:13:09');
INSERT INTO `visit_log` VALUES (4124, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-08 10:13:27');
INSERT INTO `visit_log` VALUES (4125, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-08 10:13:28');
INSERT INTO `visit_log` VALUES (4126, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-08 10:17:48');
INSERT INTO `visit_log` VALUES (4127, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/pay/69', '2026-08-08 10:18:13');
INSERT INTO `visit_log` VALUES (4128, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-08 10:18:13');
INSERT INTO `visit_log` VALUES (4129, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-08 10:18:18');
INSERT INTO `visit_log` VALUES (4130, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-08 10:18:20');
INSERT INTO `visit_log` VALUES (4131, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-08 10:18:22');
INSERT INTO `visit_log` VALUES (4132, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/69', '2026-08-08 10:18:27');
INSERT INTO `visit_log` VALUES (4133, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-08 10:18:32');
INSERT INTO `visit_log` VALUES (4134, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/69', '2026-08-08 10:18:34');
INSERT INTO `visit_log` VALUES (4135, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/page', '2026-08-08 10:21:29');
INSERT INTO `visit_log` VALUES (4136, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13', '2026-08-08 10:22:48');
INSERT INTO `visit_log` VALUES (4137, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 10:24:23');
INSERT INTO `visit_log` VALUES (4138, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 10:24:23');
INSERT INTO `visit_log` VALUES (4139, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-08 10:25:25');
INSERT INTO `visit_log` VALUES (4140, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-08 10:25:26');
INSERT INTO `visit_log` VALUES (4141, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-08 10:25:36');
INSERT INTO `visit_log` VALUES (4142, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-08 10:25:40');
INSERT INTO `visit_log` VALUES (4143, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-08 10:25:51');
INSERT INTO `visit_log` VALUES (4144, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-08 10:25:52');
INSERT INTO `visit_log` VALUES (4145, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-08 10:32:36');
INSERT INTO `visit_log` VALUES (4146, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-08 10:32:38');
INSERT INTO `visit_log` VALUES (4147, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/comments/product/1/all', '2026-08-08 14:47:11');
INSERT INTO `visit_log` VALUES (4148, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/comments/product/1/all', '2026-08-08 14:49:42');
INSERT INTO `visit_log` VALUES (4149, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 14:54:39');
INSERT INTO `visit_log` VALUES (4150, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 14:54:39');
INSERT INTO `visit_log` VALUES (4151, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 14:54:48');
INSERT INTO `visit_log` VALUES (4152, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 14:54:48');
INSERT INTO `visit_log` VALUES (4153, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 14:54:50');
INSERT INTO `visit_log` VALUES (4154, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 14:54:51');
INSERT INTO `visit_log` VALUES (4155, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 14:54:53');
INSERT INTO `visit_log` VALUES (4156, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 14:54:53');
INSERT INTO `visit_log` VALUES (4157, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 14:54:57');
INSERT INTO `visit_log` VALUES (4158, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 14:54:57');
INSERT INTO `visit_log` VALUES (4159, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/1', '2026-08-08 14:55:00');
INSERT INTO `visit_log` VALUES (4160, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/1/images', '2026-08-08 14:55:00');
INSERT INTO `visit_log` VALUES (4161, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/1/all', '2026-08-08 14:55:00');
INSERT INTO `visit_log` VALUES (4162, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 14:55:03');
INSERT INTO `visit_log` VALUES (4163, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 14:55:03');
INSERT INTO `visit_log` VALUES (4164, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 14:55:53');
INSERT INTO `visit_log` VALUES (4165, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 14:55:53');
INSERT INTO `visit_log` VALUES (4166, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 14:55:57');
INSERT INTO `visit_log` VALUES (4167, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 14:55:57');
INSERT INTO `visit_log` VALUES (4168, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 14:56:51');
INSERT INTO `visit_log` VALUES (4169, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 14:56:51');
INSERT INTO `visit_log` VALUES (4170, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/4/all', '2026-08-08 14:57:01');
INSERT INTO `visit_log` VALUES (4171, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/4/images', '2026-08-08 14:57:01');
INSERT INTO `visit_log` VALUES (4172, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/4', '2026-08-08 14:57:01');
INSERT INTO `visit_log` VALUES (4173, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 14:57:05');
INSERT INTO `visit_log` VALUES (4174, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 14:57:05');
INSERT INTO `visit_log` VALUES (4175, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/4/images', '2026-08-08 15:00:28');
INSERT INTO `visit_log` VALUES (4176, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/4', '2026-08-08 15:00:28');
INSERT INTO `visit_log` VALUES (4177, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/4/all', '2026-08-08 15:00:28');
INSERT INTO `visit_log` VALUES (4178, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/4', '2026-08-08 15:10:39');
INSERT INTO `visit_log` VALUES (4179, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/4/images', '2026-08-08 15:10:39');
INSERT INTO `visit_log` VALUES (4180, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/4/all', '2026-08-08 15:10:39');
INSERT INTO `visit_log` VALUES (4181, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:10:48');
INSERT INTO `visit_log` VALUES (4182, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 15:10:48');
INSERT INTO `visit_log` VALUES (4183, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/9/images', '2026-08-08 15:10:51');
INSERT INTO `visit_log` VALUES (4184, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/9', '2026-08-08 15:10:51');
INSERT INTO `visit_log` VALUES (4185, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/9/all', '2026-08-08 15:10:51');
INSERT INTO `visit_log` VALUES (4186, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-08 15:11:13');
INSERT INTO `visit_log` VALUES (4187, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-08 15:11:16');
INSERT INTO `visit_log` VALUES (4188, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:11:17');
INSERT INTO `visit_log` VALUES (4189, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 15:11:17');
INSERT INTO `visit_log` VALUES (4190, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/4/all', '2026-08-08 15:11:20');
INSERT INTO `visit_log` VALUES (4191, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/4/images', '2026-08-08 15:11:20');
INSERT INTO `visit_log` VALUES (4192, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-08 15:11:20');
INSERT INTO `visit_log` VALUES (4193, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/4', '2026-08-08 15:11:20');
INSERT INTO `visit_log` VALUES (4194, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-08 15:11:36');
INSERT INTO `visit_log` VALUES (4195, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/4/images', '2026-08-08 15:11:36');
INSERT INTO `visit_log` VALUES (4196, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/4/all', '2026-08-08 15:11:36');
INSERT INTO `visit_log` VALUES (4197, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/4', '2026-08-08 15:11:36');
INSERT INTO `visit_log` VALUES (4198, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:17:58');
INSERT INTO `visit_log` VALUES (4199, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 15:17:58');
INSERT INTO `visit_log` VALUES (4200, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:18:03');
INSERT INTO `visit_log` VALUES (4201, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:18:06');
INSERT INTO `visit_log` VALUES (4202, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:18:48');
INSERT INTO `visit_log` VALUES (4203, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 15:18:48');
INSERT INTO `visit_log` VALUES (4204, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:27:45');
INSERT INTO `visit_log` VALUES (4205, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 15:27:45');
INSERT INTO `visit_log` VALUES (4206, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 15:33:33');
INSERT INTO `visit_log` VALUES (4207, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:33:33');
INSERT INTO `visit_log` VALUES (4208, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/es/search', '2026-08-08 15:34:54');
INSERT INTO `visit_log` VALUES (4209, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/es/search', '2026-08-08 15:34:58');
INSERT INTO `visit_log` VALUES (4210, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.26100.8972', '/api/product/es/search', '2026-08-08 15:38:11');
INSERT INTO `visit_log` VALUES (4211, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-08 15:42:46');
INSERT INTO `visit_log` VALUES (4212, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:42:46');
INSERT INTO `visit_log` VALUES (4213, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:42:50');
INSERT INTO `visit_log` VALUES (4214, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:42:53');
INSERT INTO `visit_log` VALUES (4215, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:42:55');
INSERT INTO `visit_log` VALUES (4216, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:42:57');
INSERT INTO `visit_log` VALUES (4217, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:42:59');
INSERT INTO `visit_log` VALUES (4218, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:43:00');
INSERT INTO `visit_log` VALUES (4219, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:43:01');
INSERT INTO `visit_log` VALUES (4220, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:43:03');
INSERT INTO `visit_log` VALUES (4221, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:43:04');
INSERT INTO `visit_log` VALUES (4222, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:43:05');
INSERT INTO `visit_log` VALUES (4223, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:43:07');
INSERT INTO `visit_log` VALUES (4224, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-08 15:43:09');
INSERT INTO `visit_log` VALUES (4225, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 10:06:40');
INSERT INTO `visit_log` VALUES (4226, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 10:06:40');
INSERT INTO `visit_log` VALUES (4227, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/8/all', '2026-08-10 10:06:51');
INSERT INTO `visit_log` VALUES (4228, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/8', '2026-08-10 10:06:51');
INSERT INTO `visit_log` VALUES (4229, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/8/images', '2026-08-10 10:06:51');
INSERT INTO `visit_log` VALUES (4230, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 10:06:54');
INSERT INTO `visit_log` VALUES (4231, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 10:06:54');
INSERT INTO `visit_log` VALUES (4232, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 10:15:39');
INSERT INTO `visit_log` VALUES (4233, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 10:15:39');
INSERT INTO `visit_log` VALUES (4234, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 10:15:42');
INSERT INTO `visit_log` VALUES (4235, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 10:15:42');
INSERT INTO `visit_log` VALUES (4236, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 10:51:08');
INSERT INTO `visit_log` VALUES (4237, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 10:51:08');
INSERT INTO `visit_log` VALUES (4238, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/13/all', '2026-08-10 10:51:14');
INSERT INTO `visit_log` VALUES (4239, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13/images', '2026-08-10 10:51:14');
INSERT INTO `visit_log` VALUES (4240, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13', '2026-08-10 10:51:14');
INSERT INTO `visit_log` VALUES (4241, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 10:51:43');
INSERT INTO `visit_log` VALUES (4242, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 10:51:43');
INSERT INTO `visit_log` VALUES (4243, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-10 10:51:47');
INSERT INTO `visit_log` VALUES (4244, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-10 10:51:49');
INSERT INTO `visit_log` VALUES (4245, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-10 10:51:52');
INSERT INTO `visit_log` VALUES (4246, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-10 10:51:54');
INSERT INTO `visit_log` VALUES (4247, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 10:52:29');
INSERT INTO `visit_log` VALUES (4248, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 10:52:29');
INSERT INTO `visit_log` VALUES (4249, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 10:52:43');
INSERT INTO `visit_log` VALUES (4250, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-10 10:52:48');
INSERT INTO `visit_log` VALUES (4251, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13', '2026-08-10 10:53:16');
INSERT INTO `visit_log` VALUES (4252, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-10 10:53:16');
INSERT INTO `visit_log` VALUES (4253, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13/images', '2026-08-10 10:53:16');
INSERT INTO `visit_log` VALUES (4254, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/13/all', '2026-08-10 10:53:16');
INSERT INTO `visit_log` VALUES (4255, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 10:53:47');
INSERT INTO `visit_log` VALUES (4256, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 10:53:47');
INSERT INTO `visit_log` VALUES (4257, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-10 10:53:52');
INSERT INTO `visit_log` VALUES (4258, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13/images', '2026-08-10 10:53:52');
INSERT INTO `visit_log` VALUES (4259, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13', '2026-08-10 10:53:52');
INSERT INTO `visit_log` VALUES (4260, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/13/all', '2026-08-10 10:53:52');
INSERT INTO `visit_log` VALUES (4261, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 10:53:54');
INSERT INTO `visit_log` VALUES (4262, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 10:53:54');
INSERT INTO `visit_log` VALUES (4263, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/13/all', '2026-08-10 10:54:00');
INSERT INTO `visit_log` VALUES (4264, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-10 10:54:00');
INSERT INTO `visit_log` VALUES (4265, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13/images', '2026-08-10 10:54:00');
INSERT INTO `visit_log` VALUES (4266, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13', '2026-08-10 10:54:00');
INSERT INTO `visit_log` VALUES (4267, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 10:54:45');
INSERT INTO `visit_log` VALUES (4268, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 10:54:46');
INSERT INTO `visit_log` VALUES (4269, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-10 10:55:11');
INSERT INTO `visit_log` VALUES (4270, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 10:55:18');
INSERT INTO `visit_log` VALUES (4271, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 10:55:18');
INSERT INTO `visit_log` VALUES (4272, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 10:56:27');
INSERT INTO `visit_log` VALUES (4273, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 10:56:27');
INSERT INTO `visit_log` VALUES (4274, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-10 11:00:42');
INSERT INTO `visit_log` VALUES (4275, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-10 11:07:59');
INSERT INTO `visit_log` VALUES (4276, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-10 11:08:08');
INSERT INTO `visit_log` VALUES (4277, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-10 11:10:28');
INSERT INTO `visit_log` VALUES (4278, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 11:11:05');
INSERT INTO `visit_log` VALUES (4279, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 11:11:05');
INSERT INTO `visit_log` VALUES (4280, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 QQBrowser/21.6.7003.400', '/api/product/es/search', '2026-08-10 11:12:38');
INSERT INTO `visit_log` VALUES (4281, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 QQBrowser/21.6.7003.400', '/api/product/hot', '2026-08-10 11:12:38');
INSERT INTO `visit_log` VALUES (4282, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 11:16:12');
INSERT INTO `visit_log` VALUES (4283, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 11:16:12');
INSERT INTO `visit_log` VALUES (4284, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-10 11:16:13');
INSERT INTO `visit_log` VALUES (4285, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 11:16:16');
INSERT INTO `visit_log` VALUES (4286, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 11:16:16');
INSERT INTO `visit_log` VALUES (4287, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-10 11:16:17');
INSERT INTO `visit_log` VALUES (4288, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 11:16:20');
INSERT INTO `visit_log` VALUES (4289, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 11:16:21');
INSERT INTO `visit_log` VALUES (4290, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-10 11:16:21');
INSERT INTO `visit_log` VALUES (4291, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 QQBrowser/21.6.7003.400', '/api/product/hot', '2026-08-10 11:18:23');
INSERT INTO `visit_log` VALUES (4292, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 QQBrowser/21.6.7003.400', '/api/product/es/search', '2026-08-10 11:18:23');
INSERT INTO `visit_log` VALUES (4293, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 QQBrowser/21.6.7003.400', '/api/product/es/search', '2026-08-10 11:18:30');
INSERT INTO `visit_log` VALUES (4294, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 QQBrowser/21.6.7003.400', '/api/product/hot', '2026-08-10 11:18:30');
INSERT INTO `visit_log` VALUES (4295, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 QQBrowser/21.6.7003.400', '/api/product/es/search', '2026-08-10 11:18:33');
INSERT INTO `visit_log` VALUES (4296, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 QQBrowser/21.6.7003.400', '/api/product/hot', '2026-08-10 11:18:33');
INSERT INTO `visit_log` VALUES (4297, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 QQBrowser/21.6.7003.400', '/api/product/es/search', '2026-08-10 11:18:40');
INSERT INTO `visit_log` VALUES (4298, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 QQBrowser/21.6.7003.400', '/api/product/hot', '2026-08-10 11:18:40');
INSERT INTO `visit_log` VALUES (4299, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 QQBrowser/21.6.7003.400', '/api/product/hot', '2026-08-10 11:18:43');
INSERT INTO `visit_log` VALUES (4300, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 QQBrowser/21.6.7003.400', '/api/product/es/search', '2026-08-10 11:18:43');
INSERT INTO `visit_log` VALUES (4301, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 QQBrowser/21.6.7003.400', '/api/product/es/search', '2026-08-10 11:18:44');
INSERT INTO `visit_log` VALUES (4302, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 QQBrowser/21.6.7003.400', '/api/product/hot', '2026-08-10 11:18:45');
INSERT INTO `visit_log` VALUES (4303, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 11:20:57');
INSERT INTO `visit_log` VALUES (4304, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 11:20:57');
INSERT INTO `visit_log` VALUES (4305, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 11:23:53');
INSERT INTO `visit_log` VALUES (4306, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 11:23:53');
INSERT INTO `visit_log` VALUES (4307, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 11:23:55');
INSERT INTO `visit_log` VALUES (4308, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 11:23:55');
INSERT INTO `visit_log` VALUES (4309, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 11:24:57');
INSERT INTO `visit_log` VALUES (4310, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 11:24:57');
INSERT INTO `visit_log` VALUES (4311, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 11:25:47');
INSERT INTO `visit_log` VALUES (4312, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 11:25:47');
INSERT INTO `visit_log` VALUES (4313, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-10 11:28:02');
INSERT INTO `visit_log` VALUES (4314, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-10 11:28:07');
INSERT INTO `visit_log` VALUES (4315, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-10 11:28:11');
INSERT INTO `visit_log` VALUES (4316, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 11:28:12');
INSERT INTO `visit_log` VALUES (4317, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 11:28:12');
INSERT INTO `visit_log` VALUES (4318, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/page', '2026-08-10 11:34:53');
INSERT INTO `visit_log` VALUES (4319, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/page', '2026-08-10 11:35:14');
INSERT INTO `visit_log` VALUES (4320, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 11:35:35');
INSERT INTO `visit_log` VALUES (4321, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 11:35:35');
INSERT INTO `visit_log` VALUES (4322, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/list', '2026-08-10 11:35:43');
INSERT INTO `visit_log` VALUES (4323, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/es/search', '2026-08-10 11:36:15');
INSERT INTO `visit_log` VALUES (4324, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/hot', '2026-08-10 11:36:15');
INSERT INTO `visit_log` VALUES (4325, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/es/search', '2026-08-10 11:36:18');
INSERT INTO `visit_log` VALUES (4326, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/hot', '2026-08-10 11:36:18');
INSERT INTO `visit_log` VALUES (4327, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/es/search', '2026-08-10 11:36:56');
INSERT INTO `visit_log` VALUES (4328, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/hot', '2026-08-10 11:36:56');
INSERT INTO `visit_log` VALUES (4329, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/es/search', '2026-08-10 11:37:09');
INSERT INTO `visit_log` VALUES (4330, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/hot', '2026-08-10 11:37:10');
INSERT INTO `visit_log` VALUES (4331, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/es/search', '2026-08-10 11:38:12');
INSERT INTO `visit_log` VALUES (4332, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/hot', '2026-08-10 11:38:12');
INSERT INTO `visit_log` VALUES (4333, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 11:39:38');
INSERT INTO `visit_log` VALUES (4334, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 11:39:38');
INSERT INTO `visit_log` VALUES (4335, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15', '2026-08-10 11:40:18');
INSERT INTO `visit_log` VALUES (4336, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15/images', '2026-08-10 11:40:18');
INSERT INTO `visit_log` VALUES (4337, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/15/all', '2026-08-10 11:40:18');
INSERT INTO `visit_log` VALUES (4338, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 11:40:34');
INSERT INTO `visit_log` VALUES (4339, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 11:40:34');
INSERT INTO `visit_log` VALUES (4340, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13', '2026-08-10 11:40:37');
INSERT INTO `visit_log` VALUES (4341, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/13/all', '2026-08-10 11:40:37');
INSERT INTO `visit_log` VALUES (4342, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13/images', '2026-08-10 11:40:37');
INSERT INTO `visit_log` VALUES (4343, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/page', '2026-08-10 11:41:02');
INSERT INTO `visit_log` VALUES (4344, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 17:32:42');
INSERT INTO `visit_log` VALUES (4345, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 17:32:42');
INSERT INTO `visit_log` VALUES (4346, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15', '2026-08-10 17:40:56');
INSERT INTO `visit_log` VALUES (4347, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15/images', '2026-08-10 17:40:56');
INSERT INTO `visit_log` VALUES (4348, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/15/all', '2026-08-10 17:40:56');
INSERT INTO `visit_log` VALUES (4349, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/15/all', '2026-08-10 17:51:43');
INSERT INTO `visit_log` VALUES (4350, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15/images', '2026-08-10 17:51:43');
INSERT INTO `visit_log` VALUES (4351, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15', '2026-08-10 17:51:43');
INSERT INTO `visit_log` VALUES (4352, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/15/all', '2026-08-10 17:51:45');
INSERT INTO `visit_log` VALUES (4353, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15', '2026-08-10 17:51:45');
INSERT INTO `visit_log` VALUES (4354, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15/images', '2026-08-10 17:51:45');
INSERT INTO `visit_log` VALUES (4355, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 17:51:46');
INSERT INTO `visit_log` VALUES (4356, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 17:51:46');
INSERT INTO `visit_log` VALUES (4357, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 17:51:49');
INSERT INTO `visit_log` VALUES (4358, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-10 17:52:28');
INSERT INTO `visit_log` VALUES (4359, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-10 17:52:35');
INSERT INTO `visit_log` VALUES (4360, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 17:52:37');
INSERT INTO `visit_log` VALUES (4361, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 17:52:37');
INSERT INTO `visit_log` VALUES (4362, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15/images', '2026-08-10 17:53:03');
INSERT INTO `visit_log` VALUES (4363, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-10 17:53:03');
INSERT INTO `visit_log` VALUES (4364, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15', '2026-08-10 17:53:03');
INSERT INTO `visit_log` VALUES (4365, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/15/all', '2026-08-10 17:53:03');
INSERT INTO `visit_log` VALUES (4366, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 17:53:05');
INSERT INTO `visit_log` VALUES (4367, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 17:53:05');
INSERT INTO `visit_log` VALUES (4368, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13/images', '2026-08-10 17:53:08');
INSERT INTO `visit_log` VALUES (4369, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13', '2026-08-10 17:53:08');
INSERT INTO `visit_log` VALUES (4370, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-10 17:53:08');
INSERT INTO `visit_log` VALUES (4371, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/13/all', '2026-08-10 17:53:08');
INSERT INTO `visit_log` VALUES (4372, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/add', '2026-08-10 17:53:12');
INSERT INTO `visit_log` VALUES (4373, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-10 17:53:15');
INSERT INTO `visit_log` VALUES (4374, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 17:53:23');
INSERT INTO `visit_log` VALUES (4375, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 17:53:23');
INSERT INTO `visit_log` VALUES (4376, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-10 17:53:25');
INSERT INTO `visit_log` VALUES (4377, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15', '2026-08-10 17:53:25');
INSERT INTO `visit_log` VALUES (4378, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/15/all', '2026-08-10 17:53:25');
INSERT INTO `visit_log` VALUES (4379, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15/images', '2026-08-10 17:53:25');
INSERT INTO `visit_log` VALUES (4380, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/add', '2026-08-10 17:53:28');
INSERT INTO `visit_log` VALUES (4381, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-10 17:53:29');
INSERT INTO `visit_log` VALUES (4382, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-10 17:53:43');
INSERT INTO `visit_log` VALUES (4383, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13', '2026-08-10 17:53:43');
INSERT INTO `visit_log` VALUES (4384, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/13/all', '2026-08-10 17:53:43');
INSERT INTO `visit_log` VALUES (4385, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13/images', '2026-08-10 17:53:43');
INSERT INTO `visit_log` VALUES (4386, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-10 17:53:44');
INSERT INTO `visit_log` VALUES (4387, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-10 17:56:07');
INSERT INTO `visit_log` VALUES (4388, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-10 17:56:22');
INSERT INTO `visit_log` VALUES (4389, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-10 17:56:23');
INSERT INTO `visit_log` VALUES (4390, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/list', '2026-08-10 17:57:14');
INSERT INTO `visit_log` VALUES (4391, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/update', '2026-08-10 17:59:48');
INSERT INTO `visit_log` VALUES (4392, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/update', '2026-08-10 17:59:49');
INSERT INTO `visit_log` VALUES (4393, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/remove', '2026-08-10 17:59:54');
INSERT INTO `visit_log` VALUES (4394, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/list', '2026-08-10 17:59:54');
INSERT INTO `visit_log` VALUES (4395, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/15', '2026-08-10 17:59:56');
INSERT INTO `visit_log` VALUES (4396, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/history', '2026-08-10 17:59:57');
INSERT INTO `visit_log` VALUES (4397, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/comments/product/15/all', '2026-08-10 17:59:57');
INSERT INTO `visit_log` VALUES (4398, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/15/images', '2026-08-10 17:59:57');
INSERT INTO `visit_log` VALUES (4399, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/add', '2026-08-10 18:00:03');
INSERT INTO `visit_log` VALUES (4400, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/list', '2026-08-10 18:00:06');
INSERT INTO `visit_log` VALUES (4401, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/clear', '2026-08-10 18:00:11');
INSERT INTO `visit_log` VALUES (4402, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/list', '2026-08-10 18:00:12');
INSERT INTO `visit_log` VALUES (4403, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/15', '2026-08-10 18:00:22');
INSERT INTO `visit_log` VALUES (4404, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/comments/product/15/all', '2026-08-10 18:00:22');
INSERT INTO `visit_log` VALUES (4405, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/history', '2026-08-10 18:00:22');
INSERT INTO `visit_log` VALUES (4406, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/15/images', '2026-08-10 18:00:22');
INSERT INTO `visit_log` VALUES (4407, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/add', '2026-08-10 18:00:26');
INSERT INTO `visit_log` VALUES (4408, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/cart/list', '2026-08-10 18:00:35');
INSERT INTO `visit_log` VALUES (4409, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 18:00:46');
INSERT INTO `visit_log` VALUES (4410, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 18:00:46');
INSERT INTO `visit_log` VALUES (4411, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-10 18:00:48');
INSERT INTO `visit_log` VALUES (4412, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/8/all', '2026-08-10 18:00:48');
INSERT INTO `visit_log` VALUES (4413, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/8', '2026-08-10 18:00:48');
INSERT INTO `visit_log` VALUES (4414, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/8/images', '2026-08-10 18:00:48');
INSERT INTO `visit_log` VALUES (4415, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/add', '2026-08-10 18:00:51');
INSERT INTO `visit_log` VALUES (4416, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 18:00:55');
INSERT INTO `visit_log` VALUES (4417, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 18:00:55');
INSERT INTO `visit_log` VALUES (4418, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-10 18:00:56');
INSERT INTO `visit_log` VALUES (4419, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/12/all', '2026-08-10 18:00:56');
INSERT INTO `visit_log` VALUES (4420, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12', '2026-08-10 18:00:56');
INSERT INTO `visit_log` VALUES (4421, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12/images', '2026-08-10 18:00:56');
INSERT INTO `visit_log` VALUES (4422, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/add', '2026-08-10 18:00:59');
INSERT INTO `visit_log` VALUES (4423, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 18:01:01');
INSERT INTO `visit_log` VALUES (4424, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 18:01:01');
INSERT INTO `visit_log` VALUES (4425, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-10 18:01:03');
INSERT INTO `visit_log` VALUES (4426, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/7', '2026-08-10 18:01:03');
INSERT INTO `visit_log` VALUES (4427, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/7/images', '2026-08-10 18:01:03');
INSERT INTO `visit_log` VALUES (4428, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/7/all', '2026-08-10 18:01:03');
INSERT INTO `visit_log` VALUES (4429, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/add', '2026-08-10 18:01:12');
INSERT INTO `visit_log` VALUES (4430, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 18:01:15');
INSERT INTO `visit_log` VALUES (4431, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 18:01:15');
INSERT INTO `visit_log` VALUES (4432, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-10 18:01:19');
INSERT INTO `visit_log` VALUES (4433, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 18:01:23');
INSERT INTO `visit_log` VALUES (4434, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 18:01:23');
INSERT INTO `visit_log` VALUES (4435, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-10 18:01:26');
INSERT INTO `visit_log` VALUES (4436, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/14/images', '2026-08-10 18:01:26');
INSERT INTO `visit_log` VALUES (4437, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/14/all', '2026-08-10 18:01:26');
INSERT INTO `visit_log` VALUES (4438, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/14', '2026-08-10 18:01:26');
INSERT INTO `visit_log` VALUES (4439, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/add', '2026-08-10 18:01:31');
INSERT INTO `visit_log` VALUES (4440, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-10 18:01:33');
INSERT INTO `visit_log` VALUES (4441, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-10 18:01:33');
INSERT INTO `visit_log` VALUES (4442, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-10 18:01:35');
INSERT INTO `visit_log` VALUES (4443, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/11/images', '2026-08-10 18:01:35');
INSERT INTO `visit_log` VALUES (4444, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/11/all', '2026-08-10 18:01:35');
INSERT INTO `visit_log` VALUES (4445, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/11', '2026-08-10 18:01:35');
INSERT INTO `visit_log` VALUES (4446, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/add', '2026-08-10 18:01:39');
INSERT INTO `visit_log` VALUES (4447, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/add', '2026-08-10 18:01:40');
INSERT INTO `visit_log` VALUES (4448, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/cart/list', '2026-08-10 18:01:42');
INSERT INTO `visit_log` VALUES (4449, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 10:51:59');
INSERT INTO `visit_log` VALUES (4450, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 10:51:59');
INSERT INTO `visit_log` VALUES (4451, 1, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/admin/page', '2026-08-11 10:58:10');
INSERT INTO `visit_log` VALUES (4452, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 11:05:07');
INSERT INTO `visit_log` VALUES (4453, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 11:05:07');
INSERT INTO `visit_log` VALUES (4454, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/16/all', '2026-08-11 11:05:10');
INSERT INTO `visit_log` VALUES (4455, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16/images', '2026-08-11 11:05:10');
INSERT INTO `visit_log` VALUES (4456, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:05:10');
INSERT INTO `visit_log` VALUES (4457, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16', '2026-08-11 11:05:10');
INSERT INTO `visit_log` VALUES (4458, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 11:05:16');
INSERT INTO `visit_log` VALUES (4459, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 11:05:16');
INSERT INTO `visit_log` VALUES (4460, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:05:22');
INSERT INTO `visit_log` VALUES (4461, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/14/all', '2026-08-11 11:05:23');
INSERT INTO `visit_log` VALUES (4462, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/14/images', '2026-08-11 11:05:23');
INSERT INTO `visit_log` VALUES (4463, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/14', '2026-08-11 11:05:23');
INSERT INTO `visit_log` VALUES (4464, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/history', '2026-08-11 11:05:39');
INSERT INTO `visit_log` VALUES (4465, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/14/images', '2026-08-11 11:05:39');
INSERT INTO `visit_log` VALUES (4466, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/14', '2026-08-11 11:05:39');
INSERT INTO `visit_log` VALUES (4467, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/comments/product/14/all', '2026-08-11 11:05:39');
INSERT INTO `visit_log` VALUES (4468, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/14', '2026-08-11 11:07:04');
INSERT INTO `visit_log` VALUES (4469, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/14/images', '2026-08-11 11:07:04');
INSERT INTO `visit_log` VALUES (4470, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/comments/product/14/all', '2026-08-11 11:07:04');
INSERT INTO `visit_log` VALUES (4471, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/history', '2026-08-11 11:07:04');
INSERT INTO `visit_log` VALUES (4472, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/14', '2026-08-11 11:07:40');
INSERT INTO `visit_log` VALUES (4473, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/14/images', '2026-08-11 11:07:40');
INSERT INTO `visit_log` VALUES (4474, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/history', '2026-08-11 11:07:40');
INSERT INTO `visit_log` VALUES (4475, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/comments/product/14/all', '2026-08-11 11:07:40');
INSERT INTO `visit_log` VALUES (4476, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/comments/product/14/all', '2026-08-11 11:09:27');
INSERT INTO `visit_log` VALUES (4477, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/history', '2026-08-11 11:09:27');
INSERT INTO `visit_log` VALUES (4478, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/14', '2026-08-11 11:09:27');
INSERT INTO `visit_log` VALUES (4479, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/14/images', '2026-08-11 11:09:27');
INSERT INTO `visit_log` VALUES (4480, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/14/images', '2026-08-11 11:10:34');
INSERT INTO `visit_log` VALUES (4481, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/14', '2026-08-11 11:10:34');
INSERT INTO `visit_log` VALUES (4482, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/comments/product/14/all', '2026-08-11 11:10:34');
INSERT INTO `visit_log` VALUES (4483, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/history', '2026-08-11 11:10:34');
INSERT INTO `visit_log` VALUES (4484, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:11:06');
INSERT INTO `visit_log` VALUES (4485, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/14', '2026-08-11 11:11:07');
INSERT INTO `visit_log` VALUES (4486, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/14/images', '2026-08-11 11:11:07');
INSERT INTO `visit_log` VALUES (4487, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/14/all', '2026-08-11 11:11:07');
INSERT INTO `visit_log` VALUES (4488, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:11:28');
INSERT INTO `visit_log` VALUES (4489, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 11:12:40');
INSERT INTO `visit_log` VALUES (4490, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 11:12:40');
INSERT INTO `visit_log` VALUES (4491, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 11:12:47');
INSERT INTO `visit_log` VALUES (4492, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 11:12:47');
INSERT INTO `visit_log` VALUES (4493, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 11:12:51');
INSERT INTO `visit_log` VALUES (4494, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:12:54');
INSERT INTO `visit_log` VALUES (4495, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:12:54');
INSERT INTO `visit_log` VALUES (4496, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:12:54');
INSERT INTO `visit_log` VALUES (4497, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:12:54');
INSERT INTO `visit_log` VALUES (4498, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/2', '2026-08-11 11:13:37');
INSERT INTO `visit_log` VALUES (4499, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/2/images', '2026-08-11 11:13:37');
INSERT INTO `visit_log` VALUES (4500, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/history', '2026-08-11 11:13:37');
INSERT INTO `visit_log` VALUES (4501, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/comments/product/2/all', '2026-08-11 11:13:37');
INSERT INTO `visit_log` VALUES (4502, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 11:14:31');
INSERT INTO `visit_log` VALUES (4503, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 11:14:32');
INSERT INTO `visit_log` VALUES (4504, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:14:33');
INSERT INTO `visit_log` VALUES (4505, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/14', '2026-08-11 11:14:33');
INSERT INTO `visit_log` VALUES (4506, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/14/images', '2026-08-11 11:14:33');
INSERT INTO `visit_log` VALUES (4507, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/14/all', '2026-08-11 11:14:33');
INSERT INTO `visit_log` VALUES (4508, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/14/all', '2026-08-11 11:18:34');
INSERT INTO `visit_log` VALUES (4509, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/14/images', '2026-08-11 11:18:34');
INSERT INTO `visit_log` VALUES (4510, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/14', '2026-08-11 11:18:34');
INSERT INTO `visit_log` VALUES (4511, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:18:34');
INSERT INTO `visit_log` VALUES (4512, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 11:22:19');
INSERT INTO `visit_log` VALUES (4513, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 11:22:19');
INSERT INTO `visit_log` VALUES (4514, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 11:22:21');
INSERT INTO `visit_log` VALUES (4515, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:22:23');
INSERT INTO `visit_log` VALUES (4516, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:22:23');
INSERT INTO `visit_log` VALUES (4517, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:22:23');
INSERT INTO `visit_log` VALUES (4518, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:22:23');
INSERT INTO `visit_log` VALUES (4519, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:24:16');
INSERT INTO `visit_log` VALUES (4520, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:24:16');
INSERT INTO `visit_log` VALUES (4521, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:24:16');
INSERT INTO `visit_log` VALUES (4522, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:24:16');
INSERT INTO `visit_log` VALUES (4523, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:24:42');
INSERT INTO `visit_log` VALUES (4524, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:24:42');
INSERT INTO `visit_log` VALUES (4525, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:24:42');
INSERT INTO `visit_log` VALUES (4526, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:24:42');
INSERT INTO `visit_log` VALUES (4527, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:24:50');
INSERT INTO `visit_log` VALUES (4528, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:25:13');
INSERT INTO `visit_log` VALUES (4529, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:25:21');
INSERT INTO `visit_log` VALUES (4530, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/8', '2026-08-11 11:25:50');
INSERT INTO `visit_log` VALUES (4531, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:26:25');
INSERT INTO `visit_log` VALUES (4532, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 11:27:12');
INSERT INTO `visit_log` VALUES (4533, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 11:27:12');
INSERT INTO `visit_log` VALUES (4534, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 11:27:15');
INSERT INTO `visit_log` VALUES (4535, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:27:17');
INSERT INTO `visit_log` VALUES (4536, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:27:17');
INSERT INTO `visit_log` VALUES (4537, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:27:17');
INSERT INTO `visit_log` VALUES (4538, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:27:17');
INSERT INTO `visit_log` VALUES (4539, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:27:25');
INSERT INTO `visit_log` VALUES (4540, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:27:26');
INSERT INTO `visit_log` VALUES (4541, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:27:31');
INSERT INTO `visit_log` VALUES (4542, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:27:31');
INSERT INTO `visit_log` VALUES (4543, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:27:31');
INSERT INTO `visit_log` VALUES (4544, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:27:31');
INSERT INTO `visit_log` VALUES (4545, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:27:51');
INSERT INTO `visit_log` VALUES (4546, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:27:51');
INSERT INTO `visit_log` VALUES (4547, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:27:51');
INSERT INTO `visit_log` VALUES (4548, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:27:51');
INSERT INTO `visit_log` VALUES (4549, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:28:01');
INSERT INTO `visit_log` VALUES (4550, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:28:02');
INSERT INTO `visit_log` VALUES (4551, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:28:09');
INSERT INTO `visit_log` VALUES (4552, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:28:09');
INSERT INTO `visit_log` VALUES (4553, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:28:09');
INSERT INTO `visit_log` VALUES (4554, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:28:09');
INSERT INTO `visit_log` VALUES (4555, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:37:58');
INSERT INTO `visit_log` VALUES (4556, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:37:58');
INSERT INTO `visit_log` VALUES (4557, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:37:58');
INSERT INTO `visit_log` VALUES (4558, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:37:58');
INSERT INTO `visit_log` VALUES (4559, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:40:50');
INSERT INTO `visit_log` VALUES (4560, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:40:50');
INSERT INTO `visit_log` VALUES (4561, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:40:50');
INSERT INTO `visit_log` VALUES (4562, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:40:50');
INSERT INTO `visit_log` VALUES (4563, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:40:54');
INSERT INTO `visit_log` VALUES (4564, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:41:22');
INSERT INTO `visit_log` VALUES (4565, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:41:22');
INSERT INTO `visit_log` VALUES (4566, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:41:22');
INSERT INTO `visit_log` VALUES (4567, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:41:22');
INSERT INTO `visit_log` VALUES (4568, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:41:27');
INSERT INTO `visit_log` VALUES (4569, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:41:28');
INSERT INTO `visit_log` VALUES (4570, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/pay/74', '2026-08-11 11:41:35');
INSERT INTO `visit_log` VALUES (4571, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:41:35');
INSERT INTO `visit_log` VALUES (4572, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:41:40');
INSERT INTO `visit_log` VALUES (4573, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:41:40');
INSERT INTO `visit_log` VALUES (4574, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:41:40');
INSERT INTO `visit_log` VALUES (4575, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:41:40');
INSERT INTO `visit_log` VALUES (4576, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:42:09');
INSERT INTO `visit_log` VALUES (4577, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:42:09');
INSERT INTO `visit_log` VALUES (4578, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:42:09');
INSERT INTO `visit_log` VALUES (4579, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:42:09');
INSERT INTO `visit_log` VALUES (4580, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:42:18');
INSERT INTO `visit_log` VALUES (4581, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/pay/73', '2026-08-11 11:42:20');
INSERT INTO `visit_log` VALUES (4582, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:42:20');
INSERT INTO `visit_log` VALUES (4583, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:42:30');
INSERT INTO `visit_log` VALUES (4584, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:42:30');
INSERT INTO `visit_log` VALUES (4585, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:42:30');
INSERT INTO `visit_log` VALUES (4586, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:42:30');
INSERT INTO `visit_log` VALUES (4587, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:42:38');
INSERT INTO `visit_log` VALUES (4588, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:43:04');
INSERT INTO `visit_log` VALUES (4589, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:43:04');
INSERT INTO `visit_log` VALUES (4590, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:43:04');
INSERT INTO `visit_log` VALUES (4591, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:43:04');
INSERT INTO `visit_log` VALUES (4592, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:43:08');
INSERT INTO `visit_log` VALUES (4593, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:43:09');
INSERT INTO `visit_log` VALUES (4594, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:43:11');
INSERT INTO `visit_log` VALUES (4595, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:43:11');
INSERT INTO `visit_log` VALUES (4596, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:43:11');
INSERT INTO `visit_log` VALUES (4597, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:43:11');
INSERT INTO `visit_log` VALUES (4598, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:43:16');
INSERT INTO `visit_log` VALUES (4599, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/pay/75', '2026-08-11 11:43:20');
INSERT INTO `visit_log` VALUES (4600, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:43:20');
INSERT INTO `visit_log` VALUES (4601, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:43:22');
INSERT INTO `visit_log` VALUES (4602, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:43:23');
INSERT INTO `visit_log` VALUES (4603, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:43:23');
INSERT INTO `visit_log` VALUES (4604, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:43:23');
INSERT INTO `visit_log` VALUES (4605, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:45:54');
INSERT INTO `visit_log` VALUES (4606, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:45:55');
INSERT INTO `visit_log` VALUES (4607, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:46:04');
INSERT INTO `visit_log` VALUES (4608, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:46:04');
INSERT INTO `visit_log` VALUES (4609, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:46:04');
INSERT INTO `visit_log` VALUES (4610, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:46:04');
INSERT INTO `visit_log` VALUES (4611, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:46:11');
INSERT INTO `visit_log` VALUES (4612, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/cancel/76', '2026-08-11 11:46:13');
INSERT INTO `visit_log` VALUES (4613, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:46:13');
INSERT INTO `visit_log` VALUES (4614, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:46:16');
INSERT INTO `visit_log` VALUES (4615, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:46:16');
INSERT INTO `visit_log` VALUES (4616, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:46:16');
INSERT INTO `visit_log` VALUES (4617, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:46:16');
INSERT INTO `visit_log` VALUES (4618, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:54:26');
INSERT INTO `visit_log` VALUES (4619, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:54:26');
INSERT INTO `visit_log` VALUES (4620, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:54:26');
INSERT INTO `visit_log` VALUES (4621, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:54:26');
INSERT INTO `visit_log` VALUES (4622, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:54:51');
INSERT INTO `visit_log` VALUES (4623, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 11:56:53');
INSERT INTO `visit_log` VALUES (4624, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 11:56:53');
INSERT INTO `visit_log` VALUES (4625, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 11:56:55');
INSERT INTO `visit_log` VALUES (4626, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:56:57');
INSERT INTO `visit_log` VALUES (4627, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:56:57');
INSERT INTO `visit_log` VALUES (4628, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:56:57');
INSERT INTO `visit_log` VALUES (4629, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:56:57');
INSERT INTO `visit_log` VALUES (4630, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:57:00');
INSERT INTO `visit_log` VALUES (4631, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:57:01');
INSERT INTO `visit_log` VALUES (4632, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:57:07');
INSERT INTO `visit_log` VALUES (4633, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:57:07');
INSERT INTO `visit_log` VALUES (4634, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:57:07');
INSERT INTO `visit_log` VALUES (4635, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:57:07');
INSERT INTO `visit_log` VALUES (4636, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:57:14');
INSERT INTO `visit_log` VALUES (4637, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/pay/77', '2026-08-11 11:57:19');
INSERT INTO `visit_log` VALUES (4638, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:57:19');
INSERT INTO `visit_log` VALUES (4639, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:57:21');
INSERT INTO `visit_log` VALUES (4640, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:57:21');
INSERT INTO `visit_log` VALUES (4641, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:57:21');
INSERT INTO `visit_log` VALUES (4642, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:57:21');
INSERT INTO `visit_log` VALUES (4643, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:58:09');
INSERT INTO `visit_log` VALUES (4644, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:58:10');
INSERT INTO `visit_log` VALUES (4645, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:58:10');
INSERT INTO `visit_log` VALUES (4646, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:58:10');
INSERT INTO `visit_log` VALUES (4647, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:58:14');
INSERT INTO `visit_log` VALUES (4648, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 11:58:27');
INSERT INTO `visit_log` VALUES (4649, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:58:30');
INSERT INTO `visit_log` VALUES (4650, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:58:54');
INSERT INTO `visit_log` VALUES (4651, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 11:58:57');
INSERT INTO `visit_log` VALUES (4652, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 11:58:57');
INSERT INTO `visit_log` VALUES (4653, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 11:58:57');
INSERT INTO `visit_log` VALUES (4654, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 11:58:57');
INSERT INTO `visit_log` VALUES (4655, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:59:02');
INSERT INTO `visit_log` VALUES (4656, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:59:09');
INSERT INTO `visit_log` VALUES (4657, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:59:17');
INSERT INTO `visit_log` VALUES (4658, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:59:25');
INSERT INTO `visit_log` VALUES (4659, 7, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 11:59:34');
INSERT INTO `visit_log` VALUES (4660, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 12:00:06');
INSERT INTO `visit_log` VALUES (4661, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 12:00:06');
INSERT INTO `visit_log` VALUES (4662, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 12:00:06');
INSERT INTO `visit_log` VALUES (4663, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 12:00:06');
INSERT INTO `visit_log` VALUES (4664, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 12:00:24');
INSERT INTO `visit_log` VALUES (4665, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 12:00:24');
INSERT INTO `visit_log` VALUES (4666, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 12:00:24');
INSERT INTO `visit_log` VALUES (4667, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 12:00:24');
INSERT INTO `visit_log` VALUES (4668, 2, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 12:00:28');
INSERT INTO `visit_log` VALUES (4669, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 14:39:10');
INSERT INTO `visit_log` VALUES (4670, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 14:39:10');
INSERT INTO `visit_log` VALUES (4671, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 14:39:28');
INSERT INTO `visit_log` VALUES (4672, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 14:39:28');
INSERT INTO `visit_log` VALUES (4673, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16', '2026-08-11 14:39:41');
INSERT INTO `visit_log` VALUES (4674, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 14:40:42');
INSERT INTO `visit_log` VALUES (4675, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 14:40:42');
INSERT INTO `visit_log` VALUES (4676, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16/images', '2026-08-11 14:40:46');
INSERT INTO `visit_log` VALUES (4677, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/16/all', '2026-08-11 14:40:46');
INSERT INTO `visit_log` VALUES (4678, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16', '2026-08-11 14:40:46');
INSERT INTO `visit_log` VALUES (4679, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 14:40:46');
INSERT INTO `visit_log` VALUES (4680, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 14:40:50');
INSERT INTO `visit_log` VALUES (4681, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 14:40:51');
INSERT INTO `visit_log` VALUES (4682, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16/images', '2026-08-11 14:40:54');
INSERT INTO `visit_log` VALUES (4683, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/16/all', '2026-08-11 14:40:54');
INSERT INTO `visit_log` VALUES (4684, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 14:40:54');
INSERT INTO `visit_log` VALUES (4685, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16', '2026-08-11 14:40:54');
INSERT INTO `visit_log` VALUES (4686, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 14:41:00');
INSERT INTO `visit_log` VALUES (4687, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/pay/78', '2026-08-11 14:41:06');
INSERT INTO `visit_log` VALUES (4688, 8, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 14:41:06');
INSERT INTO `visit_log` VALUES (4689, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 14:41:33');
INSERT INTO `visit_log` VALUES (4690, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 14:41:38');
INSERT INTO `visit_log` VALUES (4691, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 14:41:39');
INSERT INTO `visit_log` VALUES (4692, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/16/all', '2026-08-11 14:41:40');
INSERT INTO `visit_log` VALUES (4693, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16', '2026-08-11 14:41:40');
INSERT INTO `visit_log` VALUES (4694, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 14:41:40');
INSERT INTO `visit_log` VALUES (4695, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16/images', '2026-08-11 14:41:40');
INSERT INTO `visit_log` VALUES (4696, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 14:41:47');
INSERT INTO `visit_log` VALUES (4697, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 14:41:48');
INSERT INTO `visit_log` VALUES (4698, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16', '2026-08-11 14:41:52');
INSERT INTO `visit_log` VALUES (4699, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 14:41:52');
INSERT INTO `visit_log` VALUES (4700, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16/images', '2026-08-11 14:41:52');
INSERT INTO `visit_log` VALUES (4701, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/16/all', '2026-08-11 14:41:52');
INSERT INTO `visit_log` VALUES (4702, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 14:41:57');
INSERT INTO `visit_log` VALUES (4703, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/pay/79', '2026-08-11 14:42:01');
INSERT INTO `visit_log` VALUES (4704, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 14:42:02');
INSERT INTO `visit_log` VALUES (4705, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 14:42:07');
INSERT INTO `visit_log` VALUES (4706, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16', '2026-08-11 14:42:07');
INSERT INTO `visit_log` VALUES (4707, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16/images', '2026-08-11 14:42:07');
INSERT INTO `visit_log` VALUES (4708, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/16/all', '2026-08-11 14:42:07');
INSERT INTO `visit_log` VALUES (4709, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 14:42:13');
INSERT INTO `visit_log` VALUES (4710, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 14:42:13');
INSERT INTO `visit_log` VALUES (4711, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 14:42:19');
INSERT INTO `visit_log` VALUES (4712, 6, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 14:42:19');
INSERT INTO `visit_log` VALUES (4713, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 14:42:34');
INSERT INTO `visit_log` VALUES (4714, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 14:42:34');
INSERT INTO `visit_log` VALUES (4715, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 15:21:11');
INSERT INTO `visit_log` VALUES (4716, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 15:21:11');
INSERT INTO `visit_log` VALUES (4717, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/9', '2026-08-11 15:21:13');
INSERT INTO `visit_log` VALUES (4718, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/9/images', '2026-08-11 15:21:13');
INSERT INTO `visit_log` VALUES (4719, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/9/all', '2026-08-11 15:21:13');
INSERT INTO `visit_log` VALUES (4720, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 15:21:13');
INSERT INTO `visit_log` VALUES (4721, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 15:24:37');
INSERT INTO `visit_log` VALUES (4722, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 15:24:37');
INSERT INTO `visit_log` VALUES (4723, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 15:24:40');
INSERT INTO `visit_log` VALUES (4724, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16/images', '2026-08-11 15:24:40');
INSERT INTO `visit_log` VALUES (4725, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/16/all', '2026-08-11 15:24:40');
INSERT INTO `visit_log` VALUES (4726, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16', '2026-08-11 15:24:40');
INSERT INTO `visit_log` VALUES (4727, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/merchant/5', '2026-08-11 15:24:42');
INSERT INTO `visit_log` VALUES (4728, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 15:24:46');
INSERT INTO `visit_log` VALUES (4729, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16', '2026-08-11 15:24:46');
INSERT INTO `visit_log` VALUES (4730, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16/images', '2026-08-11 15:24:46');
INSERT INTO `visit_log` VALUES (4731, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/16/all', '2026-08-11 15:24:46');
INSERT INTO `visit_log` VALUES (4732, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 15:27:11');
INSERT INTO `visit_log` VALUES (4733, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 15:27:11');
INSERT INTO `visit_log` VALUES (4734, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 15:27:13');
INSERT INTO `visit_log` VALUES (4735, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12', '2026-08-11 15:27:13');
INSERT INTO `visit_log` VALUES (4736, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12/images', '2026-08-11 15:27:13');
INSERT INTO `visit_log` VALUES (4737, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/12/all', '2026-08-11 15:27:13');
INSERT INTO `visit_log` VALUES (4738, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 15:27:35');
INSERT INTO `visit_log` VALUES (4739, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12', '2026-08-11 15:27:35');
INSERT INTO `visit_log` VALUES (4740, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12/images', '2026-08-11 15:27:35');
INSERT INTO `visit_log` VALUES (4741, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/12/all', '2026-08-11 15:27:35');
INSERT INTO `visit_log` VALUES (4742, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 15:27:50');
INSERT INTO `visit_log` VALUES (4743, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/12/all', '2026-08-11 15:27:50');
INSERT INTO `visit_log` VALUES (4744, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12/images', '2026-08-11 15:27:50');
INSERT INTO `visit_log` VALUES (4745, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12', '2026-08-11 15:27:50');
INSERT INTO `visit_log` VALUES (4746, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/12/all', '2026-08-11 15:28:18');
INSERT INTO `visit_log` VALUES (4747, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12', '2026-08-11 15:28:18');
INSERT INTO `visit_log` VALUES (4748, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12/images', '2026-08-11 15:28:18');
INSERT INTO `visit_log` VALUES (4749, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 15:28:18');
INSERT INTO `visit_log` VALUES (4750, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12/images', '2026-08-11 15:36:50');
INSERT INTO `visit_log` VALUES (4751, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12', '2026-08-11 15:36:50');
INSERT INTO `visit_log` VALUES (4752, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 15:36:50');
INSERT INTO `visit_log` VALUES (4753, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/12/all', '2026-08-11 15:36:51');
INSERT INTO `visit_log` VALUES (4754, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12', '2026-08-11 15:37:08');
INSERT INTO `visit_log` VALUES (4755, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 15:37:08');
INSERT INTO `visit_log` VALUES (4756, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12/images', '2026-08-11 15:37:09');
INSERT INTO `visit_log` VALUES (4757, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/12/all', '2026-08-11 15:37:09');
INSERT INTO `visit_log` VALUES (4758, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12', '2026-08-11 15:37:12');
INSERT INTO `visit_log` VALUES (4759, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/12/images', '2026-08-11 15:37:12');
INSERT INTO `visit_log` VALUES (4760, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 15:37:12');
INSERT INTO `visit_log` VALUES (4761, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/12/all', '2026-08-11 15:37:12');
INSERT INTO `visit_log` VALUES (4762, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 15:41:22');
INSERT INTO `visit_log` VALUES (4763, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 15:41:22');
INSERT INTO `visit_log` VALUES (4764, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15/images', '2026-08-11 15:43:39');
INSERT INTO `visit_log` VALUES (4765, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15', '2026-08-11 15:43:39');
INSERT INTO `visit_log` VALUES (4766, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/15/all', '2026-08-11 15:43:40');
INSERT INTO `visit_log` VALUES (4767, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/15', '2026-08-11 15:43:49');
INSERT INTO `visit_log` VALUES (4768, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/product/15/images', '2026-08-11 15:43:49');
INSERT INTO `visit_log` VALUES (4769, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '/api/comments/product/15/all', '2026-08-11 15:43:49');
INSERT INTO `visit_log` VALUES (4770, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 15:44:27');
INSERT INTO `visit_log` VALUES (4771, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15/images', '2026-08-11 15:44:27');
INSERT INTO `visit_log` VALUES (4772, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/15', '2026-08-11 15:44:27');
INSERT INTO `visit_log` VALUES (4773, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/15/all', '2026-08-11 15:44:27');
INSERT INTO `visit_log` VALUES (4774, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 15:44:30');
INSERT INTO `visit_log` VALUES (4775, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 15:44:30');
INSERT INTO `visit_log` VALUES (4776, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13', '2026-08-11 15:44:31');
INSERT INTO `visit_log` VALUES (4777, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/13/images', '2026-08-11 15:44:31');
INSERT INTO `visit_log` VALUES (4778, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 15:44:31');
INSERT INTO `visit_log` VALUES (4779, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/13/all', '2026-08-11 15:44:32');
INSERT INTO `visit_log` VALUES (4780, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 15:44:34');
INSERT INTO `visit_log` VALUES (4781, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 15:44:35');
INSERT INTO `visit_log` VALUES (4782, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 15:44:37');
INSERT INTO `visit_log` VALUES (4783, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/10/images', '2026-08-11 15:44:37');
INSERT INTO `visit_log` VALUES (4784, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/10', '2026-08-11 15:44:37');
INSERT INTO `visit_log` VALUES (4785, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/10/all', '2026-08-11 15:44:37');
INSERT INTO `visit_log` VALUES (4786, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 15:46:31');
INSERT INTO `visit_log` VALUES (4787, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 15:46:33');
INSERT INTO `visit_log` VALUES (4788, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 15:46:39');
INSERT INTO `visit_log` VALUES (4789, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/address/list', '2026-08-11 15:46:41');
INSERT INTO `visit_log` VALUES (4790, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 15:46:45');
INSERT INTO `visit_log` VALUES (4791, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/user/page', '2026-08-11 15:46:46');
INSERT INTO `visit_log` VALUES (4792, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2/images', '2026-08-11 15:46:53');
INSERT INTO `visit_log` VALUES (4793, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/history', '2026-08-11 15:46:53');
INSERT INTO `visit_log` VALUES (4794, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/2', '2026-08-11 15:46:53');
INSERT INTO `visit_log` VALUES (4795, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/2/all', '2026-08-11 15:46:54');
INSERT INTO `visit_log` VALUES (4796, 5, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/order/72', '2026-08-11 15:46:58');
INSERT INTO `visit_log` VALUES (4797, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/es/search', '2026-08-11 15:47:24');
INSERT INTO `visit_log` VALUES (4798, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/hot', '2026-08-11 15:47:24');
INSERT INTO `visit_log` VALUES (4799, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16/images', '2026-08-11 15:47:48');
INSERT INTO `visit_log` VALUES (4800, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/product/16', '2026-08-11 15:47:48');
INSERT INTO `visit_log` VALUES (4801, NULL, '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '/api/comments/product/16/all', '2026-08-11 15:47:49');

SET FOREIGN_KEY_CHECKS = 1;
