package com.shopsphere.eshop.constant;

/**
 * 物流轨迹状态常量（模拟物流）
 *
 * 语义对齐 order_shipment.delivery_status：
 * 1已发货 → 2已签收；此处 1已揽收/2运输中/3派送中/4已签收 为轨迹细分节点。
 */
public final class TrackStatus {

    private TrackStatus() {}

    /** 已揽收（发货时立即生成） */
    public static final int PICKED_UP = 1;

    /** 运输中 */
    public static final int IN_TRANSIT = 2;

    /** 派送中 */
    public static final int DELIVERING = 3;

    /** 已签收（最后一个节点，触发自动确认收货） */
    public static final int RECEIVED = 4;
}
