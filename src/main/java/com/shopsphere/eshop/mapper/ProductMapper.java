package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.Product;
import com.shopsphere.eshop.vo.HotProductVO;
import com.shopsphere.eshop.vo.ProductSalesVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface ProductMapper extends BaseMapper<Product> {

    @Select("SELECT COUNT(*) FROM product WHERE deleted = 0")
    Long selectProductCount();

    /**
     * 原子扣减商品库存：仅当库存充足时才扣减成功，防止并发超卖
     *
     * @return 受影响行数，0 表示库存不足
     */
    @Update("UPDATE product SET stock = stock - #{qty} WHERE id = #{id} AND stock >= #{qty} AND deleted = 0")
    int deductStock(@Param("id") Long id, @Param("qty") Integer qty);

    /** 更新浏览量（Redis 计数定时落库时调用） */
    @Update("UPDATE product SET views = #{views} WHERE id = #{id} AND deleted = 0")
    int updateViews(@Param("id") Long id, @Param("views") Integer views);

    @Select("SELECT p.id, p.name, p.price, p.cover_image AS coverImage, p.description, " +
           "COALESCE(SUM(CASE WHEN o.order_status >= 1 AND o.order_status < 4 THEN oi.quantity ELSE 0 END), 0) AS sales, " +
           "ROUND(COALESCE(AVG(pc.rating), 0), 1) AS avgRating " +
           "FROM product p " +
           "LEFT JOIN order_item oi ON p.id = oi.product_id " +
           "LEFT JOIN order_shipment os ON oi.shipment_id = os.id " +
           "LEFT JOIN `order` o ON os.order_id = o.id " +
           "LEFT JOIN product_comment pc ON p.id = pc.product_id AND pc.status = 1 " +
           "WHERE p.deleted = 0 AND p.status = 1 " +
           "GROUP BY p.id " +
           "ORDER BY sales DESC, avgRating DESC " +
           "LIMIT #{limit}")
    List<HotProductVO> selectHotProducts(int limit);

    @Select("SELECT p.id AS productId, p.name AS productName, p.cover_image AS productImage, " +
           "p.price, p.stock, " +
           "COALESCE(SUM(CASE WHEN o.order_status >= 1 AND o.order_status < 4 THEN oi.quantity ELSE 0 END), 0) AS sales, " +
           "COALESCE(SUM(CASE WHEN o.order_status >= 1 AND o.order_status < 4 THEN oi.price * oi.quantity ELSE 0 END), 0) AS totalAmount " +
           "FROM product p " +
           "LEFT JOIN order_item oi ON p.id = oi.product_id " +
           "LEFT JOIN order_shipment os ON oi.shipment_id = os.id " +
           "LEFT JOIN `order` o ON os.order_id = o.id " +
           "WHERE p.merchant_id = #{merchantId} AND p.deleted = 0 " +
           "GROUP BY p.id " +
           "ORDER BY sales DESC")
    List<ProductSalesVO> selectProductSalesByMerchant(Long merchantId);
}
