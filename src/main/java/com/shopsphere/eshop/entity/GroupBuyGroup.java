package com.shopsphere.eshop.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 拼团团（每个团一行，leader 开团，其他成员见 group_buy_member）
 */
@Data
@TableName("group_buy_group")
public class GroupBuyGroup {

    /** 拼团中 */
    public static final int STATUS_ACTIVE = 0;
    /** 已成团 */
    public static final int STATUS_SUCCESS = 1;
    /** 拼团失败（已对成员退款） */
    public static final int STATUS_FAILED = 2;
    /** 已取消（活动被终止/管理员取消） */
    public static final int STATUS_CANCELLED = 3;

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("activity_id")
    private Long activityId;

    @TableField("group_no")
    private String groupNo;

    @TableField("leader_id")
    private Long leaderId;

    private Integer status;

    @TableField("expire_time")
    private LocalDateTime expireTime;

    @TableField("success_time")
    private LocalDateTime successTime;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField("update_time")
    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;
}
