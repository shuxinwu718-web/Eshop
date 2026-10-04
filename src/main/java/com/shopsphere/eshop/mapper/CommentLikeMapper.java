package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.CommentLike;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.Collection;
import java.util.Set;

@Mapper
public interface CommentLikeMapper extends BaseMapper<CommentLike> {

    /** 批量查询当前用户已点赞的评论ID集合 */
    @Select("<script>" +
            "SELECT comment_id FROM comment_like WHERE user_id = #{userId} AND comment_id IN " +
            "<foreach collection='commentIds' item='cid' open='(' separator=',' close=')'>#{cid}</foreach>" +
            "</script>")
    Set<Long> selectLikedCommentIds(@Param("commentIds") Collection<Long> commentIds,
                                    @Param("userId") Long userId);
}
