package cn.arvix.ontheway.sys.shiro.service;

import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.ExcessiveAttemptsException;
import org.apache.shiro.authc.credential.HashedCredentialsMatcher;
import org.apache.shiro.cache.Cache;
import org.apache.shiro.cache.CacheManager;


/**
 * 使用原子操作 AtomicInteger 由redis中获取数据时会出错，原因未知 报错问题 jackson出现
 * @author Created by yangyang on 16/5/11.
 *         e-mail ：296604153@qq.com ； tel ：18580128658 ；QQ ：296604153
 */
public class RetryLimitHashedCredentialsMatcher extends HashedCredentialsMatcher {

    private Cache<String, Integer> passwordRetryCache;

    public RetryLimitHashedCredentialsMatcher(CacheManager cacheManager) {
        passwordRetryCache = cacheManager.getCache("passwordRetryCache");
    }

    @Override
    public boolean doCredentialsMatch(AuthenticationToken token, AuthenticationInfo info) {
        String username = (String) token.getPrincipal();
        Integer retryCount = passwordRetryCache.get(username);
        if (retryCount == null) {
            retryCount = 0;
            passwordRetryCache.put(username, retryCount);
        }
        retryCount = retryCount + 1;
        if (retryCount > 5) {
            //if retry count > 5 throw
            throw new ExcessiveAttemptsException();
        }
        passwordRetryCache.put(username, retryCount);
        boolean matches = super.doCredentialsMatch(token, info);
        if (matches) {
            //clear retry count
            passwordRetryCache.remove(username);
        }
        return matches;
    }
}
