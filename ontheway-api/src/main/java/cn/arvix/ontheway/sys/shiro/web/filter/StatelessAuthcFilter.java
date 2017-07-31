package cn.arvix.ontheway.sys.shiro.web.filter;

import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.utils.MessageUtils;
import cn.arvix.ontheway.sys.shiro.token.StatelessToken;
import cn.arvix.ontheway.sys.shiro.web.mgt.HeaderRememberMeManager;
import cn.arvix.ontheway.sys.user.entity.TokenInfo;
import com.google.common.collect.Sets;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.AccessControlFilter;
import org.apache.shiro.web.util.WebUtils;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collections;
import java.util.Iterator;
import java.util.Set;
import java.util.UUID;

public class StatelessAuthcFilter extends AccessControlFilter {

    private static final org.slf4j.Logger log = LoggerFactory.getLogger(StatelessAuthcFilter.class);

    private Cache cache;

    private HeaderRememberMeManager rememberMeManager;

    @Autowired
    public void setRememberMeManager(HeaderRememberMeManager rememberMeManager) {
        this.rememberMeManager = rememberMeManager;
    }

    private final Set<String> annoUrls = Sets.newHashSet();

    public void setAnnoUrls(String url) {
        this.annoUrls.add(url);
    }

    public void setAnnoUrls(String... urls) {
        Collections.addAll(this.annoUrls, urls);
    }

    public Set<String> getAnnoUrls() {
        return annoUrls;
    }

    @Autowired
    public void setCache(CacheManager cacheManager) {
        this.cache = cacheManager.getCache(CommonContact.X_AUTH_TOKEN_CACHE);
    }

    @Override
    protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) throws Exception {
        String requestURI = this.getPathWithinApplication(request);
        Iterator<String> iterator = getAnnoUrls().iterator();
        String pathPattern;
        do {
            if (!iterator.hasNext()) {
                return false;
            }
            pathPattern = iterator.next();
        } while (!this.pathsMatch(pathPattern, requestURI));
        return true;
    }

    @Override
    protected boolean onAccessDenied(ServletRequest request, ServletResponse response) throws Exception {
        Subject subject = this.getSubject(request, response);
        if (subject.getPrincipal() != null) return true;

        try {
            HttpServletRequest httpRequest = WebUtils.toHttp(request);
            //获取token
            String token = httpRequest.getHeader(CommonContact.HTTP_HEADER_AUTH_TOKEN);
            //System.out.println(token);
//            if (SystemParms.ifDev()) {
//                log.info("token：{} ", token);
//            }
            if (StringUtils.isEmpty(token) && httpRequest.getHeader(HeaderRememberMeManager.DEFAULT_REMEMBER_ME_COOKIE_NAME) == null) {
                onLoginFail(response);
                return false;
            }
            //通过token获取用户ID信息
            TokenInfo obj = null;
            if (!StringUtils.isEmpty(token)) {
                Cache.ValueWrapper wrapper = cache.get(token);
                if (wrapper != null) {
                    obj = (TokenInfo) wrapper.get();
                }
            }
            HttpServletResponse httpResponse = WebUtils.toHttp(response);
            if (obj == null) {
                //当前登陆信息不存在，判断是否增加了rememberMe header
                PrincipalCollection principalCollection = rememberMeManager.getRememberedPrincipals(httpRequest, httpResponse);
                if (principalCollection != null && principalCollection.iterator().hasNext()) {
                    String principal = principalCollection.iterator().next().toString();
                    //构建token
                    token = UUID.randomUUID().toString();
                    obj = new TokenInfo(token, principal, null);
                } else {
                    //后台判断过期
                    httpResponse.setHeader(HeaderRememberMeManager.DEFAULT_REMEMBER_ME_COOKIE_NAME, "deleteMe");
                    onLoginFail(response);
                    return false;
                }
            } else {
                httpResponse.setHeader(HeaderRememberMeManager.DEFAULT_REMEMBER_ME_COOKIE_NAME,
                        httpRequest.getHeader(HeaderRememberMeManager.DEFAULT_REMEMBER_ME_COOKIE_NAME));
                httpResponse.setHeader(HeaderRememberMeManager.DEFAULT_REMEMBER_ME_COOKIE_NAME_TIMEOUT,
                        httpRequest.getHeader(HeaderRememberMeManager.DEFAULT_REMEMBER_ME_COOKIE_NAME_TIMEOUT));
            }
            //生成无状态Token
            StatelessToken statelessToken = new StatelessToken(obj.getUsername(), token);
            //委托给Realm进行登录
            getSubject(request, response).login(statelessToken);
            //刷新redis中token缓存
            cache.put(token, obj);
            httpResponse.setHeader(CommonContact.HTTP_HEADER_AUTH_TOKEN, obj.getToken());
        } catch (Exception e) {
            e.printStackTrace();
            onLoginFail(response); //6、登录失败
            return false;
        }
        return true;
    }

    private void onLoginFail(ServletResponse response) throws IOException {
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        httpResponse.setStatus(HttpServletResponse.SC_OK);
        httpResponse.setContentType("application/json;charset=utf-8");
        httpResponse.getWriter().write(JsonUtil.getFailure(MessageUtils.message(CommonContact.NO_LOGIN_ERROR),
                CommonContact.NO_LOGIN_ERROR).toString());
    }

}