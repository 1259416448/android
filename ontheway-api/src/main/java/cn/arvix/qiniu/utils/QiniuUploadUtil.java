package cn.arvix.qiniu.utils;

import cn.arvix.ontheway.sys.config.service.ConfigService;
import cn.arvix.ontheway.sys.utils.WebContextUtils;
import cn.arvix.base.common.utils.CommonContact;
import com.qiniu.common.QiniuException;
import com.qiniu.util.Auth;
import com.qiniu.util.StringMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author Created by yangyang on 2017/3/28.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
@SuppressWarnings("JavadocReference")
@Service
public class QiniuUploadUtil {

    private final ConfigService configService;

    private final WebContextUtils webContextUtils;

    @Autowired
    public QiniuUploadUtil(ConfigService configService,
                           WebContextUtils webContextUtils) {
        this.configService = configService;
        this.webContextUtils = webContextUtils;
    }

    /**
     * 生成上传token（qiniu.util包Auth类的最底层重载方法，实现生成uptoken并返回，完整逻辑)
     *
     * @param bucket 空间名
     * @param key key，可为 null
     * @param expires 有效时长，单位秒。默认3600s
     * @param policy 上传策略的其它参数，如 new StringMap().put("endUser",
     *               "uid").putNotEmpty("returnBody", "")。 scope通过
     *               bucket、key间接设置，deadline 通过 expires 间接设置
     * @param strict 是否去除非限定的策略字段，默认true
     * @return 生成的上传token
     *
     *	public String uploadToken(String bucket, String key, long expires,
     *	StringMap policy, boolean strict){
     *	return null;
    }
     */

    /**
     * 上传数据
     *
     * @param data     上传的数据 byte[]、File、filePath
     * @param key      上传数据保存的文件名
     * @param token    上传凭证
     * @param params   自定义参数，如 params.put("x:foo", "foo")
     * @param mime     指定文件mimetype
     * @param checkCrc 是否验证crc32
     * @return
     * @throws QiniuException public Response put(XXXX data, String key, String token, StringMap
     *                        params,
     *                        String mime, boolean checkCrc) throws QiniuException{
     *                        }
     */
    // 加载accessKey和secretKey，检查密钥非空，加密secretKey，重构密钥。
    public Auth getAuth() {
        String QINIU_ACCESS_KEY = configService.getConfigString(CommonContact.QINIU_ACCESS_KEY);
        String QINIU_SECRET_KEY = configService.getConfigString(CommonContact.QINIU_SECRET_KEY);
        return Auth.create(QINIU_ACCESS_KEY, QINIU_SECRET_KEY);
    }

    // 获取文件上传bucket
    public String getBucket() {
        return configService.getConfigString(CommonContact.QINIU_FILE_BUCKET);
    }


    /**
     * 获取token上传凭证，简单上传，使用默认策略
     *
     * @return 上传token
     */
    public String getUpToken() {
        return getAuth().uploadToken(getBucket(), null, 7200, new StringMap().put("returnBody", "{\n" +
                "    \"key\": $(key),\n" +
                "    \"size\": $(fsize),\n" +
                "    \"type\": $(mimeType),\n" +
                "    \"hash\": $(etag),\n" +
                "    \"w\": $(imageInfo.width),\n" +
                "    \"h\": $(imageInfo.height)\n" +
                "}\n"));
    }


    /**
     * 获取覆盖上传token
     *
     * @param key 覆盖的key名称
     * @return 上传token
     */
    public String getUpToken(String key) {
        return getAuth().uploadToken(getBucket(), key, 7200, new StringMap().put("returnBody", "{\n" +
                "    \"key\": $(fname),\n" +
                "    \"size\": $(fsize),\n" +
                "    \"type\": $(mimeType),\n" +
                "    \"hash\": $(etag),\n" +
                "    \"w\": $(imageInfo.width),\n" +
                "    \"h\": $(imageInfo.height)\n" +
                "}\n"));
    }

    //    // 设置指定上传策略
    //    public String getUpToken2() {
    //        return auth.uploadToken(
    //                "bucket",
    //                null,
    //                3600,
    //                new StringMap().put("callbackUrl", "call back url")
    //                        .putNotEmpty("callbackHost", "")
    //                        .put("callbackBody", "key=$(key)&hash=$(etag)"));
    //    }

    /**
     * 获取视频上传token
     *
     * @param bucket  上传位置
     * @param key     key名称
     * @param expires 有效时间
     * @return 上传token
     */
    //    public String getUpToken(String bucket, String key, Long expires) {
    //        StringBuilder buffer = new StringBuilder();
    //        if (!Checks.empty(SystemParms.qiniu_persistentOps)) {
    //            //启用视频水印
    //            if (sysConfigDomainService.getConfigBoolean(FangshuoContact.QINIU_ENABLE_WM_IMAGE)
    //                    && !Checks.empty(SystemParms.qiniu_Gravity)) { //添加视频水印
    //                String[] persistentOps = SystemParms.qiniu_persistentOps.split(";");
    //                if (persistentOps.length > 0) {
    //                    for (String persistentOp : persistentOps) {
    //                        if (!Checks.empty(persistentOp)) {
    //                            //如果处理哦方式有改变,请在这里修改
    //                            String wmImage = UrlSafeBase64.encodeToString(PropertiesMaker.readValue(propertiesPath, "qiniu.wmImage" + (persistentOp.contains("1920x1080") ? "1920x1080" : persistentOp.contains("1280x720") ? "1280x720" : "854x480")));
    //                            if (!Checks.empty(buffer.toString())) buffer.append(";");
    //                            buffer.append(persistentOp).append("/wmImage/").append(wmImage).append("/Gravity/").append(SystemParms.qiniu_Gravity);
    //                        }
    //                    }
    //                }
    //            } else {
    //                buffer.append(SystemParms.qiniu_persistentOps);
    //            }
    //            return auth.uploadToken(bucket, key, expires, new StringMap().putNotEmpty("persistentOps", buffer.toString())
    //                    .putNotEmpty("persistentNotifyUrl", sysConfigDomainService.getConfigString(FangshuoContact.SERVER_URL) +
    //                            sysConfigDomainService.getConfigString(FangshuoContact.QINIU_PERSISTENT_NOTIFY_URL))
    //                    .putNotEmpty("persistentPipeline", SystemParms.qiniu_persistentPipeline), true);
    //        }
    //        return null;
    //    }

    //    // 设置预处理、去除非限定的策略字段
    //    public String getUpToken3() {
    //        return auth.uploadToken(
    //                "bucket",
    //                null,
    //                3600,
    //                new StringMap().putNotEmpty("persistentOps", "")
    //                        .putNotEmpty("persistentNotifyUrl", "")
    //                        .putNotEmpty("persistentPipeline", ""), true);
    //    }
}
