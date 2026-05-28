package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.RefundQueryDTO;
import com.shopsphere.eshop.entity.RefundApplication;
import com.shopsphere.eshop.vo.RefundApplicationVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface RefundApplicationMapper extends BaseMapper<RefundApplication> {
    Page<RefundApplicationVO> selectRefundPage(Page<RefundApplicationVO> page, RefundQueryDTO queryDTO);
}