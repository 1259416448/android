package arvix.cn.ontheway;

import android.app.Application;
import android.content.Context;

import com.baidu.mapapi.SDKInitializer;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;

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
        initImageLoader(this);
    }
    public static void initImageLoader(Context context){
        if(!ImageLoader.getInstance().isInited()){
            ImageLoaderConfiguration config = null;
            if(BuildConfig.DEBUG){
                config = new ImageLoaderConfiguration.Builder(context)
						/*.threadPriority(Thread.NORM_PRIORITY - 2)
						.memoryCacheSize((int) (Runtime.getRuntime().maxMemory() / 4))
						.diskCacheSize(500 * 1024 * 1024)
						.writeDebugLogs()
						.diskCacheFileNameGenerator(new Md5FileNameGenerator())
						.tasksProcessingOrder(QueueProcessingType.LIFO).build();*/

                        //.memoryCacheExtraOptions(200, 200)
                        //.diskCacheExtraOptions(200, 200, null).threadPoolSize(3)
                        .threadPriority(Thread.NORM_PRIORITY - 1)
                        .tasksProcessingOrder(QueueProcessingType.LIFO)
                        //.denyCacheImageMultipleSizesInMemory().memoryCache(new LruMemoryCache(2 * 1024 * 1024))
						/*.memoryCacheSize(20 * 1024 * 1024)*/
                        .memoryCacheSizePercentage(13)
                        .diskCacheSize(500 * 1024 * 1024)
                        //.imageDownloader(new BaseImageDownloader(A3App.getInstance().getApplicationContext()))
                        //.imageDecoder(new BaseImageDecoder(true))
                        //.defaultDisplayImageOptions(DisplayImageOptions.createSimple())
                        //.writeDebugLogs()
                        .build();
            }else{
                config = new ImageLoaderConfiguration.Builder(context)
                        .threadPriority(Thread.NORM_PRIORITY - 2)
                        .diskCacheSize(500 * 1024 * 1024)
                        .diskCacheFileNameGenerator(new Md5FileNameGenerator())
                        .tasksProcessingOrder(QueueProcessingType.LIFO).build();
            }
            ImageLoader.getInstance().init(config);
        }

    }

}
