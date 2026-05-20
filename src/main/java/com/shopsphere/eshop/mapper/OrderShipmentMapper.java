package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.entity.OrderShipment;
import com.shopsphere.eshop.vo.MerchantShipmentVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OrderShipmentMapper extends BaseMapper<OrderShipment> {

    /**
     * 分页查询商家的发货单（联查订单+买家信息）
     */
    Page<MerchantShipmentVO> selectMerchantShipments(Page<?> page, @Param("sellerId") Long sellerId);

    /**
     * 查询商家在某订单下的所有发货单详情
     */
    List<MerchantShipmentVO> selectMerchantOrderShipments(@Param("orderId") Long orderId,
                                                           @Param("sellerId") Long sellerId);

    /**
     * 更新发货单物流信息
     */
    int updateShipmentShipping(@Param("shipmentId") Long shipmentId,
                               @Param("sellerId") Long sellerId,
                               @Param("shippingName") String shippingName,
                               @Param("shippingNo") String shippingNo);
}
