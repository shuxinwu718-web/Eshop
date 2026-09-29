package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.ChatMessage;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ChatMessageMapper extends BaseMapper<ChatMessage> {
}