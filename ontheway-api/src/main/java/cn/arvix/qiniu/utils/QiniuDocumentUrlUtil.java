package cn.arvix.qiniu.utils;

import org.apache.commons.lang3.StringUtils;

/**
 * 提供一些七牛文件路径处理
 *
 * @author Created by yangyang on 2017/6/7.
 *         e-mail ：yangyang_666@icloud.com ； tel ：18580128658 ；QQ ：296604153
 */
public class QiniuDocumentUrlUtil {

    /**
     * 增加 七牛图片流 处理
     *
     * @param urlFix 访问地址前缀
     * @param url    文件真实地址
     * @param fix    文件其他参数
     * @return 修饰后的文件路径
     */

    public static String getImgUrl(String urlFix, String url, String fix) {
        if (!StringUtils.isEmpty(fix)) {
            if (url.contains("?")) {
                return urlFix + url + "|" + fix;
            } else {
                return urlFix + url + "?" + fix;
            }
        }
        return urlFix + url;
    }

}
