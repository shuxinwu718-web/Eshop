package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.GroupBuyActivitySaveDTO;
import com.shopsphere.eshop.dto.GroupBuyOrderDTO;
import com.shopsphere.eshop.vo.GroupBuyActivityVO;
import com.shopsphere.eshop.vo.GroupBuyGroupVO;

import java.util.List;

/**
 * 拼团服务
 */
public interface GroupBuyService {

    // ==================== 用户端 ====================

    /** 商品进行中的拼团活动（含进行中团列表） */
    List<GroupBuyActivityVO> getProductActivities(Long productId, Long currentUserId);

    /** 团详情 */
    GroupBuyGroupVO getGroupDetail(Long groupId, Long currentUserId);

    /** 开团：创建拼团订单 + 建团，返回团ID */
    Long startGroup(Long activityId, GroupBuyOrderDTO dto, Long userId);

    /** 参团：创建拼团订单 + 加入团，返回团ID */
    Long joinGroup(Long groupId, GroupBuyOrderDTO dto, Long userId);

    /** 我的拼团记录 */
    List<GroupBuyGroupVO> myGroups(Long userId);

    // ==================== 订单联动（由 OrderServiceImpl 调用）====================

    /** 拼团订单支付成功：标记成员已支付 + 成团判定 */
    void onOrderPaid(Long orderId);

    /** 拼团订单取消（未支付）：释放团位与活动库存 */
    void onOrderCancelled(Long orderId);

    // ==================== 商家端 ====================

    Long createActivity(GroupBuyActivitySaveDTO dto, Long merchantId);

    void updateActivity(GroupBuyActivitySaveDTO dto, Long merchantId);

    /** 商家变更活动状态：1启动 / 2暂停 / 3终止（终止时对进行中团执行失败退款） */
    void changeActivityStatus(Long id, Integer status, Long merchantId);

    Page<GroupBuyActivityVO> merchantPage(Long merchantId, Integer pageNum, Integer pageSize, String keyword);

    // ==================== 管理端 ====================

    Page<GroupBuyActivityVO> adminPage(Integer pageNum, Integer pageSize, String keyword);

    /** 管理员取消活动（仅查看/取消权限），对进行中团执行失败退款 */
    void adminCancelActivity(Long id);

    // ==================== 定时任务 ====================

    /** 扫描超时未成团的团，执行失败退款 */
    void failExpiredGroups();
}
