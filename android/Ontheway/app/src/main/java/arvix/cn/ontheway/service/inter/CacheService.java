package arvix.cn.ontheway.service.inter;

/**
 * Created by asdtiang on 2017/7/18 0018.
 */

public interface CacheService {

    /**
     *
     * @param key
     * @param value
     */
    void put(String key,String value);

    void remove(String key);

    /**
     * 经纬度，地址信息没有删除
     */
    void clear();

    /**
     *
     */
    void clearMem();

    /**
     *
     * @param key
    */

    void putObject(String key,Object Value);

    void putObjectMem(String key,Object Value);

    String get(String key);
    Double getDouble(String key);
    Integer getInt(String key);

    <T> T getT(String key,Class<T> t);

    /**
     * get from mem first ,not found ,then get from disk
     * @param key
     * @param t
     * @param <T>
     * @return
     */
    <T> T getTMem(String key,Class<T> t);
}
