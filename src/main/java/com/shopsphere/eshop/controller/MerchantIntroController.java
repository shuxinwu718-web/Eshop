package com.shopsphere.eshop.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.annotation.CurrentUserId;
import com.shopsphere.eshop.common.Result;
import com.shopsphere.eshop.dto.IntroSubmitDTO;
import com.shopsphere.eshop.service.ProductIntroService;
import com.shopsphere.eshop.vo.IntroVersionVO;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 商家端 商品介绍管理（富文本草稿/提交审核/版本管理）
 */
@RestController
@RequestMapping("/merchant/intro")
@RequiredArgsConstructor
@Tag(name = "商家商品介绍", description = "商家编辑富文本商品介绍、提交审核、查看/恢复历史版本")
public class MerchantIntroController {

    private final ProductIntroService productIntroService;

    /** 获取编辑内容（草稿优先，无草稿取最近驳回/已通过版本） */
    @GetMapping("/product/{productId}")
    public Result<String> getEditContent(@PathVariable Long productId,
                                         @CurrentUserId Long merchantId) {
        return Result.success(productIntroService.getEditContent(productId, merchantId));
    }

    /** 保存草稿 */
    @PostMapping("/draft")
    public Result<?> saveDraft(@Valid @RequestBody IntroSubmitDTO dto,
                               @CurrentUserId Long merchantId) {
        productIntroService.saveDraft(dto.getProductId(), merchantId, dto.getContent());
        return Result.success("草稿已保存");
    }

    /** 提交审核（生成新版本号） */
    @PostMapping("/submit")
    public Result<?> submitForAudit(@Valid @RequestBody IntroSubmitDTO dto,
                                    @CurrentUserId Long merchantId) {
        productIntroService.submitForAudit(dto.getProductId(), merchantId, dto.getContent());
        return Result.success("已提交审核，请等待管理员审核");
    }

    /** 版本列表（仅元数据） */
    @GetMapping("/versions/{productId}")
    public Result<Page<IntroVersionVO>> getVersions(@PathVariable Long productId,
                                                    @RequestParam(defaultValue = "1") Integer pageNum,
                                                    @RequestParam(defaultValue = "10") Integer pageSize,
                                                    @CurrentUserId Long merchantId) {
        return Result.success(productIntroService.getVersions(productId, merchantId, pageNum, pageSize));
    }

    /** 版本详情（含正文） */
    @GetMapping("/versions/detail/{id}")
    public Result<IntroVersionVO> getVersionDetail(@PathVariable Long id,
                                                   @CurrentUserId Long merchantId) {
        return Result.success(productIntroService.getVersionDetail(id, merchantId));
    }

    /** 恢复历史版本（内容回填为当前草稿） */
    @PostMapping("/restore/{id}")
    public Result<?> restoreVersion(@PathVariable Long id,
                                    @CurrentUserId Long merchantId) {
        productIntroService.restoreVersion(id, merchantId);
        return Result.success("已恢复该版本内容，请重新提交审核");
    }
}
