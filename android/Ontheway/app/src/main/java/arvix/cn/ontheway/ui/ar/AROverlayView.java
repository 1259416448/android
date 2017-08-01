package arvix.cn.ontheway.ui.ar;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.location.Location;
import android.opengl.Matrix;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdate;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.search.core.PoiInfo;
import com.baidu.mapapi.search.core.SearchResult;
import com.baidu.mapapi.search.poi.OnGetPoiSearchResultListener;
import com.baidu.mapapi.search.poi.PoiDetailResult;
import com.baidu.mapapi.search.poi.PoiIndoorResult;
import com.baidu.mapapi.search.poi.PoiResult;

import java.util.ArrayList;
import java.util.List;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.bean.ARPoint;
import arvix.cn.ontheway.service.inter.BaiduPoiServiceInterface;
import arvix.cn.ontheway.service.inter.CacheInterface;
import arvix.cn.ontheway.utils.LocationHelper;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticVar;


/**
 * Created by ntdat on 1/13/17.
 */

public class AROverlayView extends View {

    Context context;
    private float[] rotatedProjectionMatrix = new float[16];
    private Location currentLocation;
    private List<ARPoint> arPoints;
    private double latAndLonAndAltLast = 0.0;


    public AROverlayView(Context context) {
        super(context);
        this.context = context;
        updateLocationData();
        arPoints = new ArrayList<ARPoint>();
    }

    public  void updateLocationData(){
        arPoints = new ArrayList<ARPoint>();
        CacheInterface cache = OnthewayApplication.getInstahce(CacheInterface.class);
        Double latCache = cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LAT);
        Double lonCache = 0.0;
        if(latCache!=null){
            lonCache = cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LON);
            Double  alt =     cache.getDouble(StaticVar.BAIDU_LOC_CACHE_ALT);
            Log.i(this.getClass().getName(),"init location from cache");
            if(alt==null){
                alt = 0.0;
            }
            latAndLonAndAltLast = latCache + lonCache;
            updateLocationData(latCache,lonCache,alt);
        }
    }
    private void updateLocationData(double lat, double lon, final double alt){
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
        Log.i("updateLocationData","init location from cache");
        BaiduPoiServiceInterface poiService = OnthewayApplication.getInstahce(BaiduPoiServiceInterface.class);
        if(TextUtils.isEmpty(ArTrackActivity.searchKeyWord)){
            ArTrackActivity.searchKeyWord = "美食";
        }
        poiService.search(lat,lon,ArTrackActivity.searchKeyWord,1000,new OnGetPoiSearchResultListener(){
            @Override
            public void onGetPoiResult(PoiResult poiResult) {

                if (poiResult == null
                        || poiResult.error == SearchResult.ERRORNO.RESULT_NOT_FOUND) {// 没有找到检索结果
                    Toast.makeText(App.self, "未找到结果",
                            Toast.LENGTH_LONG).show();
                    return;
                }
                //获取POI检索结果
                List<PoiInfo> allAddr = poiResult.getAllPoi();
                for (PoiInfo p: allAddr) {
                    Log.i("MainActivity", "p.name--->" + p.name +"p.phoneNum" + p.phoneNum +" -->p.address:" + p.address + "p.location" + p.location);
                    arPoints.add(new ARPoint(p.name, p.location.latitude,p.location.longitude,  alt));
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


    public void updateRotatedProjectionMatrix(float[] rotatedProjectionMatrix) {
        this.rotatedProjectionMatrix = rotatedProjectionMatrix;
        this.invalidate();
    }

    public void updateCurrentLocation(Location currentLocation){
        this.currentLocation = currentLocation;
        if(this.currentLocation!=null){
            double tempSum = this.currentLocation.getLatitude() + this.currentLocation.getLongitude() + currentLocation.getAltitude();
            if(Math.abs(tempSum-latAndLonAndAltLast)>0.0001){
                if(currentLocation.hasAltitude()){
                    updateLocationData(currentLocation.getLatitude(),currentLocation.getLongitude(),currentLocation.getAltitude());
                }else{
                    updateLocationData(currentLocation.getLatitude(),currentLocation.getLongitude(),0.0);
                }
            }
            latAndLonAndAltLast = tempSum;
        }
        this.invalidate();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);

        if (currentLocation == null || arPoints==null ||arPoints.size()==0) {
            return;
        }
        ArTrackActivity.tvCurrentLocation.setText(System.currentTimeMillis()+" d");
        final int radius = 30;
        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        paint.setStyle(Paint.Style.FILL);
        paint.setColor(Color.WHITE);
        paint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.NORMAL));
        paint.setTextSize(60);

        for (int i = 0; i < arPoints.size(); i ++) {
            float[] currentLocationInECEF = LocationHelper.WSG84toECEF(currentLocation);
            float[] pointInECEF = LocationHelper.WSG84toECEF(arPoints.get(i).getLocation());
            float[] pointInENU = LocationHelper.ECEFtoENU(currentLocation, currentLocationInECEF, pointInECEF);

            float[] cameraCoordinateVector = new float[4];
            Matrix.multiplyMV(cameraCoordinateVector, 0, rotatedProjectionMatrix, 0, pointInENU, 0);

            // cameraCoordinateVector[2] is z, that always less than 0 to display on right position
            // if z > 0, the point will display on the opposite
            if (cameraCoordinateVector[2] < 0) {
                ArTrackActivity.tvCurrentLocation.setText(System.currentTimeMillis()+" show:"+cameraCoordinateVector[2]);
                float x  = (0.5f + cameraCoordinateVector[0]/cameraCoordinateVector[3]) * canvas.getWidth();
                float y = (0.5f - cameraCoordinateVector[1]/cameraCoordinateVector[3]) * canvas.getHeight();

                canvas.drawCircle(x, y, radius, paint);
                canvas.drawText(arPoints.get(i).getName(), x - (30 * arPoints.get(i).getName().length() / 2), y - 80, paint);
            }
        }
    }
}
