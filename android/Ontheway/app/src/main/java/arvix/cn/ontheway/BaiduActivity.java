package arvix.cn.ontheway;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.support.v4.content.LocalBroadcastManager;
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
import java.util.List;
import arvix.cn.ontheway.service.BaiduLocationListenerService;
import arvix.cn.ontheway.service.inter.BaiduPoiServiceInterface;
import arvix.cn.ontheway.service.inter.CacheInterface;
import arvix.cn.ontheway.ui.MainActivity2;
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
    LocalBroadcastManager mLocalBroadcastManager;
    BroadcastReceiver mReceiver;
    private String searchKeyWord;

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
            Intent intent = new Intent(this, MainActivity2.class);
            startActivity(intent);
            System.out.println("back clicked44444444444444444444");
            Log.i(this.getClass().getName(),"back clicked!!!!!!!!!!!!!");
            return true;
        }else {
            return super.onKeyDown(keyCode, event);
        }

    }



    private void updateLocation(double lat,double lon){
        if(lat==0.0&&lon==0.0){
            Log.w(this.getClass().getName(),"lat and lon is 0.0");
            return;
        }
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
        BaiduPoiServiceInterface poiService = OnthewayApplication.getInstahce(BaiduPoiServiceInterface.class);
        if(TextUtils.isEmpty(searchKeyWord)){
            searchKeyWord = "美食";
        }
        poiService.search(lat,lon,searchKeyWord,1000,new OnGetPoiSearchResultListener(){
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
                    Log.i("MainActivity", "p.name--->" + p.name +"p.phoneNum" + p.phoneNum +" -->p.address:" + p.address + "p.location" + p.location);
                    //mBaiduMap.addOverlay()
                    double diff = 0.0002;
                    for(int i=0;i<5;i++){
                        View view = LayoutInflater.from(getApplicationContext()).inflate(R.layout.custom_marker, null);
                        LatLng latLng = new LatLng(p.location.latitude+diff*i,p.location.longitude+diff*i);
                        // ImageView img_hotel_image=
                        // (ImageView)view.findViewById(R.id.img_hotel_image);
                        // new
                        // DownloadImageTask(img_hotel_image).execute(hotel.getHotelImageUrl());
                        TextView tv_hotel_price = (TextView) view.findViewById(R.id.tv_hotel_price);
                        tv_hotel_price.setText( p.name +i);
                        BitmapDescriptor markerIcon = BitmapDescriptorFactory.fromBitmap(getViewBitmap(view));
                        Bundle bundle = new Bundle();
                        bundle.putSerializable("customData", p.phoneNum);
                        OverlayOptions oo = new MarkerOptions().position(latLng).icon(markerIcon).zIndex(9).draggable(true).extraInfo(bundle);
                        mBaiduMap.addOverlay(oo);
                    }

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



    public  void updateLocation(){
        CacheInterface cache = OnthewayApplication.getInstahce(CacheInterface.class);
        Double latCache = cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LAT);
        Double lonCache = 0.0;
        if(latCache!=null){
            lonCache = cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LON);
            Log.i(this.getClass().getName(),"init location from cache");
            updateLocation(latCache,lonCache);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_baidu);
        searchKeyWord = getIntent().getStringExtra(BaiduActivity.EXTRA_KEYWORD);
        //获取地图控件引用
        mMapView = (MapView) findViewById(R.id.bmapView);

        mBaiduMap = mMapView.getMap();
        mBaiduMap.setMyLocationEnabled(true);
        mBaiduMap.setMapType(BaiduMap.MAP_TYPE_NORMAL);
        updateLocation();
        //register localroadcast
        IntentFilter filter = new IntentFilter();
        filter.addAction(BaiduLocationListenerService.BROADCAST_LOCATION);
        mReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                Log.i(logTag,"receive broadcast-->"+intent.getAction());
                if (intent.getAction().equals(BaiduLocationListenerService.BROADCAST_LOCATION)) {
                    double lat = intent.getDoubleExtra(BaiduLocationListenerService.EXTRA_LAT,0.0);
                    double lon = intent.getDoubleExtra(BaiduLocationListenerService.EXTRA_LON,0.0);
                    updateLocation(lat,lon);
                }
            }
        };
        mLocalBroadcastManager = LocalBroadcastManager.getInstance(App.self);
        mLocalBroadcastManager.registerReceiver(mReceiver, filter);
        mBaiduMap.setOnMarkerClickListener(new BaiduMap.OnMarkerClickListener() {
            public boolean onMarkerClick(final Marker marker) {
                // TODO
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
        mLocalBroadcastManager.unregisterReceiver(mReceiver);
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
