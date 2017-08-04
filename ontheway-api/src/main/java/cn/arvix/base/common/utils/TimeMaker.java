package cn.arvix.base.common.utils;

import com.google.common.collect.Maps;
import org.apache.commons.lang3.StringUtils;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@SuppressWarnings({"unused", "WeakerAccess"})
public class TimeMaker {
    private static SimpleDateFormat formater;
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    private static final SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy/MM/dd");
    private static final SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    private static final SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
    private static final SimpleDateFormat dateTimeFormat2 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

    private static final Map<Integer, Integer> diffMap = Maps.newHashMap();

    public static final Long ONE_MINUIT = 60 * 1000L;

    public static final Long ONE_HOUR = 60 * 60 * 1000L;

    public static final Long ONE_DAY = 24 * 60 * 60 * 1000L;

    public static final Long ONE_MONTH = 30 * 24 * 60 * 60 * 1000L;

    public static final Long ONE_YEAR = 365 * 30 * 24 * 60 * 60 * 1000L;

    static {
        dateFormat.setLenient(false);// 这个的功能是不把1996-13-3 转换为1997-1-3
        dateTimeFormat.setLenient(false);
        diffMap.put(3, 6);
        diffMap.put(4, 5);
        diffMap.put(5, 4);
        diffMap.put(6, 3);
        diffMap.put(7, 2);
        diffMap.put(1, 1);
    }

    /**
     * 指定格式的当前时间
     */
    public static String nowByFormatStr(String formatStr) {
        if (StringUtils.isEmpty(formatStr)) return "";
        formater = new SimpleDateFormat(formatStr);
        return formater.format(new Date());
    }

    /**
     * 返回当前时间的java.sql.Timestamp格式
     */
    public static Timestamp nowSqlTimestamp() {
        return new Timestamp(new Date().getTime());
    }

    /**
     * 返回当前时间的Timestamp格式
     */
    public static Timestamp nowTimestamp() {
        return dateToTimestamp(new Date());
    }

    /**
     * 返回当前时间的java.sql.Date格式
     */
    public static java.sql.Date nowSqlDate() {
        long ltime = System.currentTimeMillis();
        return new java.sql.Date(ltime);
    }

    /**
     * @return yyyy-MM-dd
     */
    public static String nowDate() {
        synchronized (dateFormat) {
            return dateFormat.format(new Date());
        }
    }

    /**
     * @return HH:mm:ss
     */
    public static String nowTime() {
        synchronized (timeFormat) {
            return timeFormat.format(new Date());
        }
    }

    /**
     * @return yyyy-MM-dd HH:mm:ss
     */
    public static String nowDataTime() {
        synchronized (dateTimeFormat) {
            return dateTimeFormat.format(new Date());
        }
    }

    /**
     * @param dateStr yyyy-MM-dd
     */
    public static Date dateStrToDate(String dateStr) {
        if (dateStr == null) return null;
        Date date = null;
        try {
            synchronized (dateFormat) {
                date = dateFormat.parse(dateStr); // Wed sep 26 00:00:00 CST 2007
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return date;
    }

    /**
     * @param dataTimeStr yyyy-MM-dd  HH:mm:ss
     */
    public static Date dateTimeStrToDate(String dataTimeStr) {
        if (dataTimeStr == null)
            return null;
        Date date = null;
        try {
            synchronized (dateTimeFormat) {
                date = dateTimeFormat.parse(dataTimeStr);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return date;
    }

    /**
     * @param dataTimeStr yyyy-MM-dd HH:mm:ss
     */
    public static Timestamp dateStrToTimestamp(String dataTimeStr) {
        if (dataTimeStr == null) return null;
        Date date = dateTimeStrToDate(dataTimeStr.trim());
        if (date == null) return null;
        return new Timestamp(date.getTime());
    }

    /**
     * @param dateStr yyyy-MM-dd
     */
    public static Timestamp dataTimeStrToTimestamp(String dateStr) {
        if (dateStr == null) return null;
        Date date = dateStrToDate(dateStr.trim());
        if (date == null) return null;
        return new Timestamp(date.getTime());
    }

    /**
     * Date转Timestamp
     */
    public static Timestamp dateToTimestamp(Date date) {
        if (date == null)
            return null;
        return new Timestamp(date.getTime());
    }

    /**
     * 时间字符串转换Date
     */
    public static Date parseStringToDate(String dateStr, String formatStr) {
        if (StringUtils.isEmpty(dateStr)) return null;
        if (StringUtils.isEmpty(formatStr)) return parseStringToDate(dateStr);
        formater = new SimpleDateFormat(formatStr);
        try {
            return formater.parse(dateStr);
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 时间字符串转换Date
     */
    public static Date parseStringToDate(String dateStr) {
        if (dateStr == null || dateStr.trim().equals("")) return null;
        dateStr = dateStr.trim();
        Date date = null;
        try {
            if (dateStr.contains("/") && dateStr.length() <= 10) {
                synchronized (dateFormat1) {
                    date = dateFormat1.parse(dateStr);
                }
            } else if (dateStr.contains("/")) {
                synchronized (dateTimeFormat2) {
                    date = dateTimeFormat2.parse(dateStr);
                }
            } else if (dateStr.contains("-") && dateStr.length() <= 10) {
                synchronized (dateFormat) {
                    date = dateFormat.parse(dateStr);
                }
            } else if (dateStr.contains("-")) {
                synchronized (dateTimeFormat) {
                    date = dateTimeFormat.parse(dateStr);
                }
            }
        } catch (Exception e) {
            throw new IllegalArgumentException("你输入的日期不合法，请重新输入");
        }
        return date;
    }

    /**
     * 时间字符串转换java.sql.Timestamp
     */
    public static Timestamp parseStringToSqlTimestamp(String dateStr) {
        Date date = parseStringToDate(dateStr);
        if (date != null)
            return new Timestamp(date.getTime());
        return null;
    }

    /**
     * 返回指定格式的转化
     */
    public static String toFormatStr(Object theDate, String formatStr) {
        if (theDate == null) return "";
        if (StringUtils.isEmpty(formatStr)) {
            synchronized (dateTimeFormat) {
                return dateTimeFormat.format(theDate);
            }
        }
        formater = new SimpleDateFormat(formatStr);
        return formater.format(theDate);
    }

    /**
     * 返回指定格式的转化
     */
    public static String toFormatStr(Object theDate, String formatStr, Locale locale) {
        if (theDate == null) return "";
        if (StringUtils.isEmpty(formatStr)) {
            synchronized (dateTimeFormat) {
                return dateTimeFormat.format(theDate);
            }
        }
        formater = new SimpleDateFormat(formatStr, locale);
        return formater.format(theDate);
    }

    /**
     * 返回【yyyy-MM-dd HH:mm:ss】的格式
     */
    public static String toDateTimeStr(Object theDate) {
        if (theDate == null) return "";
        synchronized (dateTimeFormat) {
            return dateTimeFormat.format(theDate);
        }
    }

    /**
     * 返回【yyyy-MM-dd】的格式
     */
    public static String toDateStr(Object theDate) {
        if (theDate == null) return "";
        synchronized (dateFormat) {
            return dateFormat.format(theDate);
        }
    }

    /**
     * 返回【HH:mm:ss】的格式
     */
    public static String toTimeStr(Object theDate) {
        if (theDate == null) return "";
        synchronized (timeFormat) {
            return timeFormat.format(theDate);
        }
    }

    /**
     * 获取年份
     */
    public static Integer getYear(Object theDate) {
        if (theDate == null)
            return null;
        SimpleDateFormat format = new SimpleDateFormat("yyyy");
        return Integer.parseInt(format.format(theDate));
    }

    /**
     * 获取月份
     */
    public static Integer getMonth(Object theDate) {
        if (theDate == null)
            return null;
        SimpleDateFormat format = new SimpleDateFormat("MM");
        return Integer.parseInt(format.format(theDate));
    }

    /**
     * 获取日期日
     */
    public static Integer getDay(Object theDate) {
        if (theDate == null)
            return null;
        SimpleDateFormat format = new SimpleDateFormat("dd");
        return Integer.parseInt(format.format(theDate));
    }

    /**
     * 获取日期日
     */
    public static String getDayStr(Object theDate) {
        if (theDate == null)
            return null;
        SimpleDateFormat format = new SimpleDateFormat("dd");
        return format.format(theDate);
    }

    /**
     * 取昨天的日期
     */
    public static java.sql.Date getYesterdaySQLDate() {
        long ltime = System.currentTimeMillis();
        return new java.sql.Date(ltime - 24 * 60 * 60 * 1000);
    }

    /**
     * 取昨天的日期
     */
    public static Date beforeDate(Date theDate) {
        if (theDate == null)
            return null;
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(theDate);
        calendar.roll(Calendar.DAY_OF_YEAR, -1);
        return calendar.getTime();
    }

    /**
     * 获取明天的日期
     */
    public static Date nextDate(Date theDate) {
        if (theDate == null) return null;
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(theDate);
        calendar.roll(Calendar.DAY_OF_YEAR, +1);
        return calendar.getTime();
    }

    public static int getBetweenDateNo(Date date1, Date date2) {
        return getBetweenDate(date1, date2).length;
    }

    /**
     * 取中间的日期
     */
    public static String[] getBetweenDate(Date date1, Date date2) {
        Vector<String> s = new Vector<>();
        GregorianCalendar gc1 = new GregorianCalendar(), gc2 = new GregorianCalendar();
        gc1.setTime(date1);
        gc2.setTime(date2);
        do {
            GregorianCalendar gc3 = (GregorianCalendar) gc1.clone();
            synchronized (dateFormat1) {
                s.add(dateFormat1.format(gc3.getTime()));
            }
            gc1.add(Calendar.DAY_OF_MONTH, 1);
        } while (!gc1.after(gc2));
        return s.toArray(new String[s.size()]);
    }

    /**
     * 取星期几
     */
    public static String getWeek(Date theDate) {
        String[] weekDays = {"星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"};
        Calendar cal = Calendar.getInstance();
        cal.setTime(theDate);
        int w = cal.get(Calendar.DAY_OF_WEEK) - 1;
        if (w < 0) w = 0;
        return weekDays[w];

    }

    /**
     * 取时间差
     */
    public static String getDValue(Date theDate1, Date theDate2) {
        if (theDate1 == null || theDate2 == null) return "";
        long millisecond = theDate2.getTime() - theDate1.getTime();
        if (millisecond < 0) return "";
        if (millisecond == 0) return "0毫秒";
        int secondMs = 1000;
        int minuteMs = secondMs * 60;
        int hourMs = minuteMs * 60;
        int dayMs = hourMs * 24;
        long surplus = millisecond;//剩余
        long day = millisecond / dayMs;
        surplus -= day * dayMs;
        long hour = surplus / hourMs;
        surplus -= hour * hourMs;
        long minute = surplus / minuteMs;
        surplus -= minute * minuteMs;
        long second = surplus / secondMs;
        surplus -= second * secondMs;
        long milliSecond = surplus;
        StringBuilder resBuffer = new StringBuilder();
        if (day != 0) resBuffer.append(day).append(" 天 ");
        if (hour != 0) resBuffer.append(hour).append(" 小时 ");
        if (minute != 0) resBuffer.append(minute).append(" 分 ");
        if (second != 0) resBuffer.append(second).append(" 秒 ");
        if (milliSecond != 0) resBuffer.append(milliSecond).append(" 毫秒 ");
        return resBuffer.toString();
    }

    /*	public static void main(String[] a){
            System.out.println(TimeMaker.parseStringToSqlTimestamp("1992-10-29"));
        }*/
    public static String getCron(Object date) {
        String dateFormat = "ss mm HH dd MM ? yyyy";
        return toFormatStr(date, dateFormat);
    }

    /**
     * 前n小时
     */
    public static String getBeforehour(int hour) {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.HOUR, hour);
        synchronized (dateTimeFormat) {
            return dateTimeFormat.format(calendar.getTime());
        }
    }

    /**
     * 后n天
     */
    public static Date getAfterDay(Date date, int day) {
        return getBeforeDay(date, -day);
    }

    /**
     * 前n天
     */
    public static Date getBeforeDay(Date date, int day) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.DATE, -day);
        return calendar.getTime();
    }

    /**
     * 前n月
     */
    public static String getBeforeMonth(int month) {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MONTH, month);
        synchronized (dateTimeFormat) {
            return dateTimeFormat.format(calendar.getTime());
        }
    }

    /**
     * 获取本周一时间(中国习惯)
     */
    public static String getMonday() {
        Calendar cal = Calendar.getInstance();
        cal.setFirstDayOfWeek(Calendar.MONDAY);
        cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
        synchronized (dateFormat) {
            return dateFormat.format(cal.getTime());
        }
    }

    /**
     * 获取本周周末时间(中国习惯)
     */
    public static String getSunday() {
        Calendar cal = Calendar.getInstance();
        cal.setFirstDayOfWeek(Calendar.MONDAY);
        cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
        synchronized (dateFormat) {
            return dateFormat.format(cal.getTime());
        }
    }

    /**
     * 比较两个时间是否属于同一天
     *
     * @param date1 data1
     * @param date2 data2
     * @return 对比结果
     */
    public static boolean isSameDate(Date date1, Date date2) {
        Calendar cal1 = Calendar.getInstance();
        cal1.setTime(date1);

        Calendar cal2 = Calendar.getInstance();
        cal2.setTime(date2);

        boolean isSameYear = cal1.get(Calendar.YEAR) == cal2
                .get(Calendar.YEAR);
        boolean isSameMonth = isSameYear
                && cal1.get(Calendar.MONTH) == cal2.get(Calendar.MONTH);

        return isSameMonth
                && cal1.get(Calendar.DAY_OF_MONTH) == cal2
                .get(Calendar.DAY_OF_MONTH);
    }

    /**
     * 某年某月一共有多少周
     *
     * @param year  年
     * @param month 月
     * @return 周数
     */
    public static int weekOfMonth(int year, int month) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(year, month, 0);
        int day = calendar.get(Calendar.DAY_OF_MONTH);
        calendar.set(Calendar.DAY_OF_MONTH, 1); //第一天
        int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
        if (dayOfWeek != Calendar.MONDAY) {
            day = day - diffMap.get(dayOfWeek);
        }
        return day / 7 + (day % 7 == 0 ? 0 : 1);
    }

    /**
     * 某年某季度一共有多少周
     *
     * @param year    年
     * @param quarter 季度
     * @return 周数
     */
    public static int weekOfYearQuarter(int year, int quarter) {
        int day;
        int month = 0;
        if (quarter == 1) {
            day = 31 + 31;
            if (year % 4 == 0) {
                day = day + 29;
            } else {
                day = day + 28;
            }
        } else if (quarter == 2) {
            day = 30 + 31 + 30;
            month = 3;
        } else if (quarter == 3) {
            day = 31 + 31 + 30;
            month = 6;
        } else {
            month = 9;
            day = 31 + 30 + 31;
        }
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.YEAR, year);
        calendar.set(Calendar.MONTH, month);
        calendar.set(Calendar.DAY_OF_MONTH, 1); //1月第一天
        int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
        if (dayOfWeek != Calendar.MONDAY) {
            day = day - diffMap.get(dayOfWeek);
        }
        return day / 7 + (day % 7 == 0 ? 0 : 1);
    }

    public static Long toTimeMillis(Date date) {
        if (date != null) {
            return date.getTime();
        }
        return null;
    }

    /**
     * 请两个时间的时间差 天数 不能跨两年
     *
     * @param date1 开始时间
     * @param date2 结束时间
     * @return data2 -data1 非严格意义的天数差 data2>data1  否则 -1
     */
    public static int timeDiffByDay(Date date1, Date date2) {
        if (date1 == null || date2 == null) return -1;
        if (date1.after(date2)) return -1;
        Calendar calendar = Calendar.getInstance();
        //当前日期在第几天
        calendar.setTime(date1);
        int day1 = calendar.get(Calendar.DAY_OF_YEAR);
        int year1 = calendar.get(Calendar.YEAR);
        calendar.setTime(date2);
        //任务日期在第几天
        int day2 = calendar.get(Calendar.DAY_OF_YEAR);
        int year2 = calendar.get(Calendar.YEAR);
        int day;
        //判断当前日期是否跨年
        if (year2 != year1) {
            if (year1 % 4 == 0) {
                day = 366 - day1;
            } else {
                day = 365 - day1;
            }
            day = day + day2;
            //判断跨年数量
            for (int i = 1; i < year2 - year1; i++) {
                if ((year1 + i) % 4 == 0) {
                    day = day + 366;
                } else {
                    day = day + 365;
                }
            }
        } else {
            day = day2 - day1;
        }
        return day;
    }

    /**
     * 根据传入的时间计算距离当前时间多久
     *
     * @param time 时间戳
     * @return 时间字符串
     */
    public static String dateCreatedStr(Long time) {
        Long currentTime = System.currentTimeMillis();
        Long diffTime = currentTime - time;
        String str = "";
        if(diffTime < 1000){
            str = "刚刚";
        }else if (diffTime < ONE_MINUIT) {
            str = diffTime / 1000 + "秒前";
        } else if (diffTime < ONE_HOUR) {
            str = diffTime / ONE_MINUIT + "分钟前";
        } else if (diffTime < ONE_DAY) {
            str = diffTime / ONE_HOUR + "小时前";
        } else if (diffTime < ONE_MONTH) {
            str = diffTime / ONE_DAY + "天前";
        } else if (diffTime < ONE_YEAR) {
            str = diffTime / ONE_MONTH + "月前";
        } else {
            str = diffTime / ONE_YEAR + "年前";
        }
        return str;
    }

}
