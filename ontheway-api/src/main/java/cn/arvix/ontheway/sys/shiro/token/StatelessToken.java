package cn.arvix.ontheway.sys.shiro.token;

import org.apache.shiro.authc.AuthenticationToken;

public class StatelessToken implements AuthenticationToken {

    private String username;
    private String token;

    public StatelessToken(String username, String token) {
        this.username = username;
        this.token = token;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    @Override
    public Object getPrincipal() {
        return this.getUsername();
    }

    @Override
    public Object getCredentials() {
        return this.token;
    }

}
