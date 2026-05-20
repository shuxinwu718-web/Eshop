package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.Favorite;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface FavoriteMapper extends BaseMapper<Favorite> {

    // 查询用户收藏的商品ID列表
    @Select("SELECT product_id FROM favorite WHERE user_id = #{userId}")
    List<Long> findProductIdsByUserId(@Param("userId") Long userId);

    @Select("SELECT COUNT(*) > 0 FROM favorite WHERE user_id = #{userId} AND product_id = #{productId}")
    boolean existsByUserIdAndProductId(@Param("userId") Long userId, @Param("productId") Long productId);
}