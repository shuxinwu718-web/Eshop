package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.entity.*;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.*;
import com.shopsphere.eshop.mapper.ProductSpecMapper;
import com.shopsphere.eshop.mapper.ProductSkuMapper;
import com.shopsphere.eshop.service.MerchantApplyService;
import com.shopsphere.eshop.service.MerchantMessageService;
import com.shopsphere.eshop.service.OrderShipmentService;
import com.shopsphere.eshop.service.ProductImageService;
import com.shopsphere.eshop.service.ProductService;
import com.shopsphere.eshop.dto.ProductSaveDTO;
import com.shopsphere.eshop.dto.StoreDesignDTO;
import com.shopsphere.eshop.vo.MerchantApplyVO;
import com.shopsphere.eshop.vo.MerchantProductVO;
import com.shopsphere.eshop.vo.MerchantShipmentVO;
import com.shopsphere.eshop.vo.MerchantStatisticsVO;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/merchant")
@RequiredArgsConstructor
@Tag(name = "商家功能管理", description = "商家对自己商品和订单的管理")
public class MerchantController {

    private final ProductService productService;
    private final ProductMapper productMapper;
    private final CategoryMapper categoryMapper;
    private final OrderShipmentService orderShipmentService;
    private final ProductImageService productImageService;
    private final OrderShipmentMapper orderShipmentMapper;
    private final OrderMapper orderMapper;

    private final MerchantApplyService merchantApplyService;
    private final MerchantMessageService messageService;
    private final StoreDesignMapper storeDesignMapper;
    private final ProductSizeChartMapper productSizeChartMapper;
    private final ProductSpecMapper productSpecMapper;
    private final ProductSkuMapper productSkuMapper;
    private final ObjectMapper objectMapper;
    private final StringRedisTemplate stringRedisTemplate;

    /** 清除小店信息缓存（店铺设计变更后调用，key 与 StoreController 保持一致） */
    private void evictStoreInfoCache(Long merchantId) {
        stringRedisTemplate.delete(StoreController.CACHE_KEY_PREFIX + merchantId);
    }

    // ==================== 商品管理 ====================

    @GetMapping("/products")
    public Result<Map<String, Object>> getProductList(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status,
            @CurrentUserId Long merchantId) {

        Page<Product> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Product::getMerchantId, merchantId);
        if (keyword != null && !keyword.isBlank()) {
            wrapper.like(Product::getName, keyword);
        }
        if (status != null) {
            wrapper.eq(Product::getStatus, status);
        }
        wrapper.orderByDesc(Product::getCreateTime);
        Page<Product> productPage = productMapper.selectPage(page, wrapper);

        List<MerchantProductVO> voList = productPage.getRecords().stream().map(p -> {
            MerchantProductVO vo = new MerchantProductVO();
            vo.setId(p.getId());
            vo.setName(p.getName());
            vo.setCategoryId(p.getCategoryId());
            vo.setPrice(p.getPrice());
            vo.setStock(p.getStock());
            vo.setCoverImage(p.getCoverImage());
            vo.setDescription(p.getDescription());
            vo.setStatus(p.getStatus());
            vo.setCreateTime(p.getCreateTime());
            if (p.getCategoryId() != null) {
                Category cat = categoryMapper.selectById(p.getCategoryId());
                if (cat != null) vo.setCategoryName(cat.getName());
            }
            return vo;
        }).collect(Collectors.toList());

        Map<String, Object> result = new HashMap<>();
        result.put("rows", voList);
        result.put("total", productPage.getTotal());
        return Result.success(result);
    }

    @GetMapping("/product/{id}")
    public Result<MerchantProductVO> getProductDetail(@PathVariable Long id,
                                                       @CurrentUserId Long merchantId) {
        Product product = productMapper.selectById(id);
        if (product == null || !product.getMerchantId().equals(merchantId)) {
            throw new BusinessException("商品不存在");
        }

        MerchantProductVO vo = new MerchantProductVO();
        BeanUtils.copyProperties(product, vo);
        if (product.getCategoryId() != null) {
            Category cat = categoryMapper.selectById(product.getCategoryId());
            if (cat != null) vo.setCategoryName(cat.getName());
        }
        List<String> images = productImageService.getProductImages(product.getId());
        vo.setImages(images);

        // 填充尺寸表数据
        ProductSizeChart chart = productSizeChartMapper.selectOne(
                new LambdaQueryWrapper<ProductSizeChart>().eq(ProductSizeChart::getProductId, id));
        if (chart != null) {
            vo.setSizeChartTitle(chart.getChartTitle());
            try {
                @SuppressWarnings("unchecked")
                List<String> columns = objectMapper.readValue(chart.getColumnsJson(), List.class);
                vo.setSizeChartColumns(columns);
                @SuppressWarnings("unchecked")
                List<List<String>> rows = objectMapper.readValue(chart.getRowsJson(), List.class);
                vo.setSizeChartRows(rows);
            } catch (Exception e) {
                // ignore parse error
            }
        }

        // 填充规格模板
        vo.setSpecs(productSpecMapper.selectList(
                new LambdaQueryWrapper<ProductSpec>()
                        .eq(ProductSpec::getProductId, id)
                        .orderByAsc(ProductSpec::getSortOrder)));

        // 填充SKU列表
        vo.setSkus(productSkuMapper.selectList(
                new LambdaQueryWrapper<ProductSku>()
                        .eq(ProductSku::getProductId, id)));

        return Result.success(vo);
    }

    @PostMapping("/product")
    public Result<?> createProduct(@RequestBody ProductSaveDTO dto,
                                   @CurrentUserId Long merchantId) {
        dto.setMerchantId(merchantId);
        productService.addProduct(dto);
        return Result.success("添加成功");
    }

    @PutMapping("/product/{id}")
    public Result<?> updateProduct(@PathVariable Long id,
                                   @Valid @RequestBody ProductSaveDTO dto,
                                   @CurrentUserId Long merchantId) {
        Product existing = productMapper.selectById(id);
        if (existing == null || !existing.getMerchantId().equals(merchantId)) {
            throw new BusinessException("商品不存在或无权限修改");
        }
        dto.setId(id);
        productService.updateProduct(dto);
        return Result.success("修改成功");
    }

    @DeleteMapping("/product/{id}")
    public Result<?> deleteProduct(@PathVariable Long id,
                                   @CurrentUserId Long merchantId) {
        Product existing = productMapper.selectById(id);
        if (existing == null || !existing.getMerchantId().equals(merchantId)) {
            throw new BusinessException("商品不存在或无权限删除");
        }
        productService.deleteProduct(id);
        return Result.success("删除成功");
    }

    @PatchMapping("/product/{id}/status")
    public Result<?> updateProductStatus(@PathVariable Long id,
                                         @RequestBody Map<String, Integer> body,
                                         @CurrentUserId Long merchantId) {
        Product existing = productMapper.selectById(id);
        if (existing == null || !existing.getMerchantId().equals(merchantId)) {
            throw new BusinessException("商品不存在或无权限操作");
        }
        Integer status = body.get("status");
        if (status == null || (status != 0 && status != 1)) {
            throw new BusinessException("状态值无效");
        }
        productService.changeStatus(id, status);
        return Result.success("状态更新成功");
    }

    // ==================== 发货单管理 ====================

    /**
     * 商家获取自己的发货单列表（包含商品明细）
     */
    @GetMapping("/shipments")
    public Result<Page<MerchantShipmentVO>> getShipments(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @CurrentUserId Long merchantId) {
        Page<MerchantShipmentVO> page = orderShipmentService.getMerchantShipments(merchantId, pageNum, pageSize);
        return Result.success(page);
    }

    /**
     * 商家获取某订单下自己的发货单详情
     */
    @GetMapping("/order/{orderId}")
    public Result<java.util.List<MerchantShipmentVO>> getOrderDetail(
            @PathVariable Long orderId,
            @CurrentUserId Long merchantId) {
        return Result.success(orderShipmentService.getMerchantOrderShipments(orderId, merchantId));
    }

    /**
     * 商家发货（按发货单维度）
     */
    @PutMapping("/shipment/{shipmentId}/ship")
    public Result<?> shipShipment(@PathVariable Long shipmentId,
                                   @RequestBody Map<String, String> body,
                                   @CurrentUserId Long sellerId) {
        String shippingName = body.get("shippingName");
        String shippingNo = body.get("shippingNo");

        if (shippingName == null || shippingName.isBlank()) {
            throw new BusinessException("请输入快递公司");
        }
        if (shippingNo == null || shippingNo.isBlank()) {
            throw new BusinessException("请输入快递单号");
        }

        orderShipmentService.shipShipment(shipmentId, sellerId, shippingName, shippingNo);
        return Result.success("发货成功");
    }

    // ==================== 统计 ====================

    @GetMapping("/statistics")
    public Result<MerchantStatisticsVO> getStatistics(
            @RequestParam(defaultValue = "30") Integer days,
            @CurrentUserId Long merchantId) {

        // 查询该商家的所有发货单
        List<OrderShipment> shipments = orderShipmentMapper.selectList(
                new LambdaQueryWrapper<OrderShipment>()
                        .eq(OrderShipment::getSellerId, merchantId)
        );

        MerchantStatisticsVO vo = new MerchantStatisticsVO();
        if (shipments.isEmpty()) {
            vo.setTotalSales(BigDecimal.ZERO);
            vo.setTotalOrders(0L);
            vo.setDailyStats(Collections.emptyList());
            return Result.success(vo);
        }

        // 批量查询关联订单，过滤出已支付的订单
        Set<Long> allOrderIds = shipments.stream().map(OrderShipment::getOrderId).collect(Collectors.toSet());
        List<Order> orders = orderMapper.selectBatchIds(allOrderIds);
        Set<Long> paidOrderIds = orders.stream()
                .filter(o -> o.getPayStatus() == 1 && o.getDeleted() == 0 && o.getOrderStatus() != 6)
                .map(Order::getId)
                .collect(Collectors.toSet());
        Map<Long, Order> orderMap = orders.stream()
                .filter(o -> paidOrderIds.contains(o.getId()))
                .collect(Collectors.toMap(Order::getId, o -> o));

        // 只统计已支付订单的发货单
        List<OrderShipment> validShipments = shipments.stream()
                .filter(s -> paidOrderIds.contains(s.getOrderId()))
                .collect(Collectors.toList());

        // 统计总销售额和总订单数
        BigDecimal totalSales = BigDecimal.ZERO;
        Set<Long> orderIdSet = new HashSet<>();
        Map<String, BigDecimal> dailySalesMap = new LinkedHashMap<>();
        Map<String, Set<Long>> dailyOrderMap = new LinkedHashMap<>();

        LocalDate today = LocalDate.now();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        for (int i = days - 1; i >= 0; i--) {
            String dateStr = today.minusDays(i).format(fmt);
            dailySalesMap.put(dateStr, BigDecimal.ZERO);
            dailyOrderMap.put(dateStr, new HashSet<>());
        }

        // 优惠分摊：整单优惠按各发货单金额占比分摊，得到商家实际应收金额
        for (OrderShipment shipment : validShipments) {
            BigDecimal amount = shipment.getTotalAmount() != null ? shipment.getTotalAmount() : BigDecimal.ZERO;
            Order order = orderMap.get(shipment.getOrderId());
            if (order != null) {
                BigDecimal orderTotal = order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO;
                BigDecimal orderPaid = order.getPayAmount() != null ? order.getPayAmount() : BigDecimal.ZERO;
                // 整单优惠 = 原价 - 实付（含优惠券扣减）
                BigDecimal discount = orderTotal.subtract(orderPaid);
                if (discount.compareTo(BigDecimal.ZERO) > 0 && orderTotal.compareTo(BigDecimal.ZERO) > 0) {
                    // 该发货单分摊的优惠 = 优惠总额 * (发货单金额 / 订单原价)
                    BigDecimal share = discount.multiply(amount)
                            .divide(orderTotal, 4, RoundingMode.HALF_UP);
                    amount = amount.subtract(share);
                    if (amount.compareTo(BigDecimal.ZERO) < 0) amount = BigDecimal.ZERO;
                }
            }
            totalSales = totalSales.add(amount);
            orderIdSet.add(shipment.getOrderId());

            if (order != null && order.getCreateTime() != null) {
                String dateKey = order.getCreateTime().toLocalDate().format(fmt);
                dailySalesMap.merge(dateKey, amount, BigDecimal::add);
                dailyOrderMap.computeIfAbsent(dateKey, k -> new HashSet<>()).add(shipment.getOrderId());
            }
        }

        List<MerchantStatisticsVO.DailyStat> dailyStats = new ArrayList<>();
        for (Map.Entry<String, BigDecimal> entry : dailySalesMap.entrySet()) {
            MerchantStatisticsVO.DailyStat stat = new MerchantStatisticsVO.DailyStat();
            stat.setDate(entry.getKey());
            stat.setSales(entry.getValue().setScale(2, RoundingMode.HALF_UP));
            Set<Long> orderIdsInDay = dailyOrderMap.get(entry.getKey());
            stat.setOrders(orderIdsInDay != null ? (long) orderIdsInDay.size() : 0L);
            dailyStats.add(stat);
        }

        vo.setTotalSales(totalSales.setScale(2, RoundingMode.HALF_UP));
        vo.setTotalOrders((long) orderIdSet.size());
        vo.setDailyStats(dailyStats);
        return Result.success(vo);
    }

    /**
     * 商家各商品销量统计
     */
    // ==================== 小店设计 ====================

    @GetMapping("/store-design")
    public Result<StoreDesign> getStoreDesign(@CurrentUserId Long merchantId) {
        StoreDesign design = storeDesignMapper.selectOne(
                new LambdaQueryWrapper<StoreDesign>().eq(StoreDesign::getMerchantId, merchantId));
        if (design == null) {
            design = new StoreDesign();
            design.setMerchantId(merchantId);
            design.setBackgroundColor("#667eea");
        }
        return Result.success(design);
    }

    @PutMapping("/store-design")
    public Result<?> updateStoreDesign(@RequestBody StoreDesignDTO dto,
                                       @CurrentUserId Long merchantId) {
        StoreDesign design = storeDesignMapper.selectOne(
                new LambdaQueryWrapper<StoreDesign>().eq(StoreDesign::getMerchantId, merchantId));
        if (design == null) {
            design = new StoreDesign();
            design.setMerchantId(merchantId);
            design.setBackgroundColor(dto.getBackgroundColor());
            design.setBannerUrl(dto.getBannerUrl());
            design.setAnnouncement(dto.getAnnouncement());
            design.setDraftLayout(dto.getDraftLayout());
            storeDesignMapper.insert(design);
        } else {
            design.setBackgroundColor(dto.getBackgroundColor());
            design.setBannerUrl(dto.getBannerUrl());
            design.setAnnouncement(dto.getAnnouncement());
            design.setDraftLayout(dto.getDraftLayout());
            storeDesignMapper.updateById(design);
        }
        // 店铺信息变更，清除小店信息缓存
        evictStoreInfoCache(merchantId);
        return Result.success("保存成功");
    }

    /**
     * 发布装修草稿：楼层配置 draftLayout 生效为 layout（用户端可见），并清除草稿
     */
    @PutMapping("/store-design/publish")
    public Result<?> publishStoreDesign(@CurrentUserId Long merchantId) {
        StoreDesign design = storeDesignMapper.selectOne(
                new LambdaQueryWrapper<StoreDesign>().eq(StoreDesign::getMerchantId, merchantId));
        if (design == null) {
            throw new BusinessException("店铺设计不存在，请先保存");
        }
        if (design.getDraftLayout() == null || design.getDraftLayout().isBlank()) {
            throw new BusinessException("暂无待发布的草稿");
        }
        design.setLayout(design.getDraftLayout());
        // 用 LambdaUpdateWrapper 强制置空草稿（updateById 默认忽略 null 字段）
        storeDesignMapper.update(null, new LambdaUpdateWrapper<StoreDesign>()
                .eq(StoreDesign::getMerchantId, merchantId)
                .set(StoreDesign::getLayout, design.getDraftLayout())
                .set(StoreDesign::getDraftLayout, null));
        evictStoreInfoCache(merchantId);
        return Result.success("发布成功");
    }

    @DeleteMapping("/store-design/avatar")
    public Result<?> deleteStoreAvatar(@CurrentUserId Long merchantId) {
        StoreDesign design = storeDesignMapper.selectOne(
                new LambdaQueryWrapper<StoreDesign>().eq(StoreDesign::getMerchantId, merchantId));
        if (design != null) {
            design.setBannerUrl(null);
            storeDesignMapper.updateById(design);
            // 头像变更，清除小店信息缓存
            evictStoreInfoCache(merchantId);
        }
        return Result.success("头像已删除");
    }

    @GetMapping("/product-sales")
    public Result<?> getProductSales(@CurrentUserId Long merchantId) {
        return Result.success(productService.getProductSalesByMerchant(merchantId));
    }

    // ==================== 用户留言 ====================

    @GetMapping("/messages")
    public Result<Page<MerchantMessage>> getMessages(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "20") Integer pageSize,
            @CurrentUserId Long merchantId) {
        return Result.success(messageService.getMessages(merchantId, pageNum, pageSize));
    }

    @GetMapping("/messages/unread-count")
    public Result<Long> getMessageUnreadCount(@CurrentUserId Long merchantId) {
        return Result.success(messageService.getUnreadCount(merchantId));
    }

    @PutMapping("/messages/{id}/read")
    public Result<?> markMessageRead(@PathVariable Long id,
                                     @CurrentUserId Long merchantId) {
        messageService.markAsRead(merchantId, id);
        return Result.success("操作成功");
    }

    @PutMapping("/messages/{id}/reply")
    public Result<?> replyToMessage(@PathVariable Long id,
                                    @RequestBody Map<String, String> body,
                                    @CurrentUserId Long merchantId) {
        String replyContent = body.get("replyContent");
        if (replyContent == null || replyContent.isBlank()) {
            throw new BusinessException("请输入回复内容");
        }
        messageService.replyToMessage(merchantId, id, replyContent);
        return Result.success("回复成功");
    }

    // ==================== 商家资格证书 ====================


    /**
     * 商家查看自己的入驻申请信息
     */
    @GetMapping("/my-apply")
    public Result<MerchantApplyVO> getMyApply(@CurrentUserId Long merchantId) {
        MerchantApplyVO vo = merchantApplyService.getMyApply(merchantId);
        return Result.success(vo);
    }
}
