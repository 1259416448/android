package cn.arvix.ontheway.footprint.entity;

import cn.arvix.base.common.entity.BaseEntity;
import cn.arvix.base.common.utils.CommonContact;
import cn.arvix.base.common.utils.HibernateValidationUtil;
import cn.arvix.base.common.utils.TimeMaker;
import cn.arvix.ontheway.footprint.dto.CommentDetailDTO;
import cn.arvix.ontheway.sys.user.entity.User;

import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;

/**
 * @author Created by yangyang on 2017/7/30.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */

@Entity
@Table(name = "otw_comment")
public class Comment extends BaseEntity<Long> {

    //评论内容
    @NotNull(message = "content is not null")
    private String content;

    //回复人
    @ManyToOne
    private User commentUser;

    //评论人
    @ManyToOne
    @NotNull(message = "user is not null")
    private User user;

    //评论足迹
    @ManyToOne
    @NotNull(message = "footprint is not null")
    private Footprint footprint;

    //关联的评论ID
    private Long replyCommentId;

    /**
     * checkLack
     */
    public String checkLack() {
        StringBuilder builder = HibernateValidationUtil.validateModel(this);
        return builder.toString();
    }

    public CommentDetailDTO toDetailDTO(String fixUrl) {
        CommentDetailDTO detailDTO = new CommentDetailDTO();
        detailDTO.setCommentContent(this.content);
        detailDTO.setUserId(this.getUser().getId());
        detailDTO.setUserHeadImg(fixUrl + this.getUser().getHeadImg() + "?" + CommonContact.USER_HEAD_IMG_FIX);
        detailDTO.setUserNickname(this.getUser().getName());
        detailDTO.setDateCreate(TimeMaker.toTimeMillis(this.getDateCreated()));
        detailDTO.setDateCreatedStr(TimeMaker.dateCreatedStr(detailDTO.getDateCreate()));
        detailDTO.setCommentId(this.getId());
        return detailDTO;
    }


    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public User getCommentUser() {
        return commentUser;
    }

    public void setCommentUser(User commentUser) {
        this.commentUser = commentUser;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Footprint getFootprint() {
        return footprint;
    }

    public void setFootprint(Footprint footprint) {
        this.footprint = footprint;
    }

    public Long getReplyCommentId() {
        return replyCommentId;
    }

    public void setReplyCommentId(Long replyCommentId) {
        this.replyCommentId = replyCommentId;
    }
}
