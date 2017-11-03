package arvix.cn.ontheway.ui.usercenter;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import org.xutils.x;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;

public class MyCollectionActivity extends BaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_my_collection);
        x.view().inject(self);
        HeaderHolder head=new HeaderHolder();
        head.init(self,"我的收藏");
    }
}
