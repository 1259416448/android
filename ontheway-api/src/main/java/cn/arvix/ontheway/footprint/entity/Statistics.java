package cn.arvix.ontheway.footprint.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.entity.SystemModule;
import cn.arvix.base.common.utils.HibernateValidationUtil;

import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.Table;

/**
 * 记录足迹统计信息
 *
 * @author Created by yangyang on 2017/7/26.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Entity
@Table(name = "otw_statistics")
public class Statistics extends BaseEntity<Long> {

    private Long instanceId;

    @Enumerated(EnumType.STRING)
    private SystemModule systemModule;

    //评论数
    private Integer commentNum = 0;

    //点赞数
    private Integer likeNum = 0;

    /**
     * checkLack
     */
    public String checkLack() {
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        return builder.toString();
    }

    public Long getInstanceId() {
        return instanceId;
    }

    public void setInstanceId(Long instanceId) {
        this.instanceId = instanceId;
    }

    public SystemModule getSystemModule() {
        return systemModule;
    }

    public void setSystemModule(SystemModule systemModule) {
        this.systemModule = systemModule;
    }

    public Integer getCommentNum() {
        return commentNum;
    }

    public void setCommentNum(Integer commentNum) {
        this.commentNum = commentNum;
    }

    public Integer getLikeNum() {
        return likeNum;
    }

    public void setLikeNum(Integer likeNum) {
        this.likeNum = likeNum;
    }
}
