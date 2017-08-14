package cn.arvix.ontheway.message.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.utils.HibernateValidationUtil;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

/**
 * 数据库中保存的用户消息信息
 *
 * @author Created by yangyang on 2017/8/11.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Entity
@Table(name = "otw_new_message_count")
public class NewMessageCount extends BaseEntity<Long> {

    @NotNull(message = "userId is not null")
    private Long userId;

    //未读系统消息
    @NotNull(message = "systemNum is not null")
    private Integer systemNum = 0;

    //未读新的赞
    @NotNull(message = "likeNum is not null")
    private Integer likeNum = 0;

    //新的评论数
    @NotNull(message = "CommentNum is not null")
    private Integer CommentNum = 0;

    //新的足迹
    @NotNull(message = "footprintNum is not null")
    private Integer footprintNum = 0;

    public static NewMessageCount getInstance(){
        return new NewMessageCount();
    }

    /**
     * checkLack
     */
    @Override
    public String checkLack() {
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        return builder.toString();
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Integer getSystemNum() {
        return systemNum;
    }

    public void setSystemNum(Integer systemNum) {
        this.systemNum = systemNum;
    }

    public Integer getLikeNum() {
        return likeNum;
    }

    public void setLikeNum(Integer likeNum) {
        this.likeNum = likeNum;
    }

    public Integer getCommentNum() {
        return CommentNum;
    }

    public void setCommentNum(Integer commentNum) {
        CommentNum = commentNum;
    }

    public Integer getFootprintNum() {
        return footprintNum;
    }

    public void setFootprintNum(Integer footprintNum) {
        this.footprintNum = footprintNum;
    }
}
