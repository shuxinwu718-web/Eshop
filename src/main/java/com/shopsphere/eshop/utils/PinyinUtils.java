package com.shopsphere.eshop.utils;

import com.github.stuxuhai.jpinyin.PinyinFormat;
import com.github.stuxuhai.jpinyin.PinyinHelper;

/**
 * 汉字拼音工具类，用于支持拼音搜索。
 * 存储格式：全拼（不带声调，空格分隔），例如 "手机" -> "shou ji"
 * 搜索时：用户输入 "shouji" 或 "sj" 均可匹配
 */
public class PinyinUtils {

    /**
     * 获取中文文本的全拼（不带声调，空格分隔）
     * 例如："手机" -> "shou ji"，"笔记本电脑" -> "bi ji ben dian nao"
     */
    public static String getPinyin(String text) {
        if (text == null || text.isBlank()) {
            return "";
        }
        try {
            return PinyinHelper.convertToPinyinString(text, " ", PinyinFormat.WITHOUT_TONE);
        } catch (Exception e) {
            return "";
        }
    }

    /**
     * 获取中文文本的拼音首字母缩写
     * 例如："手机" -> "sj", "笔记本电脑" -> "bjbndn"
     */
    public static String getPinyinInitials(String text) {
        if (text == null || text.isBlank()) {
            return "";
        }
        try {
            return PinyinHelper.getShortPinyin(text);
        } catch (Exception e) {
            return "";
        }
    }
}
