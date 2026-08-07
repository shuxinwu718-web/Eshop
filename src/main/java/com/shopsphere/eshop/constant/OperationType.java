package com.shopsphere.eshop.constant;

/**
 * 操作日志类型常量
 *
 * Q13 整改：统一 @Log(type = ...) 的命名规范（全部为 UPPER_SNAKE_CASE），
 * 消除 "Cancle_Order"/"Change_Status" 等拼写与命名混乱。
 */
public final class OperationType {

    private OperationType() {}

    // 优惠券
    public static final String ADD_COUPON = "ADD_COUPON";
    public static final String UPDATE_COUPON = "UPDATE_COUPON";
    public static final String DELETE_COUPON = "DELETE_COUPON";
    public static final String CHANGE_STATUS = "CHANGE_STATUS";

    // 退款
    public static final String AUDIT_REFUND = "AUDIT_REFUND";

    // 秒杀场次
    public static final String ADD_SECKILL_SESSION = "ADD_SECKILL_SESSION";
    public static final String UPDATE_SECKILL_SESSION = "UPDATE_SECKILL_SESSION";
    public static final String DELETE_SECKILL_SESSION = "DELETE_SECKILL_SESSION";
    public static final String CANCEL_SECKILL_SESSION = "CANCEL_SECKILL_SESSION";
    public static final String PREHEAT_SECKILL = "PREHEAT_SECKILL";

    // 商品分类
    public static final String ADD_CATEGORY = "ADD_CATEGORY";
    public static final String UPDATE_CATEGORY = "UPDATE_CATEGORY";
    public static final String DELETE_CATEGORY = "DELETE_CATEGORY";

    // 通知
    public static final String PUBLISH_NOTICE = "PUBLISH_NOTICE";
    public static final String DELETE_NOTICE = "DELETE_NOTICE";

    // 订单
    public static final String CANCEL_ORDER = "CANCEL_ORDER";

    // 商品
    public static final String DELETE_PRODUCT = "DELETE_PRODUCT";

    // 用户
    public static final String QUERY_USERS = "QUERY_USERS";
    public static final String FREEZE_USER = "FREEZE_USER";
    public static final String UNFREEZE_USER = "UNFREEZE_USER";
    public static final String VIEW_ONLINE_USERS = "VIEW_ONLINE_USERS";
    public static final String KICK_USER = "KICK_USER";
    public static final String SEARCH_USERS = "SEARCH_USERS";
}
