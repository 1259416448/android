package arvix.cn.ontheway.service.impl;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Created by asdtiang on 2017/8/22 0022.
 * asdtiangxia@163.com
 */

public class ArFootPrintCacheMemoryService {
    private static  String logTag = ArFootPrintCacheMemoryService.class.getName();
    private static Map<String,Object> cacheMap = new ConcurrentHashMap<>();
    /**
     * @param key
     * @param value
     */

    public void put(String key, String value) {
        cacheMap.put(key,value);
    }


    public void remove(String key) {
        if(null!=key){
            cacheMap.remove(key);
        }
    }

    /**
     *
     */

    public void clear() {
        cacheMap.clear();
    }

    /**
     * @param key
     * @param value
     */

    public void putObject(String key, Object value) {
        if(key!=null){
            cacheMap.put(key,value);
        }
    }


    public <T> T getT(String key, Class<T> t) {
        T result = null;
        if(key!=null){
            Object entity = cacheMap.get(key);
            if(entity!=null){
                result = (T)entity;
            }
        }
        return result;
    }
}
