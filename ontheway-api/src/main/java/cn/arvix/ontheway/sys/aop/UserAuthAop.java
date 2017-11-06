package cn.arvix.ontheway.sys.aop;

import cn.arvix.ontheway.sys.shiro.realm.StatelessRealm;
import cn.arvix.ontheway.sys.shiro.spring.SpringCacheManagerWrapper;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.ontheway.sys.user.service.UserService;
import cn.arvix.ontheway.sys.utils.WebContextUtils;
import cn.arvix.base.common.utils.CommonContact;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author Created by yangyang on 2017/4/21.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Aspect
@Component
public class UserAuthAop {

    private final WebContextUtils webContextUtils;

    private final SpringCacheManagerWrapper shiroCacheManager;

    private final UserService userService;

    @Autowired
    public UserAuthAop(SpringCacheManagerWrapper shiroCacheManager,
                       WebContextUtils webContextUtils,
                       UserService userService) {
        this.shiroCacheManager = shiroCacheManager;
        this.webContextUtils = webContextUtils;
        this.userService = userService;
    }

    //认证缓存
    private org.apache.shiro.cache.Cache<String, Object> getAuthenticationCache() {
        return shiroCacheManager.getCache(CommonContact.AUTHENTICATION_CACHE);
    }

    //授权缓存
    private org.apache.shiro.cache.Cache<String, Object> getAuthorizationCache() {
        return shiroCacheManager.getCache(StatelessRealm.class.getName() + "." + CommonContact.AUTHORIZATION_CACHE);
    }

    @Pointcut("execution(public * cn.arvix.ontheway.sys.user.service.UserService.password(..))")
    public void passwordMethod() {

    }

    @Pointcut("execution(public * cn.arvix.ontheway.sys.user.service.UserService.resetPassword(..))")
    public void resetPasswordMethod() {

    }

    @Pointcut("execution(public * cn.arvix.ontheway.sys.permission.service.RoleService.roleResourceSave(..))" +
            "|| execution(public * cn.arvix.ontheway.sys.auth.service.AuthService.saveAuth(..))")
    public void roleResourceSaveMethod() {

    }

    //访问命名切入点来应用后置通知
    @AfterReturning("passwordMethod()")
    public void passWordAfterReturn() {
        doClearAuthentication(webContextUtils.getCheckCurrentUser());
    }

    @AfterReturning("roleResourceSaveMethod()")
    public void roleResourceSaveAfterReturn() {
        authorizationCacheClear();
    }


    //访问命名切入点来应用后置通知
    @AfterReturning("resetPasswordMethod()")
    public void resetPasswordAfterReturn(JoinPoint jp) {
        doClearAuthentication(userService.findOne((Long) jp.getArgs()[0]));
    }

    private void doClearAuthentication(User user) {
        clear(user.getUsername());
    }

    private void clear(String key) {
        getAuthenticationCache().remove(key);
    }

    //直接清空所有
    private void authorizationCacheClear() {
        getAuthorizationCache().clear();
    }

}
