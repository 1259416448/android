package arvix.cn.ontheway.service.inter;

/**
 * Created by asdtiang on 2017/7/18 0018.
 */

public interface CacheInterface {

    /**
     *
     * @param key
     * @param value
     */
    void put(String key,String value);

    void remove(String key);

    /**
     *
     * @param key


    void putObject(String key,Object Value);
     */
    String get(String key);
    Double getDouble(String key);
    Integer getInt(String key);
/**
    <T> T getT(String key,Class<T> t);
*/
}
