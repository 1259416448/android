package arvix.cn.ontheway.ui.ar;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
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
import android.widget.ImageView;
import android.widget.TextView;

import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.utils.DistanceUtil;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;

import org.xutils.image.ImageDecoder;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.bean.FootPrintBean;
import arvix.cn.ontheway.bean.FootPrintSearchVo;
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

public class AROverlayView extends View implements FootPrintSearchNotify<FootPrintBean>, View.OnTouchListener {
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
    private Bitmap bitmapTemp = null;
    private String rePointKeyTemp = "";
    private int drawXOffset = 0;
    private int drawYOffset = 0;
    private ViewGroup rootView;
    MyProgressDialog wait;
    private FootPrintSearchVo trackSearchVo;
    Paint circlePaint ;
    Paint centerPaint ;
    Paint pointPaint;
    public static float xDegrees;
    public static float yDegrees;
    private List<DrawTrackPointInfo> drawTrackPointInfoList = new ArrayList<>();
    private float trackViewItemRectW = 0.0f;
    private float trackViewItemRectH = 0.0f;
    private float computeTouchDiffY = 0.0f;
    public AROverlayView(Context context, ViewGroup rootView,FootPrintSearchVo trackSearchVo) {
        super(context);
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
        trackViewItemRectW = StaticMethod.dip2px(context, 164);
        trackViewItemRectH = StaticMethod.dip2px(context, 41);
        circlePaint = new Paint();
        circlePaint.setAntiAlias(true); //設置畫筆為無鋸齒
        circlePaint.setColor(Color.WHITE); //設置畫筆顏色
        circlePaint.setStrokeWidth((float) 3.0); //線寬
        circlePaint.setStyle(Paint.Style.STROKE); //空心效果

        centerPaint = new Paint();
        centerPaint.setAntiAlias(true); //設置畫筆為無鋸齒
        centerPaint.setColor(Color.WHITE); //設置畫筆顏色

        pointPaint= new Paint();
        pointPaint.setAntiAlias(true); //設置畫筆為無鋸齒
        pointPaint.setColor(Color.RED); //設置畫筆顏色

        rootView.setOnTouchListener(this);
        computeTouchDiffY = StaticMethod.getStatusBarHeight(context);
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


    private String oldRotateStr = "";
    private String newRotateStr = "";
    private float[] oldrotatedProjectionMatrix = new float[16];
    java.text.DecimalFormat   df   =new   java.text.DecimalFormat("#.00");

    public void updateRotatedProjectionMatrix(float[] rotatedProjectionMatrix) {
        this.rotatedProjectionMatrix = rotatedProjectionMatrix;
        newRotateStr = "";
        float diffAbs = 0;
        for(int i=0;i<rotatedProjectionMatrix.length;i++){
            newRotateStr = newRotateStr +"-"+  df.format(rotatedProjectionMatrix[i]);
            diffAbs = diffAbs + Math.abs(rotatedProjectionMatrix[i] - oldrotatedProjectionMatrix[i]);
        }
        if(diffAbs>0.5){
            Log.i(logTag,"updateRotatedProjectionMatrix--->change  new"  + newRotateStr);
            Log.i(logTag,"updateRotatedProjectionMatrix--->change  old"  + oldRotateStr);
            this.invalidate();
            oldrotatedProjectionMatrix = rotatedProjectionMatrix;
            oldRotateStr = newRotateStr;
        }
    }

    public void updateCurrentLocation(Location currentLocation) {
        this.currentLocation = currentLocation;
        if (this.currentLocation != null) {
            double tempSum = this.currentLocation.getLatitude() + this.currentLocation.getLongitude() + currentLocation.getAltitude();
            if (Math.abs(tempSum - latAndLonAndAltLast) > 0.0001) {
                if (currentLocation.hasAltitude()) {
                    this.alt = currentLocation.getAltitude();
                    updateLocationData(currentLocation.getLatitude(), currentLocation.getLongitude());
                } else {
                    this.alt = 0.0;
                    updateLocationData(currentLocation.getLatitude(), currentLocation.getLongitude());
                }
            }
            Log.i(logTag,"currentLocation--->change");
            this.invalidate();
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
                        StaticMethod.showToast(footPrintBean.getFootprintContent(),context);
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
        if(drawTrackPointInfoList.size()>0){
            DrawTrackPointInfo drawTrackPointInfo;
            for(int i=drawTrackPointInfoList.size()-1;i>=0;i-- ){
                drawTrackPointInfo = drawTrackPointInfoList.get(i);
                Log.i(logTag,"touch--->touchX:"+touchX+",touchY:"+touchY +",drawX:"+drawTrackPointInfo.drawX+",drawY:"+drawTrackPointInfo.drawY
                        +",rectHeight:"+drawTrackPointInfo.rectHeight +",rectWidth:"+drawTrackPointInfo.rectWidth +"    " + drawTrackPointInfo.footPrintBean.getFootprintContent());
                if( drawTrackPointInfo.drawX < touchX &&  touchX < (drawTrackPointInfo.drawX + drawTrackPointInfo.rectWidth)
                && drawTrackPointInfo.drawY < touchY && touchY <  (drawTrackPointInfo.drawY + drawTrackPointInfo.rectHeight)   ){
                    footPrintBean = drawTrackPointInfo.footPrintBean;
                    break;
                }
            }
        }
        return footPrintBean;
    }

    private class DrawTrackPointInfo {
        public DrawTrackPointInfo(){
            rectWidth = trackViewItemRectW;
            rectHeight = trackViewItemRectH;
        }
        float drawX;
        float drawY;
        FootPrintBean footPrintBean;
        float rectWidth;
        float rectHeight;
    }


    @Override
    protected void onDraw(final Canvas canvas) {
        super.onDraw(canvas);
        if (this.pagination.getContent() != null && this.pagination.getContent().size() > 0) {
            Location location;
            try {
                Log.i(logTag, "do onDraw------------------------------------>");
                Map<String, Integer> drawPointRePointMap = new HashMap<String, Integer>();
                LatLng center = new LatLng(cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LAT),cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LON));
                LatLng target = null;
                float radius = StaticMethod.dip2px(context,20*1.414213562f);
                float cx = StaticMethod.dip2px(context,55);
                float cy = canvas.getHeight() - StaticMethod.dip2px(context,55);
                List<DrawTrackPointInfo> drawTrackPointInfoListTemp = new ArrayList<>();
                DrawTrackPointInfo pointInfo = null;
                //for start
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
                    float radarX = (float) (drawX%radius*Math.cos(xDegrees));
                    float radarY = (float) (drawY%radius*Math.cos(yDegrees));
                    pointInfo = new DrawTrackPointInfo();
                    pointInfo.footPrintBean = footPrintBean;
                    pointInfo.drawY = drawY;
                    pointInfo.drawX = drawX;
                    if (cameraCoordinateVector[2] < 0) {
                        drawTrackPointInfoListTemp.add(pointInfo);
                        Log.i(logTag, "drawRadar point radarX:" + radarX + ",radarY:" + radarY + "  radius:"+radius);

                        ArFootPrintActivity.tvCurrentLocation.setText(System.currentTimeMillis() + " show:" + cameraCoordinateVector[2]);
                        bitmapTemp = dataCache.getTMem(viewBitmapCachePrefix + footPrintBean.getFootprintId(), Bitmap.class);
                        if (bitmapTemp != null) {
                            Log.i(logTag, "load form cache bitmap drawX:" + drawX + ",drawY:" + drawY + "  ");
                            canvas.drawBitmap(bitmapTemp, drawX, drawY, mBitPaint);
                        } else {
                            View convertView = LayoutInflater.from(context).inflate(R.layout.track_ar_item, rootView, false);
                            ViewHolder h = new ViewHolder();
                            x.view().inject(h, convertView);
                            h.addressTv.setText(StaticMethod.genLesStr(footPrintBean.getFootprintAddress(), 4));
                            h.timeTv.setText(footPrintBean.getDateCreatedStr());
                            h.contentTv.setText(StaticMethod.genLesStr(footPrintBean.getFootprintContent(), 6));
                            Bitmap headerBitmap = dataCache.getTMem(footPrintBean.getUserHeadImg(), Bitmap.class);
                            boolean headerLoaded = false;
                            boolean trackPhotoLoaded = false;
                            Log.i(logTag,"h.userHeader--->"+h.userHeader.getLayoutParams().width+ " "+StaticMethod.dip2px(context, 28));
                            if (headerBitmap != null) {
                                h.userHeader.setImageBitmap(headerBitmap);
                                headerLoaded = true;
                            }
                            if (!TextUtils.isEmpty(footPrintBean.getFootprintPhoto())) {
                                Bitmap trackPhotoBitmap = dataCache.getTMem(footPrintBean.getFootprintPhoto(), Bitmap.class);
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
                                dataCache.putObjectMem(viewBitmapCachePrefix + footPrintBean.getFootprintId(), bitmapTemp);
                            }
                            convertView.setDrawingCacheEnabled(false);
                        }
                    }
                    canvas.drawCircle(cx - radarX,cy - radarY,StaticMethod.dip2px(context,2),pointPaint);
                }
                // for end
                this.drawTrackPointInfoList = drawTrackPointInfoListTemp;
            } catch (Exception e) {
                Log.e(logTag, "load image error", e);
                e.printStackTrace();
            }
        }
    }



    protected void onDestroy() {
        dataCache.clear();
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
                    ArFootPrintActivity.handler.sendMessage(msg);
                    //update activity end
                    trackSearchVo.setTotalPages(paginationFetch.getTotalPages());
                    for (final FootPrintBean footPrintBean : pagination.getContent()) {
                        newTrackBeanIdStr =newTrackBeanIdStr + footPrintBean.getFootprintId();
                        try {
                            if (dataCache.getTMem(footPrintBean.getUserHeadImg(), Bitmap.class) == null) {
                                Bitmap bitmap = Glide.with(context)
                                        .load(footPrintBean.getUserHeadImg())
                                        .asBitmap()
                                        .diskCacheStrategy(DiskCacheStrategy.ALL)
                                        .into(width, width)
                                        .get();
                                // bitmap = ImageDecoder.cut2ScaleSize(bitmap,width-20, width-20,false);
                                bitmap = ImageDecoder.cut2Circular(bitmap,false);
                                dataCache.putObjectMem(footPrintBean.getUserHeadImg(), bitmap);
                                Log.i(logTag, "put cache:" + footPrintBean.getUserHeadImg());
                            }
                            if(footPrintBean.getFootprintPhoto()!=null){
                                if (dataCache.getTMem(footPrintBean.getFootprintPhoto(), Bitmap.class) == null) {
                                    Log.i(logTag,"genCadhe:"+ footPrintBean.getFootprintPhoto());
                                    Bitmap bitmap = Glide.with(context)
                                            .load(footPrintBean.getFootprintPhoto())
                                            .asBitmap()
                                            .diskCacheStrategy(DiskCacheStrategy.ALL)
                                            .into(width, width)
                                            .get(10, TimeUnit.SECONDS);
                                    Log.i(logTag, "put cache:" + footPrintBean.getFootprintPhoto());
                                    dataCache.putObjectMem(footPrintBean.getFootprintPhoto(), bitmap);
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




