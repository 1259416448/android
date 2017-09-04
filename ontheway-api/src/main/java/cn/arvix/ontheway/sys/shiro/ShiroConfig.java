package cn.arvix.ontheway.sys.shiro;

import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.shiro.pam.ModularRealmAuthenticator;
import cn.arvix.ontheway.sys.shiro.realm.AutoLoginRealm;
import cn.arvix.ontheway.sys.shiro.realm.StatelessRealm;
import cn.arvix.ontheway.sys.shiro.realm.UserRealm;
import cn.arvix.ontheway.sys.shiro.service.RetryLimitHashedCredentialsMatcher;
import cn.arvix.ontheway.sys.shiro.spring.SpringCacheManagerWrapper;
import cn.arvix.ontheway.sys.shiro.web.filter.CorsFilter;
import cn.arvix.ontheway.sys.shiro.web.filter.MyShiroFilterFactoryBean;
import cn.arvix.ontheway.sys.shiro.web.filter.StatelessAuthcFilter;
import cn.arvix.ontheway.sys.shiro.web.mgt.HeaderRememberMeManager;
import cn.arvix.ontheway.sys.shiro.web.mgt.StatelessDefaultSubjectFactory;
import cn.arvix.base.common.utils.CommonContact;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.pam.FirstSuccessfulStrategy;
import org.apache.shiro.mgt.DefaultSessionStorageEvaluator;
import org.apache.shiro.mgt.DefaultSubjectDAO;
import org.apache.shiro.mgt.SecurityManager;
import org.apache.shiro.realm.Realm;
import org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.web.mgt.DefaultWebSecurityManager;
import org.apache.shiro.web.session.mgt.DefaultWebSessionManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.cache.CacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.filter.DelegatingFilterProxy;

import javax.servlet.Filter;
import java.util.Collection;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/3/13.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Configuration
public class ShiroConfig {

    @Bean(name = "shiroCacheManager")
    public SpringCacheManagerWrapper shiroCacheManager(CacheManager cacheManager) {
        SpringCacheManagerWrapper springCacheManagerWrapper = new SpringCacheManagerWrapper();
        springCacheManagerWrapper.setCacheManager(cacheManager);
        return springCacheManagerWrapper;
    }

    @Bean(name = "firstSuccessfulStrategy")
    public FirstSuccessfulStrategy firstSuccessfulStrategy() {
        return new FirstSuccessfulStrategy();
    }

    @Bean(name = "statelessRealm")
    public StatelessRealm statelessRealm(SpringCacheManagerWrapper shiroCacheManager) {
        StatelessRealm statelessRealm = new StatelessRealm();
        statelessRealm.setCachingEnabled(true);
        statelessRealm.setCacheManager(shiroCacheManager);
        statelessRealm.setAuthenticationCachingEnabled(false);
        statelessRealm.setAuthorizationCachingEnabled(true);
        statelessRealm.setAuthorizationCacheName(CommonContact.AUTHORIZATION_CACHE);
        return statelessRealm;
    }

    @Bean(name = "autoLoginRealm")
    public AutoLoginRealm autoLoginRealm(SpringCacheManagerWrapper shiroCacheManager) {
        AutoLoginRealm autoLoginRealm = new AutoLoginRealm();
        autoLoginRealm.setCachingEnabled(true);
        autoLoginRealm.setCacheManager(shiroCacheManager);
        autoLoginRealm.setAuthenticationCachingEnabled(false);
        autoLoginRealm.setAuthorizationCachingEnabled(true);
        autoLoginRealm.setAuthorizationCacheName(CommonContact.AUTHORIZATION_CACHE);
        return autoLoginRealm;
    }

    @Bean(name = "credentialsMatcher")
    public RetryLimitHashedCredentialsMatcher retryLimitHashedCredentialsMatcher(SpringCacheManagerWrapper shiroCacheManger) {
        RetryLimitHashedCredentialsMatcher credentialsMatcher = new RetryLimitHashedCredentialsMatcher(shiroCacheManger);
        credentialsMatcher.setHashAlgorithmName("md5");
        credentialsMatcher.setHashIterations(2);
        credentialsMatcher.setStoredCredentialsHexEncoded(true);
        return credentialsMatcher;
    }

    @Bean(name = "stateRealm")
    public UserRealm stateRealm(SpringCacheManagerWrapper shiroCacheManger,
                                RetryLimitHashedCredentialsMatcher credentialsMatcher) {
        UserRealm userRealm = new UserRealm();
        userRealm.setCacheManager(shiroCacheManger);
        userRealm.setCredentialsMatcher(credentialsMatcher);
        userRealm.setCachingEnabled(true);
        userRealm.setAuthenticationCachingEnabled(true);
        userRealm.setAuthenticationCacheName(CommonContact.AUTHENTICATION_CACHE);
        userRealm.setAuthorizationCachingEnabled(true);
        userRealm.setAuthorizationCacheName(CommonContact.AUTHORIZATION_CACHE);
        return userRealm;
    }

    @Bean(name = "defaultWebSessionManager")
    public DefaultWebSessionManager defaultWebSessionManager() {
        DefaultWebSessionManager defaultWebSessionManager = new DefaultWebSessionManager();
        defaultWebSessionManager.setSessionValidationSchedulerEnabled(false);
        return defaultWebSessionManager;
    }

    @Bean
    public StatelessDefaultSubjectFactory statelessDefaultSubjectFactory() {
        return new StatelessDefaultSubjectFactory();
    }

    @Bean(name = "modularRealmAuthenticator")
    public ModularRealmAuthenticator modularRealmAuthenticator(FirstSuccessfulStrategy firstSuccessfulStrategy,
                                                               StatelessRealm statelessRealm,
                                                               UserRealm userRealm,
                                                               AutoLoginRealm autoLoginRealm) {
        ModularRealmAuthenticator modularRealmAuthenticator = new ModularRealmAuthenticator();
        modularRealmAuthenticator.setAuthenticationStrategy(firstSuccessfulStrategy);
        Collection<Realm> realms = Lists.newArrayList();
        realms.add(statelessRealm);
        realms.add(userRealm);
        realms.add(autoLoginRealm);
        modularRealmAuthenticator.setRealms(realms);
        return modularRealmAuthenticator;
    }

    @Bean(name = "securityManager")
    public DefaultWebSecurityManager defaultWebSecurityManager(SpringCacheManagerWrapper shiroCacheManager,
                                                               ModularRealmAuthenticator modularRealmAuthenticator,
                                                               StatelessRealm statelessRealm,
                                                               UserRealm userRealm,
                                                               AutoLoginRealm autoLoginRealm,
                                                               DefaultWebSessionManager defaultWebSessionManager,
                                                               StatelessDefaultSubjectFactory subjectFactory) {
        DefaultWebSecurityManager defaultWebSecurityManager = new DefaultWebSecurityManager();
        Collection<Realm> realms = Lists.newArrayList();
        realms.add(statelessRealm);
        realms.add(userRealm);
        realms.add(autoLoginRealm);
        defaultWebSecurityManager.setRealms(realms);
        defaultWebSecurityManager.setCacheManager(shiroCacheManager);
        defaultWebSecurityManager.setAuthenticator(modularRealmAuthenticator);
        defaultWebSecurityManager.setSessionManager(defaultWebSessionManager);
        defaultWebSecurityManager.setSubjectFactory(subjectFactory);
        DefaultSubjectDAO subjectDAO = new DefaultSubjectDAO();
        DefaultSessionStorageEvaluator sessionStorageEvaluator = new DefaultSessionStorageEvaluator();
        sessionStorageEvaluator.setSessionStorageEnabled(false);
        subjectDAO.setSessionStorageEvaluator(sessionStorageEvaluator);
        defaultWebSecurityManager.setSubjectDAO(subjectDAO);
        SecurityUtils.setSecurityManager(defaultWebSecurityManager);
        return defaultWebSecurityManager;
    }

    @Bean
    public StatelessAuthcFilter statelessAuthcFilter() {
        StatelessAuthcFilter statelessAuthcFilter = new StatelessAuthcFilter();
        statelessAuthcFilter.setAnnoUrls("/v2/api-docs",
                "/api/v1/check/username",
                "/api/v1/login",
                "/api/v1/login/sms/sent/**",
                "/api/v1/login/sms",
                "/app/footprint/search/**",
                "/app/footprint/view/**",
                "/app/footprint/user/**",
                "/app/business/type/all",
                "/app/business/search/**",
                "/app/business/view/**",
                "/app/footprint/comment/search"
        );
        return statelessAuthcFilter;
    }

    @Bean(name = "corsFilter")
    public CorsFilter corsFilter(ConfigService configService) {
        return new CorsFilter(configService);
    }

    @Bean
    public FilterRegistrationBean delegatingFilterProxy() {
        FilterRegistrationBean filterRegistrationBean = new FilterRegistrationBean();
        DelegatingFilterProxy proxy = new DelegatingFilterProxy();
        proxy.setTargetFilterLifecycle(true);
        proxy.setTargetBeanName("shiroFilter");
        filterRegistrationBean.setFilter(proxy);
        return filterRegistrationBean;
    }

    @Bean(name = "rememberMeManager")
    public HeaderRememberMeManager rememberMeManager() {
        HeaderRememberMeManager headerRememberMeManager = new HeaderRememberMeManager();
        headerRememberMeManager.setCipherKey(org.apache.shiro.codec.Base64.decode("9terOruuoUtbNkxmdxQ4vw=="));
        return headerRememberMeManager;
    }

    @Bean(name = "shiroFilter")
    @Autowired
    public ShiroFilterFactoryBean shiroFilter(CorsFilter corsFilter, StatelessAuthcFilter statelessAuthcFilter,
                                              DefaultWebSecurityManager securityManager) {
        MyShiroFilterFactoryBean shiroFilterFactoryBean = new MyShiroFilterFactoryBean();
        Map<String, Filter> filterMap = Maps.newHashMap();
        filterMap.put("cors", corsFilter);
        filterMap.put("statelessAuthc", statelessAuthcFilter);
        shiroFilterFactoryBean.setFilters(filterMap);
        shiroFilterFactoryBean.setSecurityManager(securityManager);
        shiroFilterFactoryBean.setFilterChainDefinitions("/api/v1/** =noSessionCreation,cors,statelessAuthc\n" +
                "/app/** =noSessionCreation,cors,statelessAuthc\n");
        return shiroFilterFactoryBean;
    }

    /**
     * 加入shiro安全框架
     */
    @Bean(name = "authorizationAttributeSourceAdvisor")
    @Autowired
    public AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor(SecurityManager securityManager) {
        AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor = new AuthorizationAttributeSourceAdvisor();
        authorizationAttributeSourceAdvisor.setSecurityManager(securityManager);
        return authorizationAttributeSourceAdvisor;
    }

}
