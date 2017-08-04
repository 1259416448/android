package arvix.cn.ontheway.ui.usercenter;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.pizidea.imagepicker.AndroidImagePicker;
import com.qiniu.android.http.ResponseInfo;
import com.qiniu.android.storage.UpCompletionHandler;

import org.json.JSONException;
import org.json.JSONObject;
import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.BaseResponse;
import arvix.cn.ontheway.bean.QiniuBean;
import arvix.cn.ontheway.bean.UserInfo;
import arvix.cn.ontheway.http.ServerUrl;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;

/**
 * Created by asdtiang on 2017/7/21 0021.
 * asdtiangxia@163.com
 */

public class PersonInfoActivity extends BaseActivity {


    @ViewInject(R.id.nameTv)
    private TextView nameTV;
    @ViewInject(R.id.sex_tv)
    private TextView sexTV;
    @ViewInject(R.id.phone_tv)
    private TextView phoneTV;
    @ViewInject(R.id.header_img)
    private ImageView headerIV;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_person_info);
        initView();
    }

    //正整数，小于等于0会导致不响应onActivityResult
    private final int REQ_GET_NAME_EDIT = new Random().nextInt(Integer.MAX_VALUE);

    private void initView() {
        x.view().inject(this);
        new HeaderHolder().init(self, "个人信息");
        nameTV.setText(App.userInfo.getName());
        sexTV.setText(StaticMethod.genSexShow());
        phoneTV.setText(StaticMethod.genPhoneShow());
        nameTV.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(self, EditNicknameActivity.class);
                intent.putExtra(EditNicknameActivity.EXTRA_NICKNAME, App.userInfo.getName());
                startActivityForResult(intent, REQ_GET_NAME_EDIT);
            }
        });
        StaticMethod.setCircularHeaderImg(headerIV, 110, 110);
        headerIV.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AndroidImagePicker.getInstance().pickAndCrop(PersonInfoActivity.this, true, 160, new AndroidImagePicker.OnImageCropCompleteListener() {
                    @Override
                    public void onImageCropComplete(final Bitmap bmp, float ratio) {
                        Log.i(logTag, "=====onImageCropComplete (get bitmap=" + bmp.toString());
                        RequestParams requestParams = new RequestParams(ServerUrl.QINIU_UPTOKEN);
                        try {
                            x.http().get(requestParams, new Callback.CommonCallback<String>() {
                                @Override
                                public void onSuccess(String result) {
                                    BaseResponse response = StaticMethod.genResponse(result);
                                    if (response.getCode() == StaticVar.SUCCESS) {
                                        byte[] data = StaticMethod.bitmap2Bytes(bmp);
                                        String key = UUID.randomUUID().toString().replace("-", "");
                                        String token = response.getBody().getString("uptoken");
                                        App.qiniuUploadManager.put(data, key, token,
                                                new UpCompletionHandler() {
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
                                                                RequestParams requestParams = new RequestParams();
                                                                requestParams.setUri(ServerUrl.UPDATE_HEADER);
                                                                requestParams.setBodyContent(JSON.toJSONString(qiniuBean));
                                                                x.http().post(requestParams, new Callback.CommonCallback<String>() {
                                                                    @Override
                                                                    public void onSuccess(String result) {
                                                                        try {
                                                                            BaseResponse<UserInfo> response = StaticMethod.genResponse(result,UserInfo.class);
                                                                            Log.i(logTag, "imageInfo -->" + result);
                                                                            if (response.getCode() == StaticVar.SUCCESS) {
                                                                                UserInfo userInfo = response.getBodyBean();
                                                                                StaticMethod.updateUserInfo(self,userInfo);
                                                                                StaticMethod.setCircularHeaderImg(headerIV,110,110);
                                                                            } else {
                                                                                StaticMethod.showToast("上传失败" + response.getCode(), self);
                                                                            }
                                                                        } catch (Exception e) {
                                                                            e.printStackTrace();
                                                                        }
                                                                    }

                                                                    @Override
                                                                    public void onError(Throwable throwable, boolean b) {

                                                                    }

                                                                    @Override
                                                                    public void onCancelled(CancelledException e) {

                                                                    }

                                                                    @Override
                                                                    public void onFinished() {

                                                                    }
                                                                });


                                                            } catch (JSONException e) {
                                                                e.printStackTrace();
                                                            }
                                                            //qiniuBean.setFileType();

                                                        } else {
                                                            Log.i("qiniu", "Upload Fail");
                                                            //如果失败，这里可以把info信息上报自己的服务器，便于后面分析上传错误原因
                                                        }
                                                        Log.i("qiniu", key + ",\r\n " + info + ",\r\n " + res);
                                                    }
                                                }, null);
                                    } else {
                                        StaticMethod.showToast("request uptoken 失败" + response.getCode(), self);
                                    }
                                }

                                @Override
                                public void onError(Throwable ex, boolean isOnCallback) {

                                }

                                @Override
                                public void onCancelled(CancelledException cex) {

                                }

                                @Override
                                public void onFinished() {

                                }
                            });

                        } catch (Throwable throwable) {
                            throwable.printStackTrace();
                        }
                    }
                });
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        Log.i(logTag, "xxx---------------->edit nickname return:");
        if (resultCode == RESULT_OK) {
            if (requestCode == REQ_GET_NAME_EDIT) {
                String s = data.getStringExtra(EditNicknameActivity.EXTRA_NICKNAME);
                nameTV.setText(s);
                App.userInfo.setUsername(s);
                LocalBroadcastManager.getInstance(self).sendBroadcast(new Intent(StaticVar.BROADCAST_ACTION_USER_CHANGE));
            }
        }
    }
}
