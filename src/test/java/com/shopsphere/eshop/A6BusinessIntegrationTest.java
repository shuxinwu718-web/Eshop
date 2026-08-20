package com.shopsphere.eshop;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.shopsphere.eshop.dto.OrderCreateDTO;
import com.shopsphere.eshop.entity.Coupon;
import com.shopsphere.eshop.entity.Order;
import com.shopsphere.eshop.entity.OrderItem;
import com.shopsphere.eshop.entity.OrderShipment;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.entity.User;
import com.shopsphere.eshop.entity.UserCoupon;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.CouponMapper;
import com.shopsphere.eshop.mapper.OrderItemMapper;
import com.shopsphere.eshop.mapper.OrderMapper;
import com.shopsphere.eshop.mapper.OrderShipmentMapper;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.mapper.UserCouponMapper;
import com.shopsphere.eshop.mapper.UserMapper;
import com.shopsphere.eshop.service.OrderService;
import com.shopsphere.eshop.service.UserCouponService;
import com.shopsphere.eshop.service.UserService;
import com.shopsphere.eshop.util.CouponCalculator;
import com.shopsphere.eshop.vo.UserVO;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * A6 业务规则集成测试（并发 / 越权 / 注销）
 *
 * 覆盖整改项：
 * - C1：并发下单不超卖（原子扣减库存）
 * - C2：并发领券不超发（原子扣减券库存）
 * - S3：用户 A 使用用户 B 的优惠券下单 → 拒绝
 * - S8：已注销（deleted=1）用户不出现在用户搜索结果中
 *
 * 说明：测试数据带唯一标记，用例结束后物理清理，不影响开发库。
 */
@SpringBootTest
class A6BusinessIntegrationTest {

    @Autowired private OrderService orderService;
    @Autowired private UserCouponService userCouponService;
    @Autowired private UserService userService;
    @Autowired private ProductMapper productMapper;
    @Autowired private CouponMapper couponMapper;
    @Autowired private UserCouponMapper userCouponMapper;
    @Autowired private UserMapper userMapper;
    @Autowired private OrderMapper orderMapper;
    @Autowired private OrderItemMapper orderItemMapper;
    @Autowired private OrderShipmentMapper orderShipmentMapper;
    @Autowired private JdbcTemplate jdbcTemplate;

    private final String marker = "A6T" + UUID.randomUUID().toString().substring(0, 8);
    private final List<Long> createdOrderIds = new ArrayList<>();
    private final List<Long> createdCouponIds = new ArrayList<>();
    private final List<Long> createdProductIds = new ArrayList<>();
    private final List<Long> createdUserCouponIds = new ArrayList<>();
    private final List<Long> createdUserIds = new ArrayList<>();

    @AfterEach
    void cleanup() {
        // 通知（下单会向商家发「新订单通知」）
        if (!createdOrderIds.isEmpty()) {
            String in = joinIds(createdOrderIds);
            jdbcTemplate.update("DELETE FROM sys_notice WHERE biz_type = 'new_order' AND biz_id IN (" + in + ")");
            jdbcTemplate.update("DELETE FROM order_item WHERE order_id IN (" + in + ")");
            jdbcTemplate.update("DELETE FROM order_shipment WHERE order_id IN (" + in + ")");
            jdbcTemplate.update("DELETE FROM `order` WHERE id IN (" + in + ")");
        }
        createdOrderIds.forEach(id -> {});
        if (!createdProductIds.isEmpty()) {
            jdbcTemplate.update("DELETE FROM product WHERE id IN (" + joinIds(createdProductIds) + ")");
        }
        if (!createdUserCouponIds.isEmpty()) {
            jdbcTemplate.update("DELETE FROM user_coupon WHERE id IN (" + joinIds(createdUserCouponIds) + ")");
        }
        if (!createdCouponIds.isEmpty()) {
            jdbcTemplate.update("DELETE FROM coupon WHERE id IN (" + joinIds(createdCouponIds) + ")");
        }
        if (!createdUserIds.isEmpty()) {
            jdbcTemplate.update("DELETE FROM `user` WHERE id IN (" + joinIds(createdUserIds) + ")");
        }
    }

    private String joinIds(List<Long> ids) {
        return ids.stream().map(String::valueOf).reduce((a, b) -> a + "," + b).orElse("0");
    }

    /** 挑选一个普通买家用户（USER 角色，保证非商家） */
    private User pickBuyer() {
        List<User> users = userMapper.selectList(new LambdaQueryWrapper<User>()
                .eq(User::getRole, "USER")
                .eq(User::getDeleted, 0)
                .last("LIMIT 1"));
        assertTrue(!users.isEmpty(), "开发库缺少 USER 角色种子用户");
        return users.get(0);
    }

    /** 挑选一个与买家不同的用户作为商品商家 */
    private Long pickMerchantId(Long excludeUserId) {
        List<User> users = userMapper.selectList(new LambdaQueryWrapper<User>()
                .eq(User::getDeleted, 0)
                .ne(User::getId, excludeUserId)
                .last("LIMIT 1"));
        assertTrue(!users.isEmpty(), "开发库缺少可用商家种子用户");
        return users.get(0).getId();
    }

    private Product insertProduct(Long merchantId, int stock) {
        Product p = new Product();
        p.setMerchantId(merchantId);
        p.setName("A6测试商品-" + marker);
        p.setPrice(new BigDecimal("10.00"));
        p.setStock(stock);
        p.setStatus(1);
        p.setDeleted(0);
        productMapper.insert(p);
        createdProductIds.add(p.getId());
        return p;
    }

    private Coupon insertCoupon(int stock) {
        Coupon c = new Coupon();
        c.setName("A6测试券-" + marker);
        c.setType(0);
        c.setValue(new BigDecimal("5.00"));
        c.setMinAmount(new BigDecimal("0.00"));
        c.setStock(stock);
        c.setLimitPerUser(1000);
        c.setObtainType(0);
        c.setStartTime(LocalDateTime.now().minusDays(1));
        c.setEndTime(LocalDateTime.now().plusDays(1));
        c.setStatus(1);
        c.setDeleted(0);
        couponMapper.insert(c);
        createdCouponIds.add(c.getId());
        return c;
    }

    private OrderCreateDTO buildOrder(Product p, Long userCouponId) {
        OrderCreateDTO.OrderItemDTO item = new OrderCreateDTO.OrderItemDTO();
        item.setProductId(p.getId());
        item.setQuantity(1);
        OrderCreateDTO dto = new OrderCreateDTO();
        dto.setItems(List.of(item));
        dto.setReceiverName("A6测试");
        dto.setReceiverPhone("13800000000");
        dto.setReceiverAddress("测试地址");
        dto.setRemark(marker);
        dto.setUserCouponId(userCouponId);
        return dto;
    }

    // ==================== C1 并发下单不超卖 ====================

    @Test
    void concurrentOrderDoesNotOversell() throws Exception {
        User buyer = pickBuyer();
        Product p = insertProduct(pickMerchantId(buyer.getId()), 10);

        int threads = 20;
        AtomicInteger success = new AtomicInteger();
        CountDownLatch start = new CountDownLatch(1);
        ExecutorService pool = Executors.newFixedThreadPool(threads);
        try {
            List<Future<Boolean>> futures = new ArrayList<>();
            for (int i = 0; i < threads; i++) {
                futures.add(pool.submit(() -> {
                    start.await();
                    try {
                        Order order = orderService.createOrder(buildOrder(p, null), buyer.getId());
                        synchronized (createdOrderIds) {
                            createdOrderIds.add(order.getId());
                        }
                        return true;
                    } catch (Exception e) {
                        return false;
                    }
                }));
            }
            start.countDown();
            for (Future<Boolean> f : futures) {
                if (Boolean.TRUE.equals(f.get(60, TimeUnit.SECONDS))) {
                    success.incrementAndGet();
                }
            }
        } finally {
            pool.shutdownNow();
        }

        // 库存 10，并发 20 单，成功数必须 <= 10（不超卖）
        assertTrue(success.get() <= 10, "并发下单超卖: 成功 " + success.get() + " 单，库存仅 10");
        // 剩余库存精确等于 10 - 成功数
        Product after = productMapper.selectById(p.getId());
        assertEquals(10 - success.get(), after.getStock(),
                "库存扣减不精确: 成功 " + success.get() + " 单，剩余库存 " + after.getStock());
    }

    // ==================== C2 并发领券不超发 ====================

    @Test
    void concurrentCouponClaimDoesNotOverIssue() throws Exception {
        User buyer = pickBuyer();
        Coupon c = insertCoupon(5); // 券库存 5

        int threads = 20;
        AtomicInteger success = new AtomicInteger();
        CountDownLatch start = new CountDownLatch(1);
        ExecutorService pool = Executors.newFixedThreadPool(threads);
        try {
            List<Future<Boolean>> futures = new ArrayList<>();
            for (int i = 0; i < threads; i++) {
                futures.add(pool.submit(() -> {
                    start.await();
                    try {
                        userCouponService.receiveCoupon(buyer.getId(), c.getId());
                        return true;
                    } catch (Exception e) {
                        return false;
                    }
                }));
            }
            start.countDown();
            for (Future<Boolean> f : futures) {
                if (Boolean.TRUE.equals(f.get(60, TimeUnit.SECONDS))) {
                    success.incrementAndGet();
                }
            }
        } finally {
            pool.shutdownNow();
        }

        // 券库存 5，并发 20 次领取，成功数必须 <= 5（不超发）
        assertTrue(success.get() <= 5, "并发领券超发: 成功 " + success.get() + " 张，库存仅 5");
        long issued = userCouponMapper.selectCount(new LambdaQueryWrapper<UserCoupon>()
                .eq(UserCoupon::getCouponId, c.getId()));
        assertEquals(success.get(), issued, "发放记录数与成功数不一致");
    }

    // ==================== C3 用券下单金额与 CouponCalculator 一致 ====================

    @Test
    void couponOrderPayAmountMatchesCalculator() {
        User buyer = pickBuyer();
        Product p = insertProduct(pickMerchantId(buyer.getId()), 100);

        // 8.5 折券，最高优惠 50 元，无门槛
        Coupon c = new Coupon();
        c.setName("A6折扣券-" + marker);
        c.setType(1);
        c.setValue(new BigDecimal("8.5"));
        c.setMinAmount(BigDecimal.ZERO);
        c.setMaxDiscount(new BigDecimal("50"));
        c.setStock(100);
        c.setLimitPerUser(1000);
        c.setObtainType(0);
        c.setStartTime(LocalDateTime.now().minusDays(1));
        c.setEndTime(LocalDateTime.now().plusDays(1));
        c.setStatus(1);
        c.setDeleted(0);
        couponMapper.insert(c);
        createdCouponIds.add(c.getId());

        UserCoupon uc = new UserCoupon();
        uc.setUserId(buyer.getId());
        uc.setCouponId(c.getId());
        uc.setStatus(0);
        uc.setGetTime(LocalDateTime.now());
        userCouponMapper.insert(uc);
        createdUserCouponIds.add(uc.getId());

        // 50 件 × 10 元 = 500 元；8.5 折优惠 75 元 → 封顶 50 → 实付 450
        OrderCreateDTO dto = buildOrder(p, uc.getId());
        dto.getItems().get(0).setQuantity(50);

        Order order = orderService.createOrder(dto, buyer.getId());
        createdOrderIds.add(order.getId());

        assertEquals(0, new BigDecimal("500.00").compareTo(order.getTotalAmount()),
                "订单总额不符: " + order.getTotalAmount());
        assertEquals(0, new BigDecimal("450.00").compareTo(order.getPayAmount()),
                "订单实付不符: " + order.getPayAmount());
        // 与唯一计算来源 CouponCalculator 同源，保证前后端口径一致
        assertEquals(0, order.getPayAmount().compareTo(
                        CouponCalculator.calc(order.getTotalAmount(), c).payAmount()),
                "订单实付与 CouponCalculator 口径不一致");
    }

    // ==================== S3 优惠券越权使用 ====================

    @Test
    void couponIdorIsRejected() {
        User buyer = pickBuyer();
        User victim = userMapper.selectOne(new LambdaQueryWrapper<User>()
                .eq(User::getDeleted, 0)
                .ne(User::getId, buyer.getId())
                .last("LIMIT 1"));
        assertTrue(victim != null, "开发库缺少第二个用户");

        Product p = insertProduct(pickMerchantId(buyer.getId()), 10);
        Coupon c = insertCoupon(10);

        // 优惠券发给 victim，buyer 试图使用
        UserCoupon uc = new UserCoupon();
        uc.setUserId(victim.getId());
        uc.setCouponId(c.getId());
        uc.setStatus(0);
        uc.setGetTime(LocalDateTime.now());
        userCouponMapper.insert(uc);
        createdUserCouponIds.add(uc.getId());

        BusinessException ex = assertThrows(BusinessException.class,
                () -> orderService.createOrder(buildOrder(p, uc.getId()), buyer.getId()));
        assertTrue(ex.getMessage().contains("优惠券不属于当前用户"),
                "越权校验消息不符: " + ex.getMessage());
        // 事务回滚，库存未扣
        assertEquals(10, productMapper.selectById(p.getId()).getStock());
    }

    // ==================== S8 已注销用户不出现在搜索 ====================

    @Test
    void deactivatedUserHiddenInSearch() {
        User u = new User();
        u.setUsername("a6deleted_" + marker);
        u.setNickname("A6注销测试");
        u.setPassword("x");
        u.setRole("USER");
        u.setStatus(0);
        u.setDeleted(1); // 已注销（逻辑删除）
        userMapper.insert(u);
        createdUserIds.add(u.getId());

        Page<UserVO> page = userService.searchUsers("a6deleted_" + marker, 1, 10);
        assertTrue(page.getRecords().stream()
                        .noneMatch(v -> v.getUsername().equals(u.getUsername())),
                "已注销用户出现在搜索结果中");
    }
}
