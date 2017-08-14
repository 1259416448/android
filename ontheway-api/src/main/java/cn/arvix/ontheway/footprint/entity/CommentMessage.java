package cn.arvix.ontheway.footprint.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import cn.arvix.ontheway.sys.user.entity.User;

import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

/**
 * @author Created by yangyang on 2017/8/10.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Entity
@Table(name = "otw_comment_message")
public class CommentMessage extends BaseEntity<Long> {

    //评论
    @OneToOne
    private Comment comment;

    //足迹
    @ManyToOne
    @NotNull(message = "footprint is not null")
    private Footprint footprint;

    //状态
    @NotNull(message = "status is not null")
    private Boolean status = Boolean.FALSE;

    //用户ID
    @NotNull(message = "userId is not null")
    private Long userId;

    //评论用户
    @ManyToOne
    @NotNull(message = "commentUser is not null")
    private User commentUser;

    /**
     * checkLack
     */
    public String checkLack() {
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        return builder.toString();
    }

    public Comment getComment() {
        return comment;
    }

    public void setComment(Comment comment) {
        this.comment = comment;
    }

    public Footprint getFootprint() {
        return footprint;
    }

    public void setFootprint(Footprint footprint) {
        this.footprint = footprint;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public User getCommentUser() {
        return commentUser;
    }

    public void setCommentUser(User commentUser) {
        this.commentUser = commentUser;
    }
}
