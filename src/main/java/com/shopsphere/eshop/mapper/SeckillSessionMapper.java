package com.shopsphere.eshop.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shopsphere.eshop.entity.SeckillSession;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface SeckillSessionMapper extends BaseMapper<SeckillSession> {

    /**
     * 原子扣减秒杀DB库存：仅当库存 > 0 时才扣减成功，防止与 Redis 库存不一致
     *
     * @return 受影响行数，0 表示库存已空
     */
    @Update("UPDATE seckill_session SET seckill_stock = seckill_stock - 1 WHERE id = #{id} AND seckill_stock > 0")
    int deductStock(@Param("id") Long id);
}
