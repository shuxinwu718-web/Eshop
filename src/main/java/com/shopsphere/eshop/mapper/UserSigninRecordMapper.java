package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.UserSigninRecord;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserSigninRecordMapper extends BaseMapper<UserSigninRecord> {
    // 可自定义查询最近连续签到天数，这里利用 SQL 或 Java 逻辑计算
}