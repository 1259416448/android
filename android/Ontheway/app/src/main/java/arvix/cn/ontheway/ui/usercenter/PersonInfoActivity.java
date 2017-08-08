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
import com.alibaba.fastjson.util.TypeUtils;
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
import arvix.cn.ontheway.service.inter.FileUploadCallBack;
import arvix.cn.ontheway.service.inter.FileUploadService;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;
import arvix.cn.ontheway.utils.OnthewayApplication;
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

    FileUploadService fileUploadService;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_person_info);
        fileUploadService = OnthewayApplication.getInstahce(FileUploadService.class);
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
                        byte[] data = StaticMethod.bitmap2Bytes(bmp);
                        Log.i(logTag, "=====onImageCropComplete (get bitmap=" + bmp.toString());
                        fileUploadService.upload(self,data,ServerUrl.UPDATE_HEADER,new FileUploadCallBack(){
                            @Override
                            public void uploadBack(BaseResponse baseResponse) {
                                if (baseResponse.getCode() == StaticVar.SUCCESS) {
                                    UserInfo userInfo = TypeUtils.castToJavaBean(baseResponse.getBody(), UserInfo.class);
                                    StaticMethod.updateUserInfo(self,userInfo);
                                    StaticMethod.setCircularHeaderImg(headerIV,110,110);
                                } else {
                                    StaticMethod.showToast("上传失败" + baseResponse.getCode(), self);
                                }
                            }
                        });
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
