package arvix.cn.ontheway.ui.ar;

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
import android.view.MotionEvent;
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
import arvix.cn.ontheway.service.impl.CacheDefault;
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

public class AROverlayView implements FootPrintSearchNotify<FootPrintBean>, View.OnTouchListener {
    private String logTag = this.getClass().getName();
    Context context;
    private float[] rotatedProjectionMatrix = new float[16];
    private Location currentLocation;
    private double latAndLonAndAltLast = 0.0;
    private double alt;//海拔
    CacheService cache;
    CacheService dataCache;
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
    float cx = StaticMethod.dip2px(App.self,55);
    LatLng center = new LatLng(OnthewayApplication.getInstahce(CacheService.class).getDouble(StaticVar.BAIDU_LOC_CACHE_LAT),OnthewayApplication.getInstahce(CacheService.class).getDouble(StaticVar.BAIDU_LOC_CACHE_LON));
    private int headerImgWidth = StaticMethod.dip2px(App.self, 28);
    private String preTrackBeanIdStr = "";
    private String oldRotateStr = "";
    private String newRotateStr = "";
    private float[] oldRotatedProjectionMatrix = new float[16];
    java.text.DecimalFormat   df   =new   java.text.DecimalFormat("#.00");
    private double screenRadius = 0;
    private double radarZoom = 0;
    long downTime=0;
    private  List<RadarPoint> radarPointList  = new ArrayList<>();
    private  List<ImageView> radarImageViewList  = new ArrayList<>();
    public AROverlayView(Context context, ViewGroup rootView, FootPrintSearchVo trackSearchVo) {
        this.context = context;
        this.rootView = rootView;
        this.trackSearchVo = trackSearchVo;
        cache = OnthewayApplication.getInstahce(CacheService.class);
        dataCache = new CacheDefault();
        footPrintSearchService = OnthewayApplication.getInstahce(FootPrintSearchService.class);
        mBitPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mBitPaint.setFilterBitmap(true);
        mBitPaint.setDither(true);
        drawXOffset = StaticMethod.dip2px(context, 0);
        drawYOffset = StaticMethod.dip2px(context, 50);
        rootView.setOnTouchListener(this);
        currentLocation = new Location("");
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
        trackSearchVo.setSearchType(FootPrintSearchVo.SearchType.ar);
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
        if(diffAbs>0.3){
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


    /**
     * 足迹view点击事件
     * Called when a touch event is dispatched to a view. This allows listeners to
     * get a chance to respond before the target view.
     *
     * @param v     The view the touch event has been dispatched to.
     * @param event The MotionEvent object containing full information about
     *              the event.
     * @return True if the listener has consumed the event, false otherwise.
     */

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        Object obj = v.getTag();
        if(obj!=null && (obj instanceof FootPrintBean)){
            long tillTime=System.currentTimeMillis()-downTime;
            //时间差在允许范围内时,视为一次单击事件成立
            //if(tillTime<150) {
                FootPrintBean footPrintBean = (FootPrintBean) obj;
                Intent intent = new Intent(context, TrackDetailActivity.class);
                intent.putExtra(StaticVar.EXTRA_TRACK_BEAN, footPrintBean);
                context.startActivity(intent);
           // }
        }
        return true;
    }

    public void drawRadarPoint() {
        float cy = this.rootView.getHeight() - StaticMethod.dip2px(App.self,55);
        for(ImageView imageView : radarImageViewList){
            rootView.removeView(imageView);
        }
        if(radarZoom==0){
            double temp = rootView.getWidth()*rootView.getWidth()+ rootView.getHeight()*rootView.getHeight();
            screenRadius = Math.sqrt(temp);
            radarZoom = screenRadius/radius;
        }
        radarImageViewList.clear();
        int halfSW = rootView.getWidth()/2;
        for(RadarPoint radarPoint : radarPointList){
            double left = cx -  (halfSW - radarPoint.x)/radarZoom;
            double top ;
            if(radarPoint.isNegative){
                top = cy  +  (rootView.getHeight()-radarPoint.y + halfSW)/radarZoom;
            }else{
                top = cy - (rootView.getHeight()-radarPoint.y + halfSW)/radarZoom;
            }
            ImageView imageView = new ImageView(context);
            double pointRadius = (cx-left)*(cx-left)+(cy-top)*(cy-top);
            if(Math.sqrt(pointRadius) < (radius)){
                FrameLayout.LayoutParams marginLeftAndTop = new FrameLayout.LayoutParams(StaticMethod.dip2px(context,2), StaticMethod.dip2px(context,2));
                marginLeftAndTop.setMargins((int)(left), (int)(top), 0, 0);
                Log.i(logTag,"radarZoom:"+radarZoom+",left:"+(int)(left)+",top:"+(int)(top)+",screenRadius"+screenRadius+",sW:"+rootView.getWidth() +",sH:"+rootView.getHeight());
                imageView.setLayoutParams(marginLeftAndTop);
                imageView.setBackgroundResource(R.drawable.red_point);
                rootView.addView(imageView);
                radarImageViewList.add(imageView);
            }
        }
    }


    class RadarPoint {
        float x, y;
        boolean isNegative = false;

        @Override
        public String toString() {
            return x + ", " + y;
        }
    }

    public void move() {
        if (this.pagination.getContent() != null && this.pagination.getContent().size() > 0) {
            Location location;
            try {
                Log.i(logTag, "do onDraw------------------------------------>");
                Map<String, Integer> drawPointRePointMap = new HashMap<String, Integer>();
                LatLng target = null;
                //for start
                radarPointList.clear();
                RadarPoint radarPoint;
                for ( final FootPrintBean footPrintBean : this.pagination.getContent()) {
                    location = new Location(footPrintBean.getFootprintContent());
                    location.setLatitude(footPrintBean.getLatitude());
                    location.setLongitude(footPrintBean.getLongitude());
                    location.setAltitude(this.alt);
                    target = new LatLng(footPrintBean.getLatitude(), footPrintBean.getLongitude());
                    Log.i(logTag,"distance---->" + DistanceUtil.getDistance(center,target));
                    float[] currentLocationInECEF = LocationHelper.WSG84toECEF(currentLocation);
                    float[] pointInECEF = LocationHelper.WSG84toECEF(location);
                    float[] pointInENU = LocationHelper.ECEFtoENU(currentLocation, currentLocationInECEF, pointInECEF);
                    float[] cameraCoordinateVector = new float[4];
                    Matrix.multiplyMV(cameraCoordinateVector, 0, rotatedProjectionMatrix, 0, pointInENU, 0);
                    // cameraCoordinateVector[2] is z, that always less than 0 to display on right position
                    // if z > 0, the point will display on the opposite
                    float drawX = (0.5f + cameraCoordinateVector[0] / cameraCoordinateVector[3]) * this.rootView.getWidth();
                    float drawY = (0.5f - cameraCoordinateVector[1] / cameraCoordinateVector[3]) * this.rootView.getHeight();
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
                    radarPoint.x = drawX;
                    radarPoint.y = drawY;
                    radarPoint.isNegative = true;
                    if (cameraCoordinateVector[2] < 0) {
                        radarPoint.isNegative = false;
                       // Log.i(logTag, "drawRadar point radarX:" + radarX + ",radarY:" + radarY + "  radius:"+radius);
                        ArFootPrintActivity.tvCurrentLocation.setText(System.currentTimeMillis() + " show:" + cameraCoordinateVector[2]);
                        convertViewTemp = dataCache.getTMem(viewBitmapCachePrefix + footPrintBean.getFootprintId(), View.class);
                        if (convertViewTemp != null) {

                            Log.i(logTag, "load form cache bitmap drawX:" + drawX + ",drawY:" + drawY + "  ");
                            FrameLayout.LayoutParams marginLeftAndTop = new FrameLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                            marginLeftAndTop.setMargins((int)drawX, (int)drawY, 0, 0);
                            convertViewTemp.setLayoutParams(marginLeftAndTop);
                           // moveViewWithAnimation(convertViewTemp,convertViewTemp.getLeft()*1.0f,drawX,convertViewTemp.getTop()*1.0f,drawY,100,0,false);
                        } else {
                            View convertView = LayoutInflater.from(context).inflate(R.layout.track_ar_item, rootView, false);
                            ViewHolder h = new ViewHolder();
                            x.view().inject(h, convertView);
                            h.addressTv.setText(StaticMethod.genLesAddressStr(footPrintBean.getFootprintAddress(), 4));
                            h.timeTv.setText(footPrintBean.getDateCreatedStr());
                            h.contentTv.setText(StaticMethod.genLesStr(footPrintBean.getFootprintContent(), 6));
                            StaticMethod.setCircularHeaderImg(footPrintBean.getUserHeadImg(),h.userHeader,headerImgWidth,headerImgWidth);
                            if (!TextUtils.isEmpty(footPrintBean.getFootprintPhoto())) {
                                StaticMethod.setImg(footPrintBean.getFootprintPhoto(),h.trackPhotoIv,headerImgWidth,headerImgWidth);
                            } else {
                                h.trackPhotoIv.setVisibility(View.GONE);
                            }
                            FrameLayout.LayoutParams marginLeftAndTop = new FrameLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
                            marginLeftAndTop.setMargins((int)drawX, (int)drawY, 0, 0);
                            convertView.setLayoutParams(marginLeftAndTop);
                            convertView.setTag(footPrintBean);
                            convertView.setOnTouchListener(this);
                            rootView.addView(convertView);
                            dataCache.putObjectMem(viewBitmapCachePrefix + footPrintBean.getFootprintId(), convertView);
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
    }

    protected void onDestroy() {
        preTrackBeanIdStr = "";
        dataCache.clear();
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
                    convertViewTemp = dataCache.getTMem(viewBitmapCachePrefix + footPrintBeanOld.getFootprintId(), View.class);
                    if(convertViewTemp!=null){
                        rootView.removeView(convertViewTemp);
                        dataCache.remove(viewBitmapCachePrefix + footPrintBeanOld.getFootprintId());
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




