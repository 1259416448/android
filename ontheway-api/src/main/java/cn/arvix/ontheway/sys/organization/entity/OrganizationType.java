package cn.arvix.ontheway.sys.organization.entity;

public enum OrganizationType {

    user("普通平台用户"), admin("平台管理");

    private final String info;

    private OrganizationType(String info) {
        this.info = info;
    }

    public String getInfo() {
        return info;
    }
}
