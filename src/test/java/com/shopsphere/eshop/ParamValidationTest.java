package com.shopsphere.eshop;

import com.shopsphere.eshop.dto.OrderCreateDTO;
import com.shopsphere.eshop.dto.ProductSaveDTO;
import com.shopsphere.eshop.dto.RefundApplyDTO;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.List;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 参数校验整改验证测试
 *
 * 覆盖生产问题整改项：
 * - 下单数量下限校验（@Min(1)），防止数量 0/负数破坏库存逻辑
 * - 商品价格/库存范围校验，防止负库存、0 元商品
 * - 嵌套 DTO 校验生效（OrderItemDTO 需 @Valid 级联）
 * - 退款申请订单号非空校验（jakarta.validation 替换 jetbrains 注解）
 */
class ParamValidationTest {

    private static ValidatorFactory factory;
    private static Validator validator;

    @BeforeAll
    static void setUp() {
        factory = Validation.buildDefaultValidatorFactory();
        validator = factory.getValidator();
    }

    @AfterAll
    static void tearDown() {
        factory.close();
    }

    @Test
    void orderQuantityMustBePositive() {
        OrderCreateDTO.OrderItemDTO item = new OrderCreateDTO.OrderItemDTO();
        item.setProductId(1L);
        item.setQuantity(0); // 非法：数量必须 > 0
        OrderCreateDTO dto = new OrderCreateDTO();
        dto.setItems(List.of(item));

        Set<ConstraintViolation<OrderCreateDTO>> violations = validator.validate(dto);
        assertTrue(violations.stream()
                .anyMatch(v -> v.getMessage().contains("购买数量必须大于0")));
    }

    @Test
    void orderQuantityMissingMustFail() {
        OrderCreateDTO.OrderItemDTO item = new OrderCreateDTO.OrderItemDTO();
        item.setProductId(1L);
        // quantity 不设置 -> 校验失败（同时验证嵌套 DTO 通过 @Valid 级联生效）
        OrderCreateDTO dto = new OrderCreateDTO();
        dto.setItems(List.of(item));

        Set<ConstraintViolation<OrderCreateDTO>> violations = validator.validate(dto);
        assertTrue(violations.stream()
                .anyMatch(v -> v.getMessage().contains("数量不能为空")));
    }

    @Test
    void validOrderPassesValidation() {
        OrderCreateDTO.OrderItemDTO item = new OrderCreateDTO.OrderItemDTO();
        item.setProductId(1L);
        item.setQuantity(2);
        OrderCreateDTO dto = new OrderCreateDTO();
        dto.setItems(List.of(item));

        assertTrue(validator.validate(dto).isEmpty());
    }

    @Test
    void productPriceMustBePositive() {
        ProductSaveDTO dto = new ProductSaveDTO();
        dto.setName("测试商品");
        dto.setPrice(new BigDecimal("0")); // 非法：价格必须 > 0
        dto.setStock(10);

        Set<ConstraintViolation<ProductSaveDTO>> violations = validator.validate(dto);
        assertTrue(violations.stream()
                .anyMatch(v -> v.getMessage().contains("价格必须大于0")));
    }

    @Test
    void productStockCannotBeNegative() {
        ProductSaveDTO dto = new ProductSaveDTO();
        dto.setName("测试商品");
        dto.setPrice(new BigDecimal("10.00"));
        dto.setStock(-1); // 非法：库存不能为负数

        Set<ConstraintViolation<ProductSaveDTO>> violations = validator.validate(dto);
        assertTrue(violations.stream()
                .anyMatch(v -> v.getMessage().contains("库存不能为负数")));
    }

    @Test
    void validProductPassesValidation() {
        ProductSaveDTO dto = new ProductSaveDTO();
        dto.setName("测试商品");
        dto.setPrice(new BigDecimal("10.00"));
        dto.setStock(10);

        assertTrue(validator.validate(dto).isEmpty());
    }

    @Test
    void refundOrderIdCannotBeNull() {
        RefundApplyDTO dto = new RefundApplyDTO();
        dto.setReason("不想要了");

        Set<ConstraintViolation<RefundApplyDTO>> violations = validator.validate(dto);
        assertFalse(violations.isEmpty());
        assertTrue(violations.stream()
                .anyMatch(v -> v.getPropertyPath().toString().equals("orderId")));
    }
}
