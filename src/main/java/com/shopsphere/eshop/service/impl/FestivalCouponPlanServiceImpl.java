package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.FestivalCouponPlanDTO;
import com.shopsphere.eshop.entity.Coupon;
import com.shopsphere.eshop.entity.FestivalCouponPlan;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.CouponMapper;
import com.shopsphere.eshop.mapper.FestivalCouponPlanMapper;
import com.shopsphere.eshop.service.FestivalCouponPlanService;
import com.shopsphere.eshop.vo.FestivalCouponPlanVO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FestivalCouponPlanServiceImpl implements FestivalCouponPlanService {

    private final FestivalCouponPlanMapper festivalCouponPlanMapper;
    private final CouponMapper couponMapper;

    @Override
    public Page<FestivalCouponPlanVO> pageQuery(Integer pageNum, Integer pageSize, String keyword, Integer status) {
        Page<FestivalCouponPlan> page = new Page<>(pageNum, pageSize);
        LambdaQueryWrapper<FestivalCouponPlan> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            wrapper.like(FestivalCouponPlan::getFestivalName, keyword);
        }
        if (status != null) {
            wrapper.eq(FestivalCouponPlan::getStatus, status);
        }
        wrapper.orderByDesc(FestivalCouponPlan::getCreateTime);
        Page<FestivalCouponPlan> planPage = festivalCouponPlanMapper.selectPage(page, wrapper);
        return fillCouponInfo(planPage);
    }

    @Override
    public FestivalCouponPlanVO getById(Long id) {
        FestivalCouponPlan plan = festivalCouponPlanMapper.selectById(id);
        if (plan == null) {
            throw new BusinessException("活动计划不存在");
        }
        return toVO(plan, couponMapper.selectById(plan.getCouponId()));
    }

    @Override
    public void addPlan(FestivalCouponPlanDTO dto) {
        validate(dto);
        FestivalCouponPlan plan = new FestivalCouponPlan();
        BeanUtils.copyProperties(dto, plan);
        if (plan.getStatus() == null) {
            plan.setStatus(1);
        }
        festivalCouponPlanMapper.insert(plan);
    }

    @Override
    public void updatePlan(FestivalCouponPlanDTO dto) {
        if (dto.getId() == null) {
            throw new BusinessException("活动计划ID不能为空");
        }
        FestivalCouponPlan plan = festivalCouponPlanMapper.selectById(dto.getId());
        if (plan == null) {
            throw new BusinessException("活动计划不存在");
        }
        validate(dto);
        BeanUtils.copyProperties(dto, plan);
        festivalCouponPlanMapper.updateById(plan);
    }

    @Override
    public void deletePlan(Long id) {
        festivalCouponPlanMapper.deleteById(id);
    }

    @Override
    public void changeStatus(Long id, Integer status) {
        FestivalCouponPlan plan = festivalCouponPlanMapper.selectById(id);
        if (plan == null) {
            throw new BusinessException("活动计划不存在");
        }
        plan.setStatus(status);
        festivalCouponPlanMapper.updateById(plan);
    }

    private void validate(FestivalCouponPlanDTO dto) {
        if (dto.getStartDate().isAfter(dto.getEndDate())) {
            throw new BusinessException("开始日期不能晚于结束日期");
        }
        if (dto.getRequiredSigninDays() == null || dto.getRequiredSigninDays() < 1) {
            throw new BusinessException("所需签到天数至少为 1 天");
        }
        Coupon coupon = couponMapper.selectById(dto.getCouponId());
        if (coupon == null) {
            throw new BusinessException("关联的优惠券不存在");
        }
    }

    /** 批量填充关联优惠券信息（管理端列表一次 IN 查询，避免 N+1） */
    private Page<FestivalCouponPlanVO> fillCouponInfo(Page<FestivalCouponPlan> planPage) {
        List<FestivalCouponPlan> plans = planPage.getRecords();
        Page<FestivalCouponPlanVO> voPage = new Page<>(planPage.getCurrent(), planPage.getSize(), planPage.getTotal());
        if (plans.isEmpty()) {
            voPage.setRecords(java.util.Collections.emptyList());
            return voPage;
        }
        Set<Long> couponIds = plans.stream().map(FestivalCouponPlan::getCouponId).collect(Collectors.toSet());
        Map<Long, Coupon> couponMap = couponMapper.selectBatchIds(couponIds).stream()
                .collect(Collectors.toMap(Coupon::getId, Function.identity()));
        voPage.setRecords(plans.stream()
                .map(p -> toVO(p, couponMap.get(p.getCouponId())))
                .collect(Collectors.toList()));
        return voPage;
    }

    private FestivalCouponPlanVO toVO(FestivalCouponPlan plan, Coupon coupon) {
        FestivalCouponPlanVO vo = new FestivalCouponPlanVO();
        BeanUtils.copyProperties(plan, vo);
        if (coupon != null) {
            vo.setCouponName(coupon.getName());
            vo.setCouponType(coupon.getType());
            vo.setCouponValue(coupon.getValue());
            vo.setMinAmount(coupon.getMinAmount());
            vo.setCouponStock(coupon.getStock());
        }
        return vo;
    }
}
