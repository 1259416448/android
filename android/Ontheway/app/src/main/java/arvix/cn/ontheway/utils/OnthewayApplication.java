package arvix.cn.ontheway.utils;

import java.util.HashMap;
import java.util.Map;

import arvix.cn.ontheway.service.impl.BaiduPoiServiceImpl;
import arvix.cn.ontheway.service.impl.CacheDefault;
import arvix.cn.ontheway.service.inter.BaiduPoiServiceInterface;
import arvix.cn.ontheway.service.inter.CacheInterface;

/**
 * Created by asdtiang on 2017/7/18 0018.
 * asdtiangxia@163.com
 * 简单的ioc管理
 */

public class OnthewayApplication {
    private static CacheInterface cache;
    private static Map<Class,Object> iocMap = new HashMap<Class, Object>();
    private static boolean initBefore = false;
    public static synchronized void init(){
        if(!initBefore){
            cache = new CacheDefault();
            iocMap.put(CacheInterface.class,cache);
            BaiduPoiServiceInterface poiService = new BaiduPoiServiceImpl();
            iocMap.put(BaiduPoiServiceInterface.class,poiService);
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
