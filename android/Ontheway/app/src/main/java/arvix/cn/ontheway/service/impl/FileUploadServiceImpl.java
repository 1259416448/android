package arvix.cn.ontheway.service.impl;

import android.app.Activity;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.qiniu.android.http.ResponseInfo;
import com.qiniu.android.storage.UpCompletionHandler;

import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.x;

import java.io.File;
import java.util.UUID;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.bean.BaseResponse;
import arvix.cn.ontheway.bean.QiniuBean;
import arvix.cn.ontheway.http.ServerUrl;
import arvix.cn.ontheway.service.inter.FileUploadCallBack;
import arvix.cn.ontheway.service.inter.FileUploadService;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;

/**
 * Created by asdtiang on 2017/8/7 0007.
 * asdtiangxia@163.com
 */

public class FileUploadServiceImpl implements FileUploadService {
    public String logTag = this.getClass().getName();


    private enum DataType {
        BYTE,
        FILE,
        FILEPATH,
    }

    public void upload(final Activity act, final String filePath, final String uploadUrl, final FileUploadCallBack fileUploadCallBack) {
        this.upload(act, DataType.FILEPATH, filePath, uploadUrl, fileUploadCallBack);
    }
    public void upload(final Activity act, final File File, final String uploadUrl, final FileUploadCallBack fileUploadCallBack) {
        this.upload(act, DataType.FILE, File, uploadUrl, fileUploadCallBack);
    }

    public void upload(final Activity act, final byte[] data, final String uploadUrl, final FileUploadCallBack fileUploadCallBack) {
        this.upload(act, DataType.BYTE, data, uploadUrl, fileUploadCallBack);
    }

    @Override
    public void upload(Activity act, String filePath, FileUploadCallBack fileUploadCallBack) {
        this.upload(act, DataType.FILEPATH, filePath, null, fileUploadCallBack);
    }

    @Override
    public void upload(Activity act, File File, FileUploadCallBack fileUploadCallBack) {
        this.upload(act, DataType.FILE, File, null, fileUploadCallBack);
    }

    @Override
    public void upload(Activity act, byte[] data, FileUploadCallBack fileUploadCallBack) {
        this.upload(act, DataType.BYTE, data, null, fileUploadCallBack);
    }

    private void upload(final Activity act, final DataType dataType, final Object data, final String uploadUrl, final FileUploadCallBack fileUploadCallBack) {
        RequestParams requestParams = new RequestParams(ServerUrl.QINIU_UPTOKEN);
        try {
            x.http().get(requestParams, new Callback.CommonCallback<String>() {
                @Override
                public void onSuccess(String result) {
                    Log.i(logTag,"get qiniu uptoken result-->" + result);
                    BaseResponse response = StaticMethod.genResponse(result);
                    if (response.getCode() == StaticVar.SUCCESS) {
                        String key = UUID.randomUUID().toString().replace("-", "");
                        String token = response.getBody().getString("uptoken");
                        UpCompletionHandler upCompletionHandler = new UpCompletionHandler() {
                            @Override
                            public void complete(String key, ResponseInfo info, JSONObject res) {
                                //res包含hash、key等信息，具体字段取决于上传策略的设置
                                if (info.isOK()) {
                                    Log.i("qiniu", "Upload Success");
                                    QiniuBean qiniuBean = new QiniuBean();
                                    qiniuBean.setName(key);
                                    qiniuBean.setFileSize(info.totalSize);
                                    qiniuBean.setFileUrl(key);
                                    try {
                                        qiniuBean.setFileType(res.getString("type"));
                                        qiniuBean.setW(res.getInt("w"));
                                        qiniuBean.setH(res.getInt("h"));
                                        if(uploadUrl!=null){
                                            RequestParams requestParams = new RequestParams();
                                            requestParams.setUri(uploadUrl);
                                            requestParams.setBodyContent(JSON.toJSONString(qiniuBean));
                                            x.http().post(requestParams, new Callback.CommonCallback<String>() {
                                                @Override
                                                public void onSuccess(String result) {
                                                    try {
                                                        BaseResponse response = StaticMethod.genResponse(result);
                                                        fileUploadCallBack.uploadBack(response);
                                                    } catch (Exception e) {
                                                        e.printStackTrace();
                                                    }
                                                }

                                                @Override
                                                public void onError(Throwable throwable, boolean b) {
                                                    Log.e(logTag, "error", throwable);
                                                }

                                                @Override
                                                public void onCancelled(CancelledException e) {
                                                    Log.w(logTag, "onCancelled", e);
                                                }

                                                @Override
                                                public void onFinished() {
                                                    Log.i(logTag, "onFinished");
                                                }
                                            });
                                        }else{
                                            BaseResponse response = new BaseResponse();
                                            response.setBodyBean(qiniuBean);
                                            response.setCode(StaticVar.SUCCESS);
                                            fileUploadCallBack.uploadBack(response);
                                        }
                                    } catch (JSONException e) {
                                        Log.i(logTag, "JSONException", e);
                                    }
                                } else {
                                    Log.i("qiniu", "Upload Fail");
                                    //如果失败，这里可以把info信息上报自己的服务器，便于后面分析上传错误原因
                                }
                                Log.i("qiniu", key + ",\r\n " + info + ",\r\n " + res);
                            }
                        };
                        if (dataType == DataType.BYTE) {
                            byte[] updateData = (byte[]) data;
                            App.qiniuUploadManager.put(updateData, key, token, upCompletionHandler, null);
                        } else if (dataType == DataType.FILE) {
                            File updateData = (File) data;
                            App.qiniuUploadManager.put(updateData, key, token, upCompletionHandler, null);
                        } else if (dataType == DataType.FILEPATH) {
                            String updateData = (String) data;
                            App.qiniuUploadManager.put(updateData, key, token, upCompletionHandler, null);
                        }else{
                            Log.e(logTag,"------------>unsupport dataType:"+dataType);
                        }
                    } else {
                        StaticMethod.showToast("request uptoken 失败" + response.getCode(), act);
                    }
                }
                @Override
                public void onError(Throwable ex, boolean isOnCallback) {
                    Log.e(logTag, "error", ex);
                }

                @Override
                public void onCancelled(CancelledException cex) {
                    Log.w(logTag, "onCancelled", cex);
                }

                @Override
                public void onFinished() {
                    Log.i(logTag, "onFinished");
                }
            });

        } catch (Exception e) {
            Log.e(logTag, "error", e);
        }
    }

}


