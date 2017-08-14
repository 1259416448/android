package cn.arvix.ontheway.message.dto;

import java.io.Serializable;

/**
 * 保存需要处理消息
 *
 * @author Created by yangyang on 2017/8/11.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class MessageTaskDetail implements Serializable {

    private TaskType taskType;

    //操作的ID
    private Long opId;

    public enum TaskType {
        system, //系统消息
        like, //点赞 + 1
        comment,//评论 + 1
        footprint,//关注的足迹
        clearSystem, //清除系统消息
        clearLike, //清除点赞消息
        clearComment, //清除评论消息
        clearFootprint //清除关注的足迹消息
    }

    public static MessageTaskDetail getInstance() {
        return new MessageTaskDetail();
    }

    public TaskType getTaskType() {
        return taskType;
    }

    public void setTaskType(TaskType taskType) {
        this.taskType = taskType;
    }

    public Long getOpId() {
        return opId;
    }

    public void setOpId(Long opId) {
        this.opId = opId;
    }
}
