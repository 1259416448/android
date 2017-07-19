package arvix.cn.ontheway.service.impl;

import android.util.Log;

import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.search.poi.OnGetPoiSearchResultListener;
import com.baidu.mapapi.search.poi.PoiNearbySearchOption;
import com.baidu.mapapi.search.poi.PoiSearch;

import arvix.cn.ontheway.service.inter.BaiduPoiServiceInterface;

/**
 * Created by asdtiang on 2017/7/19 0019.
 * asdtiangxia@163.com
 */

public class BaiduPoiServiceImpl implements BaiduPoiServiceInterface {
    private static String logTag = BaiduPoiServiceImpl.class.getName();


    @Override
    public void search(double lat,double lon,String keyword, int radius, OnGetPoiSearchResultListener poiListener) {
        PoiSearch poiSearch = PoiSearch.newInstance();
        poiSearch.setOnGetPoiSearchResultListener(poiListener);
        LatLng mLocation = new LatLng(lat,lon);
        poiSearch.searchNearby(new PoiNearbySearchOption().keyword(keyword).radius(radius).location(mLocation).pageNum(1).pageCapacity(15));
        Log.i(logTag,"search start----->");
    }
}
