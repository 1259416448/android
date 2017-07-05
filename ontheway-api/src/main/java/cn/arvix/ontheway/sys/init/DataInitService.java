package cn.arvix.ontheway.sys.init;

import cn.arvix.ontheway.sys.config.entity.Config;
import cn.arvix.ontheway.sys.config.entity.ConfigValueType;
import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.resource.entity.Resource;
import cn.arvix.ontheway.sys.resource.entity.ResourceType;
import cn.arvix.ontheway.sys.resource.service.ResourceService;
import cn.arvix.ontheway.sys.utils.Email;
import cn.arvix.base.common.entity.ScheduleJob;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.QuartzJobUtil;
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

    private QuartzJobUtil quartzJobUtil;

    @PersistenceContext
    private EntityManager entityManager;

    @Autowired
    public void setQuartzJobUtil(QuartzJobUtil quartzJobUtil) {
        this.quartzJobUtil = quartzJobUtil;
    }

    private static final Logger logger = LoggerFactory.getLogger(DataInitService.class);

    @Autowired
    public DataInitService(ConfigService configService, ResourceService resourceService) {
        this.configService = configService;
        this.resourceService = resourceService;
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
            createDefaultTask();
        } catch (Exception e) {
            e.printStackTrace();
        }
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
        scheduleJob.setJobName("agileBasicPolling");
        scheduleJob.setJobId("agileBasicPolling");
        scheduleJob.setJobGroup("agileTask");
        scheduleJob.setJobStatus("1");
        scheduleJob.setDesc("基础定时任务，轮询的形式添加最近1小时内需要定时发送的所有邮件或者短信");
        scheduleJob.setCronExpression("0 0 0-23 * * ? ");
        scheduleJob.setTargetObject("agileRemindService");
        scheduleJob.setTargetMethod("execute");
        quartzJobUtil.addJob(scheduleJob);

        scheduleJob = new ScheduleJob();
        scheduleJob.setJobName("agileUserRemindPolling");
        scheduleJob.setJobId("agileUserRemindPolling");
        scheduleJob.setJobGroup("agileUserRemind");
        scheduleJob.setJobStatus("1");
        scheduleJob.setDesc("基础定时任务，处理提醒信息队列，每10秒钟执行一次");
        scheduleJob.setCronExpression("0/10 * * * * ? ");
        scheduleJob.setTargetObject("agileUserRemindService");
        scheduleJob.setTargetMethod("execute");
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
                    .setMapValue("agilemaster")
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
                    .setMapValue("http://onidt4bx8.bkt.clouddn.com")
                    .setDescription("七牛默认访问URL")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.SAAS_USER_ACTIVATION_EMAIL)) {
            config = new Config();
            config.setMapName(CommonContact.SAAS_USER_ACTIVATION_EMAIL)
                    .setMapValue("<!DOCTYPE html>\n" +
                            "<html lang=\"en\">\n" +
                            "<head>\n" +
                            "    <meta charset=\"UTF-8\">\n" +
                            "    <title>Title</title>\n" +
                            "</head>\n" +
                            "<body>\n" +
                            "<div style=\"background: #f6f8f9; padding:50px;font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;\">\n" +
                            "  <div style=\"margin: 0 auto; text-align: left;padding: 38px 50px; width: 560px; font-size: 14px;color: #606060; background: #fff; border-radius:2px; font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;box-shadow: 0 0 4px rgba(0,0,0,0.2);\">\n" +
                            "    <table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"560\" style=\"margin: 0 auto;text-align: left; font-size: 14px; color: #606060;background: #fff; font-family: inherit;font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;\">\n" +
                            "       <tr>\n" +
                            "        <th colspan=\"2\">\n" +
                            "          <a href=\"http://www.arvix.cn/\"><img width=\"150\" src=\"http://o960hfmwc.bkt.clouddn.com/junjieLOGO.png\" alt=\"君捷\"></a>\n" +
                            "          <div style=\"display: inline-block;vertical-align: top;\">\n" +
                            "            <p>Agile Master Inc</p>\n" +
                            "            <p>北京君捷科技有限公司</p>\n" +
                            "          </div>\n" +
                            "        </th>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"font-size:17px; padding: 25px 0 18px;\">\n" +
                            "          尊敬的君捷用户：\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"line-height: 1.8;\">\n" +
                            "          <div>欢迎使用君捷！</div>\n" +
                            "          <div>请点击以下链接验证您的邮箱，验证成功后就可以使用君捷提供的所有服务了。</div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"font-size:12px; line-height: 20px; padding-top: 14px;padding-bottom: 25px; color: #909090;\">\n" +
                            "          <div>\n" +
                            "            <a href=\"#activationUrl#\" style=\"color: #03c5ff; word-break: break-all; text-decoration:underline;\" target=\"_blank\">#activationUrl#</a>\n" +
                            "            <div style=\"padding-top:4px;\">(如果不能打开页面，请复制该地址到浏览器打开)</div>\n" +
                            "          </div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"text-align:right; line-height: 1.8; padding-bottom: 18px;\">\n" +
                            "          <div>君捷团队</div>\n" +
                            "          <div style=\"color:#909090;\">#date#</div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"padding-top: 20px; border-top: 1px solid #e7e7e7; line-height: 1.8; font-size: 12px; color:#909090;\">\n" +
                            "          <div>温馨提示：</div>\n" +
                            "          <ol>\n" +
                            "            <li>君捷官方网址为：http://www.agilemaster.com.cn/，请注意网址，防止钓鱼。</li>\n" +
                            "            <li>本邮件为系统自动发出，请勿回复。</li>\n" +
                            "          </ol>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "    </table>\n" +
                            "  </div>\n" +
                            "</div>\n" +
                            "</body>\n" +
                            "</html>")
                    .setDescription("用户邮箱激活Html")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }

        if (configService.checkMapName(CommonContact.TASK_REMIND_HTML)) {
            config = new Config();
            config.setMapName(CommonContact.TASK_REMIND_HTML)
                    .setMapValue("<!DOCTYPE html>\n" +
                            "<html lang=\"en\">\n" +
                            "<head>\n" +
                            "    <meta charset=\"UTF-8\">\n" +
                            "    <title>Title</title>\n" +
                            "</head>\n" +
                            "<body>\n" +
                            "<div style=\"background: #f6f8f9; padding:50px;font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;\">\n" +
                            "  <div style=\"margin: 0 auto; text-align: left;padding: 38px 50px; width: 560px; font-size: 14px;color: #606060; background: #fff; border-radius:2px; font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;box-shadow: 0 0 4px rgba(0,0,0,0.2);\">\n" +
                            "    <table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"560\" style=\"margin: 0 auto;text-align: left; font-size: 14px; color: #606060;background: #fff; font-family: inherit;font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;\">\n" +
                            "       <tr>\n" +
                            "        <th colspan=\"2\">\n" +
                            "          <a href=\"http://www.arvix.cn/\"><img width=\"150\" src=\"http://o960hfmwc.bkt.clouddn.com/junjieLOGO.png\" alt=\"君捷\"></a>\n" +
                            "          <div style=\"display: inline-block;vertical-align: top;\">\n" +
                            "            <p>Agile Master Inc</p>\n" +
                            "            <p>北京君捷科技有限公司</p>\n" +
                            "          </div>\n" +
                            "        </th>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"font-size:17px; padding: 25px 0 18px;\">\n" +
                            "          hi,#remindName#：\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"line-height: 1.8;\">\n" +
                            "          <div>您的【#taskName#】任务即将到期！</div>\n" +
                            "          <div>请点击以下链接查看详情。</div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"font-size:12px; line-height: 20px; padding-top: 14px;padding-bottom: 25px; color: #909090;\">\n" +
                            "          <div>\n" +
                            "            <a href=\"#taskUrl#\" style=\"color: #03c5ff; word-break: break-all; text-decoration:underline;\" target=\"_blank\">#taskUrl#</a>\n" +
                            "            <div style=\"padding-top:4px;\">(如果不能打开页面，请复制该地址到浏览器打开)</div>\n" +
                            "          </div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"text-align:right; line-height: 1.8; padding-bottom: 18px;\">\n" +
                            "          <div>君捷团队</div>\n" +
                            "          <div style=\"color:#909090;\">#date#</div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"padding-top: 20px; border-top: 1px solid #e7e7e7; line-height: 1.8; font-size: 12px; color:#909090;\">\n" +
                            "          <div>温馨提示：</div>\n" +
                            "          <ol>\n" +
                            "            <li>君捷官方网址为：http://www.agilemaster.com.cn/，请注意网址，防止钓鱼。</li>\n" +
                            "            <li>本邮件为系统自动发出，请勿回复。</li>\n" +
                            "          </ol>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "    </table>\n" +
                            "  </div>\n" +
                            "</div>\n" +
                            "</body>\n" +
                            "</html>")
                    .setDescription("任务到期提醒邮件HTML")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }

        if (configService.checkMapName(CommonContact.TASK_CREATE_REMIND_HTML)) {
            config = new Config();
            config.setMapName(CommonContact.TASK_CREATE_REMIND_HTML)
                    .setMapValue("<!DOCTYPE html>\n" +
                            "<html lang=\"en\">\n" +
                            "<head>\n" +
                            "    <meta charset=\"UTF-8\">\n" +
                            "    <title>Title</title>\n" +
                            "</head>\n" +
                            "<body>\n" +
                            "<div style=\"background: #f6f8f9; padding:50px;font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;\">\n" +
                            "  <div style=\"margin: 0 auto; text-align: left;padding: 38px 50px; width: 560px; font-size: 14px;color: #606060; background: #fff; border-radius:2px; font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;box-shadow: 0 0 4px rgba(0,0,0,0.2);\">\n" +
                            "    <table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"560\" style=\"margin: 0 auto;text-align: left; font-size: 14px; color: #606060;background: #fff; font-family: inherit;font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;\">\n" +
                            "       <tr>\n" +
                            "        <th colspan=\"2\">\n" +
                            "          <a href=\"http://www.arvix.cn/\"><img width=\"150\" src=\"http://o960hfmwc.bkt.clouddn.com/junjieLOGO.png\" alt=\"君捷\"></a>\n" +
                            "          <div style=\"display: inline-block;vertical-align: top;\">\n" +
                            "            <p>Agile Master Inc</p>\n" +
                            "            <p>北京君捷科技有限公司</p>\n" +
                            "          </div>\n" +
                            "        </th>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"font-size:17px; padding: 25px 0 18px;\">\n" +
                            "          hi,#remindName#：\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"line-height: 1.8;\">\n" +
                            "          <div>收到【#taskName#】任务提醒！</div>\n" +
                            "          <div>请点击以下链接查看详情。</div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"font-size:12px; line-height: 20px; padding-top: 14px;padding-bottom: 25px; color: #909090;\">\n" +
                            "          <div>\n" +
                            "            <a href=\"#taskUrl#\" style=\"color: #03c5ff; word-break: break-all; text-decoration:underline;\" target=\"_blank\">#taskUrl#</a>\n" +
                            "            <div style=\"padding-top:4px;\">(如果不能打开页面，请复制该地址到浏览器打开)</div>\n" +
                            "          </div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"text-align:right; line-height: 1.8; padding-bottom: 18px;\">\n" +
                            "          <div>君捷团队</div>\n" +
                            "          <div style=\"color:#909090;\">#date#</div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"padding-top: 20px; border-top: 1px solid #e7e7e7; line-height: 1.8; font-size: 12px; color:#909090;\">\n" +
                            "          <div>温馨提示：</div>\n" +
                            "          <ol>\n" +
                            "            <li>君捷官方网址为：http://www.agilemaster.com.cn/，请注意网址，防止钓鱼。</li>\n" +
                            "            <li>本邮件为系统自动发出，请勿回复。</li>\n" +
                            "          </ol>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "    </table>\n" +
                            "  </div>\n" +
                            "</div>\n" +
                            "</body>\n" +
                            "</html>")
                    .setDescription("任务及时提醒邮件HTML")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }

        if (configService.checkMapName(CommonContact.USER_FORGET_PASS_EMAIL)) {
            config = new Config();
            config.setMapName(CommonContact.USER_FORGET_PASS_EMAIL)
                    .setMapValue("<!DOCTYPE html>\n" +
                            "<html lang=\"en\">\n" +
                            "<head>\n" +
                            "  <meta charset=\"UTF-8\">\n" +
                            "  <title>Title</title>\n" +
                            "</head>\n" +
                            "<body>\n" +
                            "<div style=\"background: #f6f8f9; padding:50px;font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;\">\n" +
                            "  <div style=\"margin: 0 auto; text-align: left;padding: 38px 50px; width: 560px; font-size: 14px;color: #606060; background: #fff; border-radius:2px; font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;box-shadow: 0 0 4px rgba(0,0,0,0.2);\">\n" +
                            "    <table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"560\" style=\"margin: 0 auto;text-align: left; font-size: 14px; color: #606060;background: #fff; font-family: inherit;font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;\">\n" +
                            "      <tr>\n" +
                            "        <th colspan=\"2\">\n" +
                            "          <a href=\"http://www.arvix.cn/\"><img width=\"150\" src=\"http://o960hfmwc.bkt.clouddn.com/junjieLOGO.png\" alt=\"君捷\"></a>\n" +
                            "          <div style=\"display: inline-block;vertical-align: top;\">\n" +
                            "            <p>Agile Master Inc</p>\n" +
                            "            <p>北京君捷科技有限公司</p>\n" +
                            "          </div>\n" +
                            "        </th>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"font-size:17px; padding: 25px 0 18px;\">\n" +
                            "          尊敬的君捷用户：\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"line-height: 1.8;\">\n" +
                            "          <div>欢迎使用君捷！</div>\n" +
                            "          <div>你的验证码是：</div>\n" +
                            "          <div style=\"font-size: 25px;color: #03c5ff;font-weight: bold;\">#checkCode#</div>\n" +
                            "          <div style=\"font-size:12px; line-height: 20px;  color: #909090;\">（请不要告诉其他人）</div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"text-align:right; line-height: 1.8; padding-bottom: 18px;\">\n" +
                            "          <div>君捷团队</div>\n" +
                            "          <div style=\"color:#909090;\">#date#</div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"padding-top: 20px; border-top: 1px solid #e7e7e7; line-height: 1.8; font-size: 12px; color:#909090;\">\n" +
                            "          <div>温馨提示：</div>\n" +
                            "          <ol>\n" +
                            "            <li>君捷官方网址为：http://www.agilemaster.com.cn/，请注意网址，防止钓鱼。</li>\n" +
                            "            <li>本邮件为系统自动发出，请勿回复。</li>\n" +
                            "          </ol>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "    </table>\n" +
                            "  </div>\n" +
                            "</div>\n" +
                            "</body>\n" +
                            "</html>")
                    .setDescription("邮箱验证码Html")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.INVITATION_HTML)) {
            config = new Config();
            config.setMapName(CommonContact.INVITATION_HTML)
                    .setMapValue("<!DOCTYPE html>\n" +
                            "<html lang=\"en\">\n" +
                            "<head>\n" +
                            "    <meta charset=\"UTF-8\">\n" +
                            "    <title>Title</title>\n" +
                            "</head>\n" +
                            "<body>\n" +
                            "<div style=\"background: #f6f8f9; padding:50px;font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;\">\n" +
                            "  <div style=\"margin: 0 auto; text-align: left;padding: 38px 50px; width: 560px; font-size: 14px;color: #606060; background: #fff; border-radius:2px; font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;box-shadow: 0 0 4px rgba(0,0,0,0.2);\">\n" +
                            "    <table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"560\" style=\"margin: 0 auto;text-align: left; font-size: 14px; color: #606060;background: #fff; font-family: inherit;font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;\">\n" +
                            "       <tr>\n" +
                            "        <th colspan=\"2\">\n" +
                            "          <a href=\"http://www.arvix.cn/\"><img width=\"150\" src=\"http://o960hfmwc.bkt.clouddn.com/junjieLOGO.png\" alt=\"君捷\"></a>\n" +
                            "          <div style=\"display: inline-block;vertical-align: top;\">\n" +
                            "            <p>Agile Master Inc</p>\n" +
                            "            <p>北京君捷科技有限公司</p>\n" +
                            "          </div>\n" +
                            "        </th>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"font-size:17px; padding: 25px 0 18px;\">\n" +
                            "          hi,#remindName#：\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"line-height: 1.8;\">\n" +
                            "          <div>您已被邀请加入【#teamName#】</div>\n" +
                            "          <div>请点击以下链接查看详情。</div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"font-size:12px; line-height: 20px; padding-top: 14px;padding-bottom: 25px; color: #909090;\">\n" +
                            "          <div>\n" +
                            "            <a href=\"#url#\" style=\"color: #03c5ff; word-break: break-all; text-decoration:underline;\" target=\"_blank\">#url#</a>\n" +
                            "            <div style=\"padding-top:4px;\">(如果不能打开页面，请复制该地址到浏览器打开)</div>\n" +
                            "          </div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"text-align:right; line-height: 1.8; padding-bottom: 18px;\">\n" +
                            "          <div>君捷团队</div>\n" +
                            "          <div style=\"color:#909090;\">#date#</div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"padding-top: 20px; border-top: 1px solid #e7e7e7; line-height: 1.8; font-size: 12px; color:#909090;\">\n" +
                            "          <div>温馨提示：</div>\n" +
                            "          <ol>\n" +
                            "            <li>君捷官方网址为：http://www.agilemaster.com.cn/，请注意网址，防止钓鱼。</li>\n" +
                            "            <li>本邮件为系统自动发出，请勿回复。</li>\n" +
                            "          </ol>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "    </table>\n" +
                            "  </div>\n" +
                            "</div>\n" +
                            "</body>\n" +
                            "</html>")
                    .setDescription("邀请加入团队Html")
                    .setValueType(ConfigValueType.String)
                    .setEditable(true)
                    .setCreater("init");
            configService.save(config);
            configList.add(config);
        }
        if (configService.checkMapName(CommonContact.INVITATION_PASSWORD_HTML)) {
            config = new Config();
            config.setMapName(CommonContact.INVITATION_PASSWORD_HTML)
                    .setMapValue("<!DOCTYPE html>\n" +
                            "<html lang=\"en\">\n" +
                            "<head>\n" +
                            "    <meta charset=\"UTF-8\">\n" +
                            "    <title>Title</title>\n" +
                            "</head>\n" +
                            "<body>\n" +
                            "<div style=\"background: #f6f8f9; padding:50px;font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;\">\n" +
                            "  <div style=\"margin: 0 auto; text-align: left;padding: 38px 50px; width: 560px; font-size: 14px;color: #606060; background: #fff; border-radius:2px; font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;box-shadow: 0 0 4px rgba(0,0,0,0.2);\">\n" +
                            "    <table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"560\" style=\"margin: 0 auto;text-align: left; font-size: 14px; color: #606060;background: #fff; font-family: inherit;font-family:Tahoma,Helvetica,'microsoft\\nyahei','Hiragino Sans GB',Simsun,sans-serif;\">\n" +
                            "       <tr>\n" +
                            "        <th colspan=\"2\">\n" +
                            "          <a href=\"http://www.arvix.cn/\"><img width=\"150\" src=\"http://o960hfmwc.bkt.clouddn.com/junjieLOGO.png\" alt=\"君捷\"></a>\n" +
                            "          <div style=\"display: inline-block;vertical-align: top;\">\n" +
                            "            <p>Agile Master Inc</p>\n" +
                            "            <p>北京君捷科技有限公司</p>\n" +
                            "          </div>\n" +
                            "        </th>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"font-size:17px; padding: 25px 0 18px;\">\n" +
                            "          hi,#remindName#：\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"line-height: 1.8;\">\n" +
                            "          <div>您已被邀请加入【#teamName#】</div>\n" +
                            "          <div>初始密码（登陆后请及时修改密码）：<span style=\"font-size: 16px;color: orange;\">#password#<span></div>\n" +
                            "          <div>请点击以下链接查看详情。</div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"font-size:12px; line-height: 20px; padding-top: 14px;padding-bottom: 25px; color: #909090;\">\n" +
                            "          <div>\n" +
                            "            <a href=\"#url#\" style=\"color: #03c5ff; word-break: break-all; text-decoration:underline;\" target=\"_blank\">#url#</a>\n" +
                            "            <div style=\"padding-top:4px;\">(如果不能打开页面，请复制该地址到浏览器打开)</div>\n" +
                            "          </div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"text-align:right; line-height: 1.8; padding-bottom: 18px;\">\n" +
                            "          <div>君捷团队</div>\n" +
                            "          <div style=\"color:#909090;\">#date#</div>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "      <tr>\n" +
                            "        <td colspan=\"2\" style=\"padding-top: 20px; border-top: 1px solid #e7e7e7; line-height: 1.8; font-size: 12px; color:#909090;\">\n" +
                            "          <div>温馨提示：</div>\n" +
                            "          <ol>\n" +
                            "            <li>君捷官方网址为：http://www.agilemaster.com.cn/，请注意网址，防止钓鱼。</li>\n" +
                            "            <li>本邮件为系统自动发出，请勿回复。</li>\n" +
                            "          </ol>\n" +
                            "        </td>\n" +
                            "      </tr>\n" +
                            "    </table>\n" +
                            "  </div>\n" +
                            "</div>\n" +
                            "</body>\n" +
                            "</html>")
                    .setDescription("邀请加入团队(带密码)Html")
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
                    .setMapValue("prod")
                    .setDescription("系统环境")
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
            //个人设置相关栏目资源
            parentResource = initResources("个人设置", null, null, null, 1f, ResourceType.column, "text-info fa fa-address-card-o");
            resourceService.save(parentResource);
            resource = initResources("个人资料", null, "/index/person/profile", parentResource.getId(), 1f, ResourceType.column, null);
            resourceService.save(resource);
            resource = initResources("头像设置", null, "/index/person/avatar", parentResource.getId(), 2f, ResourceType.column, null);
            resourceService.save(resource);
            resource = initResources("修改密码", null, "/index/person/password", parentResource.getId(), 3f, ResourceType.column, null);
            resourceService.saveAndFlush(resource);

            //日报相关
            parentResource = initResources("日报", null, null, null, 2f, ResourceType.column, "text-danger fa fa-pencil-square-o");
            resourceService.save(parentResource);
            resource = initResources("我的日报", null, "/index/blog/my", parentResource.getId(), 1f, ResourceType.column, null);
            resourceService.save(resource);
            resource = initResources("他人日报", null, "/index/blog/other", parentResource.getId(), 2f, ResourceType.column, null);
            resourceService.save(resource);
            resource = initResources("日报统计", null, "/index/blog/statistic", parentResource.getId(), 3f, ResourceType.column, null);
            resourceService.saveAndFlush(resource);

            //周报相关
            parentResource = initResources("周报", null, null, null, 3f, ResourceType.column, "text-danger fa fa-pencil-square-o");
            resourceService.save(parentResource);
            resource = initResources("我的周报", null, "/index/blog/weekly-report", parentResource.getId(), 1f, ResourceType.column, null);
            resourceService.save(resource);
            resource = initResources("周报统计", null, "/index/blog/weekly-report-statistic", parentResource.getId(), 2f, ResourceType.column, null);
            resourceService.saveAndFlush(resource);


            //团队成员设置

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
