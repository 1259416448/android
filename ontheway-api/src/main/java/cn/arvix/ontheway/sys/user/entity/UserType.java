package cn.arvix.ontheway.sys.user.entity;

/**
 * @author Created by yangyang on 2017/3/8.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public enum UserType {
    dev("开发管理员"), admin("管理员"), saas("saas用户"), user("普通用户");
    private final String info;

    private UserType(String info) {
        this.info = info;
    }

    public String getInfo() {
        return info;
    }
}
