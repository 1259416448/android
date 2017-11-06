package cn.arvix.ontheway.sys.sms;

import java.util.Map;

/**
 * 短信发送接口
 *
 * @author Created by yangyang on 2017/7/6.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public interface SMSService {

    /**
     * 发送短信
     *
     * @param msg    信息内容
     * @param params 其他参数 包含需要的所有参数
     * @return 发送结果
     */
    boolean sendMessage(String msg, Map<String, Object> params);

}
