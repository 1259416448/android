package arvix.cn.ontheway.ui.usercenter;

import android.os.Bundle;
import android.support.annotation.Nullable;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;

/**
 * Created by asdtiang on 2017/7/27 0027.
 * asdtiangxia@163.com
 */

public class MySetActivity   extends BaseActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile_set);
        HeaderHolder head=new HeaderHolder();
        head.init(self,"设置");
    }

}
