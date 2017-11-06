package cn.arvix.ontheway.ducuments.entity;

/**
 * @author Created by yangyang on 2017/3/31.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public enum DocumentDirType {
    common("公共文件夹"), user("用户创建"), attachment("附件文件夹");

    private final String info;

    DocumentDirType(String info) {
        this.info = info;
    }

    public String getInfo() {
        return info;
    }

}
