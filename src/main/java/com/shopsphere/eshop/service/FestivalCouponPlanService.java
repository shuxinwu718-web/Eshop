package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.FestivalCouponPlanDTO;
import com.shopsphere.eshop.vo.FestivalCouponPlanVO;

/**
 * 节日优惠券活动计划 管理端业务
 */
public interface FestivalCouponPlanService {

    Page<FestivalCouponPlanVO> pageQuery(Integer pageNum, Integer pageSize, String keyword, Integer status);

    FestivalCouponPlanVO getById(Long id);

    void addPlan(FestivalCouponPlanDTO dto);

    void updatePlan(FestivalCouponPlanDTO dto);

    void deletePlan(Long id);

    void changeStatus(Long id, Integer status);
}
