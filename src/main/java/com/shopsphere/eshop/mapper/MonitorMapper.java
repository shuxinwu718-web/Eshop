package com.shopsphere.eshop.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * 监控大盘聚合查询（数据源：visit_log，由 TraceFilter → MQ 异步落库）。
 * 仅做只读聚合，聚合维度：PV / UV / 耗时 / 状态码。
 */
@Mapper
public interface MonitorMapper {

    /** 概览：起始时间以来的 PV、UV、平均耗时、服务端/客户端错误数（一条 SQL 聚合） */
    @Select("""
            SELECT COUNT(*) AS pv,
                   COUNT(DISTINCT COALESCE(user_id, ip)) AS uv,
                   COALESCE(AVG(NULLIF(duration_ms, 0)), 0) AS avgDuration,
                   COALESCE(SUM(CASE WHEN status_code >= 500 THEN 1 ELSE 0 END), 0) AS serverErrors,
                   COALESCE(SUM(CASE WHEN status_code >= 400 AND status_code < 500 THEN 1 ELSE 0 END), 0) AS clientErrors
            FROM visit_log
            WHERE visit_time >= #{start}
            """)
    Map<String, Object> selectOverview(@Param("start") LocalDateTime start);

    /** 状态码分布（排除启用状态码采集前的历史 NULL 数据，避免"未知"分类干扰） */
    @Select("""
            SELECT status_code AS code, COUNT(*) AS cnt
            FROM visit_log
            WHERE visit_time >= #{start} AND status_code IS NOT NULL
            GROUP BY status_code
            ORDER BY cnt DESC
            """)
    List<Map<String, Object>> selectStatusDistribution(@Param("start") LocalDateTime start);

    /** 小时级趋势：PV / UV / 平均耗时 / 错误数（建议窗口 ≤ 48h） */
    @Select("""
            SELECT DATE_FORMAT(visit_time, '%m-%d %H:00') AS point,
                   COUNT(*) AS pv,
                   COUNT(DISTINCT COALESCE(user_id, ip)) AS uv,
                   COALESCE(AVG(NULLIF(duration_ms, 0)), 0) AS avgDuration,
                   COALESCE(SUM(CASE WHEN status_code >= 500 THEN 1 ELSE 0 END), 0) AS errors
            FROM visit_log
            WHERE visit_time >= #{start}
            GROUP BY DATE_FORMAT(visit_time, '%m-%d %H:00')
            ORDER BY point ASC
            """)
    List<Map<String, Object>> selectHourlyTrend(@Param("start") LocalDateTime start);

    /** 慢接口 Top N：按平均耗时降序（NULL 耗时的历史数据不参与） */
    @Select("""
            SELECT request_uri AS uri,
                   COUNT(*) AS cnt,
                   COALESCE(ROUND(AVG(NULLIF(duration_ms, 0)), 1), 0) AS avgDuration,
                   COALESCE(MAX(duration_ms), 0) AS maxDuration
            FROM visit_log
            WHERE visit_time >= #{start} AND duration_ms IS NOT NULL
            GROUP BY request_uri
            ORDER BY avgDuration DESC
            LIMIT #{limit}
            """)
    List<Map<String, Object>> selectSlowPaths(@Param("start") LocalDateTime start, @Param("limit") int limit);

    /** 热点接口 Top N：按访问次数降序 */
    @Select("""
            SELECT request_uri AS uri,
                   COUNT(*) AS cnt,
                   COALESCE(ROUND(AVG(NULLIF(duration_ms, 0)), 1), 0) AS avgDuration,
                   COALESCE(MAX(duration_ms), 0) AS maxDuration
            FROM visit_log
            WHERE visit_time >= #{start}
            GROUP BY request_uri
            ORDER BY cnt DESC
            LIMIT #{limit}
            """)
    List<Map<String, Object>> selectHotPaths(@Param("start") LocalDateTime start, @Param("limit") int limit);

    /** 访问日志明细分页查询（按时间段 + 路径关键词 + 状态码筛选） */
    @Select("""
            SELECT id, request_uri AS uri, method, status_code AS statusCode,
                   duration_ms AS durationMs, ip, user_agent AS userAgent, visit_time AS visitTime
            FROM visit_log
            WHERE visit_time >= #{start} AND visit_time <= #{end}
              AND (#{uri} IS NULL OR request_uri LIKE CONCAT('%', #{uri}, '%'))
              AND (#{status} IS NULL OR status_code = #{status})
            ORDER BY visit_time DESC
            LIMIT #{offset}, #{size}
            """)
    List<Map<String, Object>> selectAccessLogs(@Param("start") LocalDateTime start,
                                               @Param("end") LocalDateTime end,
                                               @Param("uri") String uri,
                                               @Param("status") Integer status,
                                               @Param("offset") int offset,
                                               @Param("size") int size);

    /** 访问日志总条数（同筛选条件，用于分页总数） */
    @Select("""
            SELECT COUNT(*)
            FROM visit_log
            WHERE visit_time >= #{start} AND visit_time <= #{end}
              AND (#{uri} IS NULL OR request_uri LIKE CONCAT('%', #{uri}, '%'))
              AND (#{status} IS NULL OR status_code = #{status})
            """)
    long countAccessLogs(@Param("start") LocalDateTime start,
                         @Param("end") LocalDateTime end,
                         @Param("uri") String uri,
                         @Param("status") Integer status);
}
