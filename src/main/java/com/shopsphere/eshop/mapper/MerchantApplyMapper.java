package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.entity.MerchantApply;
import com.shopsphere.eshop.vo.MerchantApplyVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface MerchantApplyMapper extends BaseMapper<MerchantApply> {
    // 分页查询申请列表（联查用户表获取用户名）
    Page<MerchantApplyVO> selectApplyPage(Page<?> page, @Param("status") Integer status);

    @Select("SELECT COUNT(*) FROM merchant_apply WHERE status = 0")
    Long selectPendingCount();
}