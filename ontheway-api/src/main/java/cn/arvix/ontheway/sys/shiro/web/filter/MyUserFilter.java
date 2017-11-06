package cn.arvix.ontheway.sys.shiro.web.filter;

import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.JsonUtil;
import cn.arvix.base.common.utils.MessageUtils;
import org.apache.shiro.subject.Subject;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

/**
 * 当前拦截器拦截用户需要登陆才能访问的地址
 *
 * @author Created by yangyang on 2017/3/22.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class MyUserFilter extends org.apache.shiro.web.filter.authc.UserFilter {

    protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) {
        if (this.isLoginRequest(request, response)) {
            return true;
        } else {
            Subject subject = this.getSubject(request, response);
            return subject.getPrincipal() != null;
        }
    }

    protected boolean onAccessDenied(ServletRequest request, ServletResponse response) throws Exception {
        //this.saveRequest(request);
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        httpResponse.setStatus(HttpServletResponse.SC_OK);
        httpResponse.setContentType("application/json;charset=utf-8");
        httpResponse.getWriter().write(JsonUtil.getFailure(MessageUtils.message(CommonContact.NO_LOGIN_ERROR),
                CommonContact.NO_LOGIN_ERROR).toString());
        return false;
    }

}
