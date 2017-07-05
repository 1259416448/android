package cn.arvix.base.common.utils;

import cn.arvix.base.common.entity.ScheduleJob;
import cn.arvix.base.common.plugin.InvokingJobDetailDetailFactory;
import org.quartz.*;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * 定时任务操作工具类
 *
 * @author yangyang 2015 Jun 2, 2015 e-mail ：296604153@qq.com ； tel ：18580128658
 *         ；QQ ：296604153
 * @version v1.0
 */
@Service
public class QuartzJobUtil {

    @Resource(name = "schedulerFactoryBean")
    private Scheduler scheduler;

    public void addJob(ScheduleJob job, Object... data) throws SchedulerException {
        // 这里获取任务信息数据
        TriggerKey triggerKey = TriggerKey.triggerKey(job.getJobName(),
                job.getJobGroup());

        // 获取trigger，即在spring配置文件中定义的 bean id="myTrigger"
        CronTrigger trigger = (CronTrigger) scheduler.getTrigger(triggerKey);

        // 不存在，创建一个
        if (null == trigger) {
            JobDetail jobDetail = JobBuilder.newJob(InvokingJobDetailDetailFactory.class)
                    .withIdentity(job.getJobName(), job.getJobGroup()).build();
            jobDetail.getJobDataMap().put("targetObject", job.getTargetObject());
            jobDetail.getJobDataMap().put("targetMethod", job.getTargetMethod());
            if (data != null) {
                int i = 0;
                for (Object obj : data) {
                    jobDetail.getJobDataMap().put("data_" + i, obj);
                    i++;
                }
            }
            // 表达式调度构建器
            CronScheduleBuilder scheduleBuilder = CronScheduleBuilder
                    .cronSchedule(job.getCronExpression());

            // 按新的cronExpression表达式构建一个新的trigger
            trigger = TriggerBuilder.newTrigger()
                    .withIdentity(job.getJobName(), job.getJobGroup())
                    .withSchedule(scheduleBuilder).build();
            scheduler.scheduleJob(jobDetail, trigger);
        } else {
            // Trigger已存在，那么更新相应的定时设置
            // 表达式调度构建器
            CronScheduleBuilder scheduleBuilder = CronScheduleBuilder
                    .cronSchedule(job.getCronExpression());
            // 按新的cronExpression表达式重新构建trigger
            trigger = trigger.getTriggerBuilder().withIdentity(triggerKey)
                    .withSchedule(scheduleBuilder).build();
            // 按新的trigger重新设置job执行
            scheduler.rescheduleJob(triggerKey, trigger);
        }
    }

    /**
     * 修改一个任务的触发时间
     *
     * @throws SchedulerException
     */
    public void modifyJobTime(ScheduleJob job) throws SchedulerException {
        TriggerKey triggerKey = TriggerKey.triggerKey(job.getJobName(),
                job.getJobGroup());
        CronTrigger trigger = (CronTrigger) scheduler.getTrigger(triggerKey);
        if (trigger == null) {
            addJob(job);
            return;
        }
        String oldTime = trigger.getCronExpression();
        if (!oldTime.equalsIgnoreCase(job.getCronExpression())) {
            // 表达式调度构建器
            CronScheduleBuilder scheduleBuilder = CronScheduleBuilder
                    .cronSchedule(job.getCronExpression());

            // 按新的cronExpression表达式重新构建trigger
            trigger = trigger.getTriggerBuilder().withIdentity(triggerKey)
                    .withSchedule(scheduleBuilder).build();

            // 按新的trigger重新设置job执行
            scheduler.rescheduleJob(triggerKey, trigger);
        }
    }

    /**
     * 删除一个任务。
     *
     * @param job 待删除任务
     * @throws SchedulerException
     */
    public void removeJob(ScheduleJob job) throws SchedulerException {
        TriggerKey triggerKey = TriggerKey.triggerKey(job.getJobName(),
                job.getJobGroup());
        CronTrigger trigger = (CronTrigger) scheduler.getTrigger(triggerKey);
        scheduler.pauseTrigger(triggerKey);// 停止触发器
        scheduler.unscheduleJob(triggerKey);// 移除触发器
        if (trigger != null) {
            scheduler.resumeJob(trigger.getJobKey());// 删除任务
        }
    }


}
