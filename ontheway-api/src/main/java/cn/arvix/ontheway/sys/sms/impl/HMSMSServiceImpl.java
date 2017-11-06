package cn.arvix.ontheway.sys.sms.impl;

import cn.arvix.ontheway.sys.sms.SMSService;
import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.Arrays;
import java.util.Map;

/**
 * @author Created by yangyang on 2017/10/9.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@Service("hmSMSServiceImpl")
public class HMSMSServiceImpl implements SMSService {

    //请求地址
    private static final String url = "http://client.cloud.hbsmservice.com:8080/sms_send2.do";

    //访问接口账户id
    private static final String corp_id = "df6585";

    //访问接口账户密码
    private static final String corp_pwd = "mm2289";

    //业务代码
    private static final String corp_service = "106902707091";

    //扩展小号
    private static final String ext = "06";

    private static final String sign = "【ON THE WAY】";

    /**
     * 发送短信
     *
     * @param msg    信息内容
     * @param params 其他参数 包含需要的所有参数
     * @return 发送结果
     */
    @Override
    public boolean sendMessage(String msg, Map<String, Object> params) {

        //创建httpclient对象
        CloseableHttpClient client = HttpClients.createDefault();
        //创建post方式请求对象
        HttpPost httpPost = new HttpPost(url);

        httpPost.setHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

        System.out.println(String.valueOf(params.get("mobile")));
        System.out.println(sign + msg);

        NameValuePair[] data = {
                new BasicNameValuePair("corp_id", corp_id),
                new BasicNameValuePair("corp_pwd", corp_pwd),
                new BasicNameValuePair("corp_service", corp_service),
                new BasicNameValuePair("mobile", String.valueOf(params.get("mobile"))),
                new BasicNameValuePair("msg_content", sign + msg),
                new BasicNameValuePair("corp_msg_id", ""),
                new BasicNameValuePair("sign", sign),
                new BasicNameValuePair("ext", ext)
        };
        try {
            httpPost.setEntity(new UrlEncodedFormEntity(Arrays.asList(data), "utf-8"));
            HttpResponse response = client.execute(httpPost);

            System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>" + response.getStatusLine().getStatusCode());

            for (Header h : response.getAllHeaders()) {
                System.out.println(h.toString());
            }

            HttpEntity resEntity = response.getEntity();

            if (resEntity != null) {
                String result = EntityUtils.toString(resEntity);
                System.out.println(result);
            }


            return true;

        } catch (IOException e) {
            e.printStackTrace();
        }


        return false;
    }
}
