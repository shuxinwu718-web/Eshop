package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.GroupBuyActivity;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface GroupBuyActivityMapper extends BaseMapper<GroupBuyActivity> {

    /**
     * 拼团成团时扣减活动成团名额：仅当名额充足时才扣减成功，防止超发。
     * total_stock 语义 = 活动可成团次数（每成功一个团扣 1）。
     *
     * @return 受影响行数，0 表示名额不足
     */
    @Update("UPDATE group_buy_activity SET total_stock = total_stock - #{count} WHERE id = #{id} AND total_stock >= #{count}")
    int deductStock(@Param("id") Long id, @Param("count") int count);
}
