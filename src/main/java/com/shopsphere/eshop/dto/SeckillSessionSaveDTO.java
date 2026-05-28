package com.shopsphere.eshop.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class SeckillSessionSaveDTO {
    private Long id;

    @NotNull(message = "请选择优惠券")
    private Long couponId;

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
