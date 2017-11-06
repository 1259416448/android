package cn.arvix.ontheway.sys.shiro.realm;

import cn.arvix.ontheway.sys.shiro.token.AutoLoginToken;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.slf4j.LoggerFactory;

public class AutoLoginRealm extends AuthorizingRealm {

    private static final org.slf4j.Logger log = LoggerFactory.getLogger(AutoLoginRealm.class);

//    private final AuthService authService;
//
//    @Autowired
//    public StatelessRealm(AuthService authService) {
//        this.authService = authService;
//    }

    @Override
    public boolean supports(AuthenticationToken token) {
        //仅支持StatelessToken类型的Token
        return token instanceof AutoLoginToken;
    }

    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
//        return authService.getAuth(principalCollection, getName());
        return null;
    }

    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        AutoLoginToken autoLoginToken = (AutoLoginToken) token;
        log.info("AutoLoginRealm info username:{}", autoLoginToken.getUsername());
        //然后进行客户端消息摘要和服务器端消息摘要的匹配
        return new SimpleAuthenticationInfo(
                autoLoginToken.getUsername(),
                autoLoginToken.getCredentials(),
                getName());
    }
}
