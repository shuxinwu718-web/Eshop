package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.ProductComment;
import com.shopsphere.eshop.vo.ProductCommentVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ProductCommentMapper extends BaseMapper<ProductComment> {
    @Select("SELECT c.*, u.nickname as user_name, u.avatar as user_avatar " +
            "FROM product_comment c " +
            "LEFT JOIN user u ON c.user_id = u.id " +
            "WHERE c.product_id = #{productId} AND c.deleted = 0 AND c.status = 1 " +
            "ORDER BY c.create_time ASC")
    List<ProductCommentVO> selectCommentsWithUser(@Param("productId") Long productId);

    /** 批量查询多个商品的用户评分平均数（仅统计已通过评论的顶层评价，忽略无评分数据） */
    @Select("<script>" +
            "SELECT product_id AS productId, ROUND(AVG(rating), 1) AS avgRating " +
            "FROM product_comment " +
            "WHERE status = 1 AND deleted = 0 AND parent_id = 0 AND rating IS NOT NULL AND rating > 0 " +
            "AND product_id IN " +
            "<foreach collection='ids' item='id' open='(' separator=',' close=')'>#{id}</foreach> " +
            "GROUP BY product_id" +
            "</script>")
    List<java.util.Map<String, Object>> selectAvgRatingByProductIds(
            @Param("ids") java.util.Collection<Long> ids);
}