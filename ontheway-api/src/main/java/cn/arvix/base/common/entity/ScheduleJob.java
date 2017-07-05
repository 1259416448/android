package cn.arvix.base.common.entity;

import java.io.Serializable;


/**
 * @author yangyang   2015  Jun 2, 2015
 *         e-mail  ：296604153@qq.com ； tel ：18580128658 ；QQ ：296604153
 */
public class ScheduleJob implements Serializable {
    /**
     * 任务id
     **/
    private String jobId;

    /**
     * 任务名称
     **/
    private String jobName;

    /**
     * 任务分组
     **/
    private String jobGroup;

    /**
     * 任务状态 0禁用 1启用 2删除
     **/
    private String jobStatus;

    /**
     * 任务运行时间表达式
     **/
    private String cronExpression;

    /**
     * 任务描述
     **/
    private String desc;

    /**
     * 执行类
     */
    private String targetObject;

    /**
     * 执行方法
     */
    private String targetMethod;

    public String getJobId() {
        return jobId;
    }

    public void setJobId(String jobId) {
        this.jobId = jobId;
    }

    public String getJobName() {
        return jobName;
    }

    public void setJobName(String jobName) {
        this.jobName = jobName;
    }

    public String getJobGroup() {
        return jobGroup;
    }

    public void setJobGroup(String jobGroup) {
        this.jobGroup = jobGroup;
    }

    public String getJobStatus() {
        return jobStatus;
    }

    public void setJobStatus(String jobStatus) {
        this.jobStatus = jobStatus;
    }

    public String getCronExpression() {
        return cronExpression;
    }

    public void setCronExpression(String cronExpression) {
        this.cronExpression = cronExpression;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getTargetObject() {
        return targetObject;
    }

    public void setTargetObject(String targetObject) {
        this.targetObject = targetObject;
    }

    public String getTargetMethod() {
        return targetMethod;
    }

    public void setTargetMethod(String targetMethod) {
        this.targetMethod = targetMethod;
    }
}
