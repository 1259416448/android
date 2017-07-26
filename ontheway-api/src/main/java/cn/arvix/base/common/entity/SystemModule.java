package cn.arvix.base.common.entity;

/**
 * @author Created by yangyang on 2017/4/7.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public enum SystemModule {
    footprint("足迹"),user("用户");

    private final String info;

    SystemModule(String info) {
        this.info = info;
    }

    public String getInfo() {
        return info;
    }
}
