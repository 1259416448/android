package cn.arvix.ontheway.sys.shiro.realm;

import cn.arvix.ontheway.sys.auth.service.AuthService;
import cn.arvix.ontheway.sys.shiro.service.ShiroLoginService;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.ontheway.sys.user.entity.UserStatus;
import cn.arvix.ontheway.sys.utils.MySimpleByteSource;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Objects;

/**
 * @author Created by yangyang on 16/5/10.
 *         e-mail ：296604153@qq.com ； tel ：18580128658 ；QQ ：296604153
 */

public class UserRealm extends AuthorizingRealm {

    private static final org.slf4j.Logger log = LoggerFactory.getLogger(UserRealm.class);

    private ShiroLoginService service;

    private AuthService authService;

    @Autowired
    public void setService(ShiroLoginService service) {
        this.service = service;
    }

    @Autowired
    public void setAuthService(AuthService authService) {
        this.authService = authService;
    }

    @Override
    public boolean supports(AuthenticationToken token) {
        return token instanceof UsernamePasswordToken;
    }

    /**
     * 获取认证后用户的信息:用户的角色,享有的权限等等
     *
     * @param principalCollection 享有权限信息
     * @return 信息
     */
    @SuppressWarnings("unchecked")
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
        return authService.getAuth(principalCollection, getName());
    }

    /**
     * 用户登陆认证
     *
     * @param authenticationToken 认证对象
     * @return 信息
     */
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken)
            throws AuthenticationException {
        UsernamePasswordToken token = (UsernamePasswordToken) authenticationToken;
        User user = service.login(token);
        if (user == null) throw new UnknownAccountException();
        if (Objects.equals(user.getStatus(), UserStatus.blocked))
            throw new LockedAccountException();
        token.setUsername(user.getUsername());
        SimpleAuthenticationInfo authenticationInfo;
        authenticationInfo = new SimpleAuthenticationInfo(user.getUsername(), user.getPassword(), getName());
        authenticationInfo.setCredentialsSalt(new MySimpleByteSource(token.getUsername() + user.getSalt()));
        return authenticationInfo;
    }
}
