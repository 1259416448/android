package cn.arvix.ontheway.sys.resource.entity;

/**
 * @author Created by yangyang on 2017/3/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public enum ResourceType {

    column("栏目"), button("按钮");

    private final String info;

    ResourceType(String info) {
        this.info = info;
    }

    public String getInfo() {
        return info;
    }
}
