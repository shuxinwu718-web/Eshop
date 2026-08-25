package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shopsphere.eshop.dto.GroupBuyActivitySaveDTO;
import com.shopsphere.eshop.dto.GroupBuyOrderDTO;
import com.shopsphere.eshop.entity.*;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.*;
import com.shopsphere.eshop.service.GroupBuyService;
import com.shopsphere.eshop.service.NoticeService;
import com.shopsphere.eshop.vo.GroupBuyActivityVO;
import com.shopsphere.eshop.vo.GroupBuyGroupVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 拼团服务实现（方案A：绑定单规格，参团同规格数量1）
 * 核心流程：
 *   开团/参团 → 创建拼团订单(type=2) + 团/成员记录（占位）
 *   支付成功 → Redis INCR 计数 → 满员即成团，通知全员
 *   超时未满员 → 定时任务自动失败 + 原路退款
 *   订单取消 → 释放团位与活动库存
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class GroupBuyServiceImpl implements GroupBuyService {

    /** 团已支付人数计数 key（Redis INCR，成团判定） */
    private static final String COUNT_KEY_PREFIX = "groupbuy:count:";
    /** 成团判定锁 key */
    private static final String LOCK_KEY_PREFIX = "groupbuy:lock:";
    /** 商品详情页拼团活动列表缓存（仅匿名用户共享；登录用户实时查询以保证 isJoined 准确） */
    private static final String ACTIVITY_LIST_CACHE_PREFIX = "gb:activity-list:";
    private static final long ACTIVITY_LIST_CACHE_TTL_SECONDS = 30L;

    private final GroupBuyActivityMapper activityMapper;
    private final GroupBuyGroupMapper groupMapper;
    private final GroupBuyMemberMapper memberMapper;
    private final ProductMapper productMapper;
    private final ProductSkuMapper productSkuMapper;
    private final OrderMapper orderMapper;
    private final OrderShipmentMapper orderShipmentMapper;
    private final OrderItemMapper orderItemMapper;
    private final AddressMapper addressMapper;
    private final UserMapper userMapper;
    private final PaymentRecordMapper paymentRecordMapper;
    private final NoticeService noticeService;
    private final StringRedisTemplate stringRedisTemplate;
    private final ObjectMapper objectMapper;

    // ==================== 用户端 ====================

    @Override
    public List<GroupBuyActivityVO> getProductActivities(Long productId, Long currentUserId) {
        // 登录用户实时查询：团列表含 isJoined（当前用户是否已参与），不能共享匿名缓存
        if (currentUserId != null) {
            return queryProductActivities(productId, currentUserId);
        }
        // 匿名用户（详情页主流量）走短 TTL 缓存，减少 DB 压力
        String cacheKey = ACTIVITY_LIST_CACHE_PREFIX + productId;
        String cached = stringRedisTemplate.opsForValue().get(cacheKey);
        if (cached != null) {
            try {
                return objectMapper.readValue(cached, new TypeReference<List<GroupBuyActivityVO>>() {});
            } catch (Exception e) {
                log.warn("拼团活动列表缓存反序列化失败，回源 DB key={}", cacheKey, e);
            }
        }
        List<GroupBuyActivityVO> list = queryProductActivities(productId, null);
        try {
            stringRedisTemplate.opsForValue().set(cacheKey,
                    objectMapper.writeValueAsString(list),
                    ACTIVITY_LIST_CACHE_TTL_SECONDS, TimeUnit.SECONDS);
        } catch (Exception e) {
            log.warn("拼团活动列表缓存写入失败 key={}", cacheKey, e);
        }
        return list;
    }

    /** 查询商品拼团活动（含进行中团列表） */
    private List<GroupBuyActivityVO> queryProductActivities(Long productId, Long currentUserId) {
        LocalDateTime now = LocalDateTime.now();
        List<GroupBuyActivity> activities = activityMapper.selectList(
                new LambdaQueryWrapper<GroupBuyActivity>()
                        .eq(GroupBuyActivity::getProductId, productId)
                        .eq(GroupBuyActivity::getStatus, GroupBuyActivity.STATUS_ONGOING)
                        .le(GroupBuyActivity::getStartTime, now)
                        .ge(GroupBuyActivity::getEndTime, now)
                        .orderByDesc(GroupBuyActivity::getCreateTime));
        if (activities.isEmpty()) {
            return Collections.emptyList();
        }
        return activities.stream()
                .map(a -> toActivityVO(a, currentUserId, true))
                .collect(Collectors.toList());
    }

    /** 活动/团状态变更后失效该商品的活动列表缓存 */
    private void evictActivityListCache(Long productId) {
        if (productId != null) {
            stringRedisTemplate.delete(ACTIVITY_LIST_CACHE_PREFIX + productId);
        }
    }

    @Override
    public GroupBuyGroupVO getGroupDetail(Long groupId, Long currentUserId) {
        GroupBuyGroup group = groupMapper.selectById(groupId);
        if (group == null) {
            throw new BusinessException("拼团不存在");
        }
        GroupBuyActivity activity = activityMapper.selectById(group.getActivityId());
        if (activity == null) {
            throw new BusinessException("拼团活动不存在");
        }
        return toGroupVO(group, activity, currentUserId);
    }

    @Override
    @Transactional
    public Long startGroup(Long activityId, GroupBuyOrderDTO dto, Long userId) {
        GroupBuyActivity activity = activityMapper.selectById(activityId);
        if (activity == null) {
            throw new BusinessException("拼团活动不存在");
        }
        validateActivity(activity);
        // 活动维度唯一性校验：一人一活动仅可开/参一次
        validateNotJoined(activity, userId);

        // 库存不在下单时扣减：拼团成功（成团）时才原子扣库存，避免开团/参团占满库存导致其他用户无法加入
        Product product = productMapper.selectById(activity.getProductId());
        if (product == null) {
            throw new BusinessException("商品不存在");
        }
        ProductSku sku = resolveSku(activity);

        Address address = getValidAddress(dto.getAddressId(), userId);
        Order order = createGroupOrder(activity, product, sku, userId, address);

        // 创建团（开团人）
        GroupBuyGroup group = new GroupBuyGroup();
        group.setActivityId(activityId);
        group.setGroupNo(generateGroupNo());
        group.setLeaderId(userId);
        group.setStatus(GroupBuyGroup.STATUS_ACTIVE);
        group.setExpireTime(LocalDateTime.now().plusHours(activity.getDurationHours()));
        groupMapper.insert(group);

        insertMember(group.getId(), userId, order.getId(), GroupBuyMember.ROLE_LEADER);

        // 团列表变化，失效该商品活动列表缓存
        evictActivityListCache(activity.getProductId());

        log.info("发起拼团成功 activityId={}, groupId={}, orderId={}, userId={}",
                activityId, group.getId(), order.getId(), userId);
        return group.getId();
    }

    @Override
    @Transactional
    public Long joinGroup(Long groupId, GroupBuyOrderDTO dto, Long userId) {
        GroupBuyGroup group = groupMapper.selectById(groupId);
        if (group == null) {
            throw new BusinessException("拼团不存在");
        }
        if (group.getStatus() != GroupBuyGroup.STATUS_ACTIVE) {
            throw new BusinessException("该团已结束");
        }
        if (group.getExpireTime().isBefore(LocalDateTime.now())) {
            throw new BusinessException("该团已过期");
        }
        if (group.getLeaderId().equals(userId)) {
            throw new BusinessException("您是开团人，不能重复参团");
        }

        GroupBuyActivity activity = activityMapper.selectById(group.getActivityId());
        if (activity == null) {
            throw new BusinessException("拼团活动不存在");
        }
        validateActivity(activity);

        // 活动维度唯一性校验：同一活动下已开团或已参团（进行中）则不可再参
        validateNotJoined(activity, userId);

        // 人数已满则不可再参（按团内成员总数统计：开团人下单即占 1 个席位，避免「2 人团凑 3 人」）
        long memberCount = memberMapper.selectCount(new LambdaQueryWrapper<GroupBuyMember>()
                .eq(GroupBuyMember::getGroupId, groupId));
        if (memberCount >= activity.getTargetCount()) {
            throw new BusinessException("该团人数已满");
        }

        // 库存不在下单时扣减：拼团成功（成团）时才原子扣库存
        Product product = productMapper.selectById(activity.getProductId());
        ProductSku sku = resolveSku(activity);

        Address address = getValidAddress(dto.getAddressId(), userId);
        Order order = createGroupOrder(activity, product, sku, userId, address);

        insertMember(groupId, userId, order.getId(), GroupBuyMember.ROLE_MEMBER);

        // 团人数变化，失效该商品活动列表缓存
        evictActivityListCache(activity.getProductId());
        return groupId;
    }

    @Override
    public List<GroupBuyGroupVO> myGroups(Long userId) {
        List<GroupBuyMember> myMembers = memberMapper.selectList(
                new LambdaQueryWrapper<GroupBuyMember>()
                        .eq(GroupBuyMember::getUserId, userId)
                        .orderByDesc(GroupBuyMember::getId));
        if (myMembers.isEmpty()) {
            return Collections.emptyList();
        }

        // ========== 批量收集外键数据（selectBatchIds + 内存 Map），消除逐条 N+1 ==========
        List<Long> groupIds = myMembers.stream().map(GroupBuyMember::getGroupId).distinct().collect(Collectors.toList());
        List<Long> orderIds = myMembers.stream().map(GroupBuyMember::getOrderId).distinct().collect(Collectors.toList());
        Map<Long, GroupBuyGroup> groupMap = toMapById(groupMapper.selectBatchIds(groupIds), GroupBuyGroup::getId);
        Map<Long, GroupBuyActivity> activityMap = toMapById(activityMapper.selectBatchIds(
                groupMap.values().stream().map(GroupBuyGroup::getActivityId).distinct().collect(Collectors.toList())),
                GroupBuyActivity::getId);
        Map<Long, Product> productMap = toMapById(productMapper.selectBatchIds(
                activityMap.values().stream().map(GroupBuyActivity::getProductId).distinct().collect(Collectors.toList())),
                Product::getId);
        Map<Long, ProductSku> skuMap = toMapById(productSkuMapper.selectBatchIds(
                activityMap.values().stream().map(GroupBuyActivity::getSkuId)
                        .filter(Objects::nonNull).distinct().collect(Collectors.toList())),
                ProductSku::getId);
        Map<Long, Order> orderMap = toMapById(orderMapper.selectBatchIds(orderIds), Order::getId);

        // 相关团全部成员（含本人），一次查出后内存分组（id 升序保证头像顺序稳定）
        List<GroupBuyMember> allMembers = memberMapper.selectList(
                new LambdaQueryWrapper<GroupBuyMember>()
                        .in(GroupBuyMember::getGroupId, groupIds)
                        .orderByAsc(GroupBuyMember::getId));
        Map<Long, List<GroupBuyMember>> membersByGroup = allMembers.stream()
                .collect(Collectors.groupingBy(GroupBuyMember::getGroupId));

        // 开团人 + 成员头像用户，一次批量查出
        Set<Long> userNeedIds = new HashSet<>();
        groupMap.values().forEach(g -> {
            if (g.getLeaderId() != null) {
                userNeedIds.add(g.getLeaderId());
            }
        });
        allMembers.forEach(m -> userNeedIds.add(m.getUserId()));
        Map<Long, User> userMap = userNeedIds.isEmpty() ? Collections.emptyMap()
                : toMapById(userMapper.selectBatchIds(userNeedIds), User::getId);

        List<GroupBuyGroupVO> list = new ArrayList<>();
        for (GroupBuyMember m : myMembers) {
            GroupBuyGroup g = groupMap.get(m.getGroupId());
            if (g == null) {
                continue;
            }
            GroupBuyActivity a = activityMap.get(g.getActivityId());
            if (a == null) {
                continue;
            }
            GroupBuyGroupVO vo = toGroupVO(g, a, userId, membersByGroup.get(g.getId()), userMap);
            vo.setIsJoined(true);
            // 「我的拼团记录」展示字段
            Product product = productMap.get(a.getProductId());
            if (product != null) {
                vo.setProductName(product.getName());
                vo.setCoverImage(product.getCoverImage());
            }
            if (a.getSkuId() != null) {
                ProductSku sku = skuMap.get(a.getSkuId());
                if (sku != null && sku.getSpecs() != null) {
                    try {
                        @SuppressWarnings("unchecked")
                        Map<String, Object> specsMap = objectMapper.readValue(sku.getSpecs(), Map.class);
                        vo.setSkuSpecs(specsMap.entrySet().stream()
                                .map(e -> e.getKey() + ":" + e.getValue())
                                .collect(Collectors.joining(", ")));
                    } catch (Exception e) {
                        vo.setSkuSpecs(sku.getSpecs());
                    }
                }
            }
            vo.setOrderId(m.getOrderId());
            Order order = orderMap.get(m.getOrderId());
            vo.setOrderStatus(order != null ? order.getOrderStatus() : null);
            vo.setCreateTime(g.getCreateTime());
            list.add(vo);
        }
        return list;
    }

    /** 批量查询结果转 id → 实体 Map（空集合安全） */
    private static <T> Map<Long, T> toMapById(List<T> list, Function<T, Long> idFn) {
        if (list == null || list.isEmpty()) {
            return Collections.emptyMap();
        }
        return list.stream().collect(Collectors.toMap(idFn, e -> e, (a, b) -> a));
    }

    // ==================== 订单联动 ====================

    @Override
    @Transactional
    public void onOrderPaid(Long orderId) {
        GroupBuyMember member = memberMapper.selectOne(
                new LambdaQueryWrapper<GroupBuyMember>().eq(GroupBuyMember::getOrderId, orderId));
        if (member == null) {
            return; // 非拼团订单
        }
        if (member.getPayStatus() == GroupBuyMember.PAY_PAID) {
            return; // 幂等
        }
        member.setPayStatus(GroupBuyMember.PAY_PAID);
        memberMapper.updateById(member);

        GroupBuyGroup group = groupMapper.selectById(member.getGroupId());
        if (group == null || group.getStatus() != GroupBuyGroup.STATUS_ACTIVE) {
            return;
        }
        GroupBuyActivity activity = activityMapper.selectById(group.getActivityId());
        if (activity == null) {
            return;
        }

        // Redis 原子计数（已支付人数），满员判定
        String countKey = COUNT_KEY_PREFIX + group.getId();
        Long count = stringRedisTemplate.opsForValue().increment(countKey);
        if (count == null || count < activity.getTargetCount()) {
            return;
        }

        // 加锁成团，防止两个并发成员同时触发重复成团
        String lockKey = LOCK_KEY_PREFIX + group.getId();
        Boolean locked = stringRedisTemplate.opsForValue()
                .setIfAbsent(lockKey, "1", 10, TimeUnit.SECONDS);
        if (!Boolean.TRUE.equals(locked)) {
            return;
        }
        try {
            // 双重检查：团可能已被其他线程置为成功
            GroupBuyGroup fresh = groupMapper.selectById(group.getId());
            if (fresh != null && fresh.getStatus() == GroupBuyGroup.STATUS_ACTIVE) {
                LocalDateTime now = LocalDateTime.now();

                // 成团才扣库存（原子）：商品/SKU 库存 targetCount 份 + 活动成团名额 1 份
                // 任一不足则整团失败并原路退款，避免超卖
                try {
                    deductStockOnGroupSuccess(activity);
                } catch (BusinessException e) {
                    log.warn("成团扣库存失败，拼团自动失败退款 groupId={}, reason={}",
                            group.getId(), e.getMessage());
                    failGroupWithRefund(group.getId(), GroupBuyGroup.STATUS_FAILED,
                            "拼团失败：" + e.getMessage());
                    return;
                }

                fresh.setStatus(GroupBuyGroup.STATUS_SUCCESS);
                fresh.setSuccessTime(now);
                groupMapper.updateById(fresh);

                // 活动已成团份数 +1
                activity.setSoldCount((activity.getSoldCount() == null ? 0 : activity.getSoldCount()) + 1);
                activityMapper.updateById(activity);

                // 通知所有成员
                List<GroupBuyMember> members = memberMapper.selectList(
                        new LambdaQueryWrapper<GroupBuyMember>().eq(GroupBuyMember::getGroupId, group.getId()));
                for (GroupBuyMember m : members) {
                    notifyQuietly("拼团成功",
                            "恭喜！您参与的拼团已成功，订单将尽快发货。团号：" + fresh.getGroupNo(),
                            m.getUserId(), "groupbuy_success", fresh.getId());
                }
                stringRedisTemplate.delete(countKey);

                // 团状态变化（进行中→已成团），失效该商品活动列表缓存
                evictActivityListCache(activity.getProductId());
                log.info("拼团成团 groupId={}, groupNo={}, memberCount={}",
                        fresh.getId(), fresh.getGroupNo(), count);
            }
        } finally {
            stringRedisTemplate.delete(lockKey);
        }
    }

    @Override
    @Transactional
    public void onOrderCancelled(Long orderId) {
        GroupBuyMember member = memberMapper.selectOne(
                new LambdaQueryWrapper<GroupBuyMember>().eq(GroupBuyMember::getOrderId, orderId));
        if (member == null) {
            return; // 非拼团订单
        }
        GroupBuyGroup group = groupMapper.selectById(member.getGroupId());
        if (group == null || group.getStatus() != GroupBuyGroup.STATUS_ACTIVE) {
            return;
        }
        // 已支付的订单不会走到取消逻辑（取消仅针对待付款），此处兜底
        if (member.getPayStatus() == GroupBuyMember.PAY_PAID) {
            return;
        }
        // 库存不下单扣（成团才扣），此处无需回滚；商品库存由订单取消逻辑恢复（也未扣过，无需操作）

        // 删除成员记录，释放团位
        memberMapper.deleteById(member.getId());
        Long remain = memberMapper.selectCount(new LambdaQueryWrapper<GroupBuyMember>()
                .eq(GroupBuyMember::getGroupId, group.getId()));
        if (remain == 0) {
            // 团内已无人（开团人取消），团直接失效
            group.setStatus(GroupBuyGroup.STATUS_CANCELLED);
            groupMapper.updateById(group);
            stringRedisTemplate.delete(COUNT_KEY_PREFIX + group.getId());
        }
        // 团人数/状态变化，失效该商品活动列表缓存
        GroupBuyActivity activity = activityMapper.selectById(group.getActivityId());
        if (activity != null) {
            evictActivityListCache(activity.getProductId());
        }
        log.info("拼团订单取消，释放团位 orderId={}, groupId={}, remainMembers={}", orderId, group.getId(), remain);
    }

    // ==================== 商家端 ====================

    @Override
    @Transactional
    public Long createActivity(GroupBuyActivitySaveDTO dto, Long merchantId) {
        Product product = productMapper.selectById(dto.getProductId());
        if (product == null) {
            throw new BusinessException("商品不存在");
        }
        if (!merchantId.equals(product.getMerchantId())) {
            throw new BusinessException("只能为自有商品创建拼团活动");
        }
        if (dto.getSkuId() != null) {
            ProductSku sku = productSkuMapper.selectById(dto.getSkuId());
            if (sku == null || !sku.getProductId().equals(dto.getProductId())) {
                throw new BusinessException("商品规格无效");
            }
        }
        if (dto.getStartTime() == null || dto.getEndTime() == null || dto.getStartTime().isAfter(dto.getEndTime())) {
            throw new BusinessException("活动时间设置错误");
        }

        // ============ 新增：创建时库存预检 ============
        validateStockOnCreate(dto);

        GroupBuyActivity activity = new GroupBuyActivity();
        BeanUtils.copyProperties(dto, activity);
        activity.setMerchantId(merchantId);
        activity.setStatus(GroupBuyActivity.STATUS_DRAFT);
        activity.setSoldCount(0);
        activityMapper.insert(activity);
        // 新活动入库（可能影响详情页展示），失效该商品活动列表缓存
        evictActivityListCache(activity.getProductId());
        return activity.getId();
    }

    @Override
    @Transactional
    public void updateActivity(GroupBuyActivitySaveDTO dto, Long merchantId) {
        GroupBuyActivity activity = activityMapper.selectById(dto.getId());
        if (activity == null) {
            throw new BusinessException("拼团活动不存在");
        }
        if (!merchantId.equals(activity.getMerchantId())) {
            throw new BusinessException("无权操作该活动");
        }
        if (activity.getStatus() == GroupBuyActivity.STATUS_ONGOING) {
            throw new BusinessException("进行中的活动不可编辑，请先暂停");
        }
        // 重新校验归属（商品可能被更换）
        Product product = productMapper.selectById(dto.getProductId());
        if (product == null || !merchantId.equals(product.getMerchantId())) {
            throw new BusinessException("商品无效");
        }
        if (dto.getSkuId() != null) {
            ProductSku sku = productSkuMapper.selectById(dto.getSkuId());
            if (sku == null || !sku.getProductId().equals(dto.getProductId())) {
                throw new BusinessException("商品规格无效");
            }
        }

        // ============ 新增：更新时库存预检 ============
        validateStockOnUpdate(activity, dto);

        GroupBuyActivity update = new GroupBuyActivity();
        BeanUtils.copyProperties(dto, update);
        update.setMerchantId(merchantId);
        activityMapper.updateById(update);
        // 活动/商品变更，失效新旧商品的活动列表缓存
        evictActivityListCache(activity.getProductId());
        evictActivityListCache(dto.getProductId());
    }

    /**
     * 创建活动时库存预检（温和拦截）
     * - 有规格：校验规格库存是否 >= 目标人数
     * - 无规格：校验商品总库存是否 >= 目标人数
     */
    private void validateStockOnCreate(GroupBuyActivitySaveDTO dto) {
        if (dto.getSkuId() != null) {
            ProductSku sku = productSkuMapper.selectById(dto.getSkuId());
            if (sku == null) {
                throw new BusinessException("商品规格不存在");
            }
            if (sku.getStock() == null || sku.getStock() < dto.getTargetCount()) {
                throw new BusinessException(
                        String.format("规格库存不足（当前库存：%d，成团需：%d件），无法创建拼团活动",
                                sku.getStock() == null ? 0 : sku.getStock(),
                                dto.getTargetCount())
                );
            }
        } else {
            Product product = productMapper.selectById(dto.getProductId());
            if (product == null) {
                throw new BusinessException("商品不存在");
            }
            if (product.getStock() == null || product.getStock() < dto.getTargetCount()) {
                throw new BusinessException(
                        String.format("商品库存不足（当前库存：%d，成团需：%d件），无法创建拼团活动",
                                product.getStock() == null ? 0 : product.getStock(),
                                dto.getTargetCount())
                );
            }
        }
    }

    /**
     * 更新活动时库存预检
     * - 草稿/暂停状态可编辑，校验当前库存是否 >= 目标人数
     * - 若目标人数被调大，需要校验库存是否足够
     */
    private void validateStockOnUpdate(GroupBuyActivity existing, GroupBuyActivitySaveDTO dto) {
        // 只有修改了 targetCount 或 更换了商品/规格 才重新校验
        boolean targetChanged = !existing.getTargetCount().equals(dto.getTargetCount());
        boolean productChanged = !existing.getProductId().equals(dto.getProductId());
        boolean skuChanged = (existing.getSkuId() == null && dto.getSkuId() != null)
                || (existing.getSkuId() != null && !existing.getSkuId().equals(dto.getSkuId()));

        if (!targetChanged && !productChanged && !skuChanged) {
            return; // 库存相关字段未变，无需校验
        }

        if (dto.getSkuId() != null) {
            ProductSku sku = productSkuMapper.selectById(dto.getSkuId());
            if (sku == null) {
                throw new BusinessException("商品规格不存在");
            }
            if (sku.getStock() == null || sku.getStock() < dto.getTargetCount()) {
                throw new BusinessException(
                        String.format("规格库存不足（当前库存：%d，成团需：%d件），请调整成团人数或补充库存",
                                sku.getStock() == null ? 0 : sku.getStock(),
                                dto.getTargetCount())
                );
            }
        } else {
            Product product = productMapper.selectById(dto.getProductId());
            if (product == null) {
                throw new BusinessException("商品不存在");
            }
            if (product.getStock() == null || product.getStock() < dto.getTargetCount()) {
                throw new BusinessException(
                        String.format("商品库存不足（当前库存：%d，成团需：%d件），请调整成团人数或补充库存",
                                product.getStock() == null ? 0 : product.getStock(),
                                dto.getTargetCount())
                );
            }
        }
    }

    @Override
    @Transactional
    public void changeActivityStatus(Long id, Integer status, Long merchantId) {
        GroupBuyActivity activity = activityMapper.selectById(id);
        if (activity == null) {
            throw new BusinessException("拼团活动不存在");
        }
        if (!merchantId.equals(activity.getMerchantId())) {
            throw new BusinessException("无权操作该活动");
        }
        if (status == GroupBuyActivity.STATUS_TERMINATED) {
            // 终止：对活动所有进行中团执行失败退款
            activity.setStatus(GroupBuyActivity.STATUS_TERMINATED);
            activityMapper.updateById(activity);
            evictActivityListCache(activity.getProductId());
            failAllActiveGroups(activity.getId(), GroupBuyGroup.STATUS_CANCELLED, "拼团活动已被商家终止，已退款");
            log.info("商家终止拼团活动 activityId={}, merchantId={}", id, merchantId);
            return;
        }
        if (status != GroupBuyActivity.STATUS_ONGOING && status != GroupBuyActivity.STATUS_PAUSED) {
            throw new BusinessException("不支持的状态变更");
        }
        // 草稿/暂停 → 进行中；进行中 → 暂停
        activity.setStatus(status);
        activityMapper.updateById(activity);
        // 活动状态变化，失效该商品活动列表缓存
        evictActivityListCache(activity.getProductId());
    }

    @Override
    public Page<GroupBuyActivityVO> merchantPage(Long merchantId, Integer pageNum, Integer pageSize, String keyword) {
        return pageQuery(pageNum, pageSize, keyword, merchantId);
    }

    // ==================== 管理端 ====================

    @Override
    public Page<GroupBuyActivityVO> adminPage(Integer pageNum, Integer pageSize, String keyword) {
        return pageQuery(pageNum, pageSize, keyword, null);
    }

    @Override
    @Transactional
    public void adminCancelActivity(Long id) {
        GroupBuyActivity activity = activityMapper.selectById(id);
        if (activity == null) {
            throw new BusinessException("拼团活动不存在");
        }
        if (activity.getStatus() == GroupBuyActivity.STATUS_TERMINATED) {
            throw new BusinessException("活动已终止");
        }
        activity.setStatus(GroupBuyActivity.STATUS_TERMINATED);
        activityMapper.updateById(activity);
        evictActivityListCache(activity.getProductId());
        failAllActiveGroups(activity.getId(), GroupBuyGroup.STATUS_CANCELLED, "拼团活动因故被取消，已自动退款");
        log.info("管理员取消拼团活动 activityId={}", id);
    }

    // ==================== 定时任务 ====================

    /**
     * 每分钟扫描超时未成团的团，执行失败退款
     */
    @Override
    @Scheduled(cron = "0 * * * * *")
    public void failExpiredGroups() {
        try {
            groupMapper.selectCount(new LambdaQueryWrapper<GroupBuyGroup>().last("limit 1"));
        } catch (Exception e) {
            return; // 表不存在时静默，避免未建表频繁报错
        }
        List<GroupBuyGroup> expired = groupMapper.selectList(
                new LambdaQueryWrapper<GroupBuyGroup>()
                        .eq(GroupBuyGroup::getStatus, GroupBuyGroup.STATUS_ACTIVE)
                        .lt(GroupBuyGroup::getExpireTime, LocalDateTime.now()));
        for (GroupBuyGroup g : expired) {
            try {
                failGroupWithRefund(g.getId(), GroupBuyGroup.STATUS_FAILED, "拼团超时未成团，已自动退款");
            } catch (Exception e) {
                log.error("拼团超时失败处理异常 groupId={}", g.getId(), e);
            }
        }
    }

    // ==================== 内部逻辑 ====================

    /** 活动有效性校验 */
    private void validateActivity(GroupBuyActivity activity) {
        if (activity.getStatus() != GroupBuyActivity.STATUS_ONGOING) {
            throw new BusinessException("拼团活动未在进行中");
        }
        LocalDateTime now = LocalDateTime.now();
        if (now.isBefore(activity.getStartTime()) || now.isAfter(activity.getEndTime())) {
            throw new BusinessException("拼团活动不在有效期内");
        }
    }

    /**
     * 活动维度参与唯一性校验：一人一活动仅可参与一次。
     * 仅统计「进行中（STATUS_ACTIVE）」的团——成团/失败/取消后团非进行中，资格自动释放，
     * 用户可再次参与（例如拼团失败退款后可重新发起）。
     */
    private void validateNotJoined(GroupBuyActivity activity, Long userId) {
        List<GroupBuyGroup> activeGroups = groupMapper.selectList(
                new LambdaQueryWrapper<GroupBuyGroup>()
                        .eq(GroupBuyGroup::getActivityId, activity.getId())
                        .eq(GroupBuyGroup::getStatus, GroupBuyGroup.STATUS_ACTIVE));
        if (activeGroups.isEmpty()) {
            return;
        }
        List<Long> groupIds = activeGroups.stream().map(GroupBuyGroup::getId).collect(Collectors.toList());
        Long cnt = memberMapper.selectCount(new LambdaQueryWrapper<GroupBuyMember>()
                .in(GroupBuyMember::getGroupId, groupIds)
                .eq(GroupBuyMember::getUserId, userId));
        if (cnt != null && cnt > 0) {
            throw new BusinessException("您已参与该拼团活动");
        }
    }

    /** 只读解析活动绑定的 SKU（无规格为 null）；下单时不扣库存 */
    private ProductSku resolveSku(GroupBuyActivity activity) {
        if (activity.getSkuId() == null) {
            return null;
        }
        ProductSku sku = productSkuMapper.selectById(activity.getSkuId());
        if (sku == null) {
            throw new BusinessException("商品规格不存在");
        }
        return sku;
    }

    /**
     * 成团时原子扣减库存：商品/SKU 库存 targetCount 份 + 活动成团名额 1 份。
     * 任一不足则抛异常并回滚已扣部分（先扣商品，后占名额；名额不足回滚商品），由调用方整团失败退款。
     */
    private void deductStockOnGroupSuccess(GroupBuyActivity activity) {
        int n = activity.getTargetCount();
        if (activity.getSkuId() != null) {
            ProductSku sku = productSkuMapper.selectById(activity.getSkuId());
            if (sku == null || productSkuMapper.deductStock(sku.getId(), n) == 0) {
                throw new BusinessException("商品库存不足，成团失败");
            }
            syncProductStock(sku.getProductId());
        } else {
            if (productMapper.deductStock(activity.getProductId(), n) == 0) {
                throw new BusinessException("商品库存不足，成团失败");
            }
        }
        // 商品库存扣减成功后再占活动成团名额（每成功一个团扣 1）
        if (activityMapper.deductStock(activity.getId(), 1) == 0) {
            restoreProductStock(activity, n);
            throw new BusinessException("活动成团名额已用完");
        }
        // 清除商品详情缓存，避免详情页展示旧库存
        stringRedisTemplate.delete("product:detail:" + activity.getProductId());
    }

    /** 成团名额不足时回滚已扣的商品/SKU 库存 */
    private void restoreProductStock(GroupBuyActivity activity, int n) {
        if (activity.getSkuId() != null) {
            ProductSku sku = productSkuMapper.selectById(activity.getSkuId());
            if (sku != null) {
                sku.setStock(sku.getStock() + n);
                productSkuMapper.updateById(sku);
                syncProductStock(sku.getProductId());
            }
        } else {
            Product p = productMapper.selectById(activity.getProductId());
            if (p != null) {
                p.setStock(p.getStock() + n);
                productMapper.updateById(p);
            }
        }
        stringRedisTemplate.delete("product:detail:" + activity.getProductId());
    }

    /** SKU 扣减后回写商品总库存 */
    private void syncProductStock(Long productId) {
        List<ProductSku> skuList = productSkuMapper.selectList(
                new LambdaQueryWrapper<ProductSku>().eq(ProductSku::getProductId, productId));
        if (skuList.isEmpty()) {
            return;
        }
        int total = skuList.stream()
                .filter(s -> s.getStock() != null)
                .mapToInt(ProductSku::getStock)
                .sum();
        Product prod = productMapper.selectById(productId);
        if (prod != null) {
            prod.setStock(total);
            productMapper.updateById(prod);
        }
    }

    /** 校验收货地址归属 */
    private Address getValidAddress(Long addressId, Long userId) {
        if (addressId == null) {
            throw new BusinessException("请选择收货地址");
        }
        Address address = addressMapper.selectById(addressId);
        if (address == null || !address.getUserId().equals(userId)) {
            throw new BusinessException("收货地址无效");
        }
        return address;
    }

    /** 创建拼团订单（单商品、数量1、拼团价、type=2、待付款） */
    private Order createGroupOrder(GroupBuyActivity activity, Product product, ProductSku sku,
                                   Long userId, Address address) {
        BigDecimal price = activity.getGroupPrice();
        String orderNo = System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8);
        String receiverAddress = (address.getProvince() == null ? "" : address.getProvince())
                + (address.getCity() == null ? "" : address.getCity())
                + (address.getDistrict() == null ? "" : address.getDistrict())
                + (address.getDetailAddress() == null ? "" : address.getDetailAddress());

        Order order = new Order();
        order.setOrderNo(orderNo);
        order.setUserId(userId);
        order.setTotalAmount(price);
        order.setPayAmount(price);
        order.setOrderStatus(0); // 待付款
        order.setType(Order.ORDER_TYPE_GROUP_BUY);
        order.setReceiverName(address.getReceiverName());
        order.setReceiverPhone(address.getReceiverPhone());
        order.setReceiverAddress(receiverAddress);
        orderMapper.insert(order);

        OrderShipment shipment = new OrderShipment();
        shipment.setOrderId(order.getId());
        shipment.setSellerId(product.getMerchantId());
        shipment.setDeliveryStatus(0);
        shipment.setTotalAmount(price);
        orderShipmentMapper.insert(shipment);

        OrderItem item = new OrderItem();
        item.setOrderId(order.getId());
        item.setShipmentId(shipment.getId());
        item.setProductId(product.getId());
        item.setSkuId(sku != null ? sku.getId() : null);
        if (sku != null && sku.getSpecs() != null) {
            try {
                @SuppressWarnings("unchecked")
                Map<String, Object> specsMap = objectMapper.readValue(sku.getSpecs(), Map.class);
                item.setSkuSpecs(specsMap.entrySet().stream()
                        .map(e -> e.getKey() + ":" + e.getValue())
                        .collect(Collectors.joining(", ")));
            } catch (Exception e) {
                item.setSkuSpecs(sku.getSpecs());
            }
        }
        item.setProductName(product.getName());
        item.setProductImage(product.getCoverImage());
        item.setPrice(price);
        item.setQuantity(1);
        orderItemMapper.insert(item);

        // 通知商家（失败不影响下单结果）
        try {
            noticeService.createAndPublish("新订单通知", "您有新的拼团订单，订单号：" + orderNo, 3,
                    product.getMerchantId(), "new_order", order.getId());
        } catch (Exception e) {
            log.warn("拼团订单商家通知失败 orderNo={}", orderNo, e);
        }
        return order;
    }

    /** 插入成员记录 */
    private void insertMember(Long groupId, Long userId, Long orderId, int role) {
        GroupBuyMember member = new GroupBuyMember();
        member.setGroupId(groupId);
        member.setUserId(userId);
        member.setOrderId(orderId);
        member.setRole(role);
        member.setPayStatus(GroupBuyMember.PAY_PENDING);
        memberMapper.insert(member);
    }

    /** 生成团号 */
    private String generateGroupNo() {
        return "T" + System.currentTimeMillis() + (int) (Math.random() * 900 + 100);
    }

    /** 活动分页查询（merchantId 为空=管理端） */
    private Page<GroupBuyActivityVO> pageQuery(Integer pageNum, Integer pageSize, String keyword, Long merchantId) {
        LambdaQueryWrapper<GroupBuyActivity> wrapper = new LambdaQueryWrapper<>();
        if (merchantId != null) {
            wrapper.eq(GroupBuyActivity::getMerchantId, merchantId);
        }
        if (keyword != null && !keyword.isBlank()) {
            List<Long> productIds = productMapper.selectList(
                            new LambdaQueryWrapper<Product>().like(Product::getName, keyword))
                    .stream().map(Product::getId).collect(Collectors.toList());
            if (productIds.isEmpty()) {
                return new Page<>(pageNum, pageSize);
            }
            wrapper.in(GroupBuyActivity::getProductId, productIds);
        }
        wrapper.orderByDesc(GroupBuyActivity::getId);
        Page<GroupBuyActivity> page = activityMapper.selectPage(new Page<>(pageNum, pageSize), wrapper);
        Page<GroupBuyActivityVO> voPage = new Page<>(pageNum, pageSize, page.getTotal());
        voPage.setRecords(page.getRecords().stream()
                .map(a -> toActivityVO(a, null, true))
                .collect(Collectors.toList()));
        return voPage;
    }

    /** 活动转 VO（withGroups 控制是否携带进行中团列表） */
    private GroupBuyActivityVO toActivityVO(GroupBuyActivity a, Long currentUserId, boolean withGroups) {
        GroupBuyActivityVO vo = new GroupBuyActivityVO();
        vo.setId(a.getId());
        vo.setProductId(a.getProductId());
        vo.setSkuId(a.getSkuId());
        vo.setGroupPrice(a.getGroupPrice());
        vo.setTargetCount(a.getTargetCount());
        vo.setDurationHours(a.getDurationHours());
        vo.setStartTime(a.getStartTime());
        vo.setEndTime(a.getEndTime());
        vo.setTotalStock(a.getTotalStock());
        vo.setStatus(a.getStatus());

        Product product = productMapper.selectById(a.getProductId());
        if (product != null) {
            vo.setProductName(product.getName());
            vo.setCoverImage(product.getCoverImage());
            vo.setOriginalPrice(a.getSkuId() != null
                    ? Optional.ofNullable(productSkuMapper.selectById(a.getSkuId())).map(ProductSku::getPrice).orElse(product.getPrice())
                    : product.getPrice());
            if (a.getSkuId() != null) {
                ProductSku sku = productSkuMapper.selectById(a.getSkuId());
                if (sku != null && sku.getSpecs() != null) {
                    try {
                        @SuppressWarnings("unchecked")
                        Map<String, Object> specsMap = objectMapper.readValue(sku.getSpecs(), Map.class);
                        vo.setSkuSpecs(specsMap.entrySet().stream()
                                .map(e -> e.getKey() + ":" + e.getValue())
                                .collect(Collectors.joining(", ")));
                    } catch (Exception e) {
                        vo.setSkuSpecs(sku.getSpecs());
                    }
                }
            }
        }
        if (withGroups) {
            List<GroupBuyGroup> groups = groupMapper.selectList(
                    new LambdaQueryWrapper<GroupBuyGroup>()
                            .eq(GroupBuyGroup::getActivityId, a.getId())
                            .eq(GroupBuyGroup::getStatus, GroupBuyGroup.STATUS_ACTIVE)
                            .gt(GroupBuyGroup::getExpireTime, LocalDateTime.now())
                            .orderByAsc(GroupBuyGroup::getExpireTime)
                            .last("limit 20"));
            vo.setActiveGroups(groups.stream()
                    .map(g -> toGroupVO(g, a, currentUserId))
                    .collect(Collectors.toList()));
        }
        return vo;
    }

    /** 团转 VO（单条版：内部按需查询成员与用户，供活动详情等低频场景使用） */
    private GroupBuyGroupVO toGroupVO(GroupBuyGroup g, GroupBuyActivity a, Long currentUserId) {
        List<GroupBuyMember> members = memberMapper.selectList(
                new LambdaQueryWrapper<GroupBuyMember>()
                        .eq(GroupBuyMember::getGroupId, g.getId())
                        .orderByAsc(GroupBuyMember::getId));
        Set<Long> userIds = new HashSet<>();
        if (g.getLeaderId() != null) {
            userIds.add(g.getLeaderId());
        }
        members.forEach(m -> userIds.add(m.getUserId()));
        Map<Long, User> userMap = userIds.isEmpty() ? Collections.emptyMap()
                : toMapById(userMapper.selectBatchIds(userIds), User::getId);
        return toGroupVO(g, a, currentUserId, members, userMap);
    }

    /** 团转 VO（批量版：成员列表与用户表由调用方一次性查出，消除列表场景 N+1） */
    private GroupBuyGroupVO toGroupVO(GroupBuyGroup g, GroupBuyActivity a, Long currentUserId,
                                      List<GroupBuyMember> members, Map<Long, User> userMap) {
        GroupBuyGroupVO vo = new GroupBuyGroupVO();
        vo.setId(g.getId());
        vo.setGroupNo(g.getGroupNo());
        vo.setActivityId(g.getActivityId());
        vo.setProductId(a.getProductId());
        vo.setSkuId(a.getSkuId());
        vo.setGroupPrice(a.getGroupPrice());
        vo.setStatus(g.getStatus());
        vo.setTargetCount(a.getTargetCount());
        vo.setExpireTime(g.getExpireTime());

        // 参与人数 = 团内成员总数（含待支付成员：开团人下单即占位；成团判定仍以「已支付人数」为准，见 onOrderPaid）
        int memberCount = members == null ? 0 : members.size();
        vo.setMemberCount(memberCount);
        vo.setProgress((int) Math.min(100, memberCount * 100.0 / a.getTargetCount()));
        vo.setRemainSeconds(Math.max(0, Duration.between(LocalDateTime.now(), g.getExpireTime()).getSeconds()));

        // 开团人匿名信息
        User leader = userMap == null ? null : userMap.get(g.getLeaderId());
        if (leader != null) {
            vo.setLeaderMask(maskName(leader));
            vo.setLeaderAvatar(leader.getAvatar());
        }

        // 成员头像（含待支付成员，与 memberCount「成员总数」口径一致；最多前 8 个）
        List<String> avatars = new ArrayList<>();
        if (members != null) {
            for (int i = 0; i < Math.min(8, members.size()); i++) {
                User u = userMap == null ? null : userMap.get(members.get(i).getUserId());
                avatars.add(u != null ? u.getAvatar() : null);
            }
        }
        vo.setMemberAvatars(avatars);

        vo.setIsJoined(currentUserId != null && members != null
                && members.stream().anyMatch(m -> m.getUserId().equals(currentUserId)));
        return vo;
    }

    /** 用户匿名化（手机号/昵称脱敏） */
    private String maskName(User user) {
        String name = user.getNickname() != null && !user.getNickname().isBlank()
                ? user.getNickname() : user.getUsername();
        if (name == null || name.isBlank()) {
            return "神秘用户";
        }
        if (name.matches("\\d{11}")) {
            return "用户 " + name.substring(0, 3) + "****" + name.substring(7);
        }
        if (name.length() <= 2) {
            return name + "***";
        }
        return "用户 " + name.substring(0, 1) + "***" + name.substring(name.length() - 1);
    }

    /** 对活动所有进行中团执行失败退款（活动终止/管理员取消） */
    private void failAllActiveGroups(Long activityId, int finalStatus, String reason) {
        List<GroupBuyGroup> groups = groupMapper.selectList(
                new LambdaQueryWrapper<GroupBuyGroup>()
                        .eq(GroupBuyGroup::getActivityId, activityId)
                        .eq(GroupBuyGroup::getStatus, GroupBuyGroup.STATUS_ACTIVE));
        for (GroupBuyGroup g : groups) {
            try {
                failGroupWithRefund(g.getId(), finalStatus, reason);
            } catch (Exception e) {
                log.error("拼团活动取消，团失败退款异常 groupId={}", g.getId(), e);
            }
        }
    }

    /**
     * 团失败处理：先对已支付成员退款（幂等），再条件更新团状态，最后回滚活动库存
     * 注意：由定时任务/活动取消内部自调用，@Transactional 不生效，
     * 因此采用「先退款后置状态 + 条件更新防并发」，退款幂等、失败可重跑
     */
    public void failGroupWithRefund(Long groupId, int finalStatus, String reason) {
        GroupBuyGroup group = groupMapper.selectById(groupId);
        if (group == null || group.getStatus() != GroupBuyGroup.STATUS_ACTIVE) {
            return;
        }

        // 1. 团内成员：已支付的原路退款（幂等）+ 通知
        List<GroupBuyMember> members = memberMapper.selectList(
                new LambdaQueryWrapper<GroupBuyMember>().eq(GroupBuyMember::getGroupId, groupId));
        for (GroupBuyMember m : members) {
            if (m.getPayStatus() == GroupBuyMember.PAY_PAID) {
                try {
                    refundGroupOrder(m.getOrderId(), group.getGroupNo());
                } catch (Exception e) {
                    log.error("拼团失败退款异常 orderId={}, groupId={}", m.getOrderId(), groupId, e);
                }
            }
            notifyQuietly("拼团失败", reason + "。团号：" + group.getGroupNo(), m.getUserId(), "groupbuy_failed", groupId);
        }

        // 2. 条件更新团状态（仅 ACTIVE → finalStatus），防止定时任务与活动取消并发重复处理
        LambdaUpdateWrapper<GroupBuyGroup> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(GroupBuyGroup::getId, groupId)
                .eq(GroupBuyGroup::getStatus, GroupBuyGroup.STATUS_ACTIVE)
                .set(GroupBuyGroup::getStatus, finalStatus);
        groupMapper.update(null, wrapper);

        // 3. 库存无需回滚：下单不扣库存（成团才扣），成团扣库存失败场景已在 deductStockOnGroupSuccess 内自愈回滚
        stringRedisTemplate.delete(COUNT_KEY_PREFIX + groupId);

        // 团状态变化（进行中→失败/取消），失效该商品活动列表缓存
        GroupBuyActivity activity = activityMapper.selectById(group.getActivityId());
        if (activity != null) {
            evictActivityListCache(activity.getProductId());
        }
        log.info("拼团失败处理完成 groupId={}, groupNo={}, status={}, members={}",
                groupId, group.getGroupNo(), finalStatus, members.size());
    }

    /** 拼团失败退款：订单置已退款 + 回退支付时累加的销量 + 更新支付记录。
     *  注意：未成团时从未扣过商品/SKU 库存（成团才扣），故此处不操作库存。 */
    private void refundGroupOrder(Long orderId, String groupNo) {
        Order order = orderMapper.selectById(orderId);
        if (order == null || order.getOrderStatus() == Order.STATUS_REFUNDED) {
            return;
        }
        order.setOrderStatus(Order.STATUS_REFUNDED);
        orderMapper.updateById(order);

        List<OrderItem> items = orderItemMapper.selectList(
                new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, orderId));
        Set<Long> affected = new HashSet<>();
        for (OrderItem item : items) {
            if (item.getSkuId() != null) {
                ProductSku sku = productSkuMapper.selectById(item.getSkuId());
                if (sku != null) {
                    sku.setSales(Math.max(0, (sku.getSales() == null ? 0 : sku.getSales()) - item.getQuantity()));
                    productSkuMapper.updateById(sku);
                }
            } else {
                Product p = productMapper.selectById(item.getProductId());
                if (p != null) {
                    p.setSales(Math.max(0, (p.getSales() == null ? 0 : p.getSales()) - item.getQuantity()));
                    productMapper.updateById(p);
                }
            }
            affected.add(item.getProductId());
        }
        for (Long pid : affected) {
            List<ProductSku> skuList = productSkuMapper.selectList(
                    new LambdaQueryWrapper<ProductSku>().eq(ProductSku::getProductId, pid));
            if (!skuList.isEmpty()) {
                int totalSales = skuList.stream().filter(s -> s.getSales() != null).mapToInt(ProductSku::getSales).sum();
                Product p = productMapper.selectById(pid);
                if (p != null) {
                    p.setSales(totalSales);
                    productMapper.updateById(p);
                }
            }
            stringRedisTemplate.delete("product:detail:" + pid);
        }

        // 更新支付记录为已退款
        PaymentRecord payRecord = paymentRecordMapper.selectOne(
                new LambdaQueryWrapper<PaymentRecord>()
                        .eq(PaymentRecord::getOrderId, orderId)
                        .eq(PaymentRecord::getStatus, 1));
        if (payRecord != null) {
            payRecord.setStatus(2);
            payRecord.setRefundTime(LocalDateTime.now());
            paymentRecordMapper.updateById(payRecord);
        }

        notifyQuietly("拼团失败退款", "您的拼团订单 " + order.getOrderNo()
                        + " 已退款 " + order.getPayAmount() + " 元（团号：" + groupNo + "）",
                order.getUserId(), "groupbuy_failed", orderId);
    }

    /** 静默发通知，失败仅记录日志 */
    private void notifyQuietly(String title, String content, Long userId, String bizType, Long bizId) {
        try {
            noticeService.createAndPublish(title, content, 3, userId, bizType, bizId);
        } catch (Exception e) {
            log.warn("拼团通知发送失败 title={}, userId={}", title, userId, e);
        }
    }
}
