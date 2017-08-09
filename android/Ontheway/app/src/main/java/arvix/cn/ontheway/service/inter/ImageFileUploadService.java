package arvix.cn.ontheway.service.inter;

import android.app.Activity;

import java.io.File;

/**
 * Created by asdtiang on 2017/8/7 0007.
 * asdtiangxia@163.com
 */

public interface ImageFileUploadService {
    /**
     *
     * @param act
     * @param filePath
     * @param sizeLimit 大于1000时表示压缩，值为压缩后图片最大值
     * @param uploadUrl 上传到七牛完成后提交地址，如果不提交，则传空
     * @param fileUploadCallBack
     */
     void upload(final Activity act, final String filePath,int sizeLimit, final String uploadUrl, final FileUploadCallBack fileUploadCallBack) ;

    /**
     *
     * @param act
     * @param File
     * @param sizeLimit 大于1000时表示压缩，值为压缩后图片最大值
     * @param uploadUrl 上传到七牛完成后提交地址，如果不提交，则传空
     * @param fileUploadCallBack
     */
     void upload(final Activity act, final File File,int sizeLimit, final String uploadUrl, final FileUploadCallBack fileUploadCallBack) ;

    /**
     *
     * @param act
     * @param data
     * @param uploadUrl 上传到七牛完成后提交地址，如果不提交，则传空
     * @param fileUploadCallBack
     */
     void upload(final Activity act, final byte[] data,final String uploadUrl, final FileUploadCallBack fileUploadCallBack) ;

}
