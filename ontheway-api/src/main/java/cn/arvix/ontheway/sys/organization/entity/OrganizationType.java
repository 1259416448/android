package cn.arvix.ontheway.sys.organization.entity;

public enum OrganizationType {
    saas("saas默认"), bloc("集团"), branch_office("分公司"), department("部门"), group("部门小组");

    private final String info;

    private OrganizationType(String info) {
        this.info = info;
    }

    public String getInfo() {
        return info;
    }
}
