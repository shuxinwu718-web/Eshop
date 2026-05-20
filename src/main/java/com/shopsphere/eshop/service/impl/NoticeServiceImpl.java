package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.NoticeFormDTO;
import com.shopsphere.eshop.dto.NoticeQueryDTO;
import com.shopsphere.eshop.entity.Notice;
import com.shopsphere.eshop.entity.NoticeRead;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.NoticeMapper;
import com.shopsphere.eshop.mapper.NoticeReadMapper;
import com.shopsphere.eshop.service.NoticeService;
import com.shopsphere.eshop.vo.NoticeVO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class NoticeServiceImpl implements NoticeService {

    private final NoticeMapper noticeMapper;
    private final NoticeReadMapper noticeReadMapper;

    // ========== 管理端方法 ==========

    @Override
    public Page<NoticeVO> getNoticePage(NoticeQueryDTO dto) {
        Page<Notice> page = new Page<>(dto.getPageNum(), dto.getPageSize());
        LambdaQueryWrapper<Notice> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(dto.getTitle())) {
            wrapper.like(Notice::getTitle, dto.getTitle());
        }
        if (dto.getPublishStatus() != null) {
            wrapper.eq(Notice::getStatus, dto.getPublishStatus());
        }
        wrapper.orderByDesc(Notice::getCreateTime);
        Page<Notice> noticePage = noticeMapper.selectPage(page, wrapper);
        List<NoticeVO> voList = noticePage.getRecords().stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
        Page<NoticeVO> resultPage = new Page<>(dto.getPageNum(), dto.getPageSize(), noticePage.getTotal());
        resultPage.setRecords(voList);
        return resultPage;
    }

    @Override
    public NoticeFormDTO getFormData(Long id) {
        Notice notice = noticeMapper.selectById(id);
        if (notice == null) {
            throw new BusinessException("通知不存在");
        }
        NoticeFormDTO dto = new NoticeFormDTO();
        BeanUtils.copyProperties(notice, dto);
        // 将 targetUserIds 转为 List<Long>
        if (StringUtils.hasText(notice.getTargetUserIds())) {
            List<Long> userIds = Arrays.stream(notice.getTargetUserIds().split(","))
                    .map(Long::parseLong)
                    .collect(Collectors.toList());
            dto.setTargetUsers(userIds);
        }
        dto.setPublishStatus(notice.getStatus()); // 前端需要 publishStatus
        return dto;
    }

    @Override
    public void createNotice(NoticeFormDTO formDTO) {
        Notice notice = new Notice();
        BeanUtils.copyProperties(formDTO, notice);
        // 处理 targetUsers -> targetUserIds
        if (formDTO.getTargetType() == 2 && !CollectionUtils.isEmpty(formDTO.getTargetUsers())) {
            String ids = formDTO.getTargetUsers().stream()
                    .map(String::valueOf)
                    .collect(Collectors.joining(","));
            notice.setTargetUserIds(ids);
        } else {
            notice.setTargetType(1);   // 默认全体
            notice.setTargetUserIds(null);
        }
        notice.setStatus(0); // 草稿
        notice.setCreateTime(LocalDateTime.now());
        noticeMapper.insert(notice);
    }

    @Override
    public void updateNotice(NoticeFormDTO formDTO) {
        Notice existing = noticeMapper.selectById(formDTO.getId());
        if (existing == null) {
            throw new BusinessException("通知不存在");
        }
        if (existing.getStatus() != 0) {
            throw new BusinessException("已发布或已撤回的通知不可编辑");
        }
        Notice notice = new Notice();
        BeanUtils.copyProperties(formDTO, notice);
        // 处理 targetUsers
        if (formDTO.getTargetType() == 2 && !CollectionUtils.isEmpty(formDTO.getTargetUsers())) {
            String ids = formDTO.getTargetUsers().stream()
                    .map(String::valueOf)
                    .collect(Collectors.joining(","));
            notice.setTargetUserIds(ids);
        } else {
            notice.setTargetType(1);
            notice.setTargetUserIds(null);
        }
        notice.setUpdateTime(LocalDateTime.now());
        noticeMapper.updateById(notice);
    }

    @Override
    public void deleteByIds(String ids) {
        List<Long> idList = Arrays.stream(ids.split(","))
                .map(Long::parseLong)
                .collect(Collectors.toList());
        // 只能删除草稿
        List<Notice> notices = noticeMapper.selectBatchIds(idList);
        for (Notice notice : notices) {
            if (notice.getStatus() != 0) {
                throw new BusinessException("通知【" + notice.getTitle() + "】已发布或已撤回，不可删除");
            }
        }
        noticeMapper.deleteBatchIds(idList);
        // 同时删除已读记录（可选）
        for (Long id : idList) {
            noticeReadMapper.delete(new LambdaQueryWrapper<NoticeRead>().eq(NoticeRead::getNoticeId, id));
        }
    }

    @Override
    public void publishNotice(Long id) {
        Notice notice = noticeMapper.selectById(id);
        if (notice == null) {
            throw new BusinessException("通知不存在");
        }
        if (notice.getStatus() != 0) {
            throw new BusinessException("只有草稿状态可发布");
        }
        notice.setStatus(1);
        notice.setPublishTime(LocalDateTime.now());
        noticeMapper.updateById(notice);
    }

    @Override
    public void revokeNotice(Long id) {
        Notice notice = noticeMapper.selectById(id);
        if (notice == null) {
            throw new BusinessException("通知不存在");
        }
        if (notice.getStatus() != 1) {
            throw new BusinessException("只有已发布状态可撤回");
        }
        notice.setStatus(2);
        notice.setRevokeTime(LocalDateTime.now());
        noticeMapper.updateById(notice);
    }

    // ========== 用户端方法 ==========

    @Override
    public Page<NoticeVO> getMyNotices(NoticeQueryDTO dto, Long userId) {
        Page<Notice> page = new Page<>(dto.getPageNum(), dto.getPageSize());
        LambdaQueryWrapper<Notice> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Notice::getStatus, 1); // 已发布
        if (StringUtils.hasText(dto.getTitle())) {
            wrapper.like(Notice::getTitle, dto.getTitle());
        }
        // 目标条件：全体 或 指定用户中包含当前用户
        wrapper.and(w -> w.eq(Notice::getTargetType, 1)
                .or().eq(Notice::getTargetType, 2)
                .and(ow -> ow.apply("FIND_IN_SET({0}, target_user_ids)", userId))
        );
        wrapper.orderByDesc(Notice::getPublishTime);
        Page<Notice> noticePage = noticeMapper.selectPage(page, wrapper);
        List<NoticeVO> voList = noticePage.getRecords().stream().map(notice -> {
            NoticeVO vo = convertToVO(notice);
            // 查询是否已读
            LambdaQueryWrapper<NoticeRead> readWrapper = new LambdaQueryWrapper<>();
            readWrapper.eq(NoticeRead::getNoticeId, notice.getId())
                    .eq(NoticeRead::getUserId, userId);
            vo.setIsRead(noticeReadMapper.selectCount(readWrapper) > 0 ? 1 : 0);
            return vo;
        }).collect(Collectors.toList());
        Page<NoticeVO> resultPage = new Page<>(dto.getPageNum(), dto.getPageSize(), noticePage.getTotal());
        resultPage.setRecords(voList);
        return resultPage;
    }

    @Override
    public NoticeVO getDetailForUser(Long noticeId, Long userId) {
        Notice notice = noticeMapper.selectById(noticeId);
        if (notice == null || notice.getStatus() != 1) {
            throw new BusinessException("通知不存在或未发布");
        }
        // 幂等记录已读
        LambdaQueryWrapper<NoticeRead> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(NoticeRead::getNoticeId, noticeId).eq(NoticeRead::getUserId, userId);
        if (noticeReadMapper.selectCount(wrapper) == 0) {
            NoticeRead read = new NoticeRead();
            read.setNoticeId(noticeId);
            read.setUserId(userId);
            read.setReadTime(LocalDateTime.now());
            noticeReadMapper.insert(read);
        }
        return convertToVO(notice);
    }

    @Override
    public void readAll(Long userId) {
        // 查询所有未读的已发布通知（且目标匹配当前用户）
        List<Notice> unreadNotices = noticeMapper.selectList(
                new LambdaQueryWrapper<Notice>()
                        .eq(Notice::getStatus, 1)
                        .and(w -> w.eq(Notice::getTargetType, 1)
                                .or().eq(Notice::getTargetType, 2)
                                .and(ow -> ow.apply("FIND_IN_SET({0}, target_user_ids)", userId))
                        )
        );
        for (Notice notice : unreadNotices) {
            LambdaQueryWrapper<NoticeRead> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(NoticeRead::getNoticeId, notice.getId())
                    .eq(NoticeRead::getUserId, userId);
            if (noticeReadMapper.selectCount(wrapper) == 0) {
                NoticeRead read = new NoticeRead();
                read.setNoticeId(notice.getId());
                read.setUserId(userId);
                read.setReadTime(LocalDateTime.now());
                noticeReadMapper.insert(read);
            }
        }
    }

    // ========== 私有辅助方法 ==========

    private NoticeVO convertToVO(Notice notice) {
        if (notice == null) return null;
        NoticeVO vo = new NoticeVO();
        BeanUtils.copyProperties(notice, vo);
        vo.setPublishStatus(notice.getStatus());   // 前端用 publishStatus
        return vo;
    }
}