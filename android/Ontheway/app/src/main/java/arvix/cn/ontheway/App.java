package arvix.cn.ontheway;

import android.app.Application;
import com.baidu.mapapi.SDKInitializer;
import org.xutils.x;

import arvix.cn.ontheway.data.UserPreference;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.UIUtils;

import static org.xutils.x.isDebug;

/**
 * Created by yd on 2017/7/18.
 */

public class App extends Application {
    public static UserPreference user;
    public static App self;

    @Override
    public  void onCreate() {
        super.onCreate();
        self = App.this;
        SDKInitializer.initialize(self);
        if(UIUtils.isMainProcess(self)){
            user = new UserPreference(self);
            OnthewayApplication.init();
            x.Ext.init(this);
        }

    }
}
