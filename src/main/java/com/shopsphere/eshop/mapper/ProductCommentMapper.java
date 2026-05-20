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
}