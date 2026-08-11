package com.shopsphere.eshop.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 拼团团展示 VO
 */
@Data
public class GroupBuyGroupVO {
    private Long id;
    private String groupNo;
    private Long activityId;
    private Long productId;
    private Long skuId;
    private BigDecimal groupPrice;
    private Integer status;              // 0拼团中 1已成团 2失败 3取消
    /** 开团用户匿名信息（如 "用户 138****1234"） */
    private String leaderMask;
    /** 开团用户头像 */
    private String leaderAvatar;
    private Integer targetCount;         // 成团人数要求
    private Integer memberCount;         // 已参团（已支付）人数
    private Integer progress;            // 百分比 0-100
    private Long remainSeconds;          // 剩余可参团时间（秒，过期为 0）
    private LocalDateTime expireTime;
    /** 当前登录用户是否已参此团 */
    private Boolean isJoined;
    /** 已参团成员头像列表（最多展示前 N 个） */
    private List<String> memberAvatars;

    // ===== 「我的拼团记录」专用展示字段（仅 myGroups 填充） =====
    /** 商品名称 */
    private String productName;
    /** 商品封面图 */
    private String coverImage;
    /** 绑定规格描述，如 "颜色:黑色, 尺码:41" */
    private String skuSpecs;
    /** 当前用户在该团的订单ID（用于跳转支付/查看订单） */
    private Long orderId;
    /** 当前用户订单状态：0待付款 1已付款 4已取消 6已退款 */
    private Integer orderStatus;
    /** 团创建（开团）时间 */
    private LocalDateTime createTime;
}
