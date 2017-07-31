package cn.arvix.ontheway.footprint.dto;

/**
 * @author Created by yangyang on 2017/7/30.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class CommentDetailDTO {

    private String commentContent;

    private String userNickname;

    private String userHeadImg;

    private Long userId;

    private String dateCreatedStr;

    private Long dateCreate;


    public String getCommentContent() {
        return commentContent;
    }

    public void setCommentContent(String commentContent) {
        this.commentContent = commentContent;
    }

    public String getUserNickname() {
        return userNickname;
    }

    public void setUserNickname(String userNickname) {
        this.userNickname = userNickname;
    }

    public String getUserHeadImg() {
        return userHeadImg;
    }

    public void setUserHeadImg(String userHeadImg) {
        this.userHeadImg = userHeadImg;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getDateCreatedStr() {
        return dateCreatedStr;
    }

    public void setDateCreatedStr(String dateCreatedStr) {
        this.dateCreatedStr = dateCreatedStr;
    }

    public Long getDateCreate() {
        return dateCreate;
    }

    public void setDateCreate(Long dateCreate) {
        this.dateCreate = dateCreate;
    }
}
