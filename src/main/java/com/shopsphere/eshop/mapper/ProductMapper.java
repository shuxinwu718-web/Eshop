package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.vo.HotProductVO;
import com.shopsphere.eshop.vo.ProductSalesVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ProductMapper extends BaseMapper<Product> {

    @Select("SELECT COUNT(*) FROM product WHERE deleted = 0")
    Long selectProductCount();

    @Select("SELECT p.id, p.name, p.price, p.cover_image AS coverImage, p.description, " +
           "COALESCE(SUM(oi.quantity), 0) AS sales, " +
           "ROUND(COALESCE(AVG(pc.rating), 0), 1) AS avgRating " +
           "FROM product p " +
           "LEFT JOIN order_item oi ON p.id = oi.product_id " +
           "LEFT JOIN order_shipment os ON oi.shipment_id = os.id " +
           "LEFT JOIN `order` o ON os.order_id = o.id AND o.order_status >= 1 " +
           "LEFT JOIN product_comment pc ON p.id = pc.product_id AND pc.status = 1 " +
           "WHERE p.deleted = 0 AND p.status = 1 " +
           "GROUP BY p.id " +
           "ORDER BY sales DESC, avgRating DESC " +
           "LIMIT #{limit}")
    List<HotProductVO> selectHotProducts(int limit);

    @Select("SELECT p.id AS productId, p.name AS productName, p.cover_image AS productImage, " +
           "p.price, p.stock, COALESCE(SUM(oi.quantity), 0) AS sales, " +
           "COALESCE(SUM(oi.price * oi.quantity), 0) AS totalAmount " +
           "FROM product p " +
           "LEFT JOIN order_item oi ON p.id = oi.product_id " +
           "LEFT JOIN order_shipment os ON oi.shipment_id = os.id " +
           "LEFT JOIN `order` o ON os.order_id = o.id AND o.order_status >= 1 " +
           "WHERE p.merchant_id = #{merchantId} AND p.deleted = 0 " +
           "GROUP BY p.id " +
           "ORDER BY sales DESC")
    List<ProductSalesVO> selectProductSalesByMerchant(Long merchantId);
}