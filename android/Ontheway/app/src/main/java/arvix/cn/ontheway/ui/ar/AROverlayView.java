package arvix.cn.ontheway.ui.ar;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.location.Location;
import android.opengl.Matrix;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.util.TypeUtils;
import com.bumptech.glide.DrawableRequestBuilder;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.resource.drawable.GlideDrawable;
import com.bumptech.glide.request.FutureTarget;
import com.bumptech.glide.request.animation.GlideAnimation;
import com.bumptech.glide.request.target.SimpleTarget;

import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.image.ImageDecoder;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.BaseResponse;
import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.bean.TrackBean;
import arvix.cn.ontheway.bean.TrackSearchVo;
import arvix.cn.ontheway.http.ServerUrl;
import arvix.cn.ontheway.service.inter.CacheService;
import arvix.cn.ontheway.service.inter.TrackSearchNotify;
import arvix.cn.ontheway.service.inter.TrackSearchService;
import arvix.cn.ontheway.utils.LocationHelper;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;

/**
 * Created by ntdat on 1/13/17.
 */

public class AROverlayView extends View implements TrackSearchNotify<TrackBean>{
    private String logTag = this.getClass().getName();
    Context context;
    private float[] rotatedProjectionMatrix = new float[16];
    private Location currentLocation;
    private double latAndLonAndAltLast = 0.0;
    private double alt;//海拔
    CacheService cache;
    TrackSearchService trackSearchService;
    private Pagination<TrackBean> pagination = new Pagination<>();
    private Pagination<TrackBean> prePagination = new Pagination<>();
    private Paint mBitPaint;
    private String viewBitmapCachePrefix = "trackItem";
    private Bitmap bitmapTemp = null;
    private String rePointKeyTemp = "";
    private int drawXOffset = 0;
    private int drawYOffset = 0;
    private ViewGroup rootView;
    private TrackSearchVo trackSearchVo;


    public AROverlayView(Context context, ViewGroup rootView,TrackSearchVo trackSearchVo) {
        super(context);
        this.context = context;
        this.rootView = rootView;
        this.trackSearchVo = trackSearchVo;
        cache = OnthewayApplication.getInstahce(CacheService.class);
        trackSearchService = OnthewayApplication.getInstahce(TrackSearchService.class);
        mBitPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mBitPaint.setFilterBitmap(true);
        mBitPaint.setDither(true);
        drawXOffset = StaticMethod.dip2px(context, 0);
        drawYOffset = StaticMethod.dip2px(context, 50);
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
        trackSearchVo.setLatitude(lat);
        trackSearchVo.setLongitude(lon);
        trackSearchVo.setSearchType(TrackSearchVo.SearchType.ar);
        trackSearchService.search(context,trackSearchVo,this);
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

    private Map<Long,DrawPoint> drawPointMap = new HashMap<>();

    private class DrawPoint {
        int drawX;
        int drawY;
    }

    @Override
    protected void onDraw(final Canvas canvas) {
        super.onDraw(canvas);
        if (this.pagination.getContent() != null && this.pagination.getContent().size() > 0) {
            Location location;
            try {
                Log.i(logTag, "do onDraw------------------------------------>");
                Map<String, Integer> drawPointRePointMap = new HashMap<String, Integer>();
                for ( final TrackBean trackBean : this.pagination.getContent()) {
                    location = new Location(trackBean.getFootprintContent());
                    location.setLatitude(trackBean.getLatitude());
                    location.setLongitude(trackBean.getLongitude());
                    location.setAltitude(this.alt);
                    float[] currentLocationInECEF = LocationHelper.WSG84toECEF(currentLocation);
                    float[] pointInECEF = LocationHelper.WSG84toECEF(location);
                    float[] pointInENU = LocationHelper.ECEFtoENU(currentLocation, currentLocationInECEF, pointInECEF);
                    float[] cameraCoordinateVector = new float[4];
                    Matrix.multiplyMV(cameraCoordinateVector, 0, rotatedProjectionMatrix, 0, pointInENU, 0);
                    // cameraCoordinateVector[2] is z, that always less than 0 to display on right position
                    // if z > 0, the point will display on the opposite
                    if (cameraCoordinateVector[2] < 0) {
                        ArTrackActivity.tvCurrentLocation.setText(System.currentTimeMillis() + " show:" + cameraCoordinateVector[2]);
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
                        bitmapTemp = cache.getTMem(viewBitmapCachePrefix + trackBean.getFootprintId(), Bitmap.class);
                        if (bitmapTemp != null) {
                            Log.i(logTag, "load form cache bitmap drawX:" + drawX + ",drawY:" + drawY + "  ");
                            canvas.drawBitmap(bitmapTemp, drawX, drawY, mBitPaint);
                        } else {
                            View convertView = LayoutInflater.from(context).inflate(R.layout.track_ar_item, rootView, false);
                            ViewHolder h = new ViewHolder();
                            x.view().inject(h, convertView);
                            h.addressTv.setText(StaticMethod.genLesStr(trackBean.getFootprintAddress(), 4));
                            h.timeTv.setText(trackBean.getDateCreatedStr());
                            h.contentTv.setText(StaticMethod.genLesStr(trackBean.getFootprintContent(), 6));
                            Bitmap headerBitmap = cache.getTMem(trackBean.getUserHeadImg(), Bitmap.class);
                            boolean headerLoaded = false;
                            boolean trackPhotoLoaded = false;
                            Log.i(logTag,"h.userHeader--->"+h.userHeader.getLayoutParams().width+ " "+StaticMethod.dip2px(context, 28));
                            if (headerBitmap != null) {
                                h.userHeader.setImageBitmap(headerBitmap);
                                headerLoaded = true;
                            }
                            if (!TextUtils.isEmpty(trackBean.getFootprintPhoto())) {
                                Bitmap trackPhotoBitmap = cache.getTMem(trackBean.getFootprintPhoto(), Bitmap.class);
                                if (trackPhotoBitmap != null) {
                                    h.trackPhotoIv.setImageBitmap(trackPhotoBitmap);
                                    trackPhotoLoaded = true;
                                }
                            } else {
                                h.trackPhotoIv.setVisibility(GONE);
                                trackPhotoLoaded = true;
                            }
                          //  Log.i(logTag, "loadImage------->,drawX:" + drawX + ",drawY:" + drawY + "  " + trackBean.getUserHeadImg());
                            bitmapTemp = StaticMethod.getViewBitmap(convertView);
                            canvas.drawBitmap(bitmapTemp, drawX, drawY, mBitPaint);
                            if (trackPhotoLoaded && headerLoaded) {
                                cache.putObjectMem(viewBitmapCachePrefix + trackBean.getFootprintId(), bitmapTemp);
                            }
                            convertView.setDrawingCacheEnabled(false);
                        }
                    }
                }
            } catch (Exception e) {
                Log.e(logTag, "load image error", e);
                e.printStackTrace();
            }
        }
    }


    public  void clearData() {
        Log.i(logTag,"clear data---------------------------------->");
        clearCache(pagination);
        clearCache(prePagination);
    }

    private void clearCache(Pagination<TrackBean> clearCachePage){
        Log.i(logTag,"clearCache data---------------------------------->");
        if(clearCachePage!=null && clearCachePage.getContent()!=null){
            for (final TrackBean trackBean : clearCachePage.getContent()) {
                cache.remove(viewBitmapCachePrefix + trackBean.getFootprintId());
                cache.remove(trackBean.getUserHeadImg());
                if(trackBean.getFootprintPhoto()!=null){
                    cache.remove(trackBean.getFootprintPhoto());
                }
            }
        }
    }
    private String preTrackBeanIdStr = "";
    /**
     * 查询数据回调实现
     * @param trackSearchVo
     * @param paginationFetch
     */
    @Override
    public void trackSearchDataFetchSuccess(TrackSearchVo trackSearchVo, Pagination<TrackBean> paginationFetch) {
        prePagination = pagination;
        pagination = paginationFetch;
        Log.i(logTag,"trackSearchDataFetchSuccess---->"+this.alt);
        new Thread(new Runnable() {
            @Override
            public void run() {
                String newTrackBeanIdStr = "";
                for (final TrackBean trackBean : pagination.getContent()) {
                    newTrackBeanIdStr = newTrackBeanIdStr + trackBean.getFootprintId();
                }
                Log.i(logTag,"trackSearchDataFetchSuccess-thread-start---->"+alt);
                int width = StaticMethod.dip2px(context, 28);
                if(!newTrackBeanIdStr.equals(preTrackBeanIdStr)){
                    for (final TrackBean trackBean : pagination.getContent()) {

                        newTrackBeanIdStr =newTrackBeanIdStr + trackBean.getFootprintId();
                        try {
                            if (cache.getTMem(trackBean.getUserHeadImg(), Bitmap.class) == null) {
                                Bitmap bitmap = Glide.with(context)
                                        .load(trackBean.getUserHeadImg())
                                        .asBitmap()
                                        .diskCacheStrategy(DiskCacheStrategy.ALL)
                                        .into(width, width)
                                        .get();
                                // bitmap = ImageDecoder.cut2ScaleSize(bitmap,width-20, width-20,false);
                                bitmap = ImageDecoder.cut2Circular(bitmap,false);
                                cache.putObjectMem(trackBean.getUserHeadImg(), bitmap);
                                Log.i(logTag, "put cache:" + trackBean.getUserHeadImg());
                            }
                            if (cache.getTMem(trackBean.getFootprintPhoto(), Bitmap.class) == null) {
                                Log.i(logTag,"genCadhe:"+trackBean.getFootprintPhoto());
                                Bitmap bitmap = Glide.with(context)
                                        .load(trackBean.getFootprintPhoto())
                                        .asBitmap()
                                        .diskCacheStrategy(DiskCacheStrategy.ALL)
                                        .into(width, width)
                                        .get(10, TimeUnit.SECONDS);
                                Log.i(logTag, "put cache:" + trackBean.getFootprintPhoto());
                                cache.putObjectMem(trackBean.getFootprintPhoto(), bitmap);
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
                    clearCache(prePagination);
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




