package cn.arvix.ontheway.sys.dto;

import io.swagger.annotations.ApiModelProperty;

/**
 * @author Created by yangyang on 2017/3/28.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class RegisterDTO {

    @ApiModelProperty(value = "注册用户名")
    private String username;

    @ApiModelProperty(value = "用户密码")
    private String password;

    @ApiModelProperty(value = "用户姓名")
    private String name;

    @ApiModelProperty(value = "角色id数组")
    private Long[] roleIds;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long[] getRoleIds() {
        return roleIds;
    }

    public void setRoleIds(Long[] roleIds) {
        this.roleIds = roleIds;
    }
}
