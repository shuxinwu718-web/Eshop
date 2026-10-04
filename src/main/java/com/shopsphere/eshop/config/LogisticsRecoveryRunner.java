package com.shopsphere.eshop.config;

import com.shopsphere.eshop.service.ShipmentTrackService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

/**
 * 模拟物流兜底：应用启动后扫描已发货但轨迹缺失/未推完的发货单，
 * 按发货时间推算补投延迟消息，防止消息全部丢失导致轨迹与自动收货停滞。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class LogisticsRecoveryRunner implements ApplicationRunner {

    private final ShipmentTrackService shipmentTrackService;

    @Override
    public void run(ApplicationArguments args) {
        try {
            shipmentTrackService.recoverMissingTracks();
        } catch (Exception e) {
            log.error("模拟物流启动兜底扫描失败", e);
        }
    }
}
