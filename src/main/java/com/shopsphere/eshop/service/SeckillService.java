package com.shopsphere.eshop.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.shopsphere.eshop.dto.SeckillSessionSaveDTO;
import com.shopsphere.eshop.entity.SeckillSession;

public interface SeckillService {

    Page<SeckillSession> pageQuery(String sessionName, Integer status, Long couponId,
                                   Integer pageNum, Integer pageSize);

    SeckillSession getById(Long id);

    void create(SeckillSessionSaveDTO dto);

    void update(SeckillSessionSaveDTO dto);

    void delete(Long id);

    void cancel(Long id);

    void preheatStock(Long id);

    /**
     * 参与秒杀
     *
     * @param sessionId 场次ID
     * @param userId    用户ID
     * @param addressId 收货地址ID（秒杀商品模式必填，秒杀券模式忽略）
     * @return 秒杀商品模式下返回生成的订单ID；秒杀券模式返回 null
     */
    Long seckill(Long sessionId, Long userId, Long addressId);
}
