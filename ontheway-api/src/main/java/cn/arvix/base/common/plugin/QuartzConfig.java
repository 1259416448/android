package cn.arvix.base.common.plugin;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;

import javax.sql.DataSource;
import java.io.IOException;
import java.util.Properties;

/**
 * @author Created by yangyang on 2017/5/16.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Configuration
public class QuartzConfig {

    @Value("${quartz.scheduler.instanceName}")
    private String quartzInstanceName;

//    @Value("${spring.datasource.driverClassName}")
//    private String myDSDriver;
//
//    @Value("${spring.datasource.url}")
//    private String myDSURL;
//
//    @Value("${spring.datasource.username}")
//    private String myDSUser;
//
//    @Value("${spring.datasource.password}")
//    private String myDSPassword;
//
//    @Value("${org.quartz.dataSource.myDS.maxConnections}")
//    private String myDSMaxConnections;

    /**
     * 设置属性
     *
     * @return quartz config
     * @throws IOException 异常
     */
    private Properties quartzProperties() throws IOException {
        Properties prop = new Properties();
        prop.put("quartz.scheduler.instanceName", quartzInstanceName);
        prop.put("org.quartz.scheduler.instanceId", "AUTO");
        prop.put("org.quartz.scheduler.skipUpdateCheck", "true");
        prop.put("org.quartz.scheduler.jmx.export", "true");

        prop.put("org.quartz.jobStore.class", "org.quartz.impl.jdbcjobstore.JobStoreTX");
        prop.put("org.quartz.jobStore.driverDelegateClass", "org.quartz.impl.jdbcjobstore.StdJDBCDelegate");
        prop.put("org.quartz.jobStore.dataSource", "quartzDataSource");
        prop.put("org.quartz.jobStore.tablePrefix", "QRTZ_");
        prop.put("org.quartz.jobStore.isClustered", "true");

        prop.put("org.quartz.jobStore.clusterCheckinInterval", "20000");
        prop.put("org.quartz.jobStore.dataSource", "myDS");
        prop.put("org.quartz.jobStore.maxMisfiresToHandleAtATime", "1");
        prop.put("org.quartz.jobStore.misfireThreshold", "120000");
        prop.put("org.quartz.jobStore.txIsolationLevelSerializable", "true");
        prop.put("org.quartz.jobStore.selectWithLockSQL", "SELECT * FROM {0}LOCKS WHERE LOCK_NAME = ? FOR UPDATE");

        prop.put("org.quartz.threadPool.class", "org.quartz.simpl.SimpleThreadPool");
        prop.put("org.quartz.threadPool.threadCount", "10");
        prop.put("org.quartz.threadPool.threadPriority", "5");
        prop.put("org.quartz.threadPool.threadsInheritContextClassLoaderOfInitializingThread", "true");

//        prop.put("org.quartz.dataSource.myDS.driver", myDSDriver);
//        prop.put("org.quartz.dataSource.myDS.URL", myDSURL);
//        prop.put("org.quartz.dataSource.myDS.user", myDSUser);
//        prop.put("org.quartz.dataSource.myDS.password", myDSPassword);
//        prop.put("org.quartz.dataSource.myDS.maxConnections", myDSMaxConnections);

        prop.put("org.quartz.plugin.triggHistory.class", "org.quartz.plugins.history.LoggingJobHistoryPlugin");
        prop.put("org.quartz.plugin.shutdownhook.class", "org.quartz.plugins.management.ShutdownHookPlugin");
        prop.put("org.quartz.plugin.shutdownhook.cleanShutdown", "true");
        return prop;
    }

    @Bean
    public SchedulerFactoryBean schedulerFactoryBean(@Qualifier("dataSource") DataSource dataSource) throws IOException {
        SchedulerFactoryBean factory = new SchedulerFactoryBean();
        // this allows to update triggers in DB when updating settings in config file:
        //用于quartz集群,QuartzScheduler 启动时更新己存在的Job，这样就不用每次修改targetObject后删除qrtz_job_details表对应记录了
        factory.setOverwriteExistingJobs(true);
        //用于quartz集群,加载quartz数据源
        factory.setDataSource(dataSource);
        //QuartzScheduler 延时启动，应用启动完10秒后 QuartzScheduler 再启动
        factory.setStartupDelay(10);
        //用于quartz集群,加载quartz数据源配置
        factory.setQuartzProperties(quartzProperties());
        factory.setAutoStartup(true);
        factory.setApplicationContextSchedulerContextKey("applicationContext");
        //直接使用配置文件
        //factory.setConfigLocation(new FileSystemResource(this.getClass().getResource("/quartz.properties").getPath()));
        return factory;
    }

}
