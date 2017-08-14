package arvix.cn.ontheway.utils;

import android.util.Log;

import java.util.HashMap;
import java.util.Map;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.bean.UserInfo;
import arvix.cn.ontheway.service.impl.BaiduPoiServiceImpl;
import arvix.cn.ontheway.service.impl.BaiduServiceImpl;
import arvix.cn.ontheway.service.impl.CacheDefault;
import arvix.cn.ontheway.service.impl.ImageFileUploadServiceImpl;
import arvix.cn.ontheway.service.impl.FootPrintSearchServiceImpl;
import arvix.cn.ontheway.service.inter.BaiduPoiService;
import arvix.cn.ontheway.service.inter.BaiduService;
import arvix.cn.ontheway.service.inter.CacheService;
import arvix.cn.ontheway.service.inter.ImageFileUploadService;
import arvix.cn.ontheway.service.inter.FootPrintSearchService;

/**
 * Created by asdtiang on 2017/7/18 0018.
 * asdtiangxia@163.com
 * 简单的ioc管理
 */

public class OnthewayApplication {
    private static CacheService cache;
    private static Map<Class,Object> iocMap = new HashMap<Class, Object>();
    private static boolean initBefore = false;

    /**
     * must init after xutils
     */
    public static synchronized void init(){
        if(!initBefore){
            cache = new CacheDefault();
            cache.get(StaticVar.AUTH_TOKEN);
            UserInfo userInfo = cache.getT(StaticVar.USER_INFO,UserInfo.class);
            if(userInfo!=null){
                App.userInfo = userInfo;
            }
            iocMap.put(CacheService.class,cache);
            BaiduPoiService poiService = new BaiduPoiServiceImpl();
            iocMap.put(BaiduPoiService.class,poiService);
            BaiduService baiduService = new BaiduServiceImpl();
            //开始定位
            baiduService.initLocation();
            iocMap.put(BaiduService.class,baiduService);

            ImageFileUploadService fileUploadService = new ImageFileUploadServiceImpl();
            iocMap.put(ImageFileUploadService.class,fileUploadService);

            FootPrintSearchService footPrintSearchService = new FootPrintSearchServiceImpl();
            iocMap.put(FootPrintSearchService.class, footPrintSearchService);

            Log.i("App","app init finish--------------------------------->");
        }
        initBefore = true;
    }
    public static  <T> T getInstahce(Class<T> tClass){
        Object object = iocMap.get(tClass);
        T result = null;
        if(object!=null){
            result = (T) object;
        }
        return result;
    }


}
