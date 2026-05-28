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

    void seckill(Long sessionId, Long userId);
}
