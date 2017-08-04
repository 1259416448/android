package arvix.cn.ontheway;

import android.app.Application;
import android.content.Context;

import com.baidu.mapapi.SDKInitializer;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;
import com.qiniu.android.common.AutoZone;
import com.qiniu.android.common.FixedZone;
import com.qiniu.android.common.Zone;
import com.qiniu.android.storage.Configuration;
import com.qiniu.android.storage.UploadManager;

import org.xutils.http.HttpTask;
import org.xutils.x;

import arvix.cn.ontheway.bean.UserInfo;
import arvix.cn.ontheway.data.UserPreference;
import arvix.cn.ontheway.http.HttpFilterDefaultImpl;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.UIUtils;

/**
 * Created by yd on 2017/7/18.
 */

public class App extends Application {
    public static UserPreference user;
    public static UserInfo userInfo;
    public static App self;
    public static UploadManager qiniuUploadManager;

    @Override
    public  void onCreate() {
        super.onCreate();
        self = App.this;
        SDKInitializer.initialize(self);
        if(UIUtils.isMainProcess(self)){
            user = new UserPreference(self);
            userInfo = new UserInfo();
            userInfo.setName("未登录用户");
            x.Ext.init(this);
            initImageLoader(this);
            // init must after x init
            OnthewayApplication.init();
            x.Ext.setDebug(BuildConfig.DEBUG); // 是否输出debug日志, 开启debug会影响性能.
            //http访问加强，支持filter
            HttpFilterDefaultImpl httpFilterDefault = new HttpFilterDefaultImpl();
            HttpTask.setHttpFilter(httpFilterDefault);

            Configuration config = new Configuration.Builder()
                    .chunkSize(512 * 1024)        // 分片上传时，每片的大小。 默认256K
                    .putThreshhold(1024 * 1024)   // 启用分片上传阀值。默认512K
                    .connectTimeout(10)           // 链接超时。默认10秒
                    .useHttps(true)               // 是否使用https上传域名
                    .responseTimeout(60)          // 服务器响应超时。默认60秒
                    .zone(AutoZone.autoZone)        // 设置区域，指定不同区域的上传域名、备用域名、备用IP。
                    .build();
            // 重用uploadManager。一般地，只需要创建一个uploadManager对象
            qiniuUploadManager = new UploadManager(config);
        }

    }

    public static void signOut(){
        userInfo = new UserInfo();
        userInfo.setName("未登录用户");
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
