package arvix.cn.ontheway.service.impl;

import android.util.Log;

import com.alibaba.fastjson.JSON;

import org.xutils.cache.DiskCacheEntity;
import org.xutils.cache.LruDiskCache;
import org.xutils.config.DbConfigs;
import org.xutils.ex.DbException;
import org.xutils.x;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import arvix.cn.ontheway.service.inter.CacheService;
import arvix.cn.ontheway.utils.StaticVar;

/**
 * Created by asdtiang on 2017/7/18 0018.
 * asdtiangxia@163.com
 * 采用xutils
 */

public class CacheDefault implements CacheService {
    private static String logTag = CacheDefault.class.getName();
    private static Map<String,Object> cacheMap = new ConcurrentHashMap<>();
    private static String cacheName = "onthewayCache";

    private static LruDiskCache diskCache = null;

    private synchronized LruDiskCache getLruDiskCache(){
        if(diskCache==null){
            diskCache = LruDiskCache.getDiskCache(cacheName);
        }
        return diskCache;
    }

    /**
     * @param key
     * @param value
     */
    @Override
    public void put(String key, String value) {
        if(key!=null&&value!=null){
            DiskCacheEntity entity = this.getLruDiskCache().get(key);
            if(entity ==null){
                entity =  new DiskCacheEntity();
                entity.setHits(-1);
                entity.setId(key.hashCode());
            }
            entity.setKey(key);
            entity.setTextContent(value);
            entity.setExpires(Long.MAX_VALUE);
            entity.setLastAccess(System.currentTimeMillis());
            entity.setHits(entity.getHits()+1);
            getLruDiskCache().put(entity);
        }else{
            Log.w(logTag,"key or value is null,key:"+key+"  value:"+value);
        }

    }

    /**
     * @param key

     */
    @Override
    public void putObject(String key, Object value) {
        put(key, JSON.toJSONString(value));
    }

    @Override
    public void putObjectMem(String key, Object Value) {
        cacheMap.put(key,Value);
    }


    @Override
    public <T> T getT(String key, Class<T> t) {
        T result = null;
        DiskCacheEntity entity = this.getLruDiskCache().get(key);
        if(entity!=null){
            if(entity.getTextContent()!=null){
               // Log.w(logTag,"entity.getTextContent():"+entity.getTextContent());
                result = JSON.parseObject(entity.getTextContent(),t);
            }
        }
        return result;
    }

    @Override
    public <T> T getTMem(String key, Class<T> t) {
        T result = null;
        if(key!=null){
            Object entity = cacheMap.get(key);
            if(entity!=null){
                Log.w(logTag,"entity.getTextContent():");
                result = (T)entity;
            }else{
                result  = getT(key,t);
            }
        }
        return result;
    }

    public  void remove(String key){
        DiskCacheEntity entity = this.getLruDiskCache().get(key);
        if(entity!=null){
            try {
                x.getDb(DbConfigs.HTTP.getConfig()).deleteById(DiskCacheEntity.class,key.hashCode());
            } catch (DbException e) {
                e.printStackTrace();
            }
        }
        if(key!=null){
            cacheMap.remove(key);
        }
    }

    @Override
    public void clear() {
        String address =  get(StaticVar.BAIDU_LOC_CACHE_ADDRESS);
        Double latCache = getDouble(StaticVar.BAIDU_LOC_CACHE_LAT);
        Double lonCache = 0.0;
        if(latCache!=null){
            lonCache = getDouble(StaticVar.BAIDU_LOC_CACHE_LON);
        }
        this.getLruDiskCache().clearCacheFiles();
        try {
            x.getDb(DbConfigs.HTTP.getConfig()).dropDb();
            if(address!=null){
                put(StaticVar.BAIDU_LOC_CACHE_ADDRESS,address);
            }
            if(latCache!=null){
                put(StaticVar.BAIDU_LOC_CACHE_LAT,latCache+"");
            }
            if(lonCache!=0.0){
                put(StaticVar.BAIDU_LOC_CACHE_LON,lonCache+"");
            }
        } catch (DbException e) {
            e.printStackTrace();
        }
        cacheMap.clear();
    }

    @Override
    public String get(String key) {
        String result = null;
        DiskCacheEntity entity = this.getLruDiskCache().get(key);
        if(entity!=null){
            result = entity.getTextContent();
        }
        return result;
    }

    @Override
    public Double getDouble(String key) {
        String result = get(key);
        if(result==null){
            return null;
        }else{
            return Double.parseDouble(result);
        }

    }

    @Override
    public Integer getInt(String key) {
        String result = get(key);
        if(result==null){
            return null;
        }else{
            return Integer.parseInt(result);
        }
    }
}
