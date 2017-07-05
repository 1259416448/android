package cn.arvix.ontheway.sys.dto;

import io.swagger.annotations.ApiModelProperty;

/**
 * @author Created by yangyang on 2017/3/18.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class UserIdOrganizationIdDTO {

    @ApiModelProperty(required = true, value = "用户ID")
    private Long userId;
    @ApiModelProperty(required = true, value = "组织机构（团队）ID")
    private Long organizationId;

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getOrganizationId() {
        return organizationId;
    }

    public void setOrganizationId(Long organizationId) {
        this.organizationId = organizationId;
    }
}
