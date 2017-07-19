package arvix.cn.ontheway;

import android.app.Application;

import com.baidu.mapapi.SDKInitializer;

import arvix.cn.ontheway.data.UserPreference;

/**
 * Created by yd on 2017/7/18.
 */

public class App extends Application {
    public static UserPreference user;
    public static App self;

    @Override
    public void onCreate() {
        super.onCreate();
        self = App.this;
        SDKInitializer.initialize(self);
        user = new UserPreference(self);
    }
}
