package com.shopsphere.eshop.vo;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 物流轨迹视图对象（模拟物流）
 *
 * 一个发货单对应一组轨迹节点；前端按时间线（el-timeline）展示。
 */
@Data
public class ShipmentTrackVO {

    // 发货单信息
    private Long shipmentId;
    private Long orderId;
    /** 快递公司名称 */
    private String shippingName;
    /** 运单号 */
    private String shippingNo;
    /** 发货单状态：0待发货 1已发货 2已签收 */
    private Integer deliveryStatus;
    /** 最新轨迹状态（无轨迹时为 null） */
    private Integer latestTrackStatus;

    // 轨迹节点列表（正序：1已揽收→4已签收）
    private List<TrackItemVO> tracks;

    @Data
    public static class TrackItemVO {
        private Integer status;
        private String title;
        private String description;
        private LocalDateTime time;
    }
}
