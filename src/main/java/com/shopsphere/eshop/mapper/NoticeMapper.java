package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.Notice;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface NoticeMapper extends BaseMapper<Notice> {

    @Select("SELECT COUNT(*) FROM sys_notice n " +
            "WHERE n.status = 1 " +
            "AND (n.target_type = 1 OR (n.target_type = 2 AND FIND_IN_SET(#{userId}, n.target_user_ids))) " +
            "AND NOT EXISTS (SELECT 1 FROM sys_notice_read r WHERE r.notice_id = n.id AND r.user_id = #{userId})")
    long countUnreadByUser(@Param("userId") Long userId);

    @Select("SELECT n.* FROM sys_notice n " +
            "WHERE n.status = 1 " +
            "AND (n.target_type = 1 OR (n.target_type = 2 AND FIND_IN_SET(#{userId}, n.target_user_ids))) " +
            "AND NOT EXISTS (SELECT 1 FROM sys_notice_read r WHERE r.notice_id = n.id AND r.user_id = #{userId}) " +
            "ORDER BY n.publish_time DESC LIMIT #{limit}")
    List<Notice> selectUnreadByUser(@Param("userId") Long userId, @Param("limit") int limit);
}