package cn.arvix.ontheway.sys.shiro.web.filter;

import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.util.CollectionUtils;
import org.apache.shiro.util.Nameable;
import org.apache.shiro.util.StringUtils;
import org.apache.shiro.web.filter.AccessControlFilter;
import org.apache.shiro.web.filter.authc.AuthenticationFilter;
import org.apache.shiro.web.filter.authz.AuthorizationFilter;
import org.apache.shiro.web.filter.mgt.FilterChainManager;

import javax.servlet.Filter;
import java.util.Iterator;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/3/23.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class MyShiroFilterFactoryBean extends ShiroFilterFactoryBean {

    protected FilterChainManager createFilterChainManager() {
        MyDefaultFilterChainManager manager = new MyDefaultFilterChainManager();
        Map defaultFilters = manager.getFilters();
        Iterator filters = defaultFilters.values().iterator();

        while (filters.hasNext()) {
            Filter chains = (Filter) filters.next();
            this.applyGlobalPropertiesIfNecessary(chains);
        }

        Map filters1 = this.getFilters();
        String entry1;
        Filter url;
        if (!CollectionUtils.isEmpty(filters1)) {
            for (Iterator chains1 = filters1.entrySet().iterator(); chains1.hasNext(); manager.addFilter(entry1, url, false)) {
                Map.Entry entry = (Map.Entry) chains1.next();
                entry1 = (String) entry.getKey();
                url = (Filter) entry.getValue();
                this.applyGlobalPropertiesIfNecessary(url);
                if (url instanceof Nameable) {
                    ((Nameable) url).setName(entry1);
                }
            }
        }

        Map chains2 = this.getFilterChainDefinitionMap();
        if (!CollectionUtils.isEmpty(chains2)) {
            Iterator entry2 = chains2.entrySet().iterator();

            while (entry2.hasNext()) {
                Map.Entry entry3 = (Map.Entry) entry2.next();
                String url1 = (String) entry3.getKey();
                String chainDefinition = (String) entry3.getValue();
                manager.createChain(url1, chainDefinition);
            }
        }

        return manager;
    }


    private void applyLoginUrlIfNecessary(Filter filter) {
        String loginUrl = this.getLoginUrl();
        if (StringUtils.hasText(loginUrl) && filter instanceof AccessControlFilter) {
            AccessControlFilter acFilter = (AccessControlFilter) filter;
            String existingLoginUrl = acFilter.getLoginUrl();
            if ("/login.jsp".equals(existingLoginUrl)) {
                acFilter.setLoginUrl(loginUrl);
            }
        }

    }

    private void applySuccessUrlIfNecessary(Filter filter) {
        String successUrl = this.getSuccessUrl();
        if (StringUtils.hasText(successUrl) && filter instanceof AuthenticationFilter) {
            AuthenticationFilter authcFilter = (AuthenticationFilter) filter;
            String existingSuccessUrl = authcFilter.getSuccessUrl();
            if ("/".equals(existingSuccessUrl)) {
                authcFilter.setSuccessUrl(successUrl);
            }
        }

    }

    private void applyUnauthorizedUrlIfNecessary(Filter filter) {
        String unauthorizedUrl = this.getUnauthorizedUrl();
        if (StringUtils.hasText(unauthorizedUrl) && filter instanceof AuthorizationFilter) {
            AuthorizationFilter authzFilter = (AuthorizationFilter) filter;
            String existingUnauthorizedUrl = authzFilter.getUnauthorizedUrl();
            if (existingUnauthorizedUrl == null) {
                authzFilter.setUnauthorizedUrl(unauthorizedUrl);
            }
        }

    }

    private void applyGlobalPropertiesIfNecessary(Filter filter) {
        this.applyLoginUrlIfNecessary(filter);
        this.applySuccessUrlIfNecessary(filter);
        this.applyUnauthorizedUrlIfNecessary(filter);
    }
}
