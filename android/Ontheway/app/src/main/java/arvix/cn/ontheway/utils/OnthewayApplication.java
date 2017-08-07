package arvix.cn.ontheway.utils;

import java.util.HashMap;
import java.util.Map;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.bean.UserInfo;
import arvix.cn.ontheway.service.impl.BaiduPoiServiceImpl;
import arvix.cn.ontheway.service.impl.BaiduServiceImpl;
import arvix.cn.ontheway.service.impl.CacheDefault;
import arvix.cn.ontheway.service.impl.FileUploadServiceImpl;
import arvix.cn.ontheway.service.inter.BaiduPoiService;
import arvix.cn.ontheway.service.inter.BaiduService;
import arvix.cn.ontheway.service.inter.CacheService;
import arvix.cn.ontheway.service.inter.FileUploadService;

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
            UserInfo userInfo = cache.getT(StaticVar.USER_INFO,UserInfo.class);
            if(userInfo!=null){
                App.userInfo = userInfo;
            }
            iocMap.put(CacheService.class,cache);
            BaiduPoiService poiService = new BaiduPoiServiceImpl();
            iocMap.put(BaiduPoiService.class,poiService);
            BaiduService baiduService = new BaiduServiceImpl();
            baiduService.initLocation();
            iocMap.put(BaiduService.class,baiduService);

            FileUploadService fileUploadService = new FileUploadServiceImpl();
            iocMap.put(FileUploadService.class,fileUploadService);
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
