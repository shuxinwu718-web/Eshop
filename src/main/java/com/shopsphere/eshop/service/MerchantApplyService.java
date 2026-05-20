package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.MerchantApplySubmitDTO;
import com.shopsphere.eshop.vo.MerchantApplyVO;

public interface MerchantApplyService {
    void submitApply(Long userId, MerchantApplySubmitDTO dto);
    Page<MerchantApplyVO> getApplyList(Integer pageNum, Integer pageSize, Integer status);
    void auditApply(Long applyId, Integer status, String remark);

    MerchantApplyVO getMyApply(Long merchantId);
}