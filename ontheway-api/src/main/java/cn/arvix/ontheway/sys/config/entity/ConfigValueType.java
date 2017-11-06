package cn.arvix.ontheway.sys.config.entity;

/**
 * @author Created by yangyang on 2017/3/14.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public enum ConfigValueType {

    BigDecimal("数字型"), String("字符型"), HTML("html代码"), Boolean("boolean"), DATE("时间字符串");

    private final String info;

    ConfigValueType(java.lang.String info) {
        this.info = info;
    }

    public String getInfo() {
        return info;
    }
}
