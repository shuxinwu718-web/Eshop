package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 物流轨迹实体（模拟物流）
 *
 * 对应表 shipment_track：发货后自动生成 已揽收→运输中→派送中→已签收 节点，
 * (shipment_id, track_status) 唯一索引保证幂等。
 */
@Data
@TableName("shipment_track")
public class ShipmentTrack {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("shipment_id")
    private Long shipmentId;

    @TableField("order_id")
    private Long orderId;

    @TableField("track_status")
    private Integer trackStatus;

    @TableField("title")
    private String title;

    @TableField("description")
    private String description;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
