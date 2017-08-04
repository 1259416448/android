package arvix.cn.ontheway.utils;

/**
 * Created by asdtiang on 2017/7/18 0018.
 * asdtiangxia@163.com
 */

public interface StaticVar {

    String BAIDU_LOC_CACHE_LAT= "baiduLocCacheLat";
    String BAIDU_LOC_CACHE_LON = "baiduLocCacheLLon";
    String BAIDU_LOC_CACHE_ALT = "baiduLocCacheAlt";
    String HEADER_URL_CACHE_KEY = "headerUrl";

    String EXTRA_TRACK_BEAN = "trackBean";
    String LAST_POIRESULT = "lastPoiResult";

    String AUTH_TOKEN = "x-auth-token";
    String AUTH_REMEMBER_ME = "remember-me";
    String SALT_KEY = "15f30b0eb8804aa09408611bafeb34b5";
    String USER_INFO = "userInfo";


    String BROADCAST_ACTION_USER_CHANGE = "broadcast.user.change";

    int SUCCESS = 0;
    int ERROR = -1;

    int MAX_PHOTO_SELECT = 9;
}
