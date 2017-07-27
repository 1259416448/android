package arvix.cn.ontheway.been;

/**
 * Created by asdtiang on 2017/7/27 0027.
 * asdtiangxia@163.com
 */

public class ReplyBean {

    private long id;
    private String replyUserHeader;
    private String replayUserName;
    private long replayUserId;
    private String content;
    private long dateCreated;
    private String sourceMsgUserName;
    private String sourceMsgUserHeader;
    private long sourceMsgUserId;
    private String sourceContent;
    private String mainPhoto;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getReplyUserHeader() {
        return replyUserHeader;
    }

    public void setReplyUserHeader(String replyUserHeader) {
        this.replyUserHeader = replyUserHeader;
    }

    public String getReplayUserName() {
        return replayUserName;
    }

    public void setReplayUserName(String replayUserName) {
        this.replayUserName = replayUserName;
    }

    public long getReplayUserId() {
        return replayUserId;
    }

    public void setReplayUserId(long replayUserId) {
        this.replayUserId = replayUserId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public long getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(long dateCreated) {
        this.dateCreated = dateCreated;
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
