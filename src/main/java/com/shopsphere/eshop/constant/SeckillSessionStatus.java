package com.shopsphere.eshop.constant;

/**
 * 秒杀场次状态常量
 */
public final class SeckillSessionStatus {

    private SeckillSessionStatus() {}

    /** 待开始 */
    public static final int PENDING = 0;

    /** 进行中 */
    public static final int ACTIVE = 1;

    /** 已结束 */
    public static final int ENDED = 2;

    /** 已撤销 */
    public static final int CANCELLED = 3;
}
