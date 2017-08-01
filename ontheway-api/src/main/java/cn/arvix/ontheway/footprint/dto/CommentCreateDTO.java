package cn.arvix.ontheway.footprint.dto;

import io.swagger.annotations.ApiModelProperty;

import java.io.Serializable;

/**
 * @author Created by yangyang on 2017/7/31.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class CommentCreateDTO implements Serializable{

    @ApiModelProperty(value = "评论内容")
    private String content;

    @ApiModelProperty(value = "回复用户ID")
    private Long commentUserId;

    @ApiModelProperty(value = "关联评论ID")
    private Long replyCommentId;

    @ApiModelProperty(value = "评论足迹ID")
    private Long footprintId;

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Long getCommentUserId() {
        return commentUserId;
    }

    public void setCommentUserId(Long commentUserId) {
        this.commentUserId = commentUserId;
    }

    public Long getReplyCommentId() {
        return replyCommentId;
    }

    public void setReplyCommentId(Long replyCommentId) {
        this.replyCommentId = replyCommentId;
    }

    public Long getFootprintId() {
        return footprintId;
    }

    public void setFootprintId(Long footprintId) {
        this.footprintId = footprintId;
    }
}
