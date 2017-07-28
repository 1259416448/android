package arvix.cn.ontheway.ui.track;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

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

import org.xutils.common.Callback;
import org.xutils.image.ImageOptions;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.List;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.BaiduActivity;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.been.TrackBean;
import arvix.cn.ontheway.data.TrackListData;
import arvix.cn.ontheway.service.BaiduLocationListenerService;
import arvix.cn.ontheway.service.inter.BaiduPoiServiceInterface;
import arvix.cn.ontheway.service.inter.CacheInterface;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.ar.ArTrackActivity;
import arvix.cn.ontheway.ui.view.BottomDialog;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;

/**
 * Created by asdtiang on 2017/7/28 0028.
 * asdtiangxia@163.com
 */

public class TrackMapActivity extends BaseActivity  implements BaiduMap.OnMarkerClickListener{

    @ViewInject(R.id.time_btn_line)
    private View timeLine;
    @ViewInject(R.id.range_btn_line)
    private View rangeLine;
    @ViewInject(R.id.time_btn)
    private Button timeButton;
    @ViewInject(R.id.range_btn)
    private Button rangeButton;
    @ViewInject(R.id.to_track_list_btn)
    private Button toTrackListBtn;
    @ViewInject(R.id.to_ar_btn)
    private Button toArBtn;

    @ViewInject(R.id.to_map_btn)
    private Button toMapBtn;
    private TrackBean currentClickedTrack;
    private View headerClickedView;
    private HeaderClickedViewHolder headerClickedViewHolder;
    private BottomDialog bottomDialog;

    private static String logTag =  TrackMapActivity.class.getName();
    public static MapView mMapView = null;
    public static BaiduMap mBaiduMap = null;
    LocalBroadcastManager mLocalBroadcastManager;
    BroadcastReceiver mReceiver;
    private String searchKeyWord;

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
                    Toast.makeText(TrackMapActivity.this, "未找到结果",
                            Toast.LENGTH_LONG).show();
                    return;
                }
                //获取POI检索结果
                List<PoiInfo> allAddr = poiResult.getAllPoi();
                for (final PoiInfo p: allAddr) {
                    Log.i("MainActivity", "p.name--->" + p.name +"p.phoneNum" + p.phoneNum +" -->p.address:" + p.address + "p.location" + p.location);
                    final View view = LayoutInflater.from(getApplicationContext()).inflate(R.layout.custom_marker, null);
                    final ImageView headerIVTemp=  (ImageView)view.findViewById(R.id.header_img);
                    /**
                     * 通过ImageOptions.Builder().set方法设置图片的属性
                     */
                    ImageOptions options = new ImageOptions.Builder().
                            setCircular(true)//设置圆形
                            .build();
                    final TrackBean trackBean =  TrackListData.genData(7,8,5,4);
                    /**
                     * 加载图片bind方法
                     */
                    x.image().bind(headerIVTemp,trackBean.getUserHeaderUrl(), options ,new Callback.CommonCallback<Drawable>() {
                        @Override
                        public void onSuccess(Drawable result) {
                        }
                        @Override
                        public void onError(Throwable ex, boolean isOnCallback) {
                        }
                        @Override
                        public void onCancelled(CancelledException cex) {
                        }
                        @Override
                        public void onFinished() {
                            LatLng latLng = new LatLng(p.location.latitude,p.location.longitude);
                            headerIVTemp.setDrawingCacheEnabled(true);
                            BitmapDescriptor markerIcon = BitmapDescriptorFactory.fromBitmap(getViewBitmap(view));
                            Bundle bundle = new Bundle();
                            bundle.putSerializable(StaticVar.EXTRA_TRACK_BEAN,trackBean);
                            OverlayOptions oo = new MarkerOptions().position(latLng).icon(markerIcon).zIndex(9).draggable(true).extraInfo(bundle);
                            mBaiduMap.addOverlay(oo);
                            headerIVTemp.setDrawingCacheEnabled(false);
                            view.setDrawingCacheEnabled(false);
                        }
                    });
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

    protected  void OnTouchEvent(){

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
        setContentView(R.layout.activity_track_map);
        x.view().inject(this);
        searchKeyWord = getIntent().getStringExtra(BaiduActivity.EXTRA_KEYWORD);
        //获取地图控件引用
        mMapView = (MapView) findViewById(R.id.bmapView);
        mBaiduMap = mMapView.getMap();
        mBaiduMap.setOnMarkerClickListener(this);
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

        rangeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(rangeLine.getVisibility() == View.VISIBLE){
                    rangeLine.setVisibility(View.INVISIBLE);
                }else{
                    rangeLine.setVisibility(View.VISIBLE);
                }
            }
        });

        timeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(timeLine.getVisibility() == View.VISIBLE){
                    timeLine.setVisibility(View.INVISIBLE);
                }else{
                    timeLine.setVisibility(View.VISIBLE);
                }
            }
        });


        toTrackListBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(self, TrackListActivity.class);
                startActivity(intent);
            }
        });

        toMapBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(self, TrackMapActivity.class);
                startActivity(intent);
            }
        });

        toArBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(self, ArTrackActivity.class);
                startActivity(intent);
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

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        boolean value = super.onTouchEvent(event);

        return value;
    }
    @Override
    public boolean onMarkerClick(Marker marker) {
        Bundle bundle = marker.getExtraInfo();
        currentClickedTrack = (TrackBean) bundle.getSerializable(StaticVar.EXTRA_TRACK_BEAN);
        Log.i(logTag,"user header--->"+currentClickedTrack.getUserHeaderUrl());
        if (headerClickedView == null) {
            bottomDialog = new BottomDialog(self);
            headerClickedView = LayoutInflater.from(getApplicationContext()).inflate(R.layout.track_map_header_click, null);
            headerClickedViewHolder = new HeaderClickedViewHolder();
            x.view().inject(headerClickedViewHolder, headerClickedView);
            headerClickedView.setTag(headerClickedViewHolder);
            headerClickedView.findViewById(R.id.track_map_show_line).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Log.i(logTag,"view clicked");
                }
            });
            bottomDialog.getView().setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    bottomDialog.dismiss();
                }
            });

        } else {
            headerClickedViewHolder = (HeaderClickedViewHolder) headerClickedView.getTag();
        }
        headerClickedViewHolder.headerIv.setDrawingCacheEnabled(false);
        StaticMethod.setCircularHeaderImg(currentClickedTrack.getUserHeaderUrl(),headerClickedViewHolder.headerIv,headerClickedViewHolder.headerIv.getWidth(),headerClickedViewHolder.headerIv.getHeight());
        headerClickedViewHolder.nicknameTv.setText(currentClickedTrack.getNickname());
        headerClickedViewHolder.addressTv.setText(currentClickedTrack.getAddress());
        headerClickedViewHolder.timeTv.setText(currentClickedTrack.getDateCreated()+"");
        headerClickedViewHolder.contentTv.setText(StaticMethod.genLesStr(currentClickedTrack.getContent(),30));
        headerClickedViewHolder.imageOne.setVisibility(View.GONE);
        headerClickedViewHolder.imageOne.setDrawingCacheEnabled(false);
        headerClickedViewHolder.imageTwo.setVisibility(View.GONE);
        headerClickedViewHolder.imageThree.setVisibility(View.GONE);
        if(!currentClickedTrack.getPhotoList().isEmpty()){
            for(int i=0;i<3||i<currentClickedTrack.getPhotoList().size();i++){
                if(i==0){
                    StaticMethod.setImg(currentClickedTrack.getPhotoList().get(i),headerClickedViewHolder.imageOne,headerClickedViewHolder.imageOne.getWidth(),headerClickedViewHolder.imageOne.getHeight());
                    headerClickedViewHolder.imageOne.setVisibility(View.VISIBLE);
                    Log.i(logTag,"photoOne--->"+currentClickedTrack.getPhotoList().get(i));
                }
                if(i==1){
                    StaticMethod.setImg(currentClickedTrack.getPhotoList().get(i),headerClickedViewHolder.imageTwo,headerClickedViewHolder.imageTwo.getWidth(),headerClickedViewHolder.imageTwo.getHeight());
                    headerClickedViewHolder.imageTwo.setVisibility(View.VISIBLE);
                    Log.i(logTag,"photoTwo--->"+currentClickedTrack.getPhotoList().get(i));
                }
                if(i==2){
                    StaticMethod.setImg(currentClickedTrack.getPhotoList().get(i),headerClickedViewHolder.imageThree,headerClickedViewHolder.imageThree.getWidth(),headerClickedViewHolder.imageThree.getHeight());
                    headerClickedViewHolder.imageThree.setVisibility(View.VISIBLE);
                    Log.i(logTag,"photoThree--->"+currentClickedTrack.getPhotoList().get(i));
                }
            }
        }
        //从这添加通过LayoutInflater加载的xml布局
        bottomDialog.setCustom(headerClickedView);
        bottomDialog.setCancelable(true);
        bottomDialog.show();
        return true;
    }

    private class HeaderClickedViewHolder {
        @ViewInject(R.id.nickname_tv)
        TextView nicknameTv;
        @ViewInject(R.id.time_tv)
        TextView timeTv;
        @ViewInject(R.id.content_tv)
        TextView contentTv;
        @ViewInject(R.id.address_tv)
        TextView addressTv;
        @ViewInject(R.id.header_img)
        ImageView headerIv;
        @ViewInject(R.id.image_one)
        ImageView imageOne;
        @ViewInject(R.id.image_two)
        ImageView imageTwo;
        @ViewInject(R.id.image_three)
        ImageView imageThree;
    }

}
