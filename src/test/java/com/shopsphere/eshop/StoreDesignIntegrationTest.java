package com.shopsphere.eshop;

import com.shopsphere.eshop.controller.MerchantController;
import com.shopsphere.eshop.controller.StoreController;
import com.shopsphere.eshop.dto.StoreDesignDTO;
import com.shopsphere.eshop.entity.StoreDesign;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.StoreDesignMapper;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 店铺主页装修模块集成测试
 * <p>
 * 覆盖：
 * - 商家保存草稿（公告 + 楼层 JSON 落库）
 * - 发布草稿（layout = draftLayout，草稿清空）
 * - 公开店铺信息（GET /api/merchant/{id}/store 返回公告与已发布楼层）
 * - 首页推荐店铺（GET /api/merchant/recommend 包含在售商家）
 * - 异常分支：无草稿发布 / 店铺设计不存在
 * 说明：测试数据带唯一标记，用例结束后物理清理，不影响开发库。
 */
@SpringBootTest
class StoreDesignIntegrationTest {

    @Autowired private MerchantController merchantController;
    @Autowired private StoreController storeController;
    @Autowired private StoreDesignMapper storeDesignMapper;
    @Autowired private JdbcTemplate jdbcTemplate;

    private final String marker = "SD" + UUID.randomUUID().toString().substring(0, 8);
    private final String draftJson = "[{\"type\":\"banner\",\"title\":\"测试横幅\",\"items\":[{\"image\":\"http://x/banner.jpg\",\"link\":\"\"}]},"
            + "{\"type\":\"notice\",\"title\":\"店铺公告\"},"
            + "{\"type\":\"goods\",\"title\":\"精选好物\",\"mode\":\"default\",\"count\":4,\"columns\":2}]";

    private Long merchantId;

    @AfterEach
    void cleanup() {
        if (merchantId != null) {
            jdbcTemplate.update("DELETE FROM product WHERE merchant_id = ? AND name LIKE 'TEST%'", merchantId);
            jdbcTemplate.update("DELETE FROM store_design WHERE merchant_id = ?", merchantId);
            jdbcTemplate.update("DELETE FROM user WHERE id = ? AND username LIKE 'test_sd_%'", merchantId);
        }
    }

    /** 新建带唯一标记的测试商家（返回 merchantId） */
    private Long insertMerchant() {
        String username = "test_sd_" + marker.toLowerCase();
        jdbcTemplate.update(
                "INSERT INTO user (username, nickname, password, role, status, deleted) VALUES (?, ?, ?, 'MERCHANT', 0, 0)",
                username, "测试小店" + marker, "test-pwd");
        return jdbcTemplate.queryForObject("SELECT id FROM user WHERE username = ?", Long.class, username);
    }

    /** 为测试商家插入一件在售商品（使其进入推荐店铺统计） */
    private void insertOnSaleProduct(Long merchantId) {
        Long categoryId = jdbcTemplate.queryForObject("SELECT id FROM category ORDER BY id LIMIT 1", Long.class);
        jdbcTemplate.update(
                "INSERT INTO product (merchant_id, name, category_id, price, stock, status, sales, deleted) "
                        + "VALUES (?, ?, ?, ?, ?, 1, 5, 0)",
                merchantId, "TEST商品-" + marker, categoryId, new BigDecimal("99.00"), 100);
    }

    private StoreDesign queryDesign() {
        return storeDesignMapper.selectOne(new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<StoreDesign>()
                .eq(StoreDesign::getMerchantId, merchantId));
    }

    @Test
    void storeDesignFullFlow() {
        merchantId = insertMerchant();
        insertOnSaleProduct(merchantId);

        // 1. 保存草稿：公告 + 楼层 JSON 落库
        StoreDesignDTO dto = new StoreDesignDTO();
        dto.setBackgroundColor("#667eea");
        dto.setBannerUrl("http://x/avatar.png");
        dto.setAnnouncement("本店新品上架，欢迎选购！" + marker);
        dto.setDraftLayout(draftJson);
        merchantController.updateStoreDesign(dto, merchantId);

        StoreDesign saved = queryDesign();
        assertNotNull(saved, "保存草稿后应存在店铺设计记录");
        assertEquals(dto.getAnnouncement(), saved.getAnnouncement(), "公告应保存即生效");
        assertEquals(draftJson, saved.getDraftLayout(), "楼层草稿应落库");
        assertNull(saved.getLayout(), "未发布前 layout 应为空");

        // 2. 公开店铺信息：未发布前返回公告但无楼层
        Map<String, Object> infoBefore = storeController.getStoreInfo(merchantId).getData();
        assertEquals("测试小店" + marker, infoBefore.get("shopName"));
        assertEquals(dto.getAnnouncement(), infoBefore.get("announcement"));
        assertNull(infoBefore.get("layout"), "未发布前公开信息不应包含楼层");

        // 3. 发布草稿：layout 生效、草稿清空
        merchantController.publishStoreDesign(merchantId);
        StoreDesign published = queryDesign();
        assertEquals(draftJson, published.getLayout(), "发布后 layout 应等于草稿内容");
        assertNull(published.getDraftLayout(), "发布后草稿应清空");

        // 4. 公开店铺信息：发布后返回楼层
        Map<String, Object> infoAfter = storeController.getStoreInfo(merchantId).getData();
        assertEquals(draftJson, infoAfter.get("layout"), "发布后公开信息应包含楼层配置");

        // 5. 重复发布 → 拒绝（无待发布草稿）
        BusinessException dup = assertThrows(BusinessException.class,
                () -> merchantController.publishStoreDesign(merchantId));
        assertTrue(dup.getMessage().contains("暂无待发布的草稿"), "重复发布提示不符: " + dup.getMessage());

        // 6. 首页推荐店铺应包含该在售商家
        List<Map<String, Object>> recommend = storeController.getRecommendStores(20).getData();
        boolean found = recommend.stream().anyMatch(item -> merchantId.equals(item.get("merchantId")));
        assertTrue(found, "推荐店铺列表应包含测试商家");
    }

    @Test
    void publishWithoutDesignFails() {
        merchantId = insertMerchant();
        // 未保存过设计直接发布 → 拒绝
        BusinessException ex = assertThrows(BusinessException.class,
                () -> merchantController.publishStoreDesign(merchantId));
        assertTrue(ex.getMessage().contains("店铺设计不存在"), "提示不符: " + ex.getMessage());
    }
}
