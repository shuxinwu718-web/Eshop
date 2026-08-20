package com.shopsphere.eshop;

import com.shopsphere.eshop.entity.Coupon;
import com.shopsphere.eshop.util.CouponCalculator;
import com.shopsphere.eshop.util.CouponCalculator.CalcResult;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * CouponCalculator 纯单元测试（无需 Spring 容器）。
 * <p>
 * 覆盖：满减 / 折扣（含封顶）/ 使用门槛 / 异常输入保护 / 边界值。
 * 这是全系统金额计算的唯一来源，任何口径调整都必须保证这些断言成立。
 */
class CouponCalculatorTest {

    private Coupon coupon(Integer type, String value, String minAmount, String maxDiscount, Integer status) {
        Coupon c = new Coupon();
        c.setType(type);
        c.setValue(value == null ? null : new BigDecimal(value));
        c.setMinAmount(minAmount == null ? null : new BigDecimal(minAmount));
        c.setMaxDiscount(maxDiscount == null ? null : new BigDecimal(maxDiscount));
        c.setStatus(status);
        return c;
    }

    // ==================== 满减券 ====================

    @Test
    void 满减券_满足门槛_按满减额优惠() {
        Coupon c = coupon(0, "20", "100", null, 1);
        CalcResult r = CouponCalculator.calc(new BigDecimal("120"), c);
        assertEquals(new BigDecimal("20"), r.discountAmount());
        assertEquals(new BigDecimal("100"), r.payAmount());
    }

    @Test
    void 满减券_不满足门槛_不优惠() {
        Coupon c = coupon(0, "20", "100", null, 1);
        CalcResult r = CouponCalculator.calc(new BigDecimal("99"), c);
        assertEquals(new BigDecimal("0"), r.discountAmount());
        assertEquals(new BigDecimal("99"), r.payAmount());
    }

    @Test
    void 满减券_原价低于满减额_实付不为负() {
        Coupon c = coupon(0, "20", "10", null, 1);
        CalcResult r = CouponCalculator.calc(new BigDecimal("10"), c);
        assertEquals(new BigDecimal("10"), r.discountAmount());
        assertEquals(new BigDecimal("0"), r.payAmount());
    }

    @Test
    void 满减券_恰好等于门槛_可优惠() {
        Coupon c = coupon(0, "20", "100", null, 1);
        CalcResult r = CouponCalculator.calc(new BigDecimal("100"), c);
        assertEquals(new BigDecimal("20"), r.discountAmount());
        assertEquals(new BigDecimal("80"), r.payAmount());
    }

    // ==================== 折扣券 ====================

    @Test
    void 折扣券_85折_未超封顶_按比例优惠() {
        Coupon c = coupon(1, "8.5", "0", "50", 1);
        // 200 × 0.85 = 170，优惠 30 < 50 封顶
        CalcResult r = CouponCalculator.calc(new BigDecimal("200"), c);
        assertEquals(new BigDecimal("30.00"), r.discountAmount());
        assertEquals(new BigDecimal("170.00"), r.payAmount());
    }

    @Test
    void 折扣券_85折_超过封顶_按封顶优惠() {
        Coupon c = coupon(1, "8.5", "0", "50", 1);
        // 500 × 0.85 = 425，优惠 75 > 50 封顶 → 优惠 50，实付 450
        CalcResult r = CouponCalculator.calc(new BigDecimal("500"), c);
        assertEquals(new BigDecimal("50"), r.discountAmount());
        assertEquals(new BigDecimal("450"), r.payAmount());
    }

    @Test
    void 折扣券_无封顶_按比例优惠() {
        Coupon c = coupon(1, "8.5", "0", null, 1);
        CalcResult r = CouponCalculator.calc(new BigDecimal("100"), c);
        assertEquals(new BigDecimal("15.00"), r.discountAmount());
        assertEquals(new BigDecimal("85.00"), r.payAmount());
    }

    @Test
    void 折扣券_不满门槛_不优惠() {
        Coupon c = coupon(1, "8.5", "100", null, 1);
        CalcResult r = CouponCalculator.calc(new BigDecimal("99.99"), c);
        assertEquals(new BigDecimal("0"), r.discountAmount());
        assertEquals(new BigDecimal("99.99"), r.payAmount());
    }

    @Test
    void 折扣券_金额舍入_两位小数() {
        Coupon c = coupon(1, "8.5", "0", null, 1);
        // 99.99 × 0.85 = 84.9915 → 84.99；优惠 = 99.99 - 84.99 = 15.00
        CalcResult r = CouponCalculator.calc(new BigDecimal("99.99"), c);
        assertEquals(new BigDecimal("15.00"), r.discountAmount());
        assertEquals(new BigDecimal("84.99"), r.payAmount());
    }

    // ==================== 异常 / 边界保护 ====================

    @Test
    void 券为空_不优惠() {
        CalcResult r = CouponCalculator.calc(new BigDecimal("100"), null);
        assertEquals(new BigDecimal("0"), r.discountAmount());
        assertEquals(new BigDecimal("100"), r.payAmount());
    }

    @Test
    void 券未启用_status不等于1_不优惠() {
        Coupon c = coupon(0, "20", "100", null, 0);
        CalcResult r = CouponCalculator.calc(new BigDecimal("200"), c);
        assertEquals(new BigDecimal("0"), r.discountAmount());
        assertEquals(new BigDecimal("200"), r.payAmount());
    }

    @Test
    void 金额为空_按0处理() {
        Coupon c = coupon(0, "20", "100", null, 1);
        CalcResult r = CouponCalculator.calc(null, c);
        assertEquals(new BigDecimal("0"), r.discountAmount());
        assertEquals(new BigDecimal("0"), r.payAmount());
    }

    @Test
    void 金额为负_不优惠且实付不为负() {
        Coupon c = coupon(0, "20", "100", null, 1);
        CalcResult r = CouponCalculator.calc(new BigDecimal("-50"), c);
        assertEquals(new BigDecimal("0"), r.discountAmount());
        assertEquals(new BigDecimal("0"), r.payAmount());
    }

    @Test
    void 折扣券_value为空_不优惠() {
        Coupon c = coupon(1, null, "0", null, 1);
        CalcResult r = CouponCalculator.calc(new BigDecimal("100"), c);
        assertEquals(new BigDecimal("0"), r.discountAmount());
        assertEquals(new BigDecimal("100"), r.payAmount());
    }

    @Test
    void 未知券类型_不优惠() {
        Coupon c = coupon(9, "20", "0", null, 1);
        CalcResult r = CouponCalculator.calc(new BigDecimal("100"), c);
        assertEquals(new BigDecimal("0"), r.discountAmount());
        assertEquals(new BigDecimal("100"), r.payAmount());
    }
}
