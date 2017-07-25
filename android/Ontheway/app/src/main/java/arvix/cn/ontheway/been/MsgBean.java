package arvix.cn.ontheway.been;

/**
 * Created by yd on 2017/7/20.
 */

public class MsgBean {
    private long id;
    private String title;
    private String url;
    private String content;
    private long msgTimeMils;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public long getMsgTimeMils() {
        return msgTimeMils;
    }

    public void setMsgTimeMils(long msgTimeMils) {
        this.msgTimeMils = msgTimeMils;
    }


}
