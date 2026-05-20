package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.OrderCreateDTO;
import com.shopsphere.eshop.dto.OrderPageQueryDTO;
import com.shopsphere.eshop.entity.*;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.*;
import com.shopsphere.eshop.service.MerchantNotificationService;
import com.shopsphere.eshop.service.OrderService;
import com.shopsphere.eshop.vo.OrderVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
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
    private final UserMapper userMapper;

    private final UserCouponMapper userCouponMapper;
    private final CouponMapper couponMapper;
    private final MerchantNotificationService notificationService;

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
            if (product.getStock() < itemDTO.getQuantity()) {
                throw new BusinessException("商品库存不足: " + product.getName());
            }
            product.setStock(product.getStock() - itemDTO.getQuantity());
            productMapper.updateById(product);

            totalAmount = totalAmount.add(product.getPrice().multiply(BigDecimal.valueOf(itemDTO.getQuantity())));

            itemsBySeller
                    .computeIfAbsent(product.getMerchantId(), k -> new ArrayList<>())
                    .add(itemDTO);
        }


        // 计算实付金额，默认等于总金额
        BigDecimal payAmount = totalAmount;

        // 3.处理优惠券（如果用户选中了）
        if (dto.getUserCouponId() != null) {
            UserCoupon userCoupon = userCouponMapper.selectById(dto.getUserCouponId());
            if (userCoupon != null && userCoupon.getStatus() == 0) {
                Coupon coupon = couponMapper.selectById(userCoupon.getCouponId());
                if (coupon != null && coupon.getStatus() == 1) {
                    // 检查门槛
                    if (totalAmount.compareTo(coupon.getMinAmount()) >= 0) {
                        if (coupon.getType() == 0) { // 满减
                            payAmount = totalAmount.subtract(coupon.getValue());
                            if (payAmount.compareTo(BigDecimal.ZERO) < 0) payAmount = BigDecimal.ZERO;
                        } else if (coupon.getType() == 1) { // 折扣
                            BigDecimal discount = coupon.getValue().divide(BigDecimal.valueOf(10));
                            payAmount = totalAmount.multiply(discount);
                            if (coupon.getMaxDiscount() != null && payAmount.compareTo(coupon.getMaxDiscount()) > 0) {
                                payAmount = coupon.getMaxDiscount();
                            }
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
                BigDecimal itemTotal = product.getPrice().multiply(BigDecimal.valueOf(itemDTO.getQuantity()));
                shipmentAmount = shipmentAmount.add(itemTotal);

                OrderItem orderItem = new OrderItem();
                orderItem.setProductId(product.getId());
                orderItem.setProductName(product.getName());
                orderItem.setProductImage(product.getCoverImage());
                orderItem.setPrice(product.getPrice());
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

        // 7. 发送新订单通知给商家
        for (Long sellerId : itemsBySeller.keySet()) {
            notificationService.createNotification(
                    sellerId,
                    "new_order",
                    "新订单通知",
                    "您有新的订单，订单号：" + orderNo,
                    order.getId(),
                    orderNo
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
        order.setOrderStatus(4);
        order.setCancelTime(LocalDateTime.now());
        orderMapper.updateById(order);

        log.info("订单取消成功 orderId={}, userId={}", orderId, userId);

        // 恢复库存
        LambdaQueryWrapper<OrderItem> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(OrderItem::getOrderId, orderId);
        List<OrderItem> items = orderItemMapper.selectList(wrapper);

        // 通知商家
        Set<Long> merchantIds = new HashSet<>();
        for (OrderItem item : items) {
            Product product = productMapper.selectById(item.getProductId());
            if (product != null) {
                product.setStock(product.getStock() + item.getQuantity());
                productMapper.updateById(product);
                merchantIds.add(product.getMerchantId());
            }
        }
        for (Long merchantId : merchantIds) {
            notificationService.createNotification(
                    merchantId,
                    "order_cancelled",
                    "订单取消通知",
                    "订单 " + order.getOrderNo() + " 已被用户取消",
                    orderId,
                    order.getOrderNo()
            );
        }
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

        // 4. 支付成功，增加各商品销量，并通知商家
        LambdaQueryWrapper<OrderItem> itemQuery = new LambdaQueryWrapper<>();
        itemQuery.eq(OrderItem::getOrderId, orderId);
        List<OrderItem> items = orderItemMapper.selectList(itemQuery);
        Set<Long> paidMerchantIds = new HashSet<>();
        for (OrderItem item : items) {
            Product product = productMapper.selectById(item.getProductId());
            if (product != null) {
                product.setSales(product.getSales() == null ? item.getQuantity() : product.getSales() + item.getQuantity());
                productMapper.updateById(product);
                paidMerchantIds.add(product.getMerchantId());
            }
        }
        for (Long merchantId : paidMerchantIds) {
            notificationService.createNotification(
                    merchantId,
                    "order_paid",
                    "订单付款通知",
                    "订单 " + order.getOrderNo() + " 已付款，请尽快发货",
                    orderId,
                    order.getOrderNo()
            );
        }

        log.info("订单支付成功 orderId={}, orderNo={}, userId={}, amount={}",
                orderId, order.getOrderNo(), userId, actualAmount);
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

    private OrderVO convertToOrderVO(Order order) {
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

        // 查询所有商品明细
        LambdaQueryWrapper<OrderItem> itemWrapper = new LambdaQueryWrapper<>();
        itemWrapper.eq(OrderItem::getOrderId, order.getId());
        List<OrderItem> items = orderItemMapper.selectList(itemWrapper);

        // 按 shipment 分组查询发货状态
        LambdaQueryWrapper<OrderShipment> shipmentWrapper = new LambdaQueryWrapper<>();
        shipmentWrapper.eq(OrderShipment::getOrderId, order.getId());
        List<OrderShipment> shipments = orderShipmentMapper.selectList(shipmentWrapper);
        Map<Long, OrderShipment> shipmentMap = shipments.stream()
                .collect(Collectors.toMap(OrderShipment::getId, s -> s));

        List<OrderVO.OrderItemVO> itemVOs = items.stream().map(item -> {
            OrderVO.OrderItemVO itemVO = new OrderVO.OrderItemVO();
            itemVO.setProductId(item.getProductId());
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
            }
            return itemVO;
        }).collect(Collectors.toList());
        vo.setItems(itemVOs);
        return vo;
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
        List<OrderVO> orderVOs = orderPage.getRecords().stream()
                .map(this::convertToOrderVO)
                .collect(Collectors.toList());
        voPage.setRecords(orderVOs);
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
        List<OrderVO> orderVOs = orderPage.getRecords().stream()
                .map(this::convertToOrderVO)
                .collect(Collectors.toList());
        voPage.setRecords(orderVOs);
        return voPage;
    }
}
