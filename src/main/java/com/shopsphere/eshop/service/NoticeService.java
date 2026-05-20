package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.NoticeFormDTO;
import com.shopsphere.eshop.dto.NoticeQueryDTO;
import com.shopsphere.eshop.vo.NoticeVO;

public interface NoticeService {

    Page<NoticeVO> getNoticePage(NoticeQueryDTO dto);
    Page<NoticeVO> getMyNotices(NoticeQueryDTO dto, Long userId);
    NoticeVO getDetailForUser(Long noticeId, Long userId);
    void readAll(Long userId);
    // 创建通知
    void createNotice(NoticeFormDTO formDTO);

    // 更新通知（仅草稿可编辑）
    void updateNotice(NoticeFormDTO formDTO);

    // 删除（可批量）
    void deleteByIds(String ids);

    // 发布
    void publishNotice(Long id);

    /** 创建并直接发布通知（系统自动生成） */
    void createAndPublish(String title, String content, Integer type, Long targetUserId);

    // 撤回
    void revokeNotice(Long id);

    // 获取表单数据（编辑回显）
    NoticeFormDTO getFormData(Long id);
}
