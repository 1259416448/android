package cn.arvix.ontheway.sys.user.entity;

import java.io.Serializable;

/**
 * 保存token信息 包含用户用户名、访问客户端
 *
 * @author Created by yangyang on 2017/4/26.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class TokenInfo implements Serializable {

    private String token;

    private String username;

    private String client;

    public TokenInfo(String token, String username, String client) {
        this.token = token;
        this.username = username;
        this.client = client;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getClient() {
        return client;
    }

    public void setClient(String client) {
        this.client = client;
    }
}
