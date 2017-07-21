package arvix.cn.ontheway.ui.usercenter;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.content.LocalBroadcastManager;
import android.view.View;
import android.widget.TextView;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.Random;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.EditTextActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;

/**
 * Created by asdtiang on 2017/7/21 0021.
 * asdtiangxia@163.com
 */

public class PersonInfoActivity extends BaseActivity {
    public static String ACTION_USER_CHANGE="user.change";

    @ViewInject(R.id.nameTv)
    private TextView nameTV;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_person_info);
        initView();
    }
    int REQ_GET_NAME_EDIT=new Random().nextInt();
    private void initView(){
        x.view().inject(this);
        new HeaderHolder().init(self,"个人信息");
        nameTV.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent=new Intent(self,EditTextActivity.class);
                intent.putExtra("hint","请输入姓名");
                intent.putExtra("default", App.user.getString("nickname",""));
                startActivityForResult(intent,REQ_GET_NAME_EDIT);
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(resultCode==RESULT_OK){
            if(requestCode==REQ_GET_NAME_EDIT){
                String s=data.getStringExtra("data");
                nameTV.setText(s);
                System.out.println("xxx:"+s);
                //// TODO: 2017/7/21 0021
                App.user.setString("nickname",s);
                LocalBroadcastManager.getInstance(self).sendBroadcast(new Intent(ACTION_USER_CHANGE));
            }
        }
    }
}
