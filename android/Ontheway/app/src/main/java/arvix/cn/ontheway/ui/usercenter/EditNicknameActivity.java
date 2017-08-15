package arvix.cn.ontheway.ui.usercenter;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.EditText;

import com.alibaba.fastjson.JSON;

import org.xutils.http.HttpMethod;
import org.xutils.http.RequestParams;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.HashMap;
import java.util.Map;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.BaseResponse;
import arvix.cn.ontheway.http.ServerUrl;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;
import arvix.cn.ontheway.utils.MyProgressDialog;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;
import arvix.cn.ontheway.utils.Windows;

/**
 * Created by asdtiang on 2017/7/21 0021.
 * asdtiangxia@163.com
 */

public class EditNicknameActivity extends BaseActivity {
    public static String EXTRA_NICKNAME = "nickname";
    @ViewInject(R.id.edit_et)
    private EditText editEt;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.edit_nickname);
        x.view().inject(this);
        String nickname = this.getIntent().getStringExtra(EXTRA_NICKNAME);
        editEt.setText(nickname);
        editEt.setSelection(editEt.getText().length());
        HeaderHolder head=new HeaderHolder();
        head.init(self,"修改名称");

        head.setUpRightTextBtn("保存", new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                final MyProgressDialog wait= Windows.waiting(self);
                final String nickname = editEt.getText().toString();
                final Intent data=new Intent();
                if(!TextUtils.isEmpty(nickname)) {
                    RequestParams requestParams = new RequestParams();
                    requestParams.setUri( ServerUrl.USER_UPDATE_NAME);
                    Map<String,Object> parMap = new HashMap<>();
                    parMap.put("name",nickname);
                    requestParams.setBodyContent(JSON.toJSONString(parMap));
                    x.http().post(requestParams, new org.xutils.common.Callback.CommonCallback<String>() {
                        @Override
                        public void onSuccess(String result) {
                            try {
                                BaseResponse response = StaticMethod.genResponse(result);
                                Log.i("onSuccess-->","result->"+result.toString());
                                wait.dismiss();
                                if(response.getCode()==StaticVar.SUCCESS){
                                    StaticMethod.showToast("更新成功",self);
                                    data.putExtra(EXTRA_NICKNAME, nickname);
                                    setResult(RESULT_OK, data);
                                }else{
                                    setResult(RESULT_CANCELED);
                                    StaticMethod.showToast("更新失败",self);
                                }
                                finish();
                            }catch (Exception e){
                                e.printStackTrace();
                                setResult(RESULT_CANCELED);
                                StaticMethod.showToast("更新失败",self);
                                finish();
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


                }else{
                    setResult(RESULT_CANCELED);
                    finish();
                }

            }
        });


    }
}
