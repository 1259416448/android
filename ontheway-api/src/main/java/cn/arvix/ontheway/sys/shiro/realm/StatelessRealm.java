package cn.arvix.ontheway.sys.shiro.realm;

import cn.arvix.ontheway.sys.auth.service.AuthService;
import cn.arvix.ontheway.sys.shiro.token.StatelessToken;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

public class StatelessRealm extends AuthorizingRealm {

    private static final org.slf4j.Logger log = LoggerFactory.getLogger(StatelessRealm.class);

    private AuthService authService;

    @Autowired
    public void setAuthService(AuthService authService) {
        this.authService = authService;
    }

    @Override
    public boolean supports(AuthenticationToken token) {
        //仅支持StatelessToken类型的Token
        return token instanceof StatelessToken;
    }

    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
        return authService.getAuth(principalCollection, getName());
    }

    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        StatelessToken statelessToken = (StatelessToken) token;
//        if (SystemParms.ifDev()) {

//        }
        log.info("StatelessRealm info userId:{} token:{}", statelessToken.getUsername(), statelessToken.getToken());
        //然后进行客户端消息摘要和服务器端消息摘要的匹配
        return new SimpleAuthenticationInfo(
                statelessToken.getUsername(),
                statelessToken.getCredentials(),
                getName());
    }
}
