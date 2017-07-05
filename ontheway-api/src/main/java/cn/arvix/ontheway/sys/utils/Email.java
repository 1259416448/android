package cn.arvix.ontheway.sys.utils;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;

import javax.mail.internet.MimeMessage;

public class Email {

    private JavaMailSender javaMailSender;
    private String from;
    private String personal;
    private TaskExecutor taskExecutor;

    private static final Logger logger = LoggerFactory.getLogger(Email.class);


    public boolean sendSimpleEmail(String subject, String text, String toEmail, Boolean ifHtml) {
        return sendSimpleEmail(null, subject, text, toEmail, ifHtml);
    }

    public boolean sendSimpleEmail(String sendName, String subject, String text, String toEmail, Boolean ifHtml) {
        return sendSimpleEmail(null, sendName, subject, text, toEmail, ifHtml);
    }

    public boolean sendSimpleEmail(String sendFrom, String sendName, String subject, String text, String toEmail, Boolean ifHtml) {
        EmailBean emailBean = new EmailBean(sendFrom, sendName, subject,
                text, toEmail, ifHtml);
        sendMailByAsynchronousMode(emailBean);
        return true;
    }

    public void sendMailByAsynchronousMode(final EmailBean emailBean) {
        taskExecutor.execute(() -> {
            try {
                MimeMessage mimeMessage = javaMailSender.createMimeMessage();
                MimeMessageHelper messageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
                messageHelper.setTo(emailBean.getToEmail());
                if (StringUtils.isEmpty(emailBean.getSendFrom())) {
                    emailBean.setSendFrom(from);
                }
                if (!StringUtils.isEmpty(emailBean.getSendName())) {
                    messageHelper.setFrom(emailBean.getSendFrom(), emailBean.getSendName());
                } else {
                    messageHelper.setFrom(emailBean.getSendFrom(), personal);
                }
                messageHelper.setSubject(emailBean.getSubject());
                messageHelper.setText(emailBean.getText(), emailBean.getIfHtml());
                javaMailSender.send(mimeMessage);
            } catch (Exception e) {
                logger.error("send email error", e);
            }
        });
    }

    public TaskExecutor getTaskExecutor() {
        return taskExecutor;
    }

    @Autowired
    public void setTaskExecutor(TaskExecutor taskExecutor) {
        this.taskExecutor = taskExecutor;
    }

    public String getFrom() {
        return from;
    }

    public void setFrom(String from) {
        this.from = from;
    }

    public JavaMailSender getJavaMailSender() {
        return javaMailSender;
    }

    public void setJavaMailSender(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

    public String getPersonal() {
        return personal;
    }

    public void setPersonal(String personal) {
        this.personal = personal;
    }
}
