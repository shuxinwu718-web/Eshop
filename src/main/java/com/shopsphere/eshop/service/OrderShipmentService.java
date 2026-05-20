package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.vo.MerchantShipmentVO;

import java.util.List;

public interface OrderShipmentService {

    /**
     * 商家分页查询自己的发货单
     */
    Page<MerchantShipmentVO> getMerchantShipments(Long sellerId, Integer pageNum, Integer pageSize);

    /**
     * 商家查询自己在某订单下的发货单详情
     */
    List<MerchantShipmentVO> getMerchantOrderShipments(Long orderId, Long sellerId);

    /**
     * 商家发货（按发货单维度）
     */
    void shipShipment(Long shipmentId, Long sellerId, String shippingName, String shippingNo);
}
