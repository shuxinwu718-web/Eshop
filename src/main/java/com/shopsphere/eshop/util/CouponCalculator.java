package com.shopsphere.eshop.util;

import com.shopsphere.eshop.entity.Coupon;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * 优惠券金额计算工具 —— 全系统唯一计算来源。
 * <p>
 * 后端下单（OrderServiceImpl）与前端结算预览（可用券接口返回实付/优惠金额）
 * 统一复用本工具，保证两端口径一致，避免金额计算逻辑分散导致的口径偏差。
 */
public final class CouponCalculator {

    private CouponCalculator() {
    }

    /**
     * 计算使用指定优惠券后的优惠金额与实付金额。
     *
     * @param totalAmount 订单商品原价总额
     * @param coupon      优惠券模板（type: 0满减 1折扣；value：满减额或折扣数(8.5即8.5折)；
     *                    maxDiscount：折扣券最高优惠金额上限；minAmount：使用门槛）
     * @return 计算结果（优惠金额 / 实付金额）
     */
    public static CalcResult calc(BigDecimal totalAmount, Coupon coupon) {
        BigDecimal original = totalAmount == null ? BigDecimal.ZERO : totalAmount;
        BigDecimal discount = BigDecimal.ZERO;

        // 仅对启用中的券且订单金额有效时计算
        if (coupon != null && coupon.getStatus() != null && coupon.getStatus() == 1
                && original.compareTo(BigDecimal.ZERO) > 0) {
            // 不满足使用门槛：不优惠
            if (coupon.getMinAmount() != null && original.compareTo(coupon.getMinAmount()) < 0) {
                return new CalcResult(BigDecimal.ZERO, original);
            }
            if (coupon.getType() != null && coupon.getType() == 0) {
                // 满减：优惠 = 满减额（不超过原价）
                discount = coupon.getValue() == null ? BigDecimal.ZERO : coupon.getValue();
                if (discount.compareTo(original) > 0) {
                    discount = original;
                }
            } else if (coupon.getType() != null && coupon.getType() == 1 && coupon.getValue() != null) {
                // 折扣：value 表示折扣（如 8.5 即 8.5 折），优惠 = 原价 × (1 - value/10)
                BigDecimal ratio = coupon.getValue().divide(BigDecimal.valueOf(10), 4, RoundingMode.HALF_UP);
                BigDecimal discounted = original.multiply(ratio).setScale(2, RoundingMode.HALF_UP);
                discount = original.subtract(discounted);
                // 最高优惠金额封顶
                if (coupon.getMaxDiscount() != null && coupon.getMaxDiscount().compareTo(BigDecimal.ZERO) > 0
                        && discount.compareTo(coupon.getMaxDiscount()) > 0) {
                    discount = coupon.getMaxDiscount();
                }
                if (discount.compareTo(BigDecimal.ZERO) < 0) {
                    discount = BigDecimal.ZERO;
                }
            }
        }

        BigDecimal pay = original.subtract(discount);
        if (pay.compareTo(BigDecimal.ZERO) < 0) {
            pay = BigDecimal.ZERO;
        }
        return new CalcResult(discount, pay);
    }

    /** 计算结果：优惠金额 / 实付金额 */
    public record CalcResult(BigDecimal discountAmount, BigDecimal payAmount) {
    }
}
