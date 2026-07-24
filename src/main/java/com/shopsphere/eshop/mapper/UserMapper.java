package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDateTime;

@Mapper
public interface UserMapper extends BaseMapper<User> {

    @Select("SELECT COUNT(*) FROM user WHERE role = 'MERCHANT' AND deleted = 0")
    Long selectMerchantCount();

    @Select("SELECT COUNT(*) FROM user WHERE role = 'MERCHANT' AND create_time >= #{since} AND deleted = 0")
    Long selectNewMerchantCount(@Param("since") LocalDateTime since);

    @Select("SELECT COUNT(*) FROM user WHERE deleted = 0 AND create_time >= #{since}")
    Long selectNewUserCount(@Param("since") LocalDateTime since);

    @Select("SELECT COUNT(*) FROM user WHERE role = 'USER' AND deleted = 0")
    Long selectUserOnlyCount();

    @Select("SELECT DATE(create_time) as date, COUNT(*) as cnt FROM user WHERE deleted = 0 " +
            "AND create_time >= #{startDate} AND create_time < #{endDate} " +
            "GROUP BY DATE(create_time) ORDER BY date")
    java.util.List<java.util.Map<String, Object>> selectDailyUserGrowth(
            @Param("startDate") java.time.LocalDateTime startDate,
            @Param("endDate") java.time.LocalDateTime endDate);

    @Select("SELECT COUNT(*) FROM user WHERE deleted = 0 AND create_time < #{endDate}")
    Long selectTotalUserCountBefore(@Param("endDate") java.time.LocalDateTime endDate);

    @Select("SELECT * FROM `user` WHERE github_id = #{githubId} AND deleted = 0")
    User findByGithubId(String githubId);
}