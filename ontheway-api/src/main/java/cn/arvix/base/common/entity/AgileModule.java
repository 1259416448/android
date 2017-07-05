package cn.arvix.base.common.entity;

/**
 * @author Created by yangyang on 2017/4/7.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public enum AgileModule {
    blog("日报"), workreport("周志"), task("任务"), document("文档");

    private final String info;

    AgileModule(String info) {
        this.info = info;
    }

    public String getInfo() {
        return info;
    }
}
