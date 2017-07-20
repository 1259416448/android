package arvix.cn.ontheway.ui;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;

/**
 * Created by yd on 2017/7/18.
 */

public class BaseActivity extends Activity {
    protected BaseActivity self;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        self = this;
    }

}
