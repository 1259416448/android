package arvix.cn.ontheway.ui;

import android.content.Intent;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;

import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.HashMap;
import java.util.Map;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.BaseResponse;
import arvix.cn.ontheway.bean.UserInfo;
import arvix.cn.ontheway.check.CheckUtils;
import arvix.cn.ontheway.http.ServerUrl;
import arvix.cn.ontheway.service.inter.CacheService;
import arvix.cn.ontheway.ui.view.BottomDialog;
import arvix.cn.ontheway.utils.HmacSHA256Utils;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;
import arvix.cn.ontheway.utils.UIUtils;

/**
 * Created by asdtiang on 2017/8/3 0003.
 * asdtiangxia@163.com
 */

public class LoginActivity  extends BaseActivity  {

    @ViewInject(R.id.phone_et)
    private EditText phoneEt;
    @ViewInject(R.id.check_code_et)
    private EditText checkCodeEt;
    @ViewInject(R.id.send_sms_tv)
    private TextView sendSmsTv;
    @ViewInject(R.id.login_btn)
    private Button loginBtn;
    @ViewInject(R.id.phone_line)
    private LinearLayout phoneLine;
    @ViewInject(R.id.check_code_line)
    private LinearLayout checkCodeLine;
    @ViewInject(R.id.login_btn_line)
    private LinearLayout loginBtnLine;


    @ViewInject(R.id.phone_tv_icon)
    private TextView phoneTvIcon;
    @ViewInject(R.id.check_code_tv_icon)
    private TextView checkCodeTvIcon;
    CacheService cache;
    private BottomDialog bottomDialog;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        UIUtils.setBarStyle(self);
        x.view().inject(self);
        cache = OnthewayApplication.getInstahce(CacheService.class);
        initView();
        initUi();
    }


    private void initView() {
        sendSmsTv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String phone = phoneEt.getText().toString();
                Log.i("","------------------------------------>"+phone);
                if(CheckUtils.checkPhone(getApplicationContext(),phone)){
                    String digest = HmacSHA256Utils.digest(StaticVar.SALT_KEY,"mobile:"+phone);
                    RequestParams requestParams = new RequestParams();
                    requestParams.setUri(ServerUrl.SEND_SMS + "/" +phone);
                    requestParams.addQueryStringParameter("digest",digest);
                    Log.i("","request------------------------------->"+phone+" digest: " + digest);
                    x.http().get(requestParams, new Callback.CommonCallback<String>() {
                        @Override
                        public void onSuccess(String o) {
                            Log.i("o",o.toString());
                            Toast toast = Toast.makeText(getApplicationContext(),
                                    "验证码发送成功", Toast.LENGTH_LONG);
                            loginBtnLine.setBackgroundResource(R.drawable.dl_button);
                            loginBtn.setBackgroundResource(R.drawable.login_btn_click);
                            toast.setGravity(Gravity.CENTER, 0, 0);
                            toast.show();
                        }

                        @Override
                        public void onError(Throwable throwable, boolean b) {
                            Log.e("error","request error", throwable);
                        }

                        @Override
                        public void onCancelled(CancelledException e) {
                            e.printStackTrace();
                            Log.w("onCancelled","request onCancelled");
                        }

                        @Override
                        public void onFinished() {
                            Log.i("onFinished","request onFinished" );
                        }
                    });
                }
            }

        });

        loginBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String phone = phoneEt.getText().toString();
                if(CheckUtils.checkPhone(getApplicationContext(),phone)){
                    RequestParams requestParams = new RequestParams();
                    requestParams.setUri( ServerUrl.SIGN_IN_SMS);
                    Map<String,Object> parMap = new HashMap<>();
                    parMap.put("password",checkCodeEt.getText().toString());
                    parMap.put("rememberMe",true);
                    parMap.put("username",phone);
                    requestParams.setBodyContent(JSON.toJSONString(parMap));
                    x.http().post(requestParams, new Callback.CommonCallback<String>() {
                        @Override
                        public void onSuccess(String result) {
                            try {
                                Log.i("onSuccess-->","result->"+result.toString());
                                BaseResponse<UserInfo> response = StaticMethod.genResponse(result,UserInfo.class);
                                Intent data=new Intent();
                                if(response.getCode()==StaticVar.SUCCESS) {
                                    UserInfo userInfo = response.getBodyBean();
                                    StaticMethod.updateUserInfo(self,userInfo);
                                    Log.i("response thread ","----------------->"+Thread.currentThread().getName());
                                    StaticMethod.showToast("登录成功",self);
                                    setResult(RESULT_OK, data);
                                    finish();
                                }else if(response.getCode() == StaticVar.ERROR){
                                    StaticMethod.showToast("登录失败",self);
                                }else{
                                    StaticMethod.showToast("登录失败" + response.getCode(),self);
                                    finish();
                                }
                            }catch (Exception e){
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
                }
            }
            });

        // fxBtn.setOnClickListener(this);
    }

    private void initUi(){
        phoneEt.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                if(hasFocus){
                    Log.i(logTag,"phoneLine------------------>hasFocus");
                    phoneLine.setBackgroundResource(R.drawable.login_text_boder_focused);
                    phoneTvIcon.setCompoundDrawablesWithIntrinsicBounds (getResources().getDrawable(R.drawable.dl_shouji_click),null,null,null);
                }else{
                    phoneLine.setBackgroundResource(R.drawable.login_text_boder);
                    phoneTvIcon.setCompoundDrawablesWithIntrinsicBounds (getResources().getDrawable(R.drawable.dl_shouji),null,null,null);
                }
            }
        });
        checkCodeEt.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                if(hasFocus){
                    checkCodeLine.setBackgroundResource(R.drawable.login_text_boder_focused);
                    checkCodeTvIcon.setCompoundDrawablesWithIntrinsicBounds (getResources().getDrawable(R.drawable.dl_yanzhengma_click),null,null,null);
                }else{
                    checkCodeLine.setBackgroundResource(R.drawable.login_text_boder);
                    checkCodeTvIcon.setCompoundDrawablesWithIntrinsicBounds (getResources().getDrawable(R.drawable.dl_yanzhengma),null,null,null);
                }
            }
        });
    }


}
