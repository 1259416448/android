package arvix.cn.ontheway.ui;

import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.TextWatcher;
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
    @ViewInject(R.id.error_info_line)
    private LinearLayout errorInfoLine;
    @ViewInject(R.id.error_tv)
    private TextView errorTv;
    @ViewInject(R.id.check_code_tv_icon)
    private TextView checkCodeTvIcon;
    CacheService cache;
    private Handler mainHandler;
    private final int sumSeconds = 60;
    private int currentCountSec = sumSeconds;
    private final int endCountTag = -1;
    private boolean phoneOk = false;
    private boolean smsOk = false;
    private boolean sendSmsClick = false;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        UIUtils.setBarStyle(self);
        x.view().inject(self);
        cache = OnthewayApplication.getInstahce(CacheService.class);
        initView();
    }

    private void initView() {
        sendSmsTv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String phone = phoneEt.getText().toString();
                errorInfoLine.setVisibility(View.GONE);
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
                            loginBtnCheckClick();
                            sendSmsClick = true;
                            sendSmsTv.setEnabled(false);
                            sendSmsTv.setTextColor(Color.parseColor("#C4C4C4"));
                            if(currentCountSec==sumSeconds){//启动倒计时
                                new Thread(new Runnable() {
                                    @Override
                                    public void run() {
                                        while(currentCountSec>0){
                                            mainHandler.sendEmptyMessage(currentCountSec--);
                                            try {
                                                Thread.sleep(1000);
                                            } catch (InterruptedException e) {
                                                e.printStackTrace();
                                            }
                                        }
                                        currentCountSec = sumSeconds;
                                        mainHandler.sendEmptyMessage(endCountTag);
                                    }
                                }).start();
                            }
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
                                    phoneLine.setBackgroundResource(R.drawable.login_text_boder);
                                    errorTv.setText(response.getMessage());
                                    errorInfoLine.setVisibility(View.VISIBLE);
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
        phoneEt.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                if(CheckUtils.checkPhone(s.toString())){
                    phoneLine.setBackgroundResource(R.drawable.login_text_boder_focused);
                    phoneTvIcon.setCompoundDrawablesWithIntrinsicBounds (getResources().getDrawable(R.drawable.dl_shouji_click),null,null,null);
                    phoneOk = true;
                }else{
                    phoneOk = false;
                    phoneLine.setBackgroundResource(R.drawable.login_text_boder);
                    phoneTvIcon.setCompoundDrawablesWithIntrinsicBounds (getResources().getDrawable(R.drawable.dl_shouji),null,null,null);
                }
                loginBtnCheckClick();
                errorInfoLine.setVisibility(View.GONE);
            }
        });
        checkCodeEt.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                if(CheckUtils.checkSmsCode(s.toString())){
                    smsOk = true;
                    checkCodeLine.setBackgroundResource(R.drawable.login_text_boder_focused);
                    checkCodeTvIcon.setCompoundDrawablesWithIntrinsicBounds (getResources().getDrawable(R.drawable.dl_yanzhengma_click),null,null,null);
                }else{
                    smsOk = false;
                    checkCodeLine.setBackgroundResource(R.drawable.login_text_boder);
                    checkCodeTvIcon.setCompoundDrawablesWithIntrinsicBounds (getResources().getDrawable(R.drawable.dl_yanzhengma),null,null,null);
                }
                loginBtnCheckClick();
                errorInfoLine.setVisibility(View.GONE);
            }
        });

        //主线程的 handler 接收到 子线程的消息，然后修改TextView的显示
        mainHandler=new Handler(){
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);
                sendSmsTv.setText("已发送("+currentCountSec+"s)");
                if(msg.what == endCountTag){
                    sendSmsTv.setEnabled(true);
                    sendSmsTv.setTextColor(Color.parseColor("#E50834"));
                    sendSmsTv.setText("获取验证码");
                }
            }
        };
    }

    private void loginBtnCheckClick(){
        if(phoneOk && smsOk && sendSmsClick){
            loginBtnLine.setBackgroundResource(R.drawable.dl_button);
            loginBtn.setBackgroundResource(R.drawable.login_btn_click);
        }else{
            loginBtnLine.setBackground(null);
            loginBtn.setBackgroundResource(R.drawable.login_btn);
        }
    }

}
