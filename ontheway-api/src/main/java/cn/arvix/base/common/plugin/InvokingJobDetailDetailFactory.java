package cn.arvix.base.common.plugin;

import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.quartz.QuartzJobBean;

import java.lang.reflect.Method;

/**
 * @author Created by yangyang on 2017/5/16.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class InvokingJobDetailDetailFactory extends QuartzJobBean {

    private ApplicationContext ctx;

    @Override
    protected void executeInternal(JobExecutionContext context) throws JobExecutionException {
        try {
            JobDataMap jobDataMap = context.getJobDetail().getJobDataMap();
            Object otargetObject = ctx.getBean(String.valueOf(jobDataMap.get("targetObject")));
            Method m;
            try {
                m = otargetObject.getClass().getMethod(String.valueOf(jobDataMap.get("targetMethod")), JobExecutionContext.class);
                m.invoke(otargetObject, context);
            } catch (SecurityException | NoSuchMethodException e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            throw new JobExecutionException(e);
        }
    }

    public void setApplicationContext(ApplicationContext applicationContext) {
        this.ctx = applicationContext;
    }

}
