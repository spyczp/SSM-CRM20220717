package com.atom.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {
    /**
     * 对指定的Date类型对象进行格式化：yyyy-MM-dd HH:mm:ss
     * @param date
     * @return 字符串格式的日期
     */
    public static String formatDateTime(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dateStr = sdf.format(date);
        return dateStr;
    }

    /**
     * 对指定的Date类型对象进行格式化：yyyy-MM-dd
     * @param date
     * @return 字符串格式的年月日
     */
    public static String formatDate(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String dateStr = sdf.format(date);
        return dateStr;
    }

    /**
     * 对指定的Date类型对象进行格式化：HH:mm:ss
     * @param date
     * @return 字符串格式的时分秒
     */
    public static String formatTime(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
        String dateStr = sdf.format(date);
        return dateStr;
    }
}
