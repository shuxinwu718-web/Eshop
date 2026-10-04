package com.shopsphere.eshop.constant;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 模拟快递公司枚举（物流轨迹模拟用）
 *
 * 商家发货时可从该列表选择快递公司；运单号由系统按公司前缀自动生成。
 */
public enum SimulatedExpressCompany {

    SF("顺丰速运", "SF"),
    YTO("圆通速递", "YT"),
    ZTO("中通快递", "ZT"),
    YUNDA("韵达快递", "YD"),
    EMS("中国邮政EMS", "EMS");

    /** 展示名称 */
    private final String name;
    /** 运单号前缀 */
    private final String prefix;

    SimulatedExpressCompany(String name, String prefix) {
        this.name = name;
        this.prefix = prefix;
    }

    public String getName() {
        return name;
    }

    public String getPrefix() {
        return prefix;
    }

    /** 所有快递公司展示名称列表（商家发货下拉用） */
    public static List<String> names() {
        return Arrays.stream(values()).map(SimulatedExpressCompany::getName).collect(Collectors.toList());
    }

    /** 按展示名称匹配；未匹配到默认返回第一个（顺丰） */
    public static SimulatedExpressCompany match(String name) {
        if (name != null) {
            for (SimulatedExpressCompany company : values()) {
                if (company.name.equals(name)) {
                    return company;
                }
            }
        }
        return SF;
    }

    /** 根据快递公司名称生成模拟运单号：前缀 + 时间戳后 8 位 + 4 位随机数 */
    public static String generateTrackingNo(String shippingName) {
        SimulatedExpressCompany company = match(shippingName);
        String ts = String.valueOf(System.currentTimeMillis()).substring(5);
        int rand = (int) (Math.random() * 9000) + 1000;
        return company.getPrefix() + ts + rand;
    }
}
