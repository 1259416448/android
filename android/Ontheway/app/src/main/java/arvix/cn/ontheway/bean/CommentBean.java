package arvix.cn.ontheway.bean;

/**
 * Created by asdtiang on 2017/7/27 0027.
 * asdtiangxia@163.com
 */

public class CommentBean {

    private long commentId;
    private String userHeadImg;
    private String userNickname;
    private long userId;
    private String commentContent;
    private long dateCreate;
    private String dateCreateStr;
    private String sourceMsgUserName;
    private String sourceMsgUserHeader;
    private long sourceMsgUserId;
    private String sourceContent;
    private String mainPhoto;

    public String getDateCreateStr() {
        return dateCreateStr;
    }

    public void setDateCreateStr(String dateCreateStr) {
        this.dateCreateStr = dateCreateStr;
    }

    public long getCommentId() {
        return commentId;
    }

    public void setCommentId(long commentId) {
        this.commentId = commentId;
    }

    public String getUserHeadImg() {
        return userHeadImg;
    }

    public void setUserHeadImg(String userHeadImg) {
        this.userHeadImg = userHeadImg;
    }

    public String getUserNickname() {
        return userNickname;
    }

    public void setUserNickname(String userNickname) {
        this.userNickname = userNickname;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getCommentContent() {
        return commentContent;
    }

    public void setCommentContent(String commentContent) {
        this.commentContent = commentContent;
    }

    public long getDateCreate() {
        return dateCreate;
    }

    public void setDateCreate(long dateCreate) {
        this.dateCreate = dateCreate;
    }

    public String getSourceMsgUserName() {
        return sourceMsgUserName;
    }

    public void setSourceMsgUserName(String sourceMsgUserName) {
        this.sourceMsgUserName = sourceMsgUserName;
    }

    public String getSourceMsgUserHeader() {
        return sourceMsgUserHeader;
    }

    public void setSourceMsgUserHeader(String sourceMsgUserHeader) {
        this.sourceMsgUserHeader = sourceMsgUserHeader;
    }

    public long getSourceMsgUserId() {
        return sourceMsgUserId;
    }

    public void setSourceMsgUserId(long sourceMsgUserId) {
        this.sourceMsgUserId = sourceMsgUserId;
    }

    public String getMainPhoto() {
        return mainPhoto;
    }

    public void setMainPhoto(String mainPhoto) {
        this.mainPhoto = mainPhoto;
    }

    public String getSourceContent() {
        return sourceContent;
    }

    public void setSourceContent(String sourceContent) {
        this.sourceContent = sourceContent;
    }
}
