package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.NoticeFormDTO;
import com.shopsphere.eshop.dto.NoticeQueryDTO;
import com.shopsphere.eshop.service.NoticeService;
import com.shopsphere.eshop.utils.JwtUtil;
import com.shopsphere.eshop.utils.TokenUtils;
import com.shopsphere.eshop.vo.NoticeVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/notices")
@Tag(name = "消息管理", description = "管理员发送公共、用户查看公共、发送消息")
public class NoticeController {

    @Autowired
    private NoticeService noticeService;
    private final JwtUtil jwtUtil;
    private final TokenUtils tokenUtils;

    public NoticeController(NoticeService noticeService, JwtUtil jwtUtil, TokenUtils tokenUtils) {
        this.noticeService = noticeService;
        this.jwtUtil = jwtUtil;
        this.tokenUtils = tokenUtils;
    }

    @GetMapping
    public Result<Page<NoticeVO>> getPage(NoticeQueryDTO dto) {
        return Result.success(noticeService.getNoticePage(dto));
    }

    @GetMapping("/{id}/form")
    public Result<NoticeFormDTO> getFormData(@PathVariable Long id) {
        return Result.success(noticeService.getFormData(id));
    }

    @PostMapping
    public Result<?> create(
            @RequestBody @Valid NoticeFormDTO dto,
            @RequestHeader(value = "Authorization", required = true) String authHeader) {
        // 从当前登录用户获取发布人信息
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        String username = jwtUtil.getUsernameFromToken(token);
        dto.setPublisherId(userId);
        dto.setPublisherName(username);
        noticeService.createNotice(dto);
        return Result.success("创建成功");
    }

    @PutMapping("/{id}")
    public Result<?> update(@PathVariable Long id, @RequestBody @Valid NoticeFormDTO dto) {
        dto.setId(id);
        noticeService.updateNotice(dto);
        return Result.success("更新成功");
    }

    @DeleteMapping("/{ids}")
    public Result<?> delete(@PathVariable String ids) {
        noticeService.deleteByIds(ids);
        return Result.success("删除成功");
    }

    @PutMapping("/{id}/publish")
    public Result<?> publish(@PathVariable Long id) {
        noticeService.publishNotice(id);
        return Result.success("发布成功");
    }

    @PutMapping("/{id}/revoke")
    public Result<?> revoke(@PathVariable Long id) {
        noticeService.revokeNotice(id);
        return Result.success("撤回成功");
    }

    @GetMapping("/{id}/detail")
    public Result<NoticeVO> getDetail
            (@PathVariable Long id,
              @RequestHeader(value = "Authorization", required = true) String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        return Result.success(noticeService.getDetailForUser(id, userId));
    }

    @GetMapping("/my")
    public Result<Page<NoticeVO>> getMyNotices(
            @RequestHeader(value = "Authorization", required = true) String authHeader,
            NoticeQueryDTO dto) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        return Result.success(noticeService.getMyNotices(dto, userId));
    }

    @PutMapping("/read-all")
    public Result<?> readAll(
            @RequestHeader(value = "Authorization", required = true) String authHeader) {
        String token = tokenUtils.extractToken(authHeader);
        Long userId = jwtUtil.getUserIdFromToken(token);
        noticeService.readAll(userId);
        return Result.success("全部标记已读");
    }
}