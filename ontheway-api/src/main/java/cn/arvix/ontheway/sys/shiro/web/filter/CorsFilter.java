package cn.arvix.ontheway.sys.shiro.web.filter;

import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.base.common.utils.CommonContact;
import org.apache.shiro.web.filter.PathMatchingFilter;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Objects;

/**
 * @author Created by yangyang on 2017/1/15.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class CorsFilter extends PathMatchingFilter {

    private final ConfigService configService;

    private static final org.slf4j.Logger log = LoggerFactory.getLogger(CorsFilter.class);

    @Autowired
    public CorsFilter(ConfigService configService) {
        this.configService = configService;
    }


    @Override
    protected boolean onPreHandle(ServletRequest req, ServletResponse res, Object mappedValue) throws Exception {
        HttpServletResponse response = (HttpServletResponse) res;
        HttpServletRequest request = (HttpServletRequest) req;
        String configAccessDomain = configService.getConfigString(CommonContact.CORS_DOMAIN_STRINGS);
        String origin = request.getHeader("origin");
        String[] configAccessDomainArray = configAccessDomain.split(",");
        boolean corsOk = false;
        if (origin != null) {
            for (String domainTemp : configAccessDomainArray) {
                if (origin.startsWith(domainTemp)) {
                    corsOk = true;
                    break;
                }
            }
            if (corsOk) {
                setCorsAccess(response, origin);
            } else {
                log.info("cors failed:configAccessDomain:{}", origin);
            }
        }
        //跨域时，如果预请求，这里直接返回空
        if (Objects.equals(request.getMethod(), "OPTIONS")) {
            response.setStatus(HttpServletResponse.SC_OK);
            //response.setContentType("application/json");
            //response.getWriter().write(JsonUtil.getSuccess("success").toString());
//            if (SystemParms.ifDev()) {
//                log.info("request method is OPTIONS.");
//            }
            return false;
        }
        return true;
    }

    private void setCorsAccess(HttpServletResponse response, String domain) {

        response.setHeader("Access-Control-Allow-Origin", domain);
        response.setHeader("Access-Control-Expose-Headers",
                "if-modified-since,x-auth-token,remember-me,remember-me-time,x-requested-with,content-type,accept");
        response.setHeader("Access-Control-Allow-Methods",
                "POST, PUT, GET, OPTIONS, DELETE");
        response.setHeader("Access-Control-Max-Age", "3600");
        response.setHeader("Access-Control-Allow-Headers",
                "if-modified-since,x-auth-token,remember-me,remember-me-time,x-requested-with,content-type,accept");
        response.setHeader("Access-Control-Allow-Credentials", "true");
    }

}
