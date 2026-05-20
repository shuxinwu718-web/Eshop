package com.shopsphere.eshop.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.MerchantApplySubmitDTO;
import com.shopsphere.eshop.entity.MerchantApply;
import com.shopsphere.eshop.entity.User;
import com.shopsphere.eshop.exception.BusinessException;
import com.shopsphere.eshop.mapper.MerchantApplyMapper;
import com.shopsphere.eshop.mapper.UserMapper;
import com.shopsphere.eshop.service.MerchantApplyService;
import com.shopsphere.eshop.vo.MerchantApplyVO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class MerchantApplyServiceImpl implements MerchantApplyService {

    private final MerchantApplyMapper applyMapper;
    private final UserMapper userMapper;

    @Override
    public void submitApply(Long userId, MerchantApplySubmitDTO dto) {
        // 检查是否已有申请正在处理或已通过
        LambdaQueryWrapper<MerchantApply> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantApply::getUserId, userId)
                .in(MerchantApply::getStatus, 0, 1); // 待审核或已通过
        if (applyMapper.selectCount(wrapper) > 0) {
            throw new BusinessException("您已有申请正在处理或已是商家");
        }

        MerchantApply apply = new MerchantApply();
        BeanUtils.copyProperties(dto, apply);
        apply.setUserId(userId);
        apply.setStatus(0); // 待审核
        applyMapper.insert(apply);
    }



    @Override
    public Page<MerchantApplyVO> getApplyList(Integer pageNum, Integer pageSize, Integer status) {
        Page<MerchantApplyVO> page = new Page<>(pageNum, pageSize);
        return applyMapper.selectApplyPage(page, status);
    }

    @Override
    public void auditApply(Long applyId, Integer status, String remark) {
        MerchantApply apply = applyMapper.selectById(applyId);
        if (apply == null) {
            throw new BusinessException("申请记录不存在");
        }
        if (apply.getStatus() != 0) {
            throw new BusinessException("该申请已被处理");
        }
        apply.setStatus(status);
        apply.setRemark(remark);
        applyMapper.updateById(apply);

        if (status == 1) { // 审核通过，修改用户角色为 MERCHANT
            User user = userMapper.selectById(apply.getUserId());
            if (user != null && !"MERCHANT".equals(user.getRole())) {
                user.setRole("MERCHANT");
                userMapper.updateById(user);
            }
        }
    }

    @Override
    public MerchantApplyVO getMyApply(Long userId) {
        // 查询申请记录
        MerchantApply apply = applyMapper.selectOne(
                new LambdaQueryWrapper<MerchantApply>().eq(MerchantApply::getUserId, userId)
        );
        if (apply == null) {
            throw new BusinessException("未找到入驻信息");
        }
        MerchantApplyVO vo = convertToVO(apply);
        // 查询用户状态
        User user = userMapper.selectById(userId);
        if (user != null) {
            vo.setUsername(user.getUsername());
            vo.setNickname(user.getNickname());
        }
        return vo;
    }



    /**
     * 实体转VO
     */
    private MerchantApplyVO convertToVO(MerchantApply apply) {
        if (apply == null) return null;
        MerchantApplyVO vo = new MerchantApplyVO();
        BeanUtils.copyProperties(apply, vo);
        // 如果需要关联用户信息，可以单独查询 user 表
        return vo;
    }
}