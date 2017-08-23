package arvix.cn.ontheway.ui.ar_draw;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
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
import android.widget.FrameLayout;
import android.widget.ImageView;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.utils.CoordinateConverter;
import com.baidu.mapapi.utils.DistanceUtil;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import org.xutils.image.ImageDecoder;
import org.xutils.x;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import arvix.cn.ontheway.App;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.FootPrintBean;
import arvix.cn.ontheway.bean.FootPrintSearchVo;
import arvix.cn.ontheway.bean.Pagination;
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

public class AROverlayViewDraw extends View implements FootPrintSearchNotify<FootPrintBean>, View.OnTouchListener {
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
    private Bitmap bitmapTemp = null;
    private String rePointKeyTemp = "";
    private int drawXOffset = 0;
    private int drawYOffset = 0;
    private ViewGroup rootView;
    MyProgressDialog wait;
    private FootPrintSearchVo trackSearchVo;
    public static float xDegrees;
    public static float yDegrees;
    public static float zDegrees;
    private  List<RadarPoint> radarPointList  = new ArrayList<>();
    private  List<ImageView> radarImageViewList  = new ArrayList<>();
    private FrameLayout radarFrameLayout;
    private List<DrawFootPrintItemInfo> drawFootPrintItemInfoList = new ArrayList<>();
    private float trackViewItemRectW = 0.0f;
    private float trackViewItemRectH = 0.0f;
    private float computeTouchDiffY = 0.0f;
    private final float radius= StaticMethod.dip2px(App.self , 37f);
    float cx = StaticMethod.dip2px(App.self,40);
    private String oldRotateStr = "";
    private String newRotateStr = "";
    private float[] oldRotatedProjectionMatrix = new float[16];
    java.text.DecimalFormat   df   =new   java.text.DecimalFormat("#.00");
    LatLng center = new LatLng(OnthewayApplication.getInstahce(CacheService.class).getDouble(StaticVar.BAIDU_LOC_CACHE_LAT),OnthewayApplication.getInstahce(CacheService.class).getDouble(StaticVar.BAIDU_LOC_CACHE_LON));
    public AROverlayViewDraw(Context context, ViewGroup rootView, FootPrintSearchVo trackSearchVo,FrameLayout radarFrameLayout) {
        super(context);
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
        trackViewItemRectW = StaticMethod.dip2px(context, 164);
        trackViewItemRectH = StaticMethod.dip2px(context, 41);
        currentLocation = new Location("");
        rootView.setOnTouchListener(this);
        computeTouchDiffY = StaticMethod.getStatusBarHeight(context);
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

    DrawMoveCheck drawMoveCheck = new DrawMoveCheck();
    public void updateRotatedProjectionMatrix(float[] rotatedProjectionMatrix) {
        this.rotatedProjectionMatrix = rotatedProjectionMatrix;
        newRotateStr = "";
        float diffAbs = 0;
        for(int i=0;i<rotatedProjectionMatrix.length;i++){
            newRotateStr = newRotateStr +"-"+  df.format(rotatedProjectionMatrix[i]);
            diffAbs = diffAbs + Math.abs(rotatedProjectionMatrix[i] - oldRotatedProjectionMatrix[i]);
        }
        drawMoveCheck.addMoveDiffAbs(diffAbs);
        drawMoveCheck.computeMoveDiffAbs();
        //这里的比较值越小，draw频率越高，移动会更流畅
        if( diffAbs > drawMoveCheck.moveDiffAbs){
         //   Log.i(logTag,"updateRotatedProjectionMatrix--->change  new"  + newRotateStr);
            this.invalidate();
            oldRotatedProjectionMatrix = rotatedProjectionMatrix;
            oldRotateStr = newRotateStr;
            drawId = UUID.randomUUID().toString();
            Log.i(logTag,"updateRotatedProjectionMatrix--->change  old"  + oldRotateStr +"  drawId :" + drawId);
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
     * Called when a touch event is dispatched to a view. This allows listeners to
     * get a chance to respond before the target view.
     *
     * @param v     The view the touch event has been dispatched to.
     * @param event The MotionEvent object containing full information about
     *              the event.
     * @return True if the listener has consumed the event, false otherwise.
     */
    //定义全局变量用于存放按下时的时间点
    long downTime=0;
    @Override
    public boolean onTouch(View v, MotionEvent event) {
        switch(event.getAction()){
            case MotionEvent.ACTION_DOWN:
                //触摸时记录当前时间
                downTime=System.currentTimeMillis();
                break;
            case MotionEvent.ACTION_UP:
                //抬起时计算与按下时时间的差
                long tillTime=System.currentTimeMillis()-downTime;
                //时间差在允许范围内时,视为一次单击事件成立
                if(tillTime<150){
                    float touchY = event.getY();
                    float touchX = event.getX();
                    Log.i(logTag,"touch--->touchX:"+touchX+",touchY:"+touchY +"  --->");
                    FootPrintBean footPrintBean = computeTouchTrack(touchX,touchY);
                    if(footPrintBean !=null){
                       // StaticMethod.showToast(footPrintBean.getFootprintContent(),context);
                        Intent intent = new Intent(context,TrackDetailActivity.class);
                        intent.putExtra(StaticVar.EXTRA_TRACK_BEAN, footPrintBean);
                        context.startActivity(intent);
                    }
                }
                //否则不视为一次单击事件
                break;
        }
        return false;
    }

    private FootPrintBean computeTouchTrack(float touchX, float touchY){
        FootPrintBean footPrintBean = null;
        touchY = touchY - computeTouchDiffY;
        if(drawFootPrintItemInfoList.size()>0){
            DrawFootPrintItemInfo drawFootPrintItemInfo;
            for(int i = drawFootPrintItemInfoList.size()-1; i>=0; i-- ){
                drawFootPrintItemInfo = drawFootPrintItemInfoList.get(i);
                Log.i(logTag,"touch--->touchX:"+touchX+",touchY:"+touchY +",drawX:"+ drawFootPrintItemInfo.drawX+",drawY:"+ drawFootPrintItemInfo.drawY
                        +",rectHeight:"+ drawFootPrintItemInfo.rectHeight +",rectWidth:"+ drawFootPrintItemInfo.rectWidth +"    " + drawFootPrintItemInfo.footPrintBean.getFootprintContent());
                if( drawFootPrintItemInfo.drawX < touchX &&  touchX < (drawFootPrintItemInfo.drawX + drawFootPrintItemInfo.rectWidth)
                && drawFootPrintItemInfo.drawY < touchY && touchY <  (drawFootPrintItemInfo.drawY + drawFootPrintItemInfo.rectHeight)   ){
                    footPrintBean = drawFootPrintItemInfo.footPrintBean;
                    break;
                }
            }
        }
        return footPrintBean;
    }

    public void clearData() {
    }
    private String drawId = "";



    @Override
    protected void onDraw(final Canvas canvas) {
        super.onDraw(canvas);
        if (this.pagination.getContent() != null && this.pagination.getContent().size() > 0) {
            Location location;
            String drawIdStr = drawId;
            long start = System.currentTimeMillis();
            try {
               // Log.i(logTag, "do onDraw------------------------------------>");
                Map<String, Integer> drawPointRePointMap = new HashMap<String, Integer>();
                List<DrawFootPrintItemInfo> drawFootPrintItemInfoListTemp = new ArrayList<>();
                DrawFootPrintItemInfo pointInfo ;
                //for start
                radarPointList.clear();
                RadarPoint radarPoint;
                for ( final FootPrintBean footPrintBean : this.pagination.getContent()) {
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
                    float drawX = (0.5f + cameraCoordinateVector[0] / cameraCoordinateVector[3]) * canvas.getWidth();
                    float drawY = (0.5f - cameraCoordinateVector[1] / cameraCoordinateVector[3]) * canvas.getHeight();
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
                    pointInfo = new DrawFootPrintItemInfo(trackViewItemRectW,trackViewItemRectH);
                    pointInfo.footPrintBean = footPrintBean;
                    pointInfo.drawY = drawY;
                    pointInfo.drawX = drawX;
                    radarPoint = new RadarPoint();
                    radarPoint.lat = footPrintBean.getLatitude();
                    radarPoint.lon = footPrintBean.getLongitude();
                    radarPoint.isNegative = true;
                    if (cameraCoordinateVector[2] < 0) {
                        drawFootPrintItemInfoListTemp.add(pointInfo);
                        radarPoint.isNegative = false;
                      //  ArFootPrintDrawActivity.tvCurrentLocation.setText(System.currentTimeMillis() + " show:" + cameraCoordinateVector[2]);
                        bitmapTemp = arFootPrintCacheMemoryService.getT(viewBitmapCachePrefix + footPrintBean.getFootprintId(), Bitmap.class);
                        if (bitmapTemp != null) {
                           // Log.i(logTag, "load form cache bitmap drawX:" + drawX + ",drawY:" + drawY + "  ");
                            canvas.drawBitmap(bitmapTemp, drawX, drawY, mBitPaint);
                        } else {
                            View convertView = LayoutInflater.from(context).inflate(R.layout.track_ar_item, rootView, false);
                            FootPrintItemViewHolder h = new FootPrintItemViewHolder();
                            x.view().inject(h, convertView);
                            h.addressTv.setText(StaticMethod.genLesAddressStr(footPrintBean.getFootprintAddress(), 4));
                            h.timeTv.setText(footPrintBean.getDateCreatedStr());
                            h.contentTv.setText(StaticMethod.genLesStr(footPrintBean.getFootprintContent(), 6));
                            Bitmap headerBitmap = arFootPrintCacheMemoryService.getT(footPrintBean.getUserHeadImg(), Bitmap.class);
                            boolean headerLoaded = false;
                            boolean trackPhotoLoaded = false;
                           // Log.i(logTag,"h.userHeader--->"+h.userHeader.getLayoutParams().width+ " "+StaticMethod.dip2px(context, 28));
                            if (headerBitmap != null) {
                                h.userHeader.setImageBitmap(headerBitmap);
                                headerLoaded = true;
                            }
                            if (!TextUtils.isEmpty(footPrintBean.getFootprintPhoto())) {
                                Bitmap trackPhotoBitmap = arFootPrintCacheMemoryService.getT(footPrintBean.getFootprintPhoto(), Bitmap.class);
                                if (trackPhotoBitmap != null) {
                                    h.trackPhotoIv.setImageBitmap(trackPhotoBitmap);
                                    trackPhotoLoaded = true;
                                }
                            } else {
                                h.trackPhotoIv.setVisibility(GONE);
                                trackPhotoLoaded = true;
                            }
                          //  Log.i(logTag, "loadImage------->,drawX:" + drawX + ",drawY:" + drawY + "  " + footPrintBean.getUserHeadImg());
                            bitmapTemp = StaticMethod.getViewBitmap(convertView);
                            canvas.drawBitmap(bitmapTemp, drawX, drawY, mBitPaint);

                            if (trackPhotoLoaded && headerLoaded) {
                                arFootPrintCacheMemoryService.putObject(viewBitmapCachePrefix + footPrintBean.getFootprintId(), bitmapTemp);
                            }
                            convertView.setDrawingCacheEnabled(false);
                        }
                    }
                    radarPointList.add(radarPoint);
                }
                // for end
                this.drawFootPrintItemInfoList = drawFootPrintItemInfoListTemp;
                drawRadarPoint();
                Log.i(logTag,"drawId:"+drawIdStr +" use time:"+(System.currentTimeMillis() - start));
            } catch (Exception e) {
                Log.e(logTag, "load image error", e);
                e.printStackTrace();
            }
        }
    }
    private double radarZoom = 0;
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
        for (ImageView im : radarImageViewList) {
            im.setVisibility(View.INVISIBLE);
        }
        float cy = StaticMethod.dip2px(App.self,40);
        int i=0;
        ImageView imageView;
        LatLng target = null;
        double distance ,azimuth ,pLeft , pTop;
        double realRadius = 1000.0;
        if(trackSearchVo.getSearchDistance()== FootPrintSearchVo.SearchDistance.one){
            realRadius = 100.0;
        }
        if(trackSearchVo.getSearchDistance()== FootPrintSearchVo.SearchDistance.two){
            realRadius = 500.0;
        }
        if(trackSearchVo.getSearchDistance()== FootPrintSearchVo.SearchDistance.three){
            realRadius = 1000.0;
        }
        radarZoom = radius/realRadius;
        int diffY  = 1;

        Map<String, Integer> drawPointRePointMap = new HashMap<>();
        float rotaDegree = zDegrees;
        double zRadians = Math.toRadians(rotaDegree);
        // Log.i(logTag,"cx:"+cx+",cy:"+cy+",radius:"+radius+",rotaDegree:"+rotaDegree);
        for(RadarPoint radarPoint : radarPointList){
            target = new LatLng(radarPoint.lat, radarPoint.lon);
            distance = DistanceUtil.getDistance(center,target);
            azimuth = StaticMethod.comAzimuth(center.latitude,center.longitude,radarPoint.lat,radarPoint.lon);
          //Log.i(logTag," Math.sin(azimuth):"+azimuth +","+Math.sin(azimuth));
            pLeft = (int)(cx + Math.sin(azimuth)*radarZoom*distance);
            pTop = (int) (cy - Math.cos(azimuth)*radarZoom*distance);

            rePointKeyTemp = pLeft + "-" + pTop;
            Integer rePointTimes = drawPointRePointMap.get(rePointKeyTemp);
            if (rePointTimes == null) {
                drawPointRePointMap.put(rePointKeyTemp, 1);
            } else {
                // TODO 雷达点偏移
                /*
                if(azimuth>0){
                    pLeft = pLeft + (diffY * rePointTimes)*Math.sin(zRadians);
                    pTop = pTop - (diffY * rePointTimes)*Math.cos(zRadians);
                }else{
                    pLeft = pLeft - (diffY * rePointTimes)*Math.sin(zRadians);
                    pTop = pTop + (diffY * rePointTimes)*Math.cos(zRadians);
                }*/
                drawPointRePointMap.put(rePointKeyTemp, rePointTimes + 1);
            }
            imageView = radarImageViewList.get(i);
            //  if(Math.sqrt(pointRadius) < (radius)){
         //   Log.i(logTag,"left:"+(int)(pLeft)+",top:"+(int)(pTop)+",realRadius"+realRadius+",sW:"
           //           +rootView.getWidth() +",sH:"+rootView.getHeight()+",distance:"+distance +",zDegrees:"+zDegrees) ;
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



    protected void onDestroy() {
        arFootPrintCacheMemoryService.clear();
    }

    private String preTrackBeanIdStr = "";
    /**
     * 查询数据回调实现
     * @param trackSearchVo
     * @param paginationFetch
     */
    @Override
    public void trackSearchDataFetchSuccess(final FootPrintSearchVo trackSearchVo, final Pagination<FootPrintBean> paginationFetch) {
        pagination = paginationFetch;
        if(wait!=null){
            wait.dismiss();
            wait = null;
        }
        Log.i(logTag,"trackSearchDataFetchSuccess---->"+this.alt);
        new Thread(new Runnable() {
            @Override
            public void run() {
                String newTrackBeanIdStr = "";
                for (final FootPrintBean footPrintBean : pagination.getContent()) {
                    newTrackBeanIdStr = newTrackBeanIdStr + footPrintBean.getFootprintId();
                }
                Log.i(logTag,"trackSearchDataFetchSuccess-thread-start---->"+alt);
                int width = StaticMethod.dip2px(context, 28);
                if(!newTrackBeanIdStr.equals(preTrackBeanIdStr)){
                    //update activity
                    Message msg = new Message();
                    Bundle b = new Bundle();
                    b.putString("totalCount", paginationFetch.getTotalElements()+"");
                    b.putString("address", cache.get(StaticVar.BAIDU_LOC_CACHE_ADDRESS));
                    msg.setData(b);
                    ArFootPrintDrawActivity.handler.sendMessage(msg);
                    //update activity end
                    trackSearchVo.setTotalPages(paginationFetch.getTotalPages());
                    for (final FootPrintBean footPrintBean : pagination.getContent()) {
                        newTrackBeanIdStr =newTrackBeanIdStr + footPrintBean.getFootprintId();
                        try {
                            if (arFootPrintCacheMemoryService.getT(footPrintBean.getUserHeadImg(), Bitmap.class) == null) {
                                Bitmap bitmap = Glide.with(context)
                                        .load(footPrintBean.getUserHeadImg())
                                        .asBitmap()
                                        .diskCacheStrategy(DiskCacheStrategy.ALL)
                                        .into(width, width)
                                        .get();
                                bitmap = ImageDecoder.cut2Circular(bitmap,false);
                                arFootPrintCacheMemoryService.putObject(footPrintBean.getUserHeadImg(), bitmap);
                                Log.i(logTag, "put cache:" + footPrintBean.getUserHeadImg());
                            }
                            if(footPrintBean.getFootprintPhoto()!=null){
                                if (arFootPrintCacheMemoryService.getT(footPrintBean.getFootprintPhoto(), Bitmap.class) == null) {
                                    Log.i(logTag,"genCadhe:"+ footPrintBean.getFootprintPhoto());
                                    Bitmap bitmap = Glide.with(context)
                                            .load(footPrintBean.getFootprintPhoto())
                                            .asBitmap()
                                            .diskCacheStrategy(DiskCacheStrategy.ALL)
                                            .into(width, width)
                                            .get(10, TimeUnit.SECONDS);
                                    Log.i(logTag, "put cache:" + footPrintBean.getFootprintPhoto());
                                    arFootPrintCacheMemoryService.putObject(footPrintBean.getFootprintPhoto(), bitmap);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            Log.e(logTag, "cache image error", e);
                        }
                    }
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                preTrackBeanIdStr = newTrackBeanIdStr;
            }
        }).start();
    }
}




