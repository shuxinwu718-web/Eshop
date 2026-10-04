package com.shopsphere.eshop.mq;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * 模拟物流轨迹推进延迟消息
 *
 * 字段 nextStatus 为本次要生成的轨迹状态（2运输中/3派送中/4已签收），
 * 由延迟交换机逐级投递实现轨迹自动推进。
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LogisticsTrackMessage implements Serializable {
    /** 发货单ID */
    private Long shipmentId;
    /** 本次要生成的轨迹状态 */
    private Integer nextStatus;
}
