package cn.arvix.ontheway.sys.shiro.web.mgt;

import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.utils.EndecryptUtils;
import cn.arvix.ontheway.sys.utils.WebContextUtils;
import cn.arvix.base.common.utils.Checks;
import cn.arvix.base.common.utils.CommonContact;
import org.apache.shiro.codec.Base64;
import org.apache.shiro.mgt.AbstractRememberMeManager;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.subject.SubjectContext;
import org.apache.shiro.web.util.WebUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 基于http header
 *
 * @author Created by yangyang on 2017/4/25.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class HeaderRememberMeManager extends AbstractRememberMeManager {

    private static final transient Logger log = LoggerFactory.getLogger(HeaderRememberMeManager.class);

    private ConfigService configService;

    private WebContextUtils webContextUtils;

    @Autowired
    public void setWebContextUtils(WebContextUtils webContextUtils) {
        this.webContextUtils = webContextUtils;
    }

    @Autowired
    public void setConfigService(ConfigService configService) {
        this.configService = configService;
    }

    public static final String DEFAULT_REMEMBER_ME_COOKIE_NAME = "remember-me";
    public static final String DEFAULT_REMEMBER_ME_COOKIE_NAME_TIMEOUT = "remember-me-time";


    public void rememberIdentity(Subject subject) {
        PrincipalCollection principals = subject.getPrincipals();
        this.rememberIdentity(subject, principals);
    }

    @Override
    protected void forgetIdentity(Subject subject) {
        if (WebUtils.isHttp(subject)) {
            HttpServletRequest request = WebUtils.getHttpRequest(subject);
            HttpServletResponse response = WebUtils.getHttpResponse(subject);
            this.forgetIdentity(request, response);
        }
    }

    @Override
    protected void rememberSerializedIdentity(Subject subject, byte[] serialized) {
        if (!WebUtils.isHttp(subject)) {
            if (log.isDebugEnabled()) {
                String request1 = "Subject argument is not an HTTP-aware instance.  This is required to obtain a servlet request and response in order to set the rememberMe cookie. Returning immediately and ignoring rememberMe operation.";
                log.debug(request1);
            }
        } else {
            HttpServletResponse response = WebUtils.getHttpResponse(subject);
            String base64 = Base64.encodeToString(serialized);
            Long time = configService.getConfigBigDecimal(CommonContact.REMEMBER_ME_TIMEOUT).longValue();
            base64 = base64 + ":" + EndecryptUtils.encrytBase64(String.valueOf(System.currentTimeMillis() + time));
            response.setHeader(DEFAULT_REMEMBER_ME_COOKIE_NAME, base64);
            response.setHeader(DEFAULT_REMEMBER_ME_COOKIE_NAME_TIMEOUT, String.valueOf(time));
        }
    }

    public PrincipalCollection getRememberedPrincipals(HttpServletRequest request, HttpServletResponse response) {
        PrincipalCollection principals = null;
        try {
            byte[] re = this.getRememberedSerializedIdentity(request, response);
            if (re != null && re.length > 0) {
                principals = this.convertBytesToPrincipals(re, null);
            }
        } catch (RuntimeException var4) {
            principals = this.onRememberedPrincipalFailure(var4, null);
        }
        return principals;
    }

    @Override
    protected byte[] getRememberedSerializedIdentity(SubjectContext subjectContext) {
        return null;
    }

    protected byte[] getRememberedSerializedIdentity(HttpServletRequest request, HttpServletResponse response) {

        String var = request.getHeader(DEFAULT_REMEMBER_ME_COOKIE_NAME);
        System.out.println(var);
        String[] var2 = var.split(":");
        if (var2.length != 2) return null;
        Long time = Checks.toLong(EndecryptUtils.decryptBase64(var2[1]));
        //必须在当前时间之前
        if (time == null || System.currentTimeMillis() > time) {
            return null;
        }
        String base64 = var2[0];
        if (base64 != null) {
            base64 = this.ensurePadding(base64);
            if (log.isTraceEnabled()) {
                log.trace("Acquired Base64 encoded identity [" + base64 + "]");
            }
            byte[] decoded = Base64.decode(base64);
            if (log.isTraceEnabled()) {
                log.trace("Base64 decoded byte array length: " + (decoded != null ? decoded.length : 0) + " bytes.");
            }
            return decoded;
        }
        return null;
    }

    private String ensurePadding(String base64) {
        int length = base64.length();
        if (length % 4 != 0) {
            StringBuilder sb = new StringBuilder(base64);

            for (int i = 0; i < length % 4; ++i) {
                sb.append('=');
            }

            base64 = sb.toString();
        }

        return base64;
    }

    @Override
    public void forgetIdentity(SubjectContext subjectContext) {
        HttpServletRequest request = webContextUtils.getRequest();
        HttpServletResponse response = webContextUtils.getResponse();
        this.forgetIdentity(request, response);
    }

    private void forgetIdentity(HttpServletRequest request, HttpServletResponse response) {
        response.setHeader(DEFAULT_REMEMBER_ME_COOKIE_NAME, "deleteMe");
    }
}
