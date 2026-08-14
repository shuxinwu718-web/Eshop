package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.vo.IntroAuditVO;
import com.shopsphere.eshop.vo.IntroVersionVO;

/**
 * 商品介绍（富文本）业务：草稿/提交审核/版本管理/审核
 */
public interface ProductIntroService {

    /** 商家获取编辑内容：草稿优先，无草稿取最近驳回/已通过版本 */
    String getEditContent(Long productId, Long merchantId);

    /** 保存草稿（覆盖当前草稿，不生成新版本号） */
    void saveDraft(Long productId, Long merchantId, String content);

    /** 提交审核：存在待审核版本则覆盖，否则生成新版本号 */
    void submitForAudit(Long productId, Long merchantId, String content);

    /** 版本列表（仅元数据） */
    Page<IntroVersionVO> getVersions(Long productId, Long merchantId, Integer pageNum, Integer pageSize);

    /** 版本详情（含正文） */
    IntroVersionVO getVersionDetail(Long id, Long merchantId);

    /** 恢复历史版本 → 内容回填为当前草稿 */
    void restoreVersion(Long id, Long merchantId);

    /** 管理端：待审核分页 */
    Page<IntroAuditVO> pendingPage(Integer pageNum, Integer pageSize, String keyword);

    /** 管理端：审核（通过同步 product.description 并清缓存 / 驳回附原因） */
    void audit(Long id, boolean pass, String remark);
}
