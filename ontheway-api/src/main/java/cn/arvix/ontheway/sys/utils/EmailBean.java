package cn.arvix.ontheway.sys.utils;

public class EmailBean {
    //发送人
    private String sendFrom;
    //发送人姓名
    private String sendName;
    private String subject;
    private String text;
    private String toEmail;
    private Boolean ifHtml = Boolean.FALSE;


    public EmailBean(String sendFrom, String sendName, String subject,
                     String text, String toEmail, Boolean ifHtml) {
        this.sendFrom = sendFrom;
        this.sendName = sendName;
        this.subject = subject;
        this.text = text;
        this.toEmail = toEmail;
        this.ifHtml = ifHtml;
    }

    public String getSendFrom() {
        return sendFrom;
    }

    public void setSendFrom(String sendFrom) {
        this.sendFrom = sendFrom;
    }

    public String getSendName() {
        return sendName;
    }

    public void setSendName(String sendName) {
        this.sendName = sendName;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getToEmail() {
        return toEmail;
    }

    public void setToEmail(String toEmail) {
        this.toEmail = toEmail;
    }

    public Boolean getIfHtml() {
        return ifHtml;
    }

    public void setIfHtml(Boolean ifHtml) {
        this.ifHtml = ifHtml;
    }
}
