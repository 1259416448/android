package arvix.cn.ontheway;


import android.content.Intent;
import android.graphics.Bitmap;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdate;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.Marker;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.OverlayOptions;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.search.core.PoiInfo;
import com.baidu.mapapi.search.core.SearchResult;
import com.baidu.mapapi.search.poi.OnGetPoiSearchResultListener;
import com.baidu.mapapi.search.poi.PoiDetailResult;
import com.baidu.mapapi.search.poi.PoiIndoorResult;
import com.baidu.mapapi.search.poi.PoiResult;
import com.baidu.mapapi.search.poi.PoiSearch;

import java.util.Iterator;
import java.util.List;

import arvix.cn.ontheway.service.BaiduLocationListenerService;
import arvix.cn.ontheway.service.inter.BaiduPoiServiceInterface;
import arvix.cn.ontheway.service.inter.CacheInterface;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticVar;

/**
 * An example full-screen activity that shows and hides the system UI (i.e.
 * status bar and navigation/system bar) with user interaction.
 */
public class BaiduActivity extends AppCompatActivity {
    public static String EXTRA_KEYWORD = "baiduKeyWord";
    private static String logTag =  BaiduActivity.class.getName();
    public static MapView mMapView = null;
    public static BaiduMap mBaiduMap = null;
    public LocationClient mLocationClient = null;
    public BDLocationListener bdLocationListener = new BaiduLocationListenerService();


    /**
     * 监听Back键按下事件,方法2:
     * 注意:
     * 返回值表示:是否能完全处理该事件
     * 在此处返回false,所以会继续传播该事件.
     * 在具体项目中此处的返回值视情况而定.
     */
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if ((keyCode == KeyEvent.KEYCODE_BACK)) {
            Intent intent = new Intent(this, MainActivity.class);
            startActivity(intent);
            System.out.println("back clicked44444444444444444444");
            Log.i(this.getClass().getName(),"back clicked!!!!!!!!!!!!!");
            return true;
        }else {
            return super.onKeyDown(keyCode, event);
        }

    }



    private void initLocation(){
        LocationClientOption option = new LocationClientOption();
        option.setLocationMode(LocationClientOption.LocationMode.Hight_Accuracy);
        //可选，默认高精度，设置定位模式，高精度，低功耗，仅设备

        option.setCoorType("bd09ll");
        //可选，默认gcj02，设置返回的定位结果坐标系

        int span=3;
        option.setScanSpan(span);


        //可选，默认0，即仅定位一次，设置发起定位请求的间隔需要大于等于1000ms才是有效的

        option.setIsNeedAddress(true);
        //可选，设置是否需要地址信息，默认不需要

        option.setOpenGps(true);
        //可选，默认false,设置是否使用gps

        option.setLocationNotify(true);
        //可选，默认false，设置是否当GPS有效时按照1S/1次频率输出GPS结果

        option.setIsNeedLocationDescribe(true);
        //可选，默认false，设置是否需要位置语义化结果，可以在BDLocation.getLocationDescribe里得到，结果类似于“在北京天安门附近”

        option.setIsNeedLocationPoiList(true);
        //可选，默认false，设置是否需要POI结果，可以在BDLocation.getPoiList里得到

        option.setIgnoreKillProcess(false);
        //可选，默认true，定位SDK内部是一个SERVICE，并放到了独立进程，设置是否在stop的时候杀死这个进程，默认不杀死

        option.SetIgnoreCacheException(false);
        //可选，默认false，设置是否收集CRASH信息，默认收集

        option.setEnableSimulateGps(false);
        //可选，默认false，设置是否需要过滤GPS仿真结果，默认需要

        mLocationClient.setLocOption(option);
    }

    public static void updateLocation(double lat,double lon ){
        // 初始化位置
        // 设定中心点坐标
        LatLng cenpt = new LatLng(lat,lon);
        // 定义地图状态(精确到50米)
        MapStatus mMapStatus = new MapStatus.Builder().target(cenpt).zoom(18).build();
        // 定义MapStatusUpdate对象，以便描述地图状态将要发生的变化
        MapStatusUpdate mMapStatusUpdate = MapStatusUpdateFactory.newMapStatus(mMapStatus);
        // 改变地图状态
        mBaiduMap.setMapStatus(mMapStatusUpdate);
        Log.i(logTag,"init location from cache");
    }



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_baidu);

        String searchKeyWord = getIntent().getStringExtra(BaiduActivity.EXTRA_KEYWORD);
        //获取地图控件引用
        mMapView = (MapView) findViewById(R.id.bmapView);

        mBaiduMap = mMapView.getMap();
        mBaiduMap.setMyLocationEnabled(true);
        mBaiduMap.setMapType(BaiduMap.MAP_TYPE_NORMAL);
        CacheInterface cache = OnthewayApplication.getInstahce(CacheInterface.class);
        Double latCache = cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LAT);
        Double lonCache = 0.0;
        if(latCache!=null){
            lonCache = cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LON);
            updateLocation(latCache, lonCache);
            Log.i(this.getClass().getName(),"init location from cache");
        }
        //获取当前坐标
        mLocationClient = new LocationClient(getApplicationContext());
        initLocation();
        //声明LocationClient类
        mLocationClient.registerLocationListener(bdLocationListener);
        mLocationClient.start();
        BaiduPoiServiceInterface poiService = OnthewayApplication.getInstahce(BaiduPoiServiceInterface.class);
        if(TextUtils.isEmpty(searchKeyWord)){
            searchKeyWord = "美食";
        }
        if(latCache!=null){
            poiService.search(latCache,lonCache,searchKeyWord,1000,new OnGetPoiSearchResultListener(){
                @Override
                public void onGetPoiResult(PoiResult poiResult) {

                    if (poiResult == null
                            || poiResult.error == SearchResult.ERRORNO.RESULT_NOT_FOUND) {// 没有找到检索结果
                        Toast.makeText(BaiduActivity.this, "未找到结果",
                                Toast.LENGTH_LONG).show();
                        return;
                    }
                    //获取POI检索结果
                    List<PoiInfo> allAddr = poiResult.getAllPoi();
                    for (PoiInfo p: allAddr) {
                        Log.d("MainActivity", "p.name--->" + p.name +"p.phoneNum" + p.phoneNum +" -->p.address:" + p.address + "p.location" + p.location);
                        //mBaiduMap.addOverlay()
                        View view = LayoutInflater.from(getApplicationContext()).inflate(R.layout.custom_marker, null);
                        // ImageView img_hotel_image=
                        // (ImageView)view.findViewById(R.id.img_hotel_image);
                        // new
                        // DownloadImageTask(img_hotel_image).execute(hotel.getHotelImageUrl());

                        TextView tv_hotel_price = (TextView) view.findViewById(R.id.tv_hotel_price);
                        tv_hotel_price.setText( p.name );
                        BitmapDescriptor markerIcon = BitmapDescriptorFactory.fromBitmap(getViewBitmap(view));

                        Bundle bundle = new Bundle();
                        bundle.putSerializable("customData", p.phoneNum);
                        OverlayOptions oo = new MarkerOptions().position(p.location).icon(markerIcon).zIndex(9).draggable(true).extraInfo(bundle);
                        mBaiduMap.addOverlay(oo);
                    }
                }

                @Override
                public void onGetPoiDetailResult(PoiDetailResult poiDetailResult) {

                }

                @Override
                public void onGetPoiIndoorResult(PoiIndoorResult poiIndoorResult) {

                }
            });
        }



        mBaiduMap.setOnMarkerClickListener(new BaiduMap.OnMarkerClickListener() {
            public boolean onMarkerClick(final Marker marker) {
                // TO DO

                return true;
            }
        });
        //test cache
//        new CacheDefauleTest(OnthewayApplication.cache).startTest();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        //在activity执行onDestroy时执行mMapView.onDestroy()，实现地图生命周期管理
        if(mMapView!=null){
            mMapView.onDestroy();
        }

    }
    @Override
    protected void onResume() {
        super.onResume();
        //在activity执行onResume时执行mMapView. onResume ()，实现地图生命周期管理
        if(mMapView!=null) {
            mMapView.onResume();
        }
    }
    @Override
    protected void onPause() {
        super.onPause();
        //在activity执行onPause时执行mMapView. onPause ()，实现地图生命周期管理
        if(mMapView!=null) {
            mMapView.onPause();
        }
    }
    private Bitmap getViewBitmap(View addViewContent) {

        addViewContent.setDrawingCacheEnabled(true);

        addViewContent.measure(View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED));
        addViewContent.layout(0, 0, addViewContent.getMeasuredWidth(), addViewContent.getMeasuredHeight());

        addViewContent.buildDrawingCache();
        Bitmap cacheBitmap = addViewContent.getDrawingCache();
        Bitmap bitmap = Bitmap.createBitmap(cacheBitmap);


        return bitmap;
    }



}
