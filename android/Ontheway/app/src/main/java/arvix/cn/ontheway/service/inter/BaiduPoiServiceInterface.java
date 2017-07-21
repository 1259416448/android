package arvix.cn.ontheway.service.inter;

import com.baidu.mapapi.search.poi.OnGetPoiSearchResultListener;

/**
 * Created by asdtiang on 2017/7/19 0019.
 * asdtiangxia@163.com
 */

public interface BaiduPoiServiceInterface {


    void search(double lat,double lon,String keyword, int radius, OnGetPoiSearchResultListener poiListener);
}
