package arvix.cn.ontheway.ui.track;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.PixelFormat;
import android.graphics.Point;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.provider.Settings;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.app.AlertDialog;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
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
import arvix.cn.ontheway.bean.TrackBean;
import arvix.cn.ontheway.data.TrackListData;
import arvix.cn.ontheway.service.BaiduLocationListenerService;
import arvix.cn.ontheway.service.inter.BaiduPoiService;
import arvix.cn.ontheway.service.inter.CacheService;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.ar.ArTrackActivity;
import arvix.cn.ontheway.ui.view.BottomDialog;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;
import arvix.cn.ontheway.utils.UIUtils;

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

        BaiduPoiService poiService = OnthewayApplication.getInstahce(BaiduPoiService.class);
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
                    x.image().bind(headerIVTemp,trackBean.getUserHeadImg(), options ,new Callback.CommonCallback<Drawable>() {
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
                            BitmapDescriptor markerIcon = BitmapDescriptorFactory.fromBitmap(StaticMethod.getViewBitmap(view));
                            Bundle bundle = new Bundle();
                            bundle.putSerializable(StaticVar.EXTRA_TRACK_BEAN,trackBean);
                            OverlayOptions oo = new MarkerOptions().anchor(0.0f,0.5f).position(latLng).icon(markerIcon).zIndex(9).draggable(true).extraInfo(bundle);
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
        CacheService cache = OnthewayApplication.getInstahce(CacheService.class);
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
                    double lat = intent.getDoubleExtra(StaticVar.BAIDU_LOC_CACHE_LAT,0.0);
                    double lon = intent.getDoubleExtra(StaticVar.BAIDU_LOC_CACHE_LON,0.0);
                    updateLocation(lat,lon);
                }
            }
        };
        mLocalBroadcastManager = LocalBroadcastManager.getInstance(App.self);
        mLocalBroadcastManager.registerReceiver(mReceiver, filter);
//        mBaiduMap.setOnMarkerClickListener(new BaiduMap.OnMarkerClickListener() {
//            public boolean onMarkerClick(final Marker marker) {
//                // TODO
//                return true;
//            }
//        });

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

        checkOverlayPermission();

        //test cache
//        new CacheDefauleTest(OnthewayApplication.cache).startTest();
    }

    private void checkOverlayPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!Settings.canDrawOverlays(this)) {
                new AlertDialog.Builder(self).setMessage("请打开悬浮窗权限").setPositiveButton("设置", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                Uri.parse("package:" + getPackageName()));
                        UIUtils.safeOpenLink(self,intent);
                    }
                }).setNegativeButton("取消",null).show();

            }
        }
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
        if(highLightView!=null){
            highLightView.setVisibility(View.VISIBLE);
        }
    }
    @Override
    protected void onPause() {
        super.onPause();
        //在activity执行onPause时执行mMapView. onPause ()，实现地图生命周期管理
        if(mMapView!=null) {
            mMapView.onPause();
        }
        if(highLightView!=null){
            highLightView.setVisibility(View.GONE);
        }
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        boolean value = super.onTouchEvent(event);

        return value;
    }

    private ImageView highLightView;
    private final int clickAnimDuration=100;
    @Override
    public boolean onMarkerClick(final Marker marker) {
        Point markerPoint=mBaiduMap.getProjection().toScreenLocation(marker.getPosition());
        Point toTarget=new Point(markerPoint.x+marker.getIcon().getBitmap().getWidth()/2,markerPoint.y+UIUtils.dip2px(self,130));
        LatLng toLoc=mBaiduMap.getProjection().fromScreenLocation(toTarget);
        mBaiduMap.animateMapStatus(MapStatusUpdateFactory.newLatLng(toLoc),clickAnimDuration);
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                Bundle bundle = marker.getExtraInfo();
                currentClickedTrack = (TrackBean) bundle.getSerializable(StaticVar.EXTRA_TRACK_BEAN);
                Log.i(logTag,"user header--->"+currentClickedTrack.getUserHeadImg());
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
                    headerClickedView.findViewById(R.id.to_track_detail).setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            Intent intent = new Intent(self,TrackDetailActivity.class);
                            intent.putExtra(StaticVar.EXTRA_TRACK_BEAN,currentClickedTrack);
                            startActivity(intent);
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
                StaticMethod.setCircularHeaderImg(currentClickedTrack.getUserHeadImg(),headerClickedViewHolder.headerIv,headerClickedViewHolder.headerIv.getWidth(),headerClickedViewHolder.headerIv.getHeight());
                headerClickedViewHolder.nicknameTv.setText(currentClickedTrack.getUserNickname());
                headerClickedViewHolder.addressTv.setText(currentClickedTrack.getFootprintAddress());
                headerClickedViewHolder.timeTv.setText(currentClickedTrack.getDateCreated()+"");
                headerClickedViewHolder.contentTv.setText(StaticMethod.genLesStr(currentClickedTrack.getFootprintContent(),30));
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
                bottomDialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
                    @Override
                    public void onDismiss(DialogInterface dialog) {
                        if(highLightView !=null){
                            WindowManager wm= (WindowManager) getSystemService(WINDOW_SERVICE);
                            wm.removeView(highLightView);
                            highLightView =null;
                        }
                    }
                });
                bottomDialog.show();

                final Point point=mBaiduMap.getProjection().toScreenLocation(marker.getPosition());

                try{
                    highLightView =new ImageView(self);
                    highLightView.setImageBitmap(marker.getIcon().getBitmap());
                    WindowManager wm= (WindowManager) getSystemService(WINDOW_SERVICE);
                    WindowManager.LayoutParams ps=new WindowManager.LayoutParams(WindowManager.LayoutParams.WRAP_CONTENT,WindowManager.LayoutParams.WRAP_CONTENT);
                    ps.x=point.x;
                    ps.y=point.y-marker.getIcon().getBitmap().getHeight()/2;
                    ps.width=marker.getIcon().getBitmap().getWidth();
                    ps.height=marker.getIcon().getBitmap().getHeight();
                    ps.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT;
                    ps.flags= WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
                            | WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE;
                    ps.format = PixelFormat.TRANSLUCENT;
                    ps.gravity = Gravity.LEFT | Gravity.TOP;
                    wm.addView(highLightView,ps);
                }catch (Exception e){
                    highLightView=null;
                }

            }
        },clickAnimDuration+20);

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
        @ViewInject(R.id.to_track_detail)
        Button toTrackDetailBtn;
    }

}
