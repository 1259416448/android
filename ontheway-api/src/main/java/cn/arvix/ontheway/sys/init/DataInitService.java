package cn.arvix.ontheway.sys.init;

import cn.arvix.base.common.entity.ScheduleJob;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.QuartzJobUtil;
import cn.arvix.ontheway.sys.config.entity.Config;
import cn.arvix.ontheway.sys.config.entity.ConfigValueType;
import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.organization.service.OrganizationService;
import cn.arvix.ontheway.sys.resource.entity.Resource;
import cn.arvix.ontheway.sys.resource.entity.ResourceType;
import cn.arvix.ontheway.sys.resource.service.ResourceService;
import cn.arvix.ontheway.sys.utils.Email;
import com.google.common.collect.Lists;
import org.quartz.SchedulerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.annotation.Bean;
import org.springframework.core.task.TaskExecutor;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;
import java.util.Properties;

/**
 * @author Created by yangyang on 2017/3/14.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Service
public class DataInitService implements ApplicationContextAware {

    private ApplicationContext applicationContext;     //Spring应用上下文环境

    private final ConfigService configService;

    private final ResourceService resourceService;

    private final OrganizationService organizationService;

    private QuartzJobUtil quartzJobUtil;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    public void setQuartzJobUtil(QuartzJobUtil quartzJobUtil) {
        this.quartzJobUtil = quartzJobUtil;
    }

    private static final Logger logger = LoggerFactory.getLogger(DataInitService.class);

    @Autowired
    public DataInitService(ConfigService configService,
                           ResourceService resourceService,
                           OrganizationService organizationService) {
        this.configService = configService;
        this.resourceService = resourceService;
        this.organizationService = organizationService;
    }


    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }

    @PostConstruct
    public void init() {
        try {
            initSysConfig();
            initResource();
            initOrganization();
            createDefaultTask();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 系统初始化启动时，创建一个用户部门，用户部门在系统中只允许存在一个！
     */
    private void initOrganization() {
        organizationService.createUserOrg();
    }

    /**
     * 创建默认定时任务
     */
    private void createDefaultTask() throws SchedulerException {
//检查定时任务表是否存在
//        Connection connection = entityManager.unwrap(Connection.class);
//        try {
//            DatabaseMetaData metaData = connection.getMetaData();
//            ResultSet rs = metaData.getTables(connection.getCatalog(), databaseName, "QRTZ_JOB_DETAILS", new String[]{"TABLE"});
//            //数据库中不存在Quartz集群表
//            if (rs == null) {
//                //connection.prepareStatement();
//                connection.close();
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
        //创建一个基础定时任务
        ScheduleJob scheduleJob = new ScheduleJob();
        scheduleJob.setJobName("footprintDeletePolling");
        scheduleJob.setJobId("footprintDeletePolling");
        scheduleJob.setJobGroup("footprint");
        scheduleJob.setJobStatus("1");
        scheduleJob.setDesc("定时任务，每30秒执行一次，检查需要删除的足迹数据");
        scheduleJob.setCronExpression("0/30 * * * * ? ");
        scheduleJob.setTargetObject("footprintService");
        scheduleJob.setTargetMethod("delete");
        quartzJobUtil.addJob(scheduleJob);

    }

    private void initSysConfig() throws Exception {
        List<Config> configList = configService.findAll();
        if (configList == null) {
            configList = Lists.newArrayList();
        }
        Config config;
        if (configService.checkMapName(CommonContact.CORS_DOMAIN_STRINGS)) {
            config = new Config();
            config.setMapName(CommonContact.CORS_DOMAIN_STRINGS)
                    .setMapValue("http://127.0.0.1:63343")
                    .setDescription("允许跨域请求的IP或者域名")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }

        if (configService.checkMapName(CommonContact.ROOT_NAME)) {
            config = new Config();
            config.setMapName(CommonContact.ROOT_NAME)
                    .setMapValue("YXJ2aXhtYXN0ZXI=")
                    .setDescription("开发者账号（Base64加密）")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }

        if (configService.checkMapName(CommonContact.ROOT_PASSWORD)) {
            config = new Config();
            config.setMapName(CommonContact.ROOT_PASSWORD)
                    .setMapValue("506b9461ccd566d0958da4b5a5e4ae2f")
                    .setDescription("开发者密码")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }

        if (configService.checkMapName(CommonContact.ROOT_ID)) {
            config = new Config();
            config.setMapName(CommonContact.ROOT_ID)
                    .setMapValue("-1")
                    .setDescription("开发者ID")
                    .setValueType(ConfigValueType.BigDecimal)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        /*
         * 邮件相关配置初始化信息
         */
        if (configService.checkMapName(CommonContact.EMAIL_CONFIG_SSL)) {
            config = new Config();
            config.setMapName(CommonContact.EMAIL_CONFIG_SSL)
                    .setMapValue("true")
                    .setDescription("邮件启用ssl")
                    .setValueType(ConfigValueType.Boolean)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.EMAIL_CONFIG_PORT)) {
            config = new Config();
            config.setMapName(CommonContact.EMAIL_CONFIG_PORT)
                    .setMapValue("465")
                    .setDescription("邮件端口")
                    .setValueType(ConfigValueType.BigDecimal)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.EMAIL_CONFIG_USERNAME)) {
            config = new Config();
            config.setMapName(CommonContact.EMAIL_CONFIG_USERNAME)
                    .setMapValue("rym@arvix.cn")
                    .setDescription("邮件账户")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.EMAIL_CONFIG_PASSWORD)) {
            config = new Config();
            config.setMapName(CommonContact.EMAIL_CONFIG_PASSWORD)
                    .setMapValue("34A.3eb6c.6b2.4a")
                    .setDescription("邮件密码")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.EMAIL_CONFIG_HOST)) {
            config = new Config();
            config.setMapName(CommonContact.EMAIL_CONFIG_HOST)
                    .setMapValue("smtp.exmail.qq.com")
                    .setDescription("邮件SMTP")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.EMAIL_CONFIG_SENT_NAME)) {
            config = new Config();
            config.setMapName(CommonContact.EMAIL_CONFIG_SENT_NAME)
                    .setMapValue("君捷")
                    .setDescription("发送人名称")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }

        /*
        服务器相关配置
         */
        if (configService.checkMapName(CommonContact.HTML_SERVER_BASE_PATH)) {
            config = new Config();
            config.setMapName(CommonContact.HTML_SERVER_BASE_PATH)
                    .setMapValue("http://localhost:4200/")
                    .setDescription("前端服务器地址")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.API_SERVER_BASE_PATH)) {
            config = new Config();
            config.setMapName(CommonContact.API_SERVER_BASE_PATH)
                    .setMapValue("http://localhost:9900/")
                    .setDescription("api服务器地址")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.SENT_EMAIL_TTL_TIME)) {
            config = new Config();
            config.setMapName(CommonContact.SENT_EMAIL_TTL_TIME)
                    .setMapValue("1-MINUTES")
                    .setDescription("发送邮件有效时间")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        /*
           七牛相关配置
         */
        if (configService.checkMapName(CommonContact.QINIU_ACCESS_KEY)) {
            config = new Config();
            config.setMapName(CommonContact.QINIU_ACCESS_KEY)
                    .setMapValue("eQI8p9dDFM-OHbI7QCJcGTJ8OcWAaJHM4eD7r7D0")
                    .setDescription("七牛默认AK")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.QINIU_SECRET_KEY)) {
            config = new Config();
            config.setMapName(CommonContact.QINIU_SECRET_KEY)
                    .setMapValue("DsLSadqv7lSBaWw7dZj16FXIetErsJXGUcwDXCA7")
                    .setDescription("七牛默认SK")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.QINIU_FILE_BUCKET)) {
            config = new Config();
            config.setMapName(CommonContact.QINIU_FILE_BUCKET)
                    .setMapValue("ontheway")
                    .setDescription("七牛默认bucket")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.QINIU_BUCKET_URL)) {
            config = new Config();
            config.setMapName(CommonContact.QINIU_BUCKET_URL)
                    .setMapValue("http://osx4pwgde.bkt.clouddn.com/")
                    .setDescription("七牛默认访问URL")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }

        if (configService.checkMapName(CommonContact.REMEMBER_ME_TIMEOUT)) {
            config = new Config();
            config.setMapName(CommonContact.REMEMBER_ME_TIMEOUT)
                    .setMapValue("604800000")
                    .setDescription("记住我有效时间")
                    .setValueType(ConfigValueType.BigDecimal)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.TEST_SENT_EMAIL_APPOINT)) {
            config = new Config();
            config.setMapName(CommonContact.TEST_SENT_EMAIL_APPOINT)
                    .setMapValue("wyj@arvix.cn")
                    .setDescription("测试环境指定接收邮箱")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.SYSTEM_ENVIRONMENT)) {
            config = new Config();
            config.setMapName(CommonContact.SYSTEM_ENVIRONMENT)
                    .setMapValue("test")
                    .setDescription("系统环境")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }

        if (configService.checkMapName(CommonContact.JU_HE_APPKEY)) {
            config = new Config();
            config.setMapName(CommonContact.JU_HE_APPKEY)
                    .setMapValue("66a181ccc8df2aa40ae401891a13d083")
                    .setDescription("聚合数据短信Key")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.JU_HE_LOGIN_CODE_TPL_ID)) {
            config = new Config();
            config.setMapName(CommonContact.JU_HE_LOGIN_CODE_TPL_ID)
                    .setMapValue("39084")
                    .setDescription("聚合数据登陆验证短信tpl_id")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }

        if (configService.checkMapName(CommonContact.SMS_CODE_TTL_TIME)) {
            config = new Config();
            config.setMapName(CommonContact.SMS_CODE_TTL_TIME)
                    .setMapValue("15-MINUTES")
                    .setDescription("短信验证码有效时间")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }

        configService.init(configList);
    }


    //初始化资源信息
    private void initResource() {
        if (resourceService.count() == 0) { //资源数据不存在时，进行初始化数据
            Resource parentResource;
            Resource resource;
            Resource resourceButton;
            //系统设置
            parentResource = initResources("系统设置", null, null, null, 10f, ResourceType.column, "text-danger fa fa-cog");
            resourceService.save(parentResource);
            resource = initResources("资源设置", null, "/index/resource", parentResource.getId(), 1f, ResourceType.column, null);
            resourceService.saveAndFlush(resource);
        }
    }

    private Resource initResources(String name, String identity,
                                   String urls, Long parentId, Float sorter,
                                   ResourceType resourceType, String iconCode) {
        Resource resource = new Resource();
        resource.setName(name);
        resource.setIdentity(identity);
        resource.setUrls(urls);
        resource.setParentId(parentId);
        resource.setSorter(sorter);
        resource.setResourceType(resourceType);
        resource.setIconCode(iconCode);
        resource.setShow(true);
        return resource;
    }

    /**
     * 邮件部分信息初始化
     */
    public JavaMailSender mailSender() {
        JavaMailSenderImpl mailImpl = new JavaMailSenderImpl();
        mailImpl.setHost(configService.getConfigString(CommonContact.EMAIL_CONFIG_HOST));
        mailImpl.setPassword(configService.getConfigString(CommonContact.EMAIL_CONFIG_PASSWORD));
        mailImpl.setPort(configService.getConfigBigDecimal(CommonContact.EMAIL_CONFIG_PORT).intValue());
        mailImpl.setUsername(configService.getConfigString(CommonContact.EMAIL_CONFIG_USERNAME));
        logger.info("JavaMailSender init:[mailHost:{},mailPw:{},mailPort:{},mailUsername:{}]",
                mailImpl.getHost(), mailImpl.getPassword(), mailImpl.getPort(), mailImpl.getUsername());
        Properties props = new Properties();
        props.put("mail.smtp.auth", true);
        if (configService.getConfigBoolean(CommonContact.EMAIL_CONFIG_SSL)) {
            props.put("mail.smtp.ssl.enable", true);
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        }
        mailImpl.setJavaMailProperties(props);
        return mailImpl;
    }

    @Bean
    public Email emailInit() {
        JavaMailSender mailImpl = mailSender();
        Email email = new Email();
        email.setFrom(configService.getConfigString(CommonContact.EMAIL_CONFIG_USERNAME));
        email.setPersonal(configService.getConfigString(CommonContact.EMAIL_CONFIG_SENT_NAME));
        email.setJavaMailSender(mailImpl);
        return email;
    }

    @Value("${mail.taskExecutor.corePoolSize}")
    private int corePoolSize;
    @Value("${mail.taskExecutor.maxPoolSize}")
    private int maxPoolSize;
    @Value("${mail.taskExecutor.queueCapacity}")
    private int queueCapacity;
    @Value("${mail.taskExecutor.keepAliveSeconds}")
    private int keepAliveSeconds;

    @Bean
    TaskExecutor mailTaskExecutor() {
        ThreadPoolTaskExecutor taskExecutor = new ThreadPoolTaskExecutor();
        taskExecutor.setCorePoolSize(corePoolSize);
        taskExecutor.setMaxPoolSize(maxPoolSize);
        taskExecutor.setKeepAliveSeconds(keepAliveSeconds);
        taskExecutor.setQueueCapacity(queueCapacity);
        return taskExecutor;
    }

}
