package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.*;
import com.shopsphere.eshop.entity.*;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.*;
import com.shopsphere.eshop.service.GroupBuyService;
import com.shopsphere.eshop.service.NoticeService;
import com.shopsphere.eshop.service.OrderService;
import com.shopsphere.eshop.entity.RefundReasonCategory;
import com.shopsphere.eshop.vo.OrderVO;
import com.shopsphere.eshop.vo.RefundApplicationVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class OrderServiceImpl implements OrderService {

    private final OrderMapper orderMapper;
    private final OrderItemMapper orderItemMapper;
    private final OrderShipmentMapper orderShipmentMapper;
    private final ProductMapper productMapper;
    private final AddressMapper addressMapper;
    private final RefundApplicationMapper refundMapper;
    private final UserCouponMapper userCouponMapper;
    private final CouponMapper couponMapper;
    private final RefundProgressLogMapper refundProgressLogMapper;
    private final PaymentRecordMapper paymentRecordMapper;
    private final RefundSatisfactionMapper refundSatisfactionMapper;
    private final RefundReasonCategoryMapper refundReasonCategoryMapper;
    private final ProductSkuMapper productSkuMapper;
    private final SeckillSessionMapper seckillSessionMapper;
    private final NoticeService noticeService;
    private final ObjectMapper objectMapper;
    private final RedisTemplate<String, Object> redisTemplate;
    private final StringRedisTemplate stringRedisTemplate;
    private final GroupBuyService groupBuyService;

    @Scheduled(cron = "0 */5 * * * ?")
    public void scheduledCancelOrders() {
        autoCancelExpiredOrders();  // 调用你已有的自动取消方法
    }

    @Override
    @Transactional
    public Order createOrder(OrderCreateDTO dto, Long userId) {
        List<OrderCreateDTO.OrderItemDTO> items = dto.getItems();
        if (items == null || items.isEmpty()) {
            throw new BusinessException("订单不能为空");
        }

        // 1. 获取收货地址
        String receiverName;
        String receiverPhone;
        String receiverAddress;
        if (dto.getAddressId() != null) {
            Address address = addressMapper.selectById(dto.getAddressId());
            if (address == null) {
                throw new BusinessException("地址不存在");
            }
            if (!address.getUserId().equals(userId)) {
                throw new BusinessException("无权使用该地址");
            }
            receiverName = address.getReceiverName();
            receiverPhone = address.getReceiverPhone();
            receiverAddress = (address.getProvince() != null ? address.getProvince() : "")
                    + (address.getCity() != null ? address.getCity() : "")
                    + (address.getDistrict() != null ? address.getDistrict() : "")
                    + (address.getDetailAddress() != null ? address.getDetailAddress() : "");
        } else {
            receiverName = dto.getReceiverName();
            receiverPhone = dto.getReceiverPhone();
            receiverAddress = dto.getReceiverAddress();
            if (receiverName == null || receiverPhone == null || receiverAddress == null) {
                throw new BusinessException("请填写收货信息或选择地址");
            }
        }

        // 2. 校验库存并扣减，同时按 seller 分组
        Map<Long, List<OrderCreateDTO.OrderItemDTO>> itemsBySeller = new LinkedHashMap<>();
        BigDecimal totalAmount = BigDecimal.ZERO;

        for (OrderCreateDTO.OrderItemDTO itemDTO : items) {
            Product product = productMapper.selectById(itemDTO.getProductId());
            if (product == null) {
                throw new BusinessException("商品不存在: " + itemDTO.getProductId());
            }
            // 禁止商家购买自家商品
            if (product.getMerchantId() != null && product.getMerchantId().equals(userId)) {
                throw new BusinessException("不能购买自家商品");
            }
            // SKU支持：如果传了skuId，使用SKU的价格和库存
            ProductSku sku = null;
            if (itemDTO.getSkuId() != null) {
                sku = productSkuMapper.selectById(itemDTO.getSkuId());
                if (sku == null || !sku.getProductId().equals(product.getId())) {
                    throw new BusinessException("SKU不存在: " + itemDTO.getSkuId());
                }
                // 原子扣减SKU库存，防止并发超卖
                if (productSkuMapper.deductStock(sku.getId(), itemDTO.getQuantity()) == 0) {
                    throw new BusinessException("商品规格库存不足: " + product.getName());
                }
            } else {
                // 原子扣减商品库存，防止并发超卖
                if (productMapper.deductStock(product.getId(), itemDTO.getQuantity()) == 0) {
                    throw new BusinessException("商品库存不足: " + product.getName());
                }
            }

            BigDecimal itemPrice = (sku != null) ? sku.getPrice() : product.getPrice();
            totalAmount = totalAmount.add(itemPrice.multiply(BigDecimal.valueOf(itemDTO.getQuantity())));

            itemsBySeller
                    .computeIfAbsent(product.getMerchantId(), k -> new ArrayList<>())
                    .add(itemDTO);
        }


        // 计算实付金额，默认等于总金额
        BigDecimal payAmount = totalAmount;

        // 3.处理优惠券（如果用户选中了）
        if (dto.getUserCouponId() != null) {
            UserCoupon userCoupon = userCouponMapper.selectById(dto.getUserCouponId());
            // 越权校验：优惠券必须属于当前用户
            if (userCoupon != null && !userCoupon.getUserId().equals(userId)) {
                throw new BusinessException("优惠券不属于当前用户");
            }
            if (userCoupon != null && userCoupon.getStatus() == 0) {
                Coupon coupon = couponMapper.selectById(userCoupon.getCouponId());
                if (coupon != null && coupon.getStatus() == 1) {
                    // 检查门槛
                    if (totalAmount.compareTo(coupon.getMinAmount()) >= 0) {
                        if (coupon.getType() == 0) { // 满减
                            payAmount = totalAmount.subtract(coupon.getValue());
                            if (payAmount.compareTo(BigDecimal.ZERO) < 0) payAmount = BigDecimal.ZERO;
                        } else if (coupon.getType() == 1) { // 折扣
                            // value 表示折扣（如 8.5 即 8.5 折），折算比例 = value/10
                            BigDecimal discountedPay = totalAmount
                                    .multiply(coupon.getValue().divide(BigDecimal.valueOf(10)));
                            // max_discount 表示「最高优惠金额」上限：优惠额超过则封顶
                            if (coupon.getMaxDiscount() != null
                                    && coupon.getMaxDiscount().compareTo(BigDecimal.ZERO) > 0) {
                                BigDecimal saved = totalAmount.subtract(discountedPay);
                                if (saved.compareTo(coupon.getMaxDiscount()) > 0) {
                                    payAmount = totalAmount.subtract(coupon.getMaxDiscount());
                                } else {
                                    payAmount = discountedPay;
                                }
                            } else {
                                payAmount = discountedPay;
                            }
                            if (payAmount.compareTo(BigDecimal.ZERO) < 0) payAmount = BigDecimal.ZERO;
                        }
                    } // else: 不满足门槛，忽略该券，仍使用原价
                }
            }
        }

        // 4. 创建订单
        String orderNo = System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8);

        Order order = new Order();
        order.setOrderNo(orderNo);
        order.setUserId(userId);
        order.setTotalAmount(totalAmount);
        order.setOrderStatus(0);
        order.setPayAmount(payAmount);
        order.setReceiverName(receiverName);
        order.setReceiverPhone(receiverPhone);
        order.setReceiverAddress(receiverAddress);
        order.setRemark(dto.getRemark());
        orderMapper.insert(order);

        // 5. 按商家创建发货单和订单项
        for (Map.Entry<Long, List<OrderCreateDTO.OrderItemDTO>> entry : itemsBySeller.entrySet()) {
            Long sellerId = entry.getKey();
            List<OrderCreateDTO.OrderItemDTO> sellerItems = entry.getValue();

            // 计算本发货单金额
            BigDecimal shipmentAmount = BigDecimal.ZERO;
            List<OrderItem> orderItems = new ArrayList<>();
            for (OrderCreateDTO.OrderItemDTO itemDTO : sellerItems) {
                Product product = productMapper.selectById(itemDTO.getProductId());
                // SKU支持：如果选了SKU，使用SKU的价格
                BigDecimal itemPrice;
                String skuSpecs = null;
                if (itemDTO.getSkuId() != null) {
                    ProductSku sku = productSkuMapper.selectById(itemDTO.getSkuId());
                    itemPrice = (sku != null) ? sku.getPrice() : product.getPrice();
                    if (sku != null && sku.getSpecs() != null) {
                        try {
                            @SuppressWarnings("unchecked")
                            Map<String, Object> specsMap = objectMapper.readValue(sku.getSpecs(), Map.class);
                            skuSpecs = specsMap.entrySet().stream()
                                    .map(e -> e.getKey() + ":" + e.getValue())
                                    .collect(Collectors.joining(", "));
                        } catch (Exception e) {
                            skuSpecs = sku.getSpecs();
                        }
                    }
                } else {
                    itemPrice = product.getPrice();
                }
                BigDecimal itemTotal = itemPrice.multiply(BigDecimal.valueOf(itemDTO.getQuantity()));
                shipmentAmount = shipmentAmount.add(itemTotal);

                OrderItem orderItem = new OrderItem();
                orderItem.setProductId(product.getId());
                orderItem.setSkuId(itemDTO.getSkuId());
                orderItem.setSkuSpecs(skuSpecs);
                orderItem.setProductName(product.getName());
                orderItem.setProductImage(product.getCoverImage());
                orderItem.setPrice(itemPrice);
                orderItem.setQuantity(itemDTO.getQuantity());
                orderItems.add(orderItem);
            }

            // 创建发货单
            OrderShipment shipment = new OrderShipment();
            shipment.setOrderId(order.getId());
            shipment.setSellerId(sellerId);
            shipment.setDeliveryStatus(0);
            shipment.setTotalAmount(shipmentAmount);
            orderShipmentMapper.insert(shipment);

            // 保存订单项（关联 shipment_id）
            for (OrderItem orderItem : orderItems) {
                orderItem.setOrderId(order.getId());
                orderItem.setShipmentId(shipment.getId());
                orderItemMapper.insert(orderItem);
            }
        }


        // 6.更新折扣劵使用情况
        if (dto.getUserCouponId() != null && payAmount.compareTo(totalAmount) < 0) {
            UserCoupon userCoupon = userCouponMapper.selectById(dto.getUserCouponId());
            if (userCoupon != null && userCoupon.getStatus() == 0) {
                userCoupon.setStatus(1);
                userCoupon.setUseTime(LocalDateTime.now());
                userCoupon.setOrderNo(orderNo);
                userCouponMapper.updateById(userCoupon);
            }
        }

        // 7. 对有SKU的商品，从SKU汇总同步product.stock（下单扣减了SKU库存）
        Set<Long> syncedProductIds = new HashSet<>();
        for (OrderCreateDTO.OrderItemDTO itemDTO : items) {
            if (itemDTO.getSkuId() != null && syncedProductIds.add(itemDTO.getProductId())) {
                List<ProductSku> skuList = productSkuMapper.selectList(
                        new LambdaQueryWrapper<ProductSku>().eq(ProductSku::getProductId, itemDTO.getProductId()));
                if (!skuList.isEmpty()) {
                    int totalStock = skuList.stream()
                            .filter(s -> s.getStock() != null)
                            .mapToInt(ProductSku::getStock)
                            .sum();
                    Product prod = productMapper.selectById(itemDTO.getProductId());
                    if (prod != null) {
                        prod.setStock(totalStock);
                        productMapper.updateById(prod);
                    }
                }
            }
        }

        // 8. 发送新订单通知给商家
        for (Long sellerId : itemsBySeller.keySet()) {
            noticeService.createAndPublish(
                    "新订单通知",
                    "您有新的订单，订单号：" + orderNo,
                    3,
                    sellerId,
                    "new_order",
                    order.getId()
            );
        }

        log.info("订单创建成功 orderNo={}, userId={}, amount={}, payAmount={}", orderNo, userId, totalAmount, payAmount);
        return order;
    }

    @Override
    @Transactional
    public void cancelOrder(Long orderId, Long userId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }
        if (order.getOrderStatus() != 0) {
            throw new BusinessException("订单已支付，无法取消");
        }
        // 复用内部取消逻辑
        cancelOrderInternal(order);
    }


    @Override
    @Transactional
    public void autoCancelExpiredOrders() {
        // 超时时间：30分钟前
        LocalDateTime expireTime = LocalDateTime.now().minusMinutes(30);
        List<Order> orders = orderMapper.selectList(
                new LambdaQueryWrapper<Order>()
                        .eq(Order::getOrderStatus, 0)      // 待付款
                        .le(Order::getCreateTime, expireTime)
        );
        if (orders.isEmpty()) return;

        for (Order order : orders) {
            try {
                cancelOrderInternal(order); // 内部取消逻辑
            } catch (Exception e) {
                log.error("自动取消订单失败, orderId={}", order.getId(), e);
            }
        }
    }

    /**
     * 内部取消订单逻辑（不校验用户，用于定时任务或退款）
     */
    private void cancelOrderInternal(Order order) {
        // 1. 更新订单状态为已取消
        order.setOrderStatus(4);
        order.setCancelTime(LocalDateTime.now());
        orderMapper.updateById(order);

        // 2. 恢复商品库存（支持SKU）——拼团订单下单时不扣库存（成团时才扣），取消时无需回退
        Set<Long> merchantIds = new HashSet<>();
        if (order.getType() != Order.ORDER_TYPE_GROUP_BUY) {
            List<OrderItem> items = orderItemMapper.selectList(
                    new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, order.getId())
            );
            Set<Long> affectedProductIds = new HashSet<>();
            for (OrderItem item : items) {
                if (item.getSkuId() != null) {
                    ProductSku sku = productSkuMapper.selectById(item.getSkuId());
                    if (sku != null) {
                        sku.setStock(sku.getStock() + item.getQuantity());
                        productSkuMapper.updateById(sku);
                    }
                } else {
                    Product product = productMapper.selectById(item.getProductId());
                    if (product != null) {
                        product.setStock(product.getStock() + item.getQuantity());
                        productMapper.updateById(product);
                        merchantIds.add(product.getMerchantId());
                    }
                }
                affectedProductIds.add(item.getProductId());
            }
            // 2b. 对有SKU的商品，重新从SKU汇总同步product.stock
            for (Long pid : affectedProductIds) {
                List<ProductSku> skuList = productSkuMapper.selectList(
                        new LambdaQueryWrapper<ProductSku>().eq(ProductSku::getProductId, pid));
                if (!skuList.isEmpty()) {
                    int totalStock = skuList.stream()
                            .filter(s -> s.getStock() != null)
                            .mapToInt(ProductSku::getStock)
                            .sum();
                    Product p = productMapper.selectById(pid);
                    if (p != null) {
                        p.setStock(totalStock);
                        productMapper.updateById(p);
                    }
                }
                // 清除Redis缓存
                redisTemplate.delete("product:detail:" + pid);
            }
        }

        // 3. 归还优惠券
        releaseCouponIfAny(order.getOrderNo());

        // 3b. 秒杀商品订单：回滚秒杀场次库存与 Redis 数据（释放库存供再次抢购）
        if (order.getSeckillSessionId() != null) {
            Long sid = order.getSeckillSessionId();
            seckillSessionMapper.addStock(sid, 1);
            stringRedisTemplate.opsForValue().increment(SeckillServiceImpl.STOCK_KEY + sid);
            stringRedisTemplate.opsForSet().remove(SeckillServiceImpl.USERS_KEY + sid, String.valueOf(order.getUserId()));
            log.info("秒杀订单取消，已回滚秒杀库存 sessionId={}, orderId={}", sid, order.getId());
        }

        // 3c. 拼团订单：删除未支付成员释放团位，团内无人则团失效
        //     （拼团订单下单不扣库存，库存由成团时扣减，此处无需回滚）
        groupBuyService.onOrderCancelled(order.getId());

        // 4. 发送系统通知（商家）
        for (Long merchantId : merchantIds) {
            noticeService.createAndPublish(
                    "订单超时取消通知",
                    "订单 " + order.getOrderNo() + " 因超时未支付已被系统自动取消",
                    3,
                    merchantId,
                    "order_cancelled",
                    order.getId()
            );
        }
        // 5. 发送通知给买家
        noticeService.createAndPublish(
                "订单已取消",
                "您的订单 " + order.getOrderNo() + " 因超时未支付已被系统自动取消",
                3,
                order.getUserId(),
                "order_cancelled",
                order.getId()
        );

        log.info("自动取消订单成功, orderId={}, orderNo={}", order.getId(), order.getOrderNo());
    }


    @Override
    @Transactional
    public void payOrder(Long orderId, Long userId, BigDecimal actualAmount) {
        // 1. 查询订单（用于校验用户归属和获取 payAmount）
        Order order = orderMapper.selectById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }
        if (order.getOrderStatus() != 0) {
            throw new BusinessException("订单状态异常，无法支付");
        }
        // 2. 校验支付金额（前端传来的实际支付金额必须等于订单的实付金额）
        if (actualAmount == null || actualAmount.compareTo(order.getPayAmount()) != 0) {
            throw new BusinessException("支付金额与订单金额不符");
        }

        // 3. 使用条件更新：仅当订单状态为 0（待付款）时才更新为已支付（防止重复支付）
        Order updateOrder = new Order();
        updateOrder.setId(orderId);
        updateOrder.setOrderStatus(1);
        updateOrder.setPayStatus(1);
        updateOrder.setPayTime(LocalDateTime.now());

        // 使用 LambdaUpdateWrapper 增加状态条件（另一种写法）
        LambdaUpdateWrapper<Order> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(Order::getId, orderId)
                .eq(Order::getOrderStatus, 0);   // 只有待付款才能更新
        int rows = orderMapper.update(updateOrder, wrapper);
        if (rows == 0) {
            throw new BusinessException("支付失败，订单状态已变更，请刷新后重试");
        }

        // 4. 支付成功，增加各商品销量（支持SKU），并通知商家
        LambdaQueryWrapper<OrderItem> itemQuery = new LambdaQueryWrapper<>();
        itemQuery.eq(OrderItem::getOrderId, orderId);
        List<OrderItem> items = orderItemMapper.selectList(itemQuery);
        Set<Long> paidMerchantIds = new HashSet<>();
        for (OrderItem item : items) {
            // 更新SKU销量
            if (item.getSkuId() != null) {
                ProductSku sku = productSkuMapper.selectById(item.getSkuId());
                if (sku != null) {
                    sku.setSales(sku.getSales() == null ? item.getQuantity() : sku.getSales() + item.getQuantity());
                    productSkuMapper.updateById(sku);
                }
            }
            // 更新商品总销量
            Product product = productMapper.selectById(item.getProductId());
            if (product != null) {
                product.setSales(product.getSales() == null ? item.getQuantity() : product.getSales() + item.getQuantity());
                productMapper.updateById(product);
                paidMerchantIds.add(product.getMerchantId());
            }
            // 清除 Redis 缓存，下次查询时重新计算销量
            redisTemplate.delete("product:detail:" + item.getProductId());
        }
        // 清除热门商品 Redis 缓存
        Set<String> hotKeys = redisTemplate.keys("product:hot:*");
        if (hotKeys != null && !hotKeys.isEmpty()) {
            redisTemplate.delete(hotKeys);
        }
        for (Long merchantId : paidMerchantIds) {
            noticeService.createAndPublish(
                    "订单付款通知",
                    "订单 " + order.getOrderNo() + " 已付款，请尽快发货",
                    3,
                    merchantId,
                    "order_paid",
                    orderId
            );
        }

        // 创建系统通知给用户
        noticeService.createAndPublish(
                "订单支付成功",
                "您的订单 " + order.getOrderNo() + " 已支付成功，请等待发货",
                3,
                userId,
                "order_paid",
                orderId
        );

        // 拼团订单：标记成员已支付并做成团判定
        if (order.getType() != null && order.getType() == Order.ORDER_TYPE_GROUP_BUY) {
            groupBuyService.onOrderPaid(orderId);
        }

        log.info("订单支付成功 orderId={}, orderNo={}, userId={}, amount={}",
                orderId, order.getOrderNo(), userId, actualAmount);
    }


    @Override
    @Transactional
    public void confirmReceive(Long orderId, Long userId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }
        if (order.getOrderStatus() != 2) {
            throw new BusinessException("订单状态异常，仅已发货订单可确认收货");
        }

        // 将当前已发货(1)的发货单标记为已签收(2)
        LocalDateTime now = LocalDateTime.now();
        LambdaUpdateWrapper<OrderShipment> sw = new LambdaUpdateWrapper<>();
        sw.eq(OrderShipment::getOrderId, orderId)
                .eq(OrderShipment::getDeliveryStatus, 1)
                .set(OrderShipment::getDeliveryStatus, 2)
                .set(OrderShipment::getReceivedTime, now);
        orderShipmentMapper.update(null, sw);

        // 检查是否所有物流单都已签收
        long totalShipments = orderShipmentMapper.selectCount(
                new LambdaQueryWrapper<OrderShipment>().eq(OrderShipment::getOrderId, orderId));
        long receivedShipments = orderShipmentMapper.selectCount(
                new LambdaQueryWrapper<OrderShipment>()
                        .eq(OrderShipment::getOrderId, orderId)
                        .eq(OrderShipment::getDeliveryStatus, 2));
        if (totalShipments == receivedShipments) {
            order.setOrderStatus(3);
            order.setFinishTime(now);
            orderMapper.updateById(order);
        }
    }

    @Override
    public Page<OrderVO> pageQuery(OrderPageQueryDTO dto, Long userId) {
        Page<Order> page = new Page<>(dto.getPageNum(), dto.getPageSize());
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getUserId, userId);
        if (StringUtils.hasText(dto.getOrderNo())) {
            wrapper.like(Order::getOrderNo, dto.getOrderNo());
        }
        if (dto.getStatus() != null) {
            wrapper.eq(Order::getOrderStatus, dto.getStatus());
        }
        wrapper.orderByDesc(Order::getCreateTime);
        Page<Order> orderPage = orderMapper.selectPage(page, wrapper);

        Page<OrderVO> voPage = new Page<>(orderPage.getCurrent(), orderPage.getSize(), orderPage.getTotal());
        List<OrderVO> orderVOs = orderPage.getRecords().stream()
                .map(this::convertToOrderVO)
                .collect(Collectors.toList());
        voPage.setRecords(orderVOs);
        return voPage;
    }

    @Override
    public OrderVO getOrderDetail(Long orderId, Long userId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }
        return convertToOrderVO(order);
    }

    @Override
    public OrderVO getAdminOrderDetail(Long orderId) {
        Order order = orderMapper.selectById(orderId);
        if (order == null) {
            throw new BusinessException("订单不存在");
        }
        return convertToOrderVO(order);
    }

    private OrderVO convertToOrderVO(Order order) {
        List<OrderVO> list = convertToOrderVOs(Collections.singletonList(order));
        return list.isEmpty() ? null : list.get(0);
    }

    /** 批量订单转 VO：一次批量查询全部关联数据（退款/满意度/订单项/发货单），消除列表接口 N+1 */
    private List<OrderVO> convertToOrderVOs(List<Order> orders) {
        if (orders == null || orders.isEmpty()) {
            return Collections.emptyList();
        }
        List<Long> orderIds = orders.stream().map(Order::getId).collect(Collectors.toList());

        // 退款记录：每单取最新一条（id 最大）
        Map<Long, RefundApplication> refundMap = refundMapper.selectList(
                        new LambdaQueryWrapper<RefundApplication>().in(RefundApplication::getOrderId, orderIds))
                .stream()
                .collect(Collectors.toMap(RefundApplication::getOrderId, r -> r,
                        (a, b) -> a.getId() >= b.getId() ? a : b));

        // 已提交退款反馈评价的退款ID集合
        Set<Long> evaluatedRefundIds = refundMap.isEmpty() ? Collections.emptySet()
                : refundSatisfactionMapper.selectList(new LambdaQueryWrapper<RefundSatisfaction>()
                        .in(RefundSatisfaction::getRefundId, refundMap.keySet()))
                .stream().map(RefundSatisfaction::getRefundId).collect(Collectors.toSet());

        // 订单项：按订单ID分组
        Map<Long, List<OrderItem>> itemsByOrder = orderItemMapper.selectList(
                        new LambdaQueryWrapper<OrderItem>().in(OrderItem::getOrderId, orderIds))
                .stream().collect(Collectors.groupingBy(OrderItem::getOrderId));

        // 发货单：按订单ID分组
        Map<Long, List<OrderShipment>> shipmentsByOrder = orderShipmentMapper.selectList(
                        new LambdaQueryWrapper<OrderShipment>().in(OrderShipment::getOrderId, orderIds))
                .stream().collect(Collectors.groupingBy(OrderShipment::getOrderId));

        // 发货单包含的订单项ID：按发货单ID分组（一次批量查询，替代每发货单一次查询）
        List<Long> shipmentIds = shipmentsByOrder.values().stream()
                .flatMap(List::stream).map(OrderShipment::getId).collect(Collectors.toList());
        Map<Long, List<Long>> itemIdsByShipment = shipmentIds.isEmpty() ? Collections.emptyMap()
                : orderItemMapper.selectList(new LambdaQueryWrapper<OrderItem>()
                        .in(OrderItem::getShipmentId, shipmentIds))
                .stream().collect(Collectors.groupingBy(OrderItem::getShipmentId,
                        Collectors.mapping(OrderItem::getId, Collectors.toList())));

        return orders.stream().map(order -> {
            OrderVO vo = new OrderVO();
            vo.setId(order.getId());
            vo.setOrderNo(order.getOrderNo());
            vo.setUserId(order.getUserId());
            vo.setTotalAmount(order.getTotalAmount());
            vo.setPayAmount(order.getPayAmount());
            vo.setStatus(order.getOrderStatus());
            vo.setPayStatus(order.getPayStatus());
            vo.setCreateTime(order.getCreateTime());
            vo.setReceiverName(order.getReceiverName());
            vo.setReceiverPhone(order.getReceiverPhone());
            vo.setReceiverAddress(order.getReceiverAddress());

            RefundApplication refundApp = refundMap.get(order.getId());
            if (refundApp != null) {
                vo.setRefundId(refundApp.getId());
                vo.setRefundStatus(refundApp.getStatus());
                vo.setEvaluated(evaluatedRefundIds.contains(refundApp.getId()));
            } else {
                vo.setEvaluated(false);
            }

            List<OrderItem> items = itemsByOrder.getOrDefault(order.getId(), Collections.emptyList());
            Map<Long, OrderShipment> shipmentMap = shipmentsByOrder
                    .getOrDefault(order.getId(), Collections.emptyList())
                    .stream().collect(Collectors.toMap(OrderShipment::getId, s -> s));

            vo.setItems(items.stream().map(item -> {
                OrderVO.OrderItemVO itemVO = new OrderVO.OrderItemVO();
                itemVO.setProductId(item.getProductId());
                itemVO.setSkuId(item.getSkuId());
                itemVO.setSkuSpecs(item.getSkuSpecs());
                itemVO.setProductName(item.getProductName());
                itemVO.setProductPrice(item.getPrice());
                itemVO.setQuantity(item.getQuantity());
                itemVO.setProductImage(item.getProductImage());

                // 从发货单获取物流信息
                OrderShipment shipment = shipmentMap.get(item.getShipmentId());
                if (shipment != null) {
                    itemVO.setShippingName(shipment.getShippingName());
                    itemVO.setShippingNo(shipment.getShippingNo());
                    itemVO.setDeliveryStatus(shipment.getDeliveryStatus());
                    if (shipment.getDeliveryStatus() != null) {
                        switch (shipment.getDeliveryStatus()) {
                            case 0: itemVO.setShipStatus("pending"); break;
                            case 1: itemVO.setShipStatus("shipped"); break;
                            case 2: itemVO.setShipStatus("received"); break;
                            default: itemVO.setShipStatus("pending");
                        }
                    }
                }
                return itemVO;
            }).collect(Collectors.toList()));

            // 构建发货单VO列表
            vo.setShipments(shipmentsByOrder.getOrDefault(order.getId(), Collections.emptyList())
                    .stream().map(s -> {
                        OrderVO.ShipmentVO sv = new OrderVO.ShipmentVO();
                        sv.setId(s.getId());
                        sv.setDeliveryStatus(s.getDeliveryStatus());
                        sv.setShippingName(s.getShippingName());
                        sv.setShippingNo(s.getShippingNo());
                        sv.setShippingTime(s.getShippingTime());
                        sv.setReceivedTime(s.getReceivedTime());
                        sv.setItemIds(itemIdsByShipment.getOrDefault(s.getId(), Collections.emptyList()));
                        return sv;
                    }).collect(Collectors.toList()));

            return vo;
        }).collect(Collectors.toList());
    }

    @Override
    public Page<OrderVO> adminPageQuery(OrderPageQueryDTO dto) {
        Page<Order> page = new Page<>(dto.getPageNum(), dto.getPageSize());
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(dto.getOrderNo())) {
            wrapper.like(Order::getOrderNo, dto.getOrderNo());
        }
        if (dto.getStatus() != null) {
            wrapper.eq(Order::getOrderStatus, dto.getStatus());
        }
        wrapper.orderByDesc(Order::getCreateTime);
        Page<Order> orderPage = orderMapper.selectPage(page, wrapper);

        Page<OrderVO> voPage = new Page<>(orderPage.getCurrent(), orderPage.getSize(), orderPage.getTotal());
        voPage.setRecords(convertToOrderVOs(orderPage.getRecords()));
        return voPage;
    }

    @Override
    public Page<OrderVO> userPageQuery(OrderPageQueryDTO dto, Long userId) {
        Page<Order> page = new Page<>(dto.getPageNum(), dto.getPageSize());
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getUserId, userId);
        if (StringUtils.hasText(dto.getOrderNo())) {
            wrapper.like(Order::getOrderNo, dto.getOrderNo());
        }
        if (dto.getStatus() != null) {
            wrapper.eq(Order::getOrderStatus, dto.getStatus());
        }
        wrapper.orderByDesc(Order::getCreateTime);
        Page<Order> orderPage = orderMapper.selectPage(page, wrapper);

        Page<OrderVO> voPage = new Page<>(orderPage.getCurrent(), orderPage.getSize(), orderPage.getTotal());
        voPage.setRecords(convertToOrderVOs(orderPage.getRecords()));
        return voPage;
    }

    @Override
    @Transactional
    public void applyRefund(Long userId, RefundApplyDTO dto) {
        Order order = orderMapper.selectById(dto.getOrderId());
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }
        // 已付款、已发货、已完成状态均可申请退款
        if (order.getOrderStatus() != 1 && order.getOrderStatus() != 2 && order.getOrderStatus() != 3) {
            throw new BusinessException("当前订单状态不支持退款");
        }
        // 检查是否已有未处理完的退款申请
        LambdaQueryWrapper<RefundApplication> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(RefundApplication::getOrderId, order.getId())
                .in(RefundApplication::getStatus,
                        RefundApplication.STATUS_PENDING_MERCHANT,
                        RefundApplication.STATUS_PENDING_ADMIN,
                        RefundApplication.STATUS_APPROVED,
                        RefundApplication.STATUS_REFUNDING);
        if (refundMapper.selectCount(wrapper) > 0) {
            throw new BusinessException("已有未处理完的退款申请");
        }

        RefundApplication application = new RefundApplication();
        application.setOrderId(order.getId());
        application.setUserId(userId);
        application.setReason(dto.getReason());
        application.setReasonCategoryId(dto.getReasonCategoryId());
        application.setStatus(RefundApplication.STATUS_PENDING_MERCHANT);
        application.setRefundAmount(order.getPayAmount());
        application.setApplyTime(LocalDateTime.now());
        refundMapper.insert(application);

        // 记录进度
        addProgressLog(application.getId(), "申请提交", "用户" + userId, "USER", null);

        // 通知管理员/商户有新退款申请
        noticeService.createAndPublish(
                "新的退款申请",
                "订单 " + order.getOrderNo() + " 申请退款，金额 " + order.getPayAmount(),
                2,
                1L,
                "refund_apply",
                application.getId()
        );
    }

    @Override
    @Transactional
    public void auditRefund(Long adminId, RefundAuditDTO dto) {
        RefundApplication application = refundMapper.selectById(dto.getRefundId());
        if (application == null) {
            throw new BusinessException("退款申请不存在");
        }

        Order order = orderMapper.selectById(application.getOrderId());
        if (order == null) {
            throw new BusinessException("订单不存在");
        }

        String operatorRole = dto.getOperatorRole() != null ? dto.getOperatorRole() : "ADMIN";

        // 根据当前状态 + 操作角色决定流转
        if (application.getStatus() == RefundApplication.STATUS_PENDING_MERCHANT
                && "MERCHANT".equals(operatorRole)) {
            // —— 商户审核 ——
            if (dto.getStatus() == RefundApplication.STATUS_REJECTED) {
                application.setStatus(RefundApplication.STATUS_REJECTED);
                application.setRemark(dto.getRemark());
                application.setAuditTime(LocalDateTime.now());
                addProgressLog(application.getId(), "商户审核", "商户" + adminId, "MERCHANT",
                        dto.getRemark() != null ? "拒绝：" + dto.getRemark() : "拒绝");
                notifyUser(order, application, "refund_reject", "退款被拒绝",
                        "您的订单 " + order.getOrderNo() + " 退款申请被商户拒绝");
            } else {
                // 商户通过 → 待管理员审核
                application.setStatus(RefundApplication.STATUS_PENDING_ADMIN);
                application.setMerchantAuditTime(LocalDateTime.now());
                addProgressLog(application.getId(), "商户审核", "商户" + adminId, "MERCHANT", "通过");
            }

        } else if (application.getStatus() == RefundApplication.STATUS_PENDING_ADMIN
                && "ADMIN".equals(operatorRole)) {
            // —— 管理员审核 ——
            if (dto.getStatus() == RefundApplication.STATUS_REJECTED) {
                application.setStatus(RefundApplication.STATUS_REJECTED);
                application.setRemark(dto.getRemark());
                application.setAuditTime(LocalDateTime.now());
                addProgressLog(application.getId(), "管理员审核", "管理员" + adminId, "ADMIN",
                        dto.getRemark() != null ? "拒绝：" + dto.getRemark() : "拒绝");
                notifyUser(order, application, "refund_reject", "退款被拒绝",
                        "您的订单 " + order.getOrderNo() + " 退款申请被管理员拒绝");
            } else {
                // 管理员通过 → 已通过（待执行退款）
                application.setStatus(RefundApplication.STATUS_APPROVED);
                application.setAdminAuditTime(LocalDateTime.now());
                application.setAuditTime(LocalDateTime.now());
                addProgressLog(application.getId(), "管理员审核", "管理员" + adminId, "ADMIN", "通过");
                notifyUser(order, application, "refund_approved", "退款已通过",
                        "您的订单 " + order.getOrderNo() + " 退款已审核通过，即将执行退款");
            }

        } else if (application.getStatus() == RefundApplication.STATUS_APPROVED
                && "ADMIN".equals(operatorRole)
                && dto.getStatus() == RefundApplication.STATUS_REFUNDING) {
            // —— 管理员执行退款 ——
            application.setStatus(RefundApplication.STATUS_REFUNDING);
            addProgressLog(application.getId(), "退款执行", "管理员" + adminId, "ADMIN", "开始退款");
            refundMapper.updateById(application);

            // 执行退款（模拟）
            executeRefund(order, application, adminId);

        } else {
            throw new BusinessException("非法操作：当前状态不允许此审核操作");
        }

        refundMapper.updateById(application);
    }

    /**
       * 执行退款：更新订单状态、恢复库存、回退销量、记录支付退款
       */
      private void executeRefund(Order order, RefundApplication application, Long adminId) {
          // 1. 订单状态改为已退款
          order.setOrderStatus(Order.STATUS_REFUNDED);
          orderMapper.updateById(order);

          // 2. 恢复库存 + 回退销量（支持SKU）
          List<OrderItem> items = orderItemMapper.selectList(
                  new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, order.getId()));
          Set<Long> affectedProductIds = new HashSet<>();
          for (OrderItem item : items) {
              if (item.getSkuId() != null) {
                  // 有SKU：恢复SKU库存，回退SKU销量
                  ProductSku sku = productSkuMapper.selectById(item.getSkuId());
                  if (sku != null) {
                      sku.setStock(sku.getStock() + item.getQuantity());
                      sku.setSales(Math.max(0, sku.getSales() - item.getQuantity()));
                      productSkuMapper.updateById(sku);
                  }
              } else {
                  // 无SKU：直接回退商品库存和销量
                  Product product = productMapper.selectById(item.getProductId());
                  if (product != null) {
                      product.setStock(product.getStock() + item.getQuantity());
                      product.setSales(Math.max(0, product.getSales() - item.getQuantity()));
                      productMapper.updateById(product);
                  }
              }
              affectedProductIds.add(item.getProductId());
          }

          // 2b. 对有SKU的商品，重新从SKU汇总同步product表库存和销量
          for (Long pid : affectedProductIds) {
              List<ProductSku> skuList = productSkuMapper.selectList(
                      new LambdaQueryWrapper<ProductSku>().eq(ProductSku::getProductId, pid));
              if (!skuList.isEmpty()) {
                  int totalStock = skuList.stream()
                          .filter(s -> s.getStock() != null)
                          .mapToInt(ProductSku::getStock)
                          .sum();
                  int totalSales = skuList.stream()
                          .filter(s -> s.getSales() != null)
                          .mapToInt(ProductSku::getSales)
                          .sum();
                  Product p = productMapper.selectById(pid);
                  if (p != null) {
                      p.setStock(totalStock);
                      p.setSales(totalSales);
                      productMapper.updateById(p);
                  }
              }
              // 清除Redis缓存
              redisTemplate.delete("product:detail:" + pid);
          }
          // 清除热门商品Redis缓存
          Set<String> hotKeys = redisTemplate.keys("product:hot:*");
          if (hotKeys != null && !hotKeys.isEmpty()) {
              redisTemplate.delete(hotKeys);
          }

          // 3. 更新支付记录状态
          PaymentRecord payRecord = paymentRecordMapper.selectOne(
                  new LambdaQueryWrapper<PaymentRecord>()
                          .eq(PaymentRecord::getOrderId, order.getId())
                          .eq(PaymentRecord::getStatus, 1));
          if (payRecord != null) {
              payRecord.setStatus(2);
              payRecord.setRefundTime(LocalDateTime.now());
              paymentRecordMapper.updateById(payRecord);
          }

          // 4. 更新退款申请状态为已退款
          application.setStatus(RefundApplication.STATUS_REFUNDED);
          application.setRefundTime(LocalDateTime.now());
          addProgressLog(application.getId(), "退款完成", "管理员" + adminId, "ADMIN", "退款已执行");

          // 5. 通知用户
          notifyUser(order, application, "refund_success", "退款成功",
                  "您的订单 " + order.getOrderNo() + " 已退款 " + application.getRefundAmount() + " 元");
      }

    /**
     * 归还优惠券：将订单使用的优惠券重置为未使用状态
     */
    private void releaseCouponIfAny(String orderNo) {
        UserCoupon coupon = userCouponMapper.selectOne(
                new LambdaQueryWrapper<UserCoupon>()
                        .eq(UserCoupon::getOrderNo, orderNo));
        if (coupon != null) {
            coupon.setStatus(0);
            coupon.setUseTime(null);
            coupon.setOrderNo(null);
            userCouponMapper.updateById(coupon);
            log.info("优惠券已归还, couponId={}, orderNo={}", coupon.getId(), orderNo);
        }
    }

    /**
     * 添加退款进度日志
     */
    private void addProgressLog(Long refundId, String nodeName, String operator, String operatorRole, String remark) {
        RefundProgressLog log = new RefundProgressLog();
        log.setRefundId(refundId);
        log.setNodeName(nodeName);
        log.setOperator(operator);
        log.setOperatorRole(operatorRole);
        log.setRemark(remark);
        log.setCreateTime(LocalDateTime.now());
        refundProgressLogMapper.insert(log);
    }

    /**
     * 发送退款通知给用户
     */
    private void notifyUser(Order order, RefundApplication application, String bizType, String title, String content) {
        noticeService.createAndPublish(
                title,
                content,
                1,
                order.getUserId(),
                bizType,
                application.getId()
        );
    }


    @Override
    public Page<RefundApplicationVO> getRefundList(RefundQueryDTO queryDTO) {
        Page<RefundApplicationVO> page = new Page<>(queryDTO.getPageNum(), queryDTO.getPageSize());
        return refundMapper.selectRefundPage(page, queryDTO);
    }

    @Override
    public List<RefundProgressLog> getRefundProgress(Long refundId) {
        return refundProgressLogMapper.selectList(
                new LambdaQueryWrapper<RefundProgressLog>()
                        .eq(RefundProgressLog::getRefundId, refundId)
                        .orderByAsc(RefundProgressLog::getCreateTime));
    }

    @Override
    public List<RefundReasonCategory> getReasonCategories() {
        return refundReasonCategoryMapper.selectList(
                new LambdaQueryWrapper<RefundReasonCategory>()
                        .eq(RefundReasonCategory::getStatus, 1)
                        .orderByAsc(RefundReasonCategory::getSort));
    }

    @Override
    @Transactional
    public void submitSatisfaction(Long userId, Long refundId, Integer rating, String feedback) {
        RefundApplication application = refundMapper.selectById(refundId);
        if (application == null || !application.getUserId().equals(userId)) {
            throw new BusinessException("退款申请不存在");
        }
        if (application.getStatus() != RefundApplication.STATUS_REFUNDED) {
            throw new BusinessException("仅已完成退款可以评价");
        }
        // 每个退款只允许一次评价
        long count = refundSatisfactionMapper.selectCount(
                new LambdaQueryWrapper<RefundSatisfaction>()
                        .eq(RefundSatisfaction::getRefundId, refundId));
        if (count > 0) {
            throw new BusinessException("已评价过该退款");
        }
        RefundSatisfaction satisfaction = new RefundSatisfaction();
        satisfaction.setRefundId(refundId);
        satisfaction.setUserId(userId);
        satisfaction.setRating(rating);
        satisfaction.setFeedback(feedback);
        satisfaction.setCreateTime(LocalDateTime.now());
        refundSatisfactionMapper.insert(satisfaction);
    }

    @Override
    public Map<String, Object> getRefundStats(Long userId, Long refundId) {
        RefundApplication application = refundMapper.selectById(refundId);
        if (application == null || !application.getUserId().equals(userId)) {
            throw new BusinessException("退款申请不存在");
        }
        List<RefundProgressLog> logs = getRefundProgress(refundId);
        // 满意度反馈
        RefundSatisfaction satisfaction = refundSatisfactionMapper.selectOne(
                new LambdaQueryWrapper<RefundSatisfaction>()
                        .eq(RefundSatisfaction::getRefundId, refundId));
        Map<String, Object> result = new HashMap<>();
        result.put("progress", logs);
        result.put("satisfaction", satisfaction);
        // 计算各节点时间
        Map<String, Object> timeline = new LinkedHashMap<>();
        timeline.put("申请时间", application.getApplyTime());
        timeline.put("商户审核时间", application.getMerchantAuditTime());
        timeline.put("管理员审核时间", application.getAdminAuditTime());
        timeline.put("退款完成时间", application.getRefundTime());
        result.put("timeline", timeline);
        return result;
    }

    @Override
    public RefundSatisfaction getRefundSatisfaction(Long refundId) {
        return refundSatisfactionMapper.selectOne(
                new LambdaQueryWrapper<RefundSatisfaction>()
                        .eq(RefundSatisfaction::getRefundId, refundId));
    }

}
