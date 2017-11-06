package cn.arvix.ontheway.sys.user.entity;

/**
 * @author Created by yangyang on 2017/3/8.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public enum UserStatus {
    normal("正常状态"), blocked("封禁状态");

    private final String info;

    UserStatus(String info) {
        this.info = info;
    }

    public String getInfo() {
        return info;
    }
}
