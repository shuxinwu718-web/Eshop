-- 商品表添加拼音搜索字段（全拼，空格分隔）
ALTER TABLE product ADD COLUMN name_pinyin VARCHAR(1000) DEFAULT '' COMMENT '商品名称全拼（空格分隔），用于拼音搜索' AFTER name;

-- 注意：已有商品的拼音数据需要通过Java应用批量生成。
-- 启动应用后，调用 POST /api/product/batch-update-pinyin 接口来填充已有数据的拼音。
