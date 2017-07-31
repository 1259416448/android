package cn.arvix.qiniu.utils;

import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.base.common.utils.CommonContact;
import com.qiniu.util.Auth;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class QiniuDownloadUtil {

    // 加载accessKey和secretKey，检查密钥非空，加密secretKey，重构密钥。

    private QiniuUploadUtil qiniuUploadUtil;

    private ConfigService configService;

    @Autowired
    public void setConfigService(ConfigService configService) {
        this.configService = configService;
    }

    @Autowired
    public void setQiniuUploadUtil(QiniuUploadUtil qiniuUploadUtil) {
        this.qiniuUploadUtil = qiniuUploadUtil;
    }

    /**
     * 公开空间资源下载 如果在给bucket绑定了域名的话，可以通过以下地址访问。 [GET] http://<domain>/<key>
     * 其中<domain>是bucket所对应的域名。七牛云存储为每一个bucket提供一个默认域名。
     * 默认域名可以到七牛云存储开发者平台中，空间设置的域名设置一节查询。 用户也可以将自有的域名绑定到bucket上，通过自有域名访问七牛云存储。
     * <key>可理解为文件名，但可包含文件分隔符等其它字符。可参考特殊key资源的访问
     *
     * 注意： key必须采用utf8编码，如使用非utf8编码访问七牛云存储将反馈错误
     *
     */
    /**
     * 私有资源下载 私有资源必须通过临时下载授权凭证(downloadToken)下载，如下： [GET]
     * http://<domain>/<key>?e=<deadline>token=<downloadToken> 注意，尖括号不是必需，代表替换项。
     * <p>
     * deadline 由服务器时间加上 指定秒数 表示过期时间点。默认 3600 秒，服务器时间需校准， 不要于标准时间相差太大。
     * downloadToken 可以使用 SDK 提供的如下方法生成： private Auth auth =
     * Auth.create(getAK(), getSK()); String url =
     * "http://abc.resdet.com/dfe/hg.jpg"; String url2 =
     * "http://abd.resdet.com/dfe/hg.jpg?imageView2/1/w/100"; //默认有效时长：3600秒
     * String urlSigned = auth.privateDownloadUrl(url2); //指定时长 String
     * urlSigned2 = auth.privateDownloadUrl(url, 3600 * 24);
     */
    public String getDownloadToken(String url, Integer time) {
        if (time == null) {
            // 默认有效时长：3600秒
            return qiniuUploadUtil.getAuth().privateDownloadUrl(url);
        } else {
            // 指定时长
            return qiniuUploadUtil.getAuth().privateDownloadUrl(url, time);
        }
    }

    public String getDownloadToken(Auth auth, String url, Integer time) {
        if (time == null) {
            // 默认有效时长：3600秒
            return auth.privateDownloadUrl(url);
        } else {
            // 指定时长
            return auth.privateDownloadUrl(url, time);
        }
    }

    /**
     * 默认有效时长：3600秒
     */
    public String getDownloadToken(String url) {
        // 默认有效时长：3600秒
        return qiniuUploadUtil.getAuth().privateDownloadUrl(url);
    }

    /**
     * 默认有效时长：3600秒
     *
     * @param urls list map example   {["url":"fileUrl"]}
     * @return 处理后的文件路径
     */
    public List<Map<String, Object>> getDownloadToken(List<Map<String, Object>> urls) {
        Auth auth = qiniuUploadUtil.getAuth();
        urls.forEach(x -> x.put("url", auth.privateDownloadUrl(x.get("url").toString())));
        return urls;
    }

    /**
     * 自动追加 url fix 信息
     *
     * @return 下载地址
     */
    public String getDownloadTokenAuto(String url, Integer time) {
        String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);
        return getDownloadToken(urlFix + url, time);
    }

    /**
     * 获取共有文件下载地址
     */
    public String getNormalDownload(String url){
        String urlFix = configService.getConfigString(CommonContact.QINIU_BUCKET_URL);
        return urlFix+url;
    }
}
