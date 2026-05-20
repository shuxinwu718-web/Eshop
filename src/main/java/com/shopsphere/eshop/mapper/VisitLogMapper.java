package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.VisitLog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Mapper
public interface VisitLogMapper extends BaseMapper<VisitLog> {

    // 统计今日 PV
    @Select("SELECT COUNT(*) FROM visit_log WHERE DATE(visit_time) = CURDATE()")
    Long countTodayPV();

    // 统计今日 UV（按 IP 去重）
    @Select("SELECT COUNT(DISTINCT ip) FROM visit_log WHERE DATE(visit_time) = CURDATE()")
    Long countTodayUV();

    // 统计总 PV
    @Select("SELECT COUNT(*) FROM visit_log")
    Long countTotalPV();

    // 统计总 UV（按 IP 去重）
    @Select("SELECT COUNT(DISTINCT ip) FROM visit_log")
    Long countTotalUV();

    // 统计昨日 PV
    @Select("SELECT COUNT(*) FROM visit_log WHERE DATE(visit_time) = CURDATE() - INTERVAL 1 DAY")
    Long countYesterdayPV();

    // 统计昨日 UV
    @Select("SELECT COUNT(DISTINCT ip) FROM visit_log WHERE DATE(visit_time) = CURDATE() - INTERVAL 1 DAY")
    Long countYesterdayUV();

    // 查询指定日期范围内的每日 PV 和 UV
    @Select("SELECT DATE(visit_time) as date, COUNT(*) as pv, COUNT(DISTINCT ip) as uv " +
            "FROM visit_log WHERE DATE(visit_time) BETWEEN #{startDate} AND #{endDate} " +
            "GROUP BY DATE(visit_time) ORDER BY date")
    List<Map<String, Object>> getDailyStats(@Param("startDate") LocalDate startDate,
                                            @Param("endDate") LocalDate endDate);
}