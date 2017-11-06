package cn.arvix.ontheway.sys.dto;

import io.swagger.annotations.ApiModelProperty;

/**
 * @author Created by yangyang on 2017/3/19.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class AuthUserOrganizationDTO {

    //需要授权的用户ID数据
    @ApiModelProperty(value = "需要授权的用户ID数据")
    private Long[] userIds;
    //需要授权的组织机构数据
    @ApiModelProperty(value = "需要授权的组织机构数据")
    private Long[] organizationIds;
    //角色ID数组
    @ApiModelProperty(value = "角色ID数组")
    private Long[] roleIds;

    public Long[] getUserIds() {
        return userIds;
    }

    public void setUserIds(Long[] userIds) {
        this.userIds = userIds;
    }

    public Long[] getOrganizationIds() {
        return organizationIds;
    }

    public void setOrganizationIds(Long[] organizationIds) {
        this.organizationIds = organizationIds;
    }

    public Long[] getRoleIds() {
        return roleIds;
    }

    public void setRoleIds(Long[] roleIds) {
        this.roleIds = roleIds;
    }
}
