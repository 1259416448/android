package cn.arvix.ontheway.sys.dto;

import io.swagger.annotations.ApiModelProperty;

/**
 * 数据分权DTO
 *
 * @author Created by yangyang on 2017/6/23.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class AuthDataOneDTO {

    //需要授权的用户ID数据
    @ApiModelProperty(value = "需要授权的用户ID数据")
    private Long[] userIds;
    //需要授权的组织机构数据
    @ApiModelProperty(value = "需要授权的组织机构数据")
    private Long[] organizationIds;

    @ApiModelProperty(value = "单条数据允许执行的操作，接收一个int类型数据作为标示，规定 1 可查 2 可改")
    private Integer opType;

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

    public Integer getOpType() {
        return opType;
    }

    public void setOpType(Integer opType) {
        this.opType = opType;
    }
}
