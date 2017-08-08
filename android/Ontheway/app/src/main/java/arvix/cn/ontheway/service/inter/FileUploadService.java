package arvix.cn.ontheway.service.inter;

import android.app.Activity;

import java.io.File;

import arvix.cn.ontheway.service.impl.FileUploadServiceImpl;

/**
 * Created by asdtiang on 2017/8/7 0007.
 * asdtiangxia@163.com
 */

public interface FileUploadService {
     void upload(final Activity act, final String filePath, final String uploadUrl, final FileUploadCallBack fileUploadCallBack) ;
     void upload(final Activity act, final File File, final String uploadUrl, final FileUploadCallBack fileUploadCallBack) ;
     void upload(final Activity act, final byte[] data, final String uploadUrl, final FileUploadCallBack fileUploadCallBack) ;
     void upload(final Activity act, final String filePath,final FileUploadCallBack fileUploadCallBack) ;
     void upload(final Activity act, final File File,  final FileUploadCallBack fileUploadCallBack) ;
     void upload(final Activity act, final byte[] data,  final FileUploadCallBack fileUploadCallBack) ;

}
