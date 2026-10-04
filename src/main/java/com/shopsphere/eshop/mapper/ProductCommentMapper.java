package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.entity.ProductComment;
import com.shopsphere.eshop.vo.ProductCommentVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.Collection;
import java.util.List;
import java.util.Map;

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

    /** 分页查询商品顶层评论（带用户信息），支持 全部/好评/中评/差评 与 有图 筛选、热度排序（XML 实现） */
    IPage<ProductCommentVO> selectCommentPage(Page<ProductCommentVO> page,
                                              @Param("productId") Long productId,
                                              @Param("type") Integer type,
                                              @Param("onlyImage") Boolean onlyImage,
                                              @Param("sortBy") Integer sortBy);

    /** 批量查询多条顶层评论的回复（带用户信息） */
    List<ProductCommentVO> selectRepliesByParentIds(@Param("parentIds") Collection<Long> parentIds);

    /** 评分分布统计：rating -> 条数 */
    List<Map<String, Object>> selectRatingDist(@Param("productId") Long productId);

    /** 有图评论的图片JSON字段（按时间倒序取前 limit 条） */
    List<String> selectImageComments(@Param("productId") Long productId, @Param("limit") int limit);

    /** 有图评论总数 */
    Long countHasImage(@Param("productId") Long productId);

    /** 已购买该商品（订单已付款/发货/完成）的用户ID集合 */
    List<Long> selectPurchasedUserIds(@Param("productId") Long productId,
                                      @Param("userIds") Collection<Long> userIds);
}