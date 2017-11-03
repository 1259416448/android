package arvix.cn.ontheway.bean;

import com.alibaba.fastjson.JSONObject;

/**
 * Created by asdtiang on 2017/8/4 0004.
 * asdtiangxia@163.com
 */

public class BaseResponse<T> {

    private int code;
    private JSONObject body;
    private String message;
    private String messageCode;
    private long serverTime;
    private String bodyJSONStr;
    private T bodyBean;

    public T getBodyBean() {
        return bodyBean;
    }

    public void setBodyBean(T bodyBean) {
        this.bodyBean = bodyBean;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public JSONObject getBody() {
        return body;
    }

    public void setBody(JSONObject body) {
        this.body = body;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getMessageCode() {
        return messageCode;
    }

    public void setMessageCode(String messageCode) {
        this.messageCode = messageCode;
    }

    public long getServerTime() {
        return serverTime;
    }

    public void setServerTime(long serverTime) {
        this.serverTime = serverTime;
    }

    public String getBodyJSONStr() {
        return bodyJSONStr;
    }

    public void setBodyJSONStr(String bodyJSONStr) {
        this.bodyJSONStr = bodyJSONStr;
    }
}
