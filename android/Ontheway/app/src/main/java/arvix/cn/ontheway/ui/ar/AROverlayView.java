package arvix.cn.ontheway.ui.ar;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.location.Location;
import android.opengl.Matrix;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.util.TypeUtils;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MarkerOptions;
import com.baidu.mapapi.map.OverlayOptions;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.search.core.PoiInfo;
import com.baidu.mapapi.search.core.SearchResult;
import com.baidu.mapapi.search.poi.OnGetPoiSearchResultListener;
import com.baidu.mapapi.search.poi.PoiDetailResult;
import com.baidu.mapapi.search.poi.PoiIndoorResult;
import com.baidu.mapapi.search.poi.PoiResult;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.request.target.BitmapImageViewTarget;

import org.xutils.common.Callback;
import org.xutils.http.RequestParams;
import org.xutils.image.ImageOptions;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.atomic.AtomicInteger;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.ARPoint;
import arvix.cn.ontheway.bean.BaseResponse;
import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.bean.TrackBean;
import arvix.cn.ontheway.bean.UserInfo;
import arvix.cn.ontheway.data.TrackListData;
import arvix.cn.ontheway.http.ServerUrl;
import arvix.cn.ontheway.service.inter.BaiduPoiService;
import arvix.cn.ontheway.service.inter.CacheService;
import arvix.cn.ontheway.ui.track.TrackListAdapter;
import arvix.cn.ontheway.utils.GlideCircleTransform;
import arvix.cn.ontheway.utils.LocationHelper;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;
/**
 * Created by ntdat on 1/13/17.
 */

public class AROverlayView extends View {
    private String logTag = this.getClass().getName();
    Context context;
    private float[] rotatedProjectionMatrix = new float[16];
    private Location currentLocation;
    private double latAndLonAndAltLast = 0.0;
    private double alt;//海拔
    CacheService cache;
    private Pagination<JSONObject> pagination = new Pagination<JSONObject>();
    private Paint mBitPaint;
    private boolean isDrawing;
    public AROverlayView(Context context) {
        super(context);
        this.context = context;
        cache = OnthewayApplication.getInstahce(CacheService.class);
        updateLocationData();
        mBitPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mBitPaint.setFilterBitmap(true);
        mBitPaint.setDither(true);
    }

    public  void updateLocationData(){
        Double latCache = cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LAT);
        Double lonCache = 0.0;
        if(latCache!=null){
            lonCache = cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LON);
            Double  altCache =     cache.getDouble(StaticVar.BAIDU_LOC_CACHE_ALT);
            Log.i(this.getClass().getName(),"init location from cache");
            if(altCache==null){
                altCache = 0.0;
            }
            latAndLonAndAltLast = latCache + lonCache;
            this.alt = altCache;
            updateLocationData(latCache,lonCache);
        }
    }
    private void updateLocationData(double lat, double lon){
        if(lat==0.0&&lon==0.0){
            Log.w(this.getClass().getName(),"lat and lon is 0.0");
            return;
        }
        RequestParams requestParams = new RequestParams();
        requestParams.setUri( ServerUrl.TRACK_AR_LIST+"/ar");
        requestParams.addParameter("number",pagination.getNumber());
        requestParams.addParameter("size",pagination.getSize());
        requestParams.addParameter("latitude",lat);
        requestParams.addParameter("longitude",lon);

        x.http().get(requestParams, new Callback.CommonCallback<String>() {
            @Override
            public void onSuccess(String result) {
                try {
                    Log.i("onSuccess-->","result->"+result.toString());
                    BaseResponse<Pagination> response = StaticMethod.genResponse(result,Pagination.class);
                    if(response.getCode()==StaticVar.SUCCESS) {
                        Pagination paginationReturn = response.getBodyBean();
                        pagination = paginationReturn;
                        //GlideCircleTransform GlideCircleTransform = new GlideCircleTransform(context);
                        new Thread(new Runnable() {
                            @Override
                            public void run() {
                                for (final JSONObject jsonObject : pagination.getContent()) {
                                    int width = StaticMethod.dip2px(context,30);
                                    final TrackBean trackBean = TypeUtils.castToJavaBean(jsonObject, TrackBean.class);
                                    try{
                                    if(cache.getTMem(trackBean.getUserHeadImg(),Bitmap.class)==null){
                                        Bitmap bitmap = Glide.with(context)
                                                .load(trackBean.getUserHeadImg())
                                                .asBitmap()
                                                .diskCacheStrategy(DiskCacheStrategy.ALL)
                                                .into(width, width)
                                                .get();
                                        cache.putObjectMem(trackBean.getUserHeadImg(),bitmap);
                                        Log.i(logTag,"put cache:"+trackBean.getUserHeadImg());
                                    }
                                    if(cache.getTMem(trackBean.getFootprintPhoto(),Bitmap.class)==null){
                                        Bitmap bitmap = Glide.with(context)
                                                .load(trackBean.getFootprintPhoto())
                                                .asBitmap()
                                                .diskCacheStrategy(DiskCacheStrategy.ALL)
                                                .into(width, width)
                                                .get();
                                        Log.i(logTag,"put cache:"+trackBean.getFootprintPhoto());
                                        cache.putObjectMem(trackBean.getFootprintPhoto(),bitmap);
                                    }
                                    }catch (Exception e){
                                        e.printStackTrace();
                                        Log.e(logTag,"cache image error",e);
                                    }
                                }
                            }
                        }).start();
                    }else if(response.getCode() == StaticVar.ERROR){
                        StaticMethod.showToast("获取数据失败",context);
                    }else{
                        StaticMethod.showToast("获取数据失败" + response.getCode(),context);
                    }
                }catch (Exception e){
                    e.printStackTrace();
                }

            }
            @Override
            public void onError(Throwable throwable, boolean b) {
            }
            @Override
            public void onCancelled(CancelledException e) {
            }
            @Override
            public void onFinished() {
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
                    this.alt = currentLocation.getAltitude();
                    updateLocationData(currentLocation.getLatitude(),currentLocation.getLongitude());
                }else{
                    this.alt = 0.0;
                    updateLocationData(currentLocation.getLatitude(),currentLocation.getLongitude());
                }
            }
            latAndLonAndAltLast = tempSum;
        }
        this.invalidate();
    }
    private long lastOnDraw = 0;
    private String viewBitmapCachePrefix = "trackItem";
    private Bitmap bitmapTemp = null;

    @Override
    protected void onDraw(final  Canvas canvas) {
        super.onDraw(canvas);
        /*
        if((System.currentTimeMillis()-lastOnDraw)<2000){
            return;
        }
        lastOnDraw = System.currentTimeMillis();
        if(isDrawing){
            return;
        }*/
        if(this.pagination.getContent()!=null && this.pagination.getContent().size()>0){
            Location location;
            try {
                isDrawing = true;
                Log.i(logTag, "do onDraw------------------------------------>");
                int i=0;
                for (final JSONObject jsonObject : this.pagination.getContent()) {
                    final TrackBean trackBean = TypeUtils.castToJavaBean(jsonObject, TrackBean.class);
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


                        bitmapTemp = cache.getTMem(viewBitmapCachePrefix+trackBean.getFootprintId(),Bitmap.class);
                        if(bitmapTemp!=null){
                            Log.i(logTag,"load form cache bitmap drawX:"+drawX+",drawY:"+drawY+"  ");
                            canvas.drawBitmap(bitmapTemp, drawX, drawY, mBitPaint);
                        }else{
                            View convertView = LayoutInflater.from(context).inflate(R.layout.track_ar_item, null);
                            ViewHolder h = new ViewHolder();
                            x.view().inject(h, convertView);
                            h.addressTv.setText(StaticMethod.genLesStr(trackBean.getFootprintAddress(), 4));
                            h.timeTv.setText(trackBean.getDateCreatedStr());
                            h.contentTv.setText(StaticMethod.genLesStr(trackBean.getFootprintContent(), 6));
                            Bitmap headerBitmap = cache.getTMem(trackBean.getUserHeadImg(),Bitmap.class);
                            boolean headerLoaded = false;
                            boolean trackPhotoLoaded = false;
                            if(headerBitmap!=null){
                                h.userHeader.setImageBitmap(headerBitmap);
                                headerLoaded = true;
                            }
                            if (!TextUtils.isEmpty(trackBean.getFootprintPhoto())) {
                                Bitmap trackPhotoBitmap = cache.getTMem(trackBean.getFootprintPhoto(),Bitmap.class);
                                if(trackPhotoBitmap!=null){
                                    h.trackPhotoIv.setImageBitmap(trackPhotoBitmap);
                                    trackPhotoLoaded = true;
                                }
                            }else{
                                h.trackPhotoIv.setVisibility(GONE);
                                trackPhotoLoaded = true;
                            }
                            Log.i(logTag, "loadImage------->,drawX:"+drawX+",drawY:"+drawY+"  "+trackBean.getUserHeadImg());
                            bitmapTemp = StaticMethod.getViewBitmap(convertView);
                            canvas.drawBitmap(bitmapTemp, drawX, drawY, mBitPaint);
                            if(trackPhotoLoaded && headerLoaded){
                                cache.putObjectMem(viewBitmapCachePrefix+trackBean.getFootprintId(),bitmapTemp);
                            }
                            convertView.setDrawingCacheEnabled(false);
                        }
                        /*
                        Glide.with(context)
                                .load(trackBean.getUserHeadImg())
                                .asBitmap()
                                .into(new BitmapImageViewTarget(h.userHeader) {
                                    @Override
                                    protected void setResource(Bitmap resource) {
                                        //Play with bitmap
                                        super.setResource(resource);
                                        try {
                                            if (!TextUtils.isEmpty(trackBean.getFootprintPhoto())) {
                                                Log.i(logTag, "loadImage------->" + trackBean.getFootprintPhoto());
                                                Glide.with(context)
                                                        .load(trackBean.getFootprintPhoto())
                                                        .asBitmap()
                                                        .into(new BitmapImageViewTarget(h.trackPhotoIv) {
                                                            @Override
                                                            protected void setResource(Bitmap resource) {
                                                                //Play with bitmap
                                                                super.setResource(resource);
                                                                Log.i(logTag, "draw convertView------->"+trackBean.getUserHeadImg());
                                                                Bitmap trackBitmap = StaticMethod.getViewBitmap(convertView);
                                                                canvas.drawBitmap(trackBitmap, drawX, drawY, mBitPaint);
                                                                convertView.setDrawingCacheEnabled(false);
                                                            }
                                                        });
                                            } else {
                                                Log.i(logTag, "draw convertView------->"+trackBean.getUserHeadImg());
                                                Bitmap trackBitmap = StaticMethod.getViewBitmap(convertView);
                                                canvas.drawBitmap(trackBitmap, drawX, drawY, mBitPaint);
                                                convertView.setDrawingCacheEnabled(false);
                                            }
                                        }catch (Exception e){
                                            Log.e(logTag,"load image error",e);
                                            e.printStackTrace();
                                        }
                                    }
                                });*/
                    }
                }
            }catch (Exception e){
                Log.e(logTag,"load image error",e);
                e.printStackTrace();
            }finally {
                isDrawing = false;
            }
        }
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




