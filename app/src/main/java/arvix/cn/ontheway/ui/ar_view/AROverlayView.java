package arvix.cn.ontheway.ui.ar_view;

import android.content.Context;
import android.content.Intent;
import android.graphics.Paint;
import android.location.Location;
import android.opengl.Matrix;
import android.os.Bundle;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.utils.CoordinateConverter;
import com.baidu.mapapi.utils.DistanceUtil;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.FootPrintBean;
import arvix.cn.ontheway.bean.FootPrintSearchVo;
import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.bean.SearchDistance;
import arvix.cn.ontheway.bean.SearchType;
import arvix.cn.ontheway.service.impl.ArFootPrintCacheMemoryService;
import arvix.cn.ontheway.service.inter.CacheService;
import arvix.cn.ontheway.service.inter.FootPrintSearchNotify;
import arvix.cn.ontheway.service.inter.FootPrintSearchService;
import arvix.cn.ontheway.ui.track.TrackDetailActivity;
import arvix.cn.ontheway.utils.LocationHelper;
import arvix.cn.ontheway.utils.MyProgressDialog;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;
import arvix.cn.ontheway.utils.Windows;

/**
 * Created by ntdat on 1/13/17.
 */

public class AROverlayView implements FootPrintSearchNotify<FootPrintBean>, View.OnClickListener {
    private String logTag = this.getClass().getName();
    Context context;
    private float[] rotatedProjectionMatrix = new float[16];
    private Location currentLocation;
    private double latAndLonAndAltLast = 0.0;
    private double alt;//海拔
    CacheService cache;
    ArFootPrintCacheMemoryService arFootPrintCacheMemoryService;
    FootPrintSearchService footPrintSearchService;
    private Pagination<FootPrintBean> pagination = new Pagination<>();
    private Paint mBitPaint;
    private String viewBitmapCachePrefix = "trackItem";
    private View convertViewTemp = null;
    private String rePointKeyTemp = "";
    private int drawXOffset = 0;
    private int drawYOffset = 0;
    private ViewGroup rootView;
    MyProgressDialog wait;
    private FootPrintSearchVo trackSearchVo;
    private final float radius= StaticMethod.dip2px(App.self , 37f);
    float cx = StaticMethod.dip2px(App.self,40);
    LatLng center = new LatLng(OnthewayApplication.getInstahce(CacheService.class).getDouble(StaticVar.BAIDU_LOC_CACHE_LAT),OnthewayApplication.getInstahce(CacheService.class).getDouble(StaticVar.BAIDU_LOC_CACHE_LON));
    private int headerImgWidth = StaticMethod.dip2px(App.self, 28);
    private String preTrackBeanIdStr = "";
    private String oldRotateStr = "";
    private String newRotateStr = "";
    private float[] oldRotatedProjectionMatrix = new float[16];
    java.text.DecimalFormat   df   =new   java.text.DecimalFormat("#.00");
    private double screenRadius = 0;
    private double radarZoom = 0;
    public static float xDegrees;
    public static float yDegrees;
    public static float zDegrees;
    private  List<RadarPoint> radarPointList  = new ArrayList<>();
    private  List<ImageView> radarImageViewList  = new ArrayList<>();
    private FrameLayout radarFrameLayout;
    public AROverlayView(Context context, ViewGroup rootView, FootPrintSearchVo trackSearchVo,FrameLayout radarFrameLayout) {
        this.context = context;
        this.rootView = rootView;
        this.trackSearchVo = trackSearchVo;
        cache = OnthewayApplication.getInstahce(CacheService.class);
        arFootPrintCacheMemoryService = new ArFootPrintCacheMemoryService();
        footPrintSearchService = OnthewayApplication.getInstahce(FootPrintSearchService.class);
        mBitPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mBitPaint.setFilterBitmap(true);
        mBitPaint.setDither(true);
        drawXOffset = StaticMethod.dip2px(context, 0);
        drawYOffset = StaticMethod.dip2px(context, 50);
        currentLocation = new Location("");
        this.radarFrameLayout = radarFrameLayout;

    }

    private void updateLocationData(double lat, double lon) {
        if (lat == 0.0 && lon == 0.0) {
            Log.w(this.getClass().getName(), "lat and lon is 0.0");
            return;
        }
        if(Math.abs(lat+lon-latAndLonAndAltLast)<0.0005){
            return;
        }
        latAndLonAndAltLast = lat + lon;
        if(wait!=null &&wait.isShowing()){
            wait.dismiss();
            wait = null;
        }
        wait = Windows.waiting(context);
        trackSearchVo.setLatitude(lat);
        trackSearchVo.setLongitude(lon);
        trackSearchVo.setSearchType(SearchType.ar);
        footPrintSearchService.search(context,trackSearchVo,this);
    }

    public void updateSearchParams(){
        if(wait!=null && wait.isShowing()){
            wait.dismiss();
            wait = null;
        }
        wait = Windows.waiting(context);
        footPrintSearchService.search(context,trackSearchVo,this);
    }

    public void updateRotatedProjectionMatrix(float[] rotatedProjectionMatrix) {
        this.rotatedProjectionMatrix = rotatedProjectionMatrix;
        newRotateStr = "";
        float diffAbs = 0;
        for(int i=0;i<rotatedProjectionMatrix.length;i++){
            newRotateStr = newRotateStr +"-"+  df.format(rotatedProjectionMatrix[i]);
            diffAbs = diffAbs + Math.abs(rotatedProjectionMatrix[i] - oldRotatedProjectionMatrix[i]);
        }
        if(diffAbs>0.1){
            Log.i(logTag,"updateRotatedProjectionMatrix--->change  new"  + newRotateStr);
            Log.i(logTag,"updateRotatedProjectionMatrix--->change  old"  + oldRotateStr);
            this.move();
            oldRotatedProjectionMatrix = rotatedProjectionMatrix;
            oldRotateStr = newRotateStr;
        }
    }

    public void updateCurrentLocation(Location currentLocationInput) {
        if (currentLocationInput != null) {
            LatLng sourceLatLng = new LatLng(currentLocationInput.getLatitude(),currentLocationInput.getLongitude());
            // 将GPS设备采集的原始GPS坐标转换成百度坐标
            CoordinateConverter converter  = new CoordinateConverter();
            converter.from(CoordinateConverter.CoordType.GPS);
            // sourceLatLng待转换坐标
            converter.coord(sourceLatLng);
            LatLng desLatLng = converter.convert();
            currentLocation.setLatitude(desLatLng.latitude);
            currentLocation.setLongitude(desLatLng.longitude);
            double tempSum = this.currentLocation.getLatitude() + this.currentLocation.getLongitude() + currentLocation.getAltitude();
            if (Math.abs(tempSum - latAndLonAndAltLast) > 0.0001) {
                if (currentLocation.hasAltitude()) {
                    this.alt = currentLocation.getAltitude();
                    updateLocationData(currentLocation.getLatitude(), currentLocation.getLongitude());
                } else {
                    this.alt = 0.0;
                    updateLocationData(currentLocation.getLatitude(), currentLocation.getLongitude());
                }
                Log.i(logTag,"currentLocation--->change");
            }
        }
    }
    public void drawRadarPoint() {
        if(radarImageViewList.size()==0){
            ImageView tempImageView = null;
            for(int i=0;i<30;i++){
                tempImageView = new ImageView(context);
                FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(StaticMethod.dip2px(context,2), StaticMethod.dip2px(context,2));
                layoutParams.setMargins(500,500,0,0);
                tempImageView.setLayoutParams(layoutParams);
                tempImageView.setBackgroundResource(R.drawable.red_point);
                tempImageView.setVisibility(View.INVISIBLE);
                radarImageViewList.add(tempImageView);
                radarFrameLayout.addView(tempImageView);
            }
        }

        float cy = StaticMethod.dip2px(App.self,40);
        int i=0;
        ImageView imageView;
        LatLng target = null;
        double distance, azimuth,pLeft,pTop;
        double realRadius = 1000.0;
        if(trackSearchVo.getSearchDistance()== SearchDistance.one){
            realRadius = 100.0;
        }
        if(trackSearchVo.getSearchDistance()== SearchDistance.two){
            realRadius = 500.0;
        }
        if(trackSearchVo.getSearchDistance()== SearchDistance.three){
            realRadius = 1000.0;
        }
        radarZoom = radius/realRadius;
        int diffY  = 1;

        Map<String, Integer> drawPointRePointMap = new HashMap<String, Integer>();
        float rotaDegree = zDegrees;
        double zRadians = Math.toRadians(rotaDegree);
       // Log.i(logTag,"cx:"+cx+",cy:"+cy+",radius:"+radius+",rotaDegree:"+rotaDegree);
        for(RadarPoint radarPoint : radarPointList){
            target = new LatLng(radarPoint.lat, radarPoint.lon);
            distance = DistanceUtil.getDistance(center,target);
            azimuth = StaticMethod.comAzimuth(center.latitude,center.longitude,radarPoint.lat,radarPoint.lon);
          //  pLeft = cx + Math.sin(azimuth)*distance/realRadius*radius;
          //  pTop =  cy - Math.cos(azimuth)*distance/realRadius*radius;
            pLeft = (int)(cx - Math.sin(azimuth)*radarZoom*distance);
            pTop = (int) (cy + Math.cos(azimuth)*radarZoom*distance);
            rePointKeyTemp = pLeft + "-" + pTop;
            Integer rePointTimes = drawPointRePointMap.get(rePointKeyTemp);
            if (rePointTimes == null) {
                drawPointRePointMap.put(rePointKeyTemp, 1);
            } else {
                pLeft = pLeft - (diffY * rePointTimes)*Math.sin(zRadians);
                pTop = pTop - (diffY * rePointTimes)*Math.cos(zRadians);
                drawPointRePointMap.put(rePointKeyTemp, rePointTimes + 1);
            }
            imageView = radarImageViewList.get(i);
          //  if(Math.sqrt(pointRadius) < (radius)){
          //  Log.i(logTag,"left:"+(int)(pLeft)+",top:"+(int)(pTop)+",realRadius"+realRadius+",sW:"
         //           +rootView.getWidth() +",sH:"+rootView.getHeight()+",distance:"+distance +",serverDistance:"+radarPoint.serverDistance) ;
            FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(StaticMethod.dip2px(context,2), StaticMethod.dip2px(context,2));

            layoutParams.setMargins((int)pLeft,(int)(pTop),0,0);
            imageView.setLayoutParams(layoutParams);
            imageView.setVisibility(View.VISIBLE);
            i++;
            if(i>30){
                imageView = new ImageView(context);
                imageView.setBackgroundResource(R.drawable.red_point);
                radarImageViewList.add(imageView);
            }
            //}
        }
        // 获取绕Z轴转过的角度
        radarFrameLayout.setRotation(-rotaDegree);
    }

    /**
     * Called when a view has been clicked.
     * 足迹view点击事件
     * @param v The view that was clicked.
     */
    @Override
    public void onClick(View v) {
        Object obj = v.getTag();
        if(obj!=null && (obj instanceof FootPrintBean)){
            FootPrintBean footPrintBean = (FootPrintBean) obj;
            Intent intent = new Intent(context, TrackDetailActivity.class);
            intent.putExtra(StaticVar.EXTRA_TRACK_BEAN, footPrintBean);
            context.startActivity(intent);
        }
    }


    class RadarPoint {
        boolean isNegative = false;
        double lat;
        double lon;
        double serverDistance;
        @Override
        public String toString() {
            return lat + ", " +lon;
        }
    }
    private boolean isMoving = false;
    public void move() {
        try {
            if(isMoving){
                Log.i(logTag,"is moving---------------------------> return");
                return;
            }
            isMoving = true;
            if (this.pagination.getContent() != null && this.pagination.getContent().size() > 0) {
                Location location;
                try {
                   // Log.i(logTag, "do onDraw------------------------------------>");
                    Map<String, Integer> drawPointRePointMap = new HashMap<String, Integer>();
                    //for start
                    radarPointList.clear();
                    for (ImageView im : radarImageViewList) {
                        im.setVisibility(View.INVISIBLE);
                    }
                    RadarPoint radarPoint;
                    for (final FootPrintBean footPrintBean : this.pagination.getContent()) {
                        location = new Location(footPrintBean.getFootprintContent());
                        location.setLatitude(footPrintBean.getLatitude());
                        location.setLongitude(footPrintBean.getLongitude());
                        location.setAltitude(this.alt);
                        float[] currentLocationInECEF = LocationHelper.WSG84toECEF(currentLocation);
                        float[] pointInECEF = LocationHelper.WSG84toECEF(location);
                        float[] pointInENU = LocationHelper.ECEFtoENU(currentLocation, currentLocationInECEF, pointInECEF);
                        float[] cameraCoordinateVector = new float[4];
                        Matrix.multiplyMV(cameraCoordinateVector, 0, rotatedProjectionMatrix, 0, pointInENU, 0);
                        // cameraCoordinateVector[2] is z, that always less than 0 to display on right position
                        // if z > 0, the point will display on the opposite
                        float drawX = (0.5f + cameraCoordinateVector[0] / cameraCoordinateVector[3]) * this.rootView.getWidth();
                        float drawY = (0.5f - cameraCoordinateVector[1] / cameraCoordinateVector[3]) * this.rootView.getHeight();
                       // Log.i(logTag, "distance---->" + ",x:" + cameraCoordinateVector[0] + ",y:" + cameraCoordinateVector[0]);
                        drawX = (int) drawX;
                        drawY = (int) drawY;
                        rePointKeyTemp = drawX + "-" + drawY;
                        Integer rePointTimes = drawPointRePointMap.get(rePointKeyTemp);
                        if (rePointTimes == null) {
                            drawPointRePointMap.put(rePointKeyTemp, 1);
                        } else {
                            drawX = drawX + drawXOffset * rePointTimes;
                            drawY = drawY + drawYOffset * rePointTimes;
                            drawPointRePointMap.put(rePointKeyTemp, rePointTimes + 1);
                        }
                        radarPoint = new RadarPoint();
                        radarPoint.lat = footPrintBean.getLatitude();
                        radarPoint.lon = footPrintBean.getLongitude();
                        radarPoint.isNegative = true;
                        radarPoint.serverDistance = footPrintBean.getDistance();
                        if (cameraCoordinateVector[2] < 0) {
                            radarPoint.isNegative = false;
                            // Log.i(logTag, "drawRadar point radarX:" + radarX + ",radarY:" + radarY + "  radius:"+radius);
                            ArFootPrintActivity.tvCurrentLocation.setText(System.currentTimeMillis() + " show:" + cameraCoordinateVector[2]);
                            convertViewTemp = arFootPrintCacheMemoryService.getT(viewBitmapCachePrefix + footPrintBean.getFootprintId(), View.class);
                            if (convertViewTemp != null) {

                               // Log.i(logTag, "load form cache bitmap drawX:" + drawX + ",drawY:" + drawY + "  ");
                                FrameLayout.LayoutParams marginLeftAndTop = new FrameLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                                marginLeftAndTop.setMargins((int) drawX, (int) drawY, 0, 0);
                                convertViewTemp.setLayoutParams(marginLeftAndTop);
                            } else {
                                View convertView = LayoutInflater.from(context).inflate(R.layout.track_ar_item, rootView, false);
                                ViewHolder h = new ViewHolder();
                                x.view().inject(h, convertView);
                                h.addressTv.setText(StaticMethod.genLesAddressStr(footPrintBean.getFootprintAddress(), 4));
                                h.timeTv.setText(footPrintBean.getDateCreatedStr());
                                h.contentTv.setText(StaticMethod.genLesStr(footPrintBean.getFootprintContent(), 6));
                                StaticMethod.setCircularHeaderImg(footPrintBean.getUserHeadImg(), h.userHeader, headerImgWidth, headerImgWidth);
                                if (!TextUtils.isEmpty(footPrintBean.getFootprintPhoto())) {
                                    StaticMethod.setImg(footPrintBean.getFootprintPhoto(), h.trackPhotoIv, headerImgWidth, headerImgWidth);
                                } else {
                                    h.trackPhotoIv.setVisibility(View.GONE);
                                }
                                FrameLayout.LayoutParams marginLeftAndTop = new FrameLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                                marginLeftAndTop.setMargins((int) drawX, (int) drawY, 0, 0);
                                convertView.setLayoutParams(marginLeftAndTop);
                                convertView.setTag(footPrintBean);
                                convertView.setOnClickListener(this);
                                rootView.addView(convertView);
                                arFootPrintCacheMemoryService.putObject(viewBitmapCachePrefix + footPrintBean.getFootprintId(), convertView);
                            }
                        }
                        radarPointList.add(radarPoint);
                    }
                    // for end
                    drawRadarPoint();
                } catch (Exception e) {
                    Log.e(logTag, "load image error", e);
                    e.printStackTrace();
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            isMoving = false;
        }
    }

    protected void onDestroy() {
        preTrackBeanIdStr = "";
        arFootPrintCacheMemoryService.clear();
    }
    /**
     * 查询数据回调实现
     * @param trackSearchVo
     * @param paginationFetch
     */
    @Override
    public void trackSearchDataFetchSuccess(final FootPrintSearchVo trackSearchVo, final Pagination<FootPrintBean> paginationFetch) {
        Pagination<FootPrintBean> lastPagination = pagination;
        pagination = paginationFetch;
        if(wait!=null){
            wait.dismiss();
            wait = null;
        }
        Log.i(logTag,"trackSearchDataFetchSuccess---->"+this.alt);
        String newTrackBeanIdStr = "";
        String latStr  ="{";
        String lonStr = "{";
        String contentStr = "{";
        for (FootPrintBean footPrintBean : pagination.getContent()) {
            latStr = latStr  + footPrintBean.getLatitude()+",";
            lonStr = lonStr  +footPrintBean.getLongitude()+"\",";
            contentStr = contentStr + "\"" + footPrintBean.getFootprintContent() +"\",";
            newTrackBeanIdStr = newTrackBeanIdStr + footPrintBean.getFootprintId();
        }
        Log.i(logTag,"latStr--->\n"+latStr+"}");
        Log.i(logTag,"lonStr--->\n"+lonStr+"}");
        Log.i(contentStr,"contentStr--->\n"+contentStr+"}");
        if(!newTrackBeanIdStr.equals(preTrackBeanIdStr)){
            //update activity
            Message msg = new Message();
            Bundle b = new Bundle();
            b.putString("totalCount", paginationFetch.getTotalElements()+"");
            b.putString("address", cache.get(StaticVar.BAIDU_LOC_CACHE_ADDRESS));
            msg.setData(b);
            ArFootPrintActivity.handler.sendMessage(msg);
            //update activity end
            trackSearchVo.setTotalPages(paginationFetch.getTotalPages());
            if(lastPagination!=null && lastPagination.getContent()!=null){
                for(FootPrintBean footPrintBeanOld : lastPagination.getContent()){
                    convertViewTemp = arFootPrintCacheMemoryService.getT(viewBitmapCachePrefix + footPrintBeanOld.getFootprintId(), View.class);
                    if(convertViewTemp!=null){
                        rootView.removeView(convertViewTemp);
                        arFootPrintCacheMemoryService.remove(viewBitmapCachePrefix + footPrintBeanOld.getFootprintId());
                    }
                }
            }
            this.move();
        }
        preTrackBeanIdStr = newTrackBeanIdStr;
    }


    /**
     * 动画移动view并摆放至相应的位置
     *
     * @param view               控件
     * @param xFromDeltaDistance x起始位置的偏移量
     * @param xToDeltaDistance   x终止位置的偏移量
     * @param yFromDeltaDistance y起始位置的偏移量
     * @param yToDeltaDistance   y终止位置的偏移量
     * @param duration           动画的播放时间
     * @param delay              延迟播放时间
     * @param isBack             是否需要返回到开始位置
     */
    public static void moveViewWithAnimation(final View view, final float xFromDeltaDistance, final float xToDeltaDistance,
                                             final float yFromDeltaDistance, final float yToDeltaDistance,
                                             int duration, int delay,
                                             final boolean isBack) {
        //创建位移动画
        TranslateAnimation ani = new TranslateAnimation(0, xToDeltaDistance-xFromDeltaDistance, 0, yToDeltaDistance-yFromDeltaDistance);
        ani.setInterpolator(new AccelerateDecelerateInterpolator());//设置加速器
        ani.setDuration(duration);//设置动画时间
       // ani.setStartOffset(delay);//设置动画延迟时间
        //监听动画播放状态
        ani.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
            }

            @Override
            public void onAnimationRepeat(Animation animation) {
            }
            @Override
            public void onAnimationEnd(Animation animation) {
                 FrameLayout.LayoutParams marginLeftAndTop = new FrameLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                 marginLeftAndTop.setMargins((int)xToDeltaDistance, (int)yToDeltaDistance, 0, 0);
                 view.clearAnimation();
                // view.layout((int)xToDeltaDistance, (int)yToDeltaDistance, (int)xToDeltaDistance +  , (int)yToDeltaDistance);
                 view.setLayoutParams(marginLeftAndTop);
            }
        });
        view.startAnimation(ani);
    }



    private class ViewHolder {
        @ViewInject(R.id.header_iv)
        ImageView userHeader;
        @ViewInject(R.id.time_tv)
        TextView timeTv;
        @ViewInject(R.id.content_tv)
        TextView contentTv;
        @ViewInject(R.id.address_tv)
        TextView addressTv;
        @ViewInject(R.id.main_photo_iv)
        ImageView trackPhotoIv;
    }
}




