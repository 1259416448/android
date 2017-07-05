package cn.arvix.base.common.utils;

/**
 * @author Created by yangyang on 2017/3/3.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface CommonContact {

    //6位提示信息
    String NOT_FUND_CODE = "404";

    //通过ID查询信息不存在
    String NOT_FUND_MESSAGE = "x00001";

    String SUCCESS_CODE = "200";
    String SERVICE_ERROR_CODE = "500";

    //更新成功代码
    String UPDATE_SUCCESS = "update.success";

    //修改成功代码
    String SAVE_SUCCESS = "save.success";

    //数据抓取成功
    String FETCH_SUCCESS = "fetch.success";

    //数据删除成功
    String DELETE_SUCCESS = "delete.success";

    //数据多项删除成功
    String DELETE_MORE_SUCCESS = "delete.more.success";

    //hibernate2级缓存移除成功
    String HIBERNATE_LEVEL2_CACHE_REMOVE_SUCCESS = "hibernate.level2.cache.remove.success";

    //查询的数据不存在
    String NOT_FUND = "not.fund";

    String NO_LOGIN_ERROR = "no.login";

    //关键信息存在
    String ADD_EXIST = "add.exit";

    //配置信息不允许修改
    String CONFIG_NOT_UPDATE = "config.not.update";

    //跨域配置
    String CORS_DOMAIN_STRINGS = "corsDomainStrings";

    //操作成功
    String OPTION_SUCCESS = "option.success";

    //操作错误
    String OPTION_ERROR = "option.error";

    //授权操作成功
    String AUTH_OPTION_SUCCESS = "auth.option.success";

    //账户锁定
    String ACCOUNT_IS_LOCK = "account.is.lock";

    //用户名或者密码错误
    String USERNAME_OR_PASSWORD_ERROR = "username.or.password.error";

    //带锁定提示
    String USERNAME_OR_PASSWORD_ERROR_LOCK = "username.or.password.error.lock";

    String LOGIN_SUCCESS = "login.success";

    //开发者用户名
    String ROOT_NAME = "rootName";

    //开发者用户名
    String ROOT_PASSWORD = "rootPassword";

    //开发者ID
    String ROOT_ID = "rootID";

    //账户禁用
    String ACCOUNT_IS_DISABLED = "account.is.disabled";

    //未登录
    String NO_LOGIN = "no.login";

    //没有权限访问
    String NO_PERMISSION = "no.permission";

    /**
     * 邮件服务相关配置信息
     */
    String EMAIL_CONFIG_PREFIX = "emailConfig";

    //使用ssl邮件
    String EMAIL_CONFIG_HOST = EMAIL_CONFIG_PREFIX + "Host";
    String EMAIL_CONFIG_USERNAME = EMAIL_CONFIG_PREFIX + "Username";
    String EMAIL_CONFIG_PASSWORD = EMAIL_CONFIG_PREFIX + "Pw";
    String EMAIL_CONFIG_PORT = EMAIL_CONFIG_PREFIX + "Port";
    String EMAIL_CONFIG_SSL = EMAIL_CONFIG_PREFIX + "Sll";
    String EMAIL_CONFIG_SENT_NAME = EMAIL_CONFIG_PREFIX + "SentName";

    /**
     * 七牛配置信息
     */
    String QINIU_ACCESS_KEY = "qiniu.access.key";
    String QINIU_SECRET_KEY = "qiniu.secret.key";
    //上传默认位置
    String QINIU_FILE_BUCKET = "qiniu.file.bucket";

    //默认空间文件访问地址
    String QINIU_BUCKET_URL = "qiniu.bucket.url";

    //saas用户注册初次激活邮件
    String SAAS_USER_ACTIVATION_EMAIL = "saas.user.activation.email";

    //忘记密码邮件
    String USER_FORGET_PASS_EMAIL = "user.forget.pass.email";

    //前端服务地址
    String HTML_SERVER_BASE_PATH = "htmlServerBasePath";

    //API服务器地址
    String API_SERVER_BASE_PATH = "apiServerBasePath";

    /**
     * 激活邮件、邮件验证码有效时间
     * 例如1-MINUTES 表示1分钟有效时间 使用-分割  [0]有效时间  [1]时间单位
     */
    String SENT_EMAIL_TTL_TIME = "sent.email.ttl.time";

    //邮件发送时间替换标示
    String EMAIL_DATE = "#date#";
    //邮件激活URL替换标示
    String EMAIL_ACTIVATION_URL = "#activationUrl#";
    //邮件验证码替换标示
    String EMAIL_CHECK_CODE = "#checkCode#";
    //远端文件删除失败
    String DOCUMENT_DELETE_ERROR = "document.delete.error";
    //判断文件是否为图片正则
    String DOCUMENT_IMG_PATTERN = "(?i).+?\\.(jpg|gif|bmp|png|jpeg)";

    //shiro认证缓存
    String AUTHENTICATION_CACHE = "authenticationCache";

    //shiro授权缓存
    String AUTHORIZATION_CACHE = "authorizationCache";

    //用户头像裁剪参数
    String USER_HEAD_IMG_FIX = "imageView2/1/w/80/h/80";

    //必填参数丢失
    String REQUIRE_PARAMS_MISS = "require.params.miss";

    //token认证缓存信息
    String X_AUTH_TOKEN_CACHE = "auth-tokenCache";

    //header token
    String HTTP_HEADER_AUTH_TOKEN = "x-auth-token";

    //默认记住我时间 毫秒
    String REMEMBER_ME_TIMEOUT = "rememberMeTimeout";

    //默认排序号差值
    Long SORTER_DEFAULT_VAL = 65536L;

    //安全值
    Long SORTER_DEFAULT_SECURITY_VAL = 10L;

    //任务动态
    String TASK_LOG_TYPE_STR_0 = "将";
    String TASK_LOG_TYPE_STR_1 = "更新";
    String TASK_LOG_TYPE_STR_2 = "新建";
    String TASK_LOG_TYPE_STR_3 = "移除";
    String TASK_LOG_TYPE_STR_4 = "为";
    String TASK_LOG_TYPE_STR_5 = "归档";

    //任务提醒邮件
    String TASK_REMIND_HTML = "taskRemindHtml";

    //任务访问地址
    String TASK_URL = "#taskUrl#";

    //提醒人名称
    String REMIND_NAME = "#remindName#";

    //任务名称
    String TASK_NAME = "#taskName#";

    //任务访问地址信息
    String TASK_URL_FIX = "index/task-list?p={projectId}&t={taskId}";

    //任务及时提示
    String TASK_CREATE_REMIND_HTML = "taskCreateRemindHtml";

    //邀请加入团队邮件
    String INVITATION_HTML = "invitation.html";

    //邀请邮件点击地址
    String INVITATION_HTML_URL = "#url#";

    //邀请团队名称
    String INVITATION_HTML_TEAM_NAME = "#teamName#";

    //邀请加入团队邮件,带初始密码
    String INVITATION_PASSWORD_HTML = "invitation.password.html";

    //邀请加入团队邮件,初始密码
    String INVITATION_PASSWORD_HTML_PASSWORD = "#password#";

    //系统环境参数
    String SYSTEM_ENVIRONMENT = "systemEnvironment";

    //测试环境指定邮件接收邮箱
    String TEST_SENT_EMAIL_APPOINT = "testSentEmailAppoint";

}
