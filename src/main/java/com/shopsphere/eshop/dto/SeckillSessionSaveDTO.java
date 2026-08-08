package com.shopsphere.eshop.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class SeckillSessionSaveDTO {
    private Long id;

    /** 场次类型：0=秒杀优惠券 1=秒杀商品（默认 0） */
    private Integer seckillType;

    /** 秒券模式必填 */
    private Long couponId;

    /** 秒商品模式必填 */
    private Long productId;

    /** 秒商品模式可选：指定SKU */
    private Long skuId;

    /** 秒商品模式必填：秒杀价 */
    private BigDecimal seckillPrice;

    @NotBlank(message = "请输入场次名称")
    private String sessionName;

    @NotNull(message = "请选择开始时间")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime startTime;

    @NotNull(message = "请选择结束时间")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime endTime;

    @NotNull(message = "请输入秒杀库存")
    private Integer seckillStock;

    private Integer limitPerUser;
}
