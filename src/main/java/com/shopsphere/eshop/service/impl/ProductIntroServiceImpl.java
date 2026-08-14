package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.entity.ProductIntroVersion;
import com.shopsphere.eshop.entity.User;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.ProductIntroVersionMapper;
import com.shopsphere.eshop.mapper.ProductMapper;
import com.shopsphere.eshop.mapper.UserMapper;
import com.shopsphere.eshop.service.ProductIntroService;
import com.shopsphere.eshop.vo.IntroAuditVO;
import com.shopsphere.eshop.vo.IntroVersionVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductIntroServiceImpl implements ProductIntroService {

    /** 状态常量 */
    private static final int STATUS_DRAFT = 0;
    private static final int STATUS_PENDING = 1;
    private static final int STATUS_APPROVED = 2;
    private static final int STATUS_REJECTED = 3;

    private static final String CACHE_PRODUCT_DETAIL = "product:detail:";

    private final ProductIntroVersionMapper introVersionMapper;
    private final ProductMapper productMapper;
    private final UserMapper userMapper;
    private final StringRedisTemplate stringRedisTemplate;

    @Override
    public String getEditContent(Long productId, Long merchantId) {
        Product product = checkOwnership(productId, merchantId);
        // 草稿优先 → 驳回 → 已通过
        ProductIntroVersion draft = latestByStatus(productId, STATUS_DRAFT);
        if (draft != null) return draft.getContent();
        ProductIntroVersion rejected = latestByStatus(productId, STATUS_REJECTED);
        if (rejected != null) return rejected.getContent();
        ProductIntroVersion approved = latestByStatus(productId, STATUS_APPROVED);
        if (approved != null) return approved.getContent();
        // 无历史版本：返回商品当前描述（可能为空）
        return product.getDescription() == null ? "" : product.getDescription();
    }

    @Override
    public void saveDraft(Long productId, Long merchantId, String content) {
        checkOwnership(productId, merchantId);
        ProductIntroVersion draft = latestByStatus(productId, STATUS_DRAFT);
        if (draft != null) {
            draft.setContent(content);
            introVersionMapper.updateById(draft);
        } else {
            ProductIntroVersion v = new ProductIntroVersion();
            v.setProductId(productId);
            v.setVersionNo(0);
            v.setContent(content);
            v.setStatus(STATUS_DRAFT);
            introVersionMapper.insert(v);
        }
    }

    @Override
    public void submitForAudit(Long productId, Long merchantId, String content) {
        checkOwnership(productId, merchantId);
        // 存在待审核版本则覆盖（管理端看到最新内容），否则新建版本号+1
        ProductIntroVersion pending = latestByStatus(productId, STATUS_PENDING);
        if (pending != null) {
            pending.setContent(content);
            pending.setAuditRemark(null);
            introVersionMapper.updateById(pending);
            return;
        }
        Integer maxVersion = introVersionMapper.selectList(
                        new LambdaQueryWrapper<ProductIntroVersion>().eq(ProductIntroVersion::getProductId, productId))
                .stream()
                .map(ProductIntroVersion::getVersionNo)
                .max(Integer::compareTo)
                .orElse(0);
        ProductIntroVersion v = new ProductIntroVersion();
        v.setProductId(productId);
        v.setVersionNo(maxVersion + 1);
        v.setContent(content);
        v.setStatus(STATUS_PENDING);
        introVersionMapper.insert(v);
    }

    @Override
    public Page<IntroVersionVO> getVersions(Long productId, Long merchantId, Integer pageNum, Integer pageSize) {
        checkOwnership(productId, merchantId);
        Page<ProductIntroVersion> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ProductIntroVersion> wrapper = new LambdaQueryWrapper<ProductIntroVersion>()
                .eq(ProductIntroVersion::getProductId, productId)
                .orderByDesc(ProductIntroVersion::getVersionNo)
                .orderByDesc(ProductIntroVersion::getId);
        Page<ProductIntroVersion> versionPage = introVersionMapper.selectPage(page, wrapper);
        Page<IntroVersionVO> voPage = new Page<>(pageNum, pageSize, versionPage.getTotal());
        voPage.setRecords(versionPage.getRecords().stream().map(v -> {
            IntroVersionVO vo = new IntroVersionVO();
            BeanUtils.copyProperties(v, vo);
            return vo;
        }).collect(Collectors.toList()));
        return voPage;
    }

    @Override
    public IntroVersionVO getVersionDetail(Long id, Long merchantId) {
        ProductIntroVersion v = introVersionMapper.selectById(id);
        if (v == null) {
            throw new BusinessException("版本不存在");
        }
        checkOwnership(v.getProductId(), merchantId);
        IntroVersionVO vo = new IntroVersionVO();
        BeanUtils.copyProperties(v, vo);
        return vo;
    }

    @Override
    public void restoreVersion(Long id, Long merchantId) {
        ProductIntroVersion v = introVersionMapper.selectById(id);
        if (v == null) {
            throw new BusinessException("版本不存在");
        }
        checkOwnership(v.getProductId(), merchantId);
        // 内容回填为当前草稿
        ProductIntroVersion draft = latestByStatus(v.getProductId(), STATUS_DRAFT);
        if (draft != null) {
            draft.setContent(v.getContent());
            introVersionMapper.updateById(draft);
        } else {
            ProductIntroVersion d = new ProductIntroVersion();
            d.setProductId(v.getProductId());
            d.setVersionNo(0);
            d.setContent(v.getContent());
            d.setStatus(STATUS_DRAFT);
            introVersionMapper.insert(d);
        }
    }

    @Override
    public Page<IntroAuditVO> pendingPage(Integer pageNum, Integer pageSize, String keyword) {
        Page<ProductIntroVersion> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<ProductIntroVersion> wrapper = new LambdaQueryWrapper<ProductIntroVersion>()
                .eq(ProductIntroVersion::getStatus, STATUS_PENDING)
                .orderByAsc(ProductIntroVersion::getCreateTime);
        // 关键字按商品名过滤：先查出商品ID集合，避免 join 分页总数失真
        if (StringUtils.hasText(keyword)) {
            List<Long> productIds = productMapper.selectList(
                            new LambdaQueryWrapper<Product>().like(Product::getName, keyword.trim()))
                    .stream().map(Product::getId).collect(Collectors.toList());
            wrapper.in(ProductIntroVersion::getProductId, productIds);
        }
        Page<ProductIntroVersion> versionPage = introVersionMapper.selectPage(page, wrapper);
        Page<IntroAuditVO> voPage = new Page<>(pageNum, pageSize, versionPage.getTotal());
        List<ProductIntroVersion> records = versionPage.getRecords();
        if (records.isEmpty()) {
            voPage.setRecords(java.util.Collections.emptyList());
            return voPage;
        }
        // 批量关联商品与商家信息
        Set<Long> productIds = records.stream().map(ProductIntroVersion::getProductId).collect(Collectors.toSet());
        Map<Long, Product> productMap = productMapper.selectBatchIds(productIds).stream()
                .collect(Collectors.toMap(Product::getId, Function.identity()));
        Set<Long> merchantIds = productMap.values().stream()
                .map(Product::getMerchantId)
                .collect(Collectors.toSet());
        Map<Long, User> userMap = merchantIds.isEmpty() ? Map.of()
                : userMapper.selectBatchIds(merchantIds).stream()
                .collect(Collectors.toMap(User::getId, Function.identity()));
        voPage.setRecords(records.stream()
                .map(v -> toAuditVO(v, productMap.get(v.getProductId()), userMap))
                .collect(Collectors.toList()));
        return voPage;
    }

    @Override
    public void audit(Long id, boolean pass, String remark) {
        ProductIntroVersion v = introVersionMapper.selectById(id);
        if (v == null) {
            throw new BusinessException("版本不存在");
        }
        if (v.getStatus() != STATUS_PENDING) {
            throw new BusinessException("该版本不在待审核状态");
        }
        if (pass) {
            v.setStatus(STATUS_APPROVED);
            v.setAuditRemark(null);
            introVersionMapper.updateById(v);
            // 审核通过：同步更新商品展示描述并清除详情缓存
            Product product = productMapper.selectById(v.getProductId());
            if (product != null) {
                product.setDescription(v.getContent());
                productMapper.updateById(product);
                stringRedisTemplate.delete(CACHE_PRODUCT_DETAIL + v.getProductId());
            }
        } else {
            if (!StringUtils.hasText(remark)) {
                throw new BusinessException("驳回时必须填写原因");
            }
            v.setStatus(STATUS_REJECTED);
            v.setAuditRemark(remark);
            introVersionMapper.updateById(v);
        }
    }

    // ==================== 私有方法 ====================

    /** 校验商品存在且归属当前商家 */
    private Product checkOwnership(Long productId, Long merchantId) {
        Product product = productMapper.selectById(productId);
        if (product == null) {
            throw new BusinessException("商品不存在");
        }
        if (merchantId == null || !merchantId.equals(product.getMerchantId())) {
            throw new BusinessException("无权操作该商品");
        }
        return product;
    }

    /** 查询指定状态的最新一条介绍版本 */
    private ProductIntroVersion latestByStatus(Long productId, int status) {
        return introVersionMapper.selectOne(
                new LambdaQueryWrapper<ProductIntroVersion>()
                        .eq(ProductIntroVersion::getProductId, productId)
                        .eq(ProductIntroVersion::getStatus, status)
                        .orderByDesc(ProductIntroVersion::getCreateTime)
                        .orderByDesc(ProductIntroVersion::getId)
                        .last("LIMIT 1"));
    }

    private IntroAuditVO toAuditVO(ProductIntroVersion v, Product product, Map<Long, User> userMap) {
        IntroAuditVO vo = new IntroAuditVO();
        BeanUtils.copyProperties(v, vo);
        vo.setSubmitTime(v.getCreateTime());
        if (product != null) {
            vo.setProductName(product.getName());
            vo.setCoverImage(product.getCoverImage());
            User merchant = product.getMerchantId() == null ? null : userMap.get(product.getMerchantId());
            if (merchant != null) {
                vo.setMerchantName(merchant.getNickname());
            }
        }
        return vo;
    }
}
