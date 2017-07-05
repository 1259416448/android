package cn.arvix.base.common.utils;

import com.google.common.collect.Lists;
import org.apache.commons.lang3.StringUtils;

import java.util.Calendar;
import java.util.Collection;
import java.util.List;
import java.util.Map;


public class Checks {

    /**
     * 是否合法邮箱
     */
    public static boolean isEmail(String email) {
        return email != null && email.length() > 6 && email.matches("^[\\w\\-\\.]+@[\\w\\-\\.]+(\\.\\w+)+$");
    }

    /**
     * 判断对象obj 是否为空或无数据
     */
    @SuppressWarnings("InfiniteRecursion")
    public static boolean empty(Object[] obj) {
        if (empty(obj)) return true;
        for (Object aObj : obj) {
            if (empty(aObj)) return true;
        }
        return false;
    }

    public static boolean empty(Object obj) {
        if (obj == null) {
            return true;
        } else if (obj instanceof String && (obj.toString().trim().equals("") || obj.toString().trim().length() == 0)) {
            return true;
        } else if (obj instanceof Collection && ((Collection) obj).isEmpty()) {
            return true;
        } else if (obj instanceof Map && ((Map) obj).isEmpty()) {
            return true;
        } else if (obj instanceof Object[] && ((Object[]) obj).length == 0) {
            return true;
        }
        return false;
    }

    public static boolean checkdate(int year, int month, int day) {
        if (year < 1 || year > 9999 || month < 1 || month > 12 || day < 1) {
            return false;
        }

        Calendar calendar = Calendar.getInstance();
        //noinspection MagicConstant
        calendar.set(year, month - 1, 1);

        int maxDay = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
        return day <= maxDay;
    }

    /**
     * 字符串是否为数字
     */
    public static boolean isNum(String value) {
        return toInteger(value) != null || toDouble(value) != null;
    }

    /**
     * 字符串是否为Double
     */
    public static Double toDouble(String value) {
        if (value == null || value.trim().length() == 0)
            return null;
        try {
            return Double.parseDouble(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 字符串是否为Float
     */
    public static Float toFloat(String value) {
        if (value == null || value.trim().length() == 0)
            return null;
        try {
            return Float.parseFloat(value);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 字符串是否为Integer
     */
    public static Integer toInteger(String value) {
        if (value == null || value.trim().length() == 0)
            return null;
        try {
            return Integer.parseInt(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 字符串是否为Long
     */
    public static Long toLong(String value) {
        if (value == null || value.trim().length() == 0)
            return null;
        try {
            return Long.parseLong(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 防止sql注入，排序字符串只能包含字符 数字 下划线 点 ` "
     *
     * @param property 验证属性
     */
    public static void assertSortProperty(String property) {
        if (!StringUtils.isEmpty(property) && !property.matches("[a-zA-Z0-9_、.`\"]*")) {
            throw new IllegalStateException("Sort property error, only contains [a-zA-Z0-9_.`\"]");
        }
    }

    /**
     * 把 以 , 分割的数组转为Long[]
     *
     * @param value 数据
     * @return 结果
     */
    public static Long[] toLongs(String value) {
        List<Long> longList = Lists.newArrayList();
        if (!StringUtils.isEmpty(value)) {
            for (String val : value.split(",")) {
                Long l = Checks.toLong(val);
                if (l != null) {
                    longList.add(l);
                }
            }
        }
        Long[] longs = new Long[longList.size()];
        return longList.toArray(longs);
    }
}
