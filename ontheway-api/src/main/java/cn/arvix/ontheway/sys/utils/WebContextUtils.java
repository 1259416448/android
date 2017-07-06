package cn.arvix.ontheway.sys.utils;

import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.user.entity.User;
import cn.arvix.ontheway.sys.user.entity.UserStatus;
import cn.arvix.ontheway.sys.user.entity.UserType;
import cn.arvix.ontheway.sys.user.exception.UserException;
import cn.arvix.ontheway.sys.user.repository.UserRepository;
import cn.arvix.base.common.utils.CommonContact;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Locale;
import java.util.Objects;

@Service
public class WebContextUtils {

    private final ConfigService configService;

    private final UserRepository userRepository;

    @Autowired
    public WebContextUtils(ConfigService configService,
                           UserRepository userRepository) {
        this.configService = configService;
        this.userRepository = userRepository;
    }

    /**
     * 获取request
     */
    public HttpServletRequest getRequest() {
        ServletRequestAttributes servletRequestAttributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (servletRequestAttributes == null) return null;
        return servletRequestAttributes.getRequest();
    }

    /**
     * 获取response
     */
    public HttpServletResponse getResponse() {
        ServletRequestAttributes servletRequestAttributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (servletRequestAttributes == null) return null;
        return servletRequestAttributes.getResponse();
    }

    /**
     * 获取session的方法
     */
    public HttpSession getSession() {
        return getRequest().getSession();
    }

    /**
     * 获取当前登陆用户Principal
     *
     * @return 登陆用户Principal
     */
    public String getCurrentPrincipal() {
        String principal = (String) SecurityUtils.getSubject().getPrincipal();
        if (principal == null) return null;
        return principal;
    }

    /**
     * 直接通过SecurityUtils获取当前用户,如果当前登陆用户不存在，返回null;
     */
    public User getCurrentUser() {
        String principal = getCurrentPrincipal();
        if (principal == null) throw new UserException("principal is null");
        if (Objects.equals(principal,
                configService.getConfigString(CommonContact.ROOT_NAME))) {
            return sysDevUser();
        }
        return userRepository.findByUsername(principal);
    }

    /**
     * 通过凭证获取用户信息
     *
     * @param principal 凭证
     * @return @{@link User}
     */
    public User getCurrentUser(String principal) {
        if (principal == null) throw new UserException("principal is null");
        if (Objects.equals(principal,
                configService.getConfigString(CommonContact.ROOT_NAME))) {
            return sysDevUser();
        }
        return userRepository.findByUsername(principal);
    }

    /**
     * 通过凭证获取用户信息
     *
     * @param principal 凭证
     * @return @{@link User}
     */
    public User getCheckCurrentUser(String principal) {
        User user = getCurrentUser(principal);
        if (user == null) throw new UserException("user is null");
        return user;
    }

    /**
     * 直接通过SecurityUtils获取当前用户
     * 获取的用户已经通过非空验证,如果当前用户不出在，抛出异常
     */
    public User getCheckCurrentUser() {
        User user = getCurrentUser();
        if (user == null) throw new UserException("user is null");
        return user;
    }

    private User sysDevUser() {
        User user = new User();
        user.setUsername(configService.getConfigString(CommonContact.ROOT_NAME));
        user.setSalt("cn/arvix");
        user.setName("Developer");
        user.setUserType(UserType.dev);
        user.setId(configService.getConfigBigDecimal(CommonContact.ROOT_ID).longValue());
        user.setPassword(configService.getConfigString(CommonContact.ROOT_PASSWORD));
        user.setStatus(UserStatus.normal);
        return user;

    }

    public String getRequestUrl() {
        HttpServletRequest request = getRequest();
        if (request == null) return null;
        return request.getServletPath() + (request.getPathInfo() == null ? "" : request.getPathInfo());
    }

    public Locale getSessionLangType(HttpServletRequest request) {

        Locale locale;
        locale = (Locale) request.getSession().getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME);
        if (locale == null) {
            //根据根据浏览器语言获取
            if (request.getLocale().getLanguage().equals("en")) {
                locale = new Locale("en", "US");
            } else {
                locale = new Locale("zh", "CN");
            }
            request.getSession().setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, locale);
        }
        return locale;
    }

    public String getSessionLangTypeString(HttpServletRequest request) {
        String str = getSessionLangType(request).toLanguageTag().replace("-", "_");
        switch (str) {
            case "en":
                return "en_US";
            case "en_US":
            case "zh_CN":
                return str;
            default:
                return "en_US";
        }
    }

    @Value(value = "${spring.profiles.active}")
    private String springProfilesActive;

    public boolean ifDev() {
        return Objects.equals(springProfilesActive, "dev");
    }

    /**
     * 通过动态配置信息获取当前系统文件是否是test环境
     */
    public boolean ifTest() {
        return Objects.equals(configService.getConfigString(CommonContact.SYSTEM_ENVIRONMENT), "test");
    }


    /**
     * 获取当前用户是否是开发者用户
     *
     * @return 是 true
     */
    public boolean ifDevUser() {
        return getCheckCurrentUser().getUserType().equals(UserType.dev);
    }

}
