package com.shopsphere.eshop.vo;

import lombok.Data;

import java.util.List;
import java.util.Map;

/**
 * 商品评价聚合统计（供评价区顶部评分卡使用）
 */
@Data
public class ProductCommentStatsVO {
    private Long total;            // 评价总数（顶层评论）
    private Double avgRating;      // 平均评分（1位小数）
    private Integer goodRate;      // 好评率 = (4星+5星) / 有评分数，整数百分比
    private Long imageCount;       // 有图评价数
    private Map<Integer, Long> dist;   // 星级分布：{5: n, 4: n, ...}
    private List<String> recentImages; // 最近晒图（最多8张）
}
