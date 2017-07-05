package cn.arvix.ontheway.sys.dto;

import java.io.Serializable;

/**
 * 保存发送的邮件激活/找回密码等邮件信息
 * 会缓存至redis中
 *
 * @author Created by yangyang on 2017/3/29.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class EmailDTO implements Serializable {

    //接收邮箱
    private String email;

    //发送内容
    private String content;

    //邮件类型
    private EmailType emailType;

    //发送时间戳
    private Long date;

    public enum EmailType {
        activation, forget
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public EmailType getEmailType() {
        return emailType;
    }

    public void setEmailType(EmailType emailType) {
        this.emailType = emailType;
    }

    public Long getDate() {
        return date;
    }

    public void setDate(Long date) {
        this.date = date;
    }
}
