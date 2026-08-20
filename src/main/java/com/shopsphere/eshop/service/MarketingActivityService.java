package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.MarketingActivitySaveDTO;
import com.shopsphere.eshop.vo.MarketingActivityVO;

import java.util.List;

/**
 * 平台营销活动服务（通用任务制：签到/下单/收藏，达标发优惠券）
 */
public interface MarketingActivityService {

    // ==================== 管理端 ====================

    Page<MarketingActivityVO> pageQuery(Integer pageNum, Integer pageSize, String keyword, Integer status);

    MarketingActivityVO getById(Long id);

    void add(MarketingActivitySaveDTO dto);

    void update(MarketingActivitySaveDTO dto);

    void delete(Long id);

    void changeStatus(Long id, Integer status);

    // ==================== 用户端 ====================

    /** 进行中活动列表（含用户任务进度，userId 为空则游客仅看基本信息） */
    List<MarketingActivityVO> listActive(Long userId);

    /** 活动详情（含任务与用户进度） */
    MarketingActivityVO getDetail(Long id, Long userId);

    /** 领取任务奖励（达标且未领取时发券） */
    void claimReward(Long userId, Long activityId, Long taskId);
}
