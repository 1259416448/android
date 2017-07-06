package cn.arvix.ontheway.sys.dto;

import io.swagger.annotations.ApiModelProperty;

/**
 * @author Created by yangyang on 2017/3/20.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class LoginDTO {

    @ApiModelProperty(required = true, value = "用户名/email/手机号码")
    private String username;
    @ApiModelProperty(required = true, value = "登陆密码/手机验证码")
    private String password;
    @ApiModelProperty(required = true, value = "记住我")
    private Boolean rememberMe = false;

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

    public Boolean getRememberMe() {
        return rememberMe;
    }

    public void setRememberMe(Boolean rememberMe) {
        this.rememberMe = rememberMe;
    }
}
