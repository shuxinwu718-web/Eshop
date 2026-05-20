package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.entity.*;
import com.shopsphere.eshop.mapper.*;
import com.shopsphere.eshop.service.MerchantApplyService;
import com.shopsphere.eshop.service.MerchantMessageService;
import com.shopsphere.eshop.service.OrderShipmentService;
import com.shopsphere.eshop.service.ProductImageService;
import com.shopsphere.eshop.service.ProductService;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import com.shopsphere.eshop.dto.ProductSaveDTO;
import com.shopsphere.eshop.vo.MerchantApplyVO;
import com.shopsphere.eshop.vo.MerchantProductVO;
import com.shopsphere.eshop.vo.MerchantShipmentVO;
import com.shopsphere.eshop.vo.MerchantStatisticsVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
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
    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;

    private final MerchantApplyService merchantApplyService;
    private final MerchantMessageService messageService;


    private Long getMerchantId(String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        return jwtUtil.getUserIdFromToken(token);
    }

    // ==================== 商品管理 ====================

    @GetMapping("/products")
    public Result<Map<String, Object>> getProductList(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status,
            @RequestHeader("Authorization") String authHeader) {
        Long merchantId = getMerchantId(authHeader);

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
                                                       @RequestHeader("Authorization") String authHeader) {
        Long merchantId = getMerchantId(authHeader);
        Product product = productMapper.selectById(id);
        if (product == null || !product.getMerchantId().equals(merchantId)) {
            return Result.error("商品不存在");
        }

        MerchantProductVO vo = new MerchantProductVO();
        BeanUtils.copyProperties(product, vo);
        if (product.getCategoryId() != null) {
            Category cat = categoryMapper.selectById(product.getCategoryId());
            if (cat != null) vo.setCategoryName(cat.getName());
        }
        List<String> images = productImageService.getProductImages(product.getId());
        vo.setImages(images);

        return Result.success(vo);
    }

    @PostMapping("/product")
    public Result<?> createProduct(@RequestBody ProductSaveDTO dto,
                                   @RequestHeader("Authorization") String authHeader) {
        dto.setMerchantId(getMerchantId(authHeader));
        productService.addProduct(dto);
        return Result.success("添加成功");
    }

    @PutMapping("/product/{id}")
    public Result<?> updateProduct(@PathVariable Long id,
                                   @RequestBody ProductSaveDTO dto,
                                   @RequestHeader("Authorization") String authHeader) {
        Long merchantId = getMerchantId(authHeader);
        Product existing = productMapper.selectById(id);
        if (existing == null || !existing.getMerchantId().equals(merchantId)) {
            return Result.error("商品不存在或无权限修改");
        }
        dto.setId(id);
        productService.updateProduct(dto);
        return Result.success("修改成功");
    }

    @DeleteMapping("/product/{id}")
    public Result<?> deleteProduct(@PathVariable Long id,
                                   @RequestHeader("Authorization") String authHeader) {
        Long merchantId = getMerchantId(authHeader);
        Product existing = productMapper.selectById(id);
        if (existing == null || !existing.getMerchantId().equals(merchantId)) {
            return Result.error("商品不存在或无权限删除");
        }
        productService.deleteProduct(id);
        return Result.success("删除成功");
    }

    @PatchMapping("/product/{id}/status")
    public Result<?> updateProductStatus(@PathVariable Long id,
                                         @RequestBody Map<String, Integer> body,
                                         @RequestHeader("Authorization") String authHeader) {
        Long merchantId = getMerchantId(authHeader);
        Product existing = productMapper.selectById(id);
        if (existing == null || !existing.getMerchantId().equals(merchantId)) {
            return Result.error("商品不存在或无权限操作");
        }
        Integer status = body.get("status");
        if (status == null || (status != 0 && status != 1)) {
            return Result.error("状态值无效");
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
            @RequestHeader("Authorization") String authHeader) {
        Long merchantId = getMerchantId(authHeader);
        Page<MerchantShipmentVO> page = orderShipmentService.getMerchantShipments(merchantId, pageNum, pageSize);
        return Result.success(page);
    }

    /**
     * 商家获取某订单下自己的发货单详情
     */
    @GetMapping("/order/{orderId}")
    public Result<java.util.List<MerchantShipmentVO>> getOrderDetail(
            @PathVariable Long orderId,
            @RequestHeader("Authorization") String authHeader) {
        Long merchantId = getMerchantId(authHeader);
        return Result.success(orderShipmentService.getMerchantOrderShipments(orderId, merchantId));
    }

    /**
     * 商家发货（按发货单维度）
     */
    @PutMapping("/shipment/{shipmentId}/ship")
    public Result<?> shipShipment(@PathVariable Long shipmentId,
                                   @RequestBody Map<String, String> body,
                                   @RequestHeader("Authorization") String authHeader) {
        Long sellerId = getMerchantId(authHeader);
        String shippingName = body.get("shippingName");
        String shippingNo = body.get("shippingNo");

        if (shippingName == null || shippingName.isBlank()) {
            return Result.error("请输入快递公司");
        }
        if (shippingNo == null || shippingNo.isBlank()) {
            return Result.error("请输入快递单号");
        }

        orderShipmentService.shipShipment(shipmentId, sellerId, shippingName, shippingNo);
        return Result.success("发货成功");
    }

    // ==================== 统计 ====================

    @GetMapping("/statistics")
    public Result<MerchantStatisticsVO> getStatistics(
            @RequestParam(defaultValue = "30") Integer days,
            @RequestHeader("Authorization") String authHeader) {
        Long merchantId = getMerchantId(authHeader);

        // 直接查询 order_shipment，不需要经过 product
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

        // 统计总销售额和总发货单数
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

        for (OrderShipment shipment : shipments) {
            totalSales = totalSales.add(shipment.getTotalAmount());
            orderIdSet.add(shipment.getOrderId());

            // 用订单创建时间作为日期分组依据
            Order order = orderMapper.selectById(shipment.getOrderId());
            if (order != null && order.getCreateTime() != null) {
                String dateKey = order.getCreateTime().toLocalDate().format(fmt);
                dailySalesMap.merge(dateKey, shipment.getTotalAmount(), BigDecimal::add);
                dailyOrderMap.computeIfAbsent(dateKey, k -> new HashSet<>()).add(shipment.getOrderId());
            }
        }

        List<MerchantStatisticsVO.DailyStat> dailyStats = new ArrayList<>();
        for (Map.Entry<String, BigDecimal> entry : dailySalesMap.entrySet()) {
            MerchantStatisticsVO.DailyStat stat = new MerchantStatisticsVO.DailyStat();
            stat.setDate(entry.getKey());
            stat.setSales(entry.getValue().setScale(2, RoundingMode.HALF_UP));
            Set<Long> orderIds = dailyOrderMap.get(entry.getKey());
            stat.setOrders(orderIds != null ? (long) orderIds.size() : 0L);
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
    @GetMapping("/product-sales")
    public Result<?> getProductSales(@RequestHeader("Authorization") String authHeader) {
        Long merchantId = getMerchantId(authHeader);
        return Result.success(productService.getProductSalesByMerchant(merchantId));
    }

    // ==================== 用户留言 ====================

    @GetMapping("/messages")
    public Result<Page<MerchantMessage>> getMessages(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "20") Integer pageSize,
            @RequestHeader("Authorization") String authHeader) {
        Long merchantId = getMerchantId(authHeader);
        return Result.success(messageService.getMessages(merchantId, pageNum, pageSize));
    }

    @GetMapping("/messages/unread-count")
    public Result<Long> getMessageUnreadCount(@RequestHeader("Authorization") String authHeader) {
        Long merchantId = getMerchantId(authHeader);
        return Result.success(messageService.getUnreadCount(merchantId));
    }

    @PutMapping("/messages/{id}/read")
    public Result<?> markMessageRead(@PathVariable Long id,
                                     @RequestHeader("Authorization") String authHeader) {
        Long merchantId = getMerchantId(authHeader);
        messageService.markAsRead(merchantId, id);
        return Result.success("操作成功");
    }

    @PutMapping("/messages/{id}/reply")
    public Result<?> replyToMessage(@PathVariable Long id,
                                    @RequestBody Map<String, String> body,
                                    @RequestHeader("Authorization") String authHeader) {
        Long merchantId = getMerchantId(authHeader);
        String replyContent = body.get("replyContent");
        if (replyContent == null || replyContent.isBlank()) {
            return Result.error("请输入回复内容");
        }
        messageService.replyToMessage(merchantId, id, replyContent);
        return Result.success("回复成功");
    }

    // ==================== 商家资格证书 ====================


    /**
     * 商家查看自己的入驻申请信息
     */
    @GetMapping("/my-apply")
    public Result<MerchantApplyVO> getMyApply(@RequestHeader("Authorization") String authHeader) {
        Long merchantId = getMerchantId(authHeader);
        MerchantApplyVO vo = merchantApplyService.getMyApply(merchantId);
        return Result.success(vo);
    }
}
