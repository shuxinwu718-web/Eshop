package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.annotation.Log;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.SeckillSessionSaveDTO;
import com.shopsphere.eshop.entity.SeckillSession;
import com.shopsphere.eshop.service.SeckillService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin/seckill")
@RequiredArgsConstructor
public class AdminSeckillController {

    private final SeckillService seckillService;

    @GetMapping("/page")
    public Result<Page<SeckillSession>> pageQuery(
            @RequestParam(required = false) String sessionName,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) Long couponId,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        return Result.success(seckillService.pageQuery(sessionName, status, couponId, pageNum, pageSize));
    }

    @GetMapping("/{id}")
    public Result<SeckillSession> getById(@PathVariable Long id) {
        return Result.success(seckillService.getById(id));
    }

    @PostMapping
    @Log(value = "新增秒杀场次", type = "ADD_SECKILL_SESSION", targetType = "SeckillSession")
    public Result<?> create(@Valid @RequestBody SeckillSessionSaveDTO dto) {
        seckillService.create(dto);
        return Result.success("创建成功");
    }

    @PutMapping
    @Log(value = "修改秒杀场次", type = "UPDATE_SECKILL_SESSION", targetType = "SeckillSession")
    public Result<?> update(@Valid @RequestBody SeckillSessionSaveDTO dto) {
        seckillService.update(dto);
        return Result.success("修改成功");
    }

    @DeleteMapping("/{id}")
    @Log(value = "删除秒杀场次", type = "DELETE_SECKILL_SESSION", targetType = "SeckillSession")
    public Result<?> delete(@PathVariable Long id) {
        seckillService.delete(id);
        return Result.success("删除成功");
    }

    @PutMapping("/cancel/{id}")
    @Log(value = "撤销秒杀场次", type = "CANCEL_SECKILL_SESSION", targetType = "SeckillSession")
    public Result<?> cancel(@PathVariable Long id) {
        seckillService.cancel(id);
        return Result.success("已撤销");
    }

    @PostMapping("/preheat/{id}")
    @Log(value = "预热秒杀库存", type = "PREHEAT_SECKILL", targetType = "SeckillSession")
    public Result<?> preheat(@PathVariable Long id) {
        seckillService.preheatStock(id);
        return Result.success("预热成功");
    }
}
