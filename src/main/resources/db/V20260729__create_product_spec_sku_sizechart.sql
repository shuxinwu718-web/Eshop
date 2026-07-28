-- 商品规格模板表
CREATE TABLE IF NOT EXISTS `product_spec` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `product_id` BIGINT NOT NULL COMMENT '商品ID',
    `spec_name` VARCHAR(50) NOT NULL COMMENT '规格名，如"颜色""尺码"',
    `spec_values` TEXT COMMENT '规格值JSON数组，如["黑色","白色"]',
    `sort_order` INT DEFAULT 0 COMMENT '排序号',
    KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品规格模板';

-- 商品SKU表
CREATE TABLE IF NOT EXISTS `product_sku` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `product_id` BIGINT NOT NULL COMMENT '商品ID',
    `specs` TEXT COMMENT '规格组合JSON，如{"颜色":"黑色","尺码":"41"}',
    `price` DECIMAL(10,2) NOT NULL COMMENT 'SKU价格',
    `stock` INT NOT NULL DEFAULT 0 COMMENT 'SKU库存',
    `sku_code` VARCHAR(100) DEFAULT NULL COMMENT 'SKU编码',
    `image` VARCHAR(500) DEFAULT NULL COMMENT 'SKU图片',
    `sales` INT DEFAULT 0 COMMENT '销量',
    KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品SKU';

-- 商品尺寸表
CREATE TABLE IF NOT EXISTS `product_size_chart` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `product_id` BIGINT NOT NULL COMMENT '商品ID',
    `chart_title` VARCHAR(100) DEFAULT '尺寸表' COMMENT '尺寸表标题',
    `columns_json` TEXT COMMENT '列头JSON数组',
    `rows_json` TEXT COMMENT '行数据JSON二维数组',
    KEY `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品尺寸表';

-- 购物车添加SKU支持
ALTER TABLE `cart` ADD COLUMN IF NOT EXISTS `sku_id` BIGINT DEFAULT NULL COMMENT '选中SKU ID' AFTER `product_id`;
ALTER TABLE `cart` ADD COLUMN IF NOT EXISTS `sku_specs` VARCHAR(200) DEFAULT NULL COMMENT 'SKU规格描述' AFTER `sku_id`;