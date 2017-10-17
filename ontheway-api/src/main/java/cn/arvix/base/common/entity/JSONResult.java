package cn.arvix.base.common.entity;

import com.alibaba.fastjson.JSON;

/**
 * Company ：FsPhoto
 * JSON返回实体。
 *
 * @author Created by yangyang on 16/7/24.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class JSONResult {

    private String message;
    private int code = -1; // -1  0
    private String messageCode;
    private Long serverTime;
    private Object body;

    public boolean ifSuccess() {
        return code == 0;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessageCode() {
        return messageCode;
    }

    public void setMessageCode(String messageCode) {
        this.messageCode = messageCode;
    }

    public <T> T getBody() {
        //noinspection unchecked
        return (T) body;
    }

    public void setBody(Object body) {
        this.body = body;
    }

    public String toString() {
        return JSON.toJSONString(this);
    }

    public Long getServerTime() {
        return serverTime;
    }

    public void setServerTime(Long serverTime) {
        this.serverTime = serverTime;
    }
}
