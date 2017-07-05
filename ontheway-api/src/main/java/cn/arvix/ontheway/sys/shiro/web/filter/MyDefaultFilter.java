package cn.arvix.ontheway.sys.shiro.web.filter;

import org.apache.shiro.util.ClassUtils;
import org.apache.shiro.web.filter.authc.AnonymousFilter;
import org.apache.shiro.web.filter.session.NoSessionCreationFilter;

import javax.servlet.Filter;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/3/23.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public enum MyDefaultFilter {
    anon(AnonymousFilter.class),

    //authc(FormAuthenticationFilter.class),

    //authcBasic(BasicHttpAuthenticationFilter.class),

    //logout(LogoutFilter.class),

    noSessionCreation(NoSessionCreationFilter.class),

    //perms(PermissionsAuthorizationFilter.class),

    //port(PortFilter.class),

    //rest(HttpMethodPermissionFilter.class),

    //roles(RolesAuthorizationFilter.class),

    //ssl(SslFilter.class),

    user(MyUserFilter.class);

    private final Class<? extends Filter> filterClass;

    private MyDefaultFilter(Class<? extends Filter> filterClass) {
        this.filterClass = filterClass;
    }

    public Filter newInstance() {
        return (Filter) ClassUtils.newInstance(this.filterClass);
    }

    public Class<? extends Filter> getFilterClass() {
        return this.filterClass;
    }

    public static Map<String, Filter> createInstanceMap(FilterConfig config) {
        LinkedHashMap filters = new LinkedHashMap(values().length);
        MyDefaultFilter[] var2 = values();
        int var3 = var2.length;

        for (int var4 = 0; var4 < var3; ++var4) {
            MyDefaultFilter myDefaultFilter = var2[var4];
            Filter filter = myDefaultFilter.newInstance();
            if (config != null) {
                try {
                    filter.init(config);
                } catch (ServletException var9) {
                    String msg = "Unable to correctly init default filter instance of type " + filter.getClass().getName();
                    throw new IllegalStateException(msg, var9);
                }
            }

            filters.put(myDefaultFilter.name(), filter);
        }

        return filters;
    }
}
