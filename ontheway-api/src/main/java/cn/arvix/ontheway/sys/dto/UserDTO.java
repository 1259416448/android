package cn.arvix.ontheway.sys.dto;

import cn.arvix.ontheway.sys.user.entity.User;

/**
 * @author Created by yangyang on 2017/3/17.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

public class UserDTO {

    //添加用户
    private User user;

    //添加用户所属组织机构ID 数组
    private Long[] organizationIds;

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Long[] getOrganizationIds() {
        return organizationIds;
    }

    public void setOrganizationIds(Long[] organizationIds) {
        this.organizationIds = organizationIds;
    }
}
