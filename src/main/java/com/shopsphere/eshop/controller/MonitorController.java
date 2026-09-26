package com.shopsphere.eshop.controller;

import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.mapper.MonitorMapper;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 管理端监控大盘（数据源 visit_log）。
 * 三个聚合接口：概览 / 小时趋势 / 接口维度（慢接口、热点）。
 */
@RestController
@RequestMapping("/api/admin/monitor")
@RequiredArgsConstructor
@Tag(name = "管理员的系统监控", description = "PV/UV、平均耗时、错误率、慢接口、热点接口可视化")
public class MonitorController {

    private final MonitorMapper monitorMapper;

    /** 概览：今日 PV / UV / 平均耗时 / 错误率 + 状态码分布 */
    @GetMapping("/overview")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Map<String, Object>> overview() {
        LocalDateTime todayStart = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0).withNano(0);
        Map<String, Object> ov = monitorMapper.selectOverview(todayStart);

        long pv = toLong(ov.get("pv"));
        long serverErrors = toLong(ov.get("serverErrors"));
        long clientErrors = toLong(ov.get("clientErrors"));

        Map<String, Object> data = new HashMap<>();
        data.put("pv", pv);
        data.put("uv", toLong(ov.get("uv")));
        data.put("avgDuration", round1(ov.get("avgDuration")));
        // 错误率 = (5xx + 4xx) / PV，保留两位小数（百分比）
        data.put("errorRate", pv > 0
                ? round1((serverErrors + clientErrors) * 100.0 / pv) : 0.0);
        data.put("statusDistribution", monitorMapper.selectStatusDistribution(todayStart));
        return Result.success(data);
    }

    /** 小时级趋势（默认近 24 小时，最大 72） */
    @GetMapping("/trend")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<List<Map<String, Object>>> trend(@RequestParam(defaultValue = "24") Integer hours) {
        int h = Math.min(Math.max(hours, 1), 72);
        return Result.success(monitorMapper.selectHourlyTrend(LocalDateTime.now().minusHours(h)));
    }

    /**
     * 接口维度 Top N（默认近 24 小时）。
     * type=slow 按平均耗时降序（慢接口），type=hot 按访问次数降序（热点接口）。
     */
    @GetMapping("/paths")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<List<Map<String, Object>>> paths(@RequestParam(defaultValue = "24") Integer hours,
                                                   @RequestParam(defaultValue = "10") Integer limit,
                                                   @RequestParam(defaultValue = "slow") String type) {
        int h = Math.min(Math.max(hours, 1), 72);
        int n = Math.min(Math.max(limit, 1), 50);
        LocalDateTime start = LocalDateTime.now().minusHours(h);
        List<Map<String, Object>> rows = "hot".equalsIgnoreCase(type)
                ? monitorMapper.selectHotPaths(start, n)
                : monitorMapper.selectSlowPaths(start, n);
        return Result.success(rows);
    }

    /**
     * 访问日志明细分页查询。
     * 支持按时间段、路径关键词、状态码筛选，用于定位具体某条请求。
     */
    @GetMapping("/access-logs")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Map<String, Object>> accessLogs(
            @RequestParam(required = false) String startTime,
            @RequestParam(required = false) String endTime,
            @RequestParam(required = false) String uri,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "20") Integer size) {

        int p = Math.max(page, 1);
        int s = Math.min(Math.max(size, 1), 100);

        LocalDateTime start = startTime != null && !startTime.isEmpty()
                ? LocalDateTime.parse(startTime.replace(" ", "T"))
                : LocalDateTime.now().minusDays(1);
        LocalDateTime end = endTime != null && !endTime.isEmpty()
                ? LocalDateTime.parse(endTime.replace(" ", "T"))
                : LocalDateTime.now();

        List<Map<String, Object>> list = monitorMapper.selectAccessLogs(start, end, uri, status, (p - 1) * s, s);
        long total = monitorMapper.countAccessLogs(start, end, uri, status);

        Map<String, Object> data = new HashMap<>();
        data.put("list", list);
        data.put("total", total);
        data.put("page", p);
        data.put("size", s);
        return Result.success(data);
    }

    private long toLong(Object val) {
        return val instanceof Number num ? num.longValue() : 0L;
    }

    private double round1(Object val) {
        return val instanceof Number num ? Math.round(num.doubleValue() * 10.0) / 10.0 : 0.0;
    }
}
