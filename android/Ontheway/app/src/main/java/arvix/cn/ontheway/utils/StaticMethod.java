package arvix.cn.ontheway.utils;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.text.format.DateFormat;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.ImageView;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;
import com.alibaba.fastjson.util.TypeUtils;

import org.xutils.image.ImageOptions;
import org.xutils.x;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Date;
import java.util.Random;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.BaseResponse;
import arvix.cn.ontheway.bean.FootPrintBean;
import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.bean.UserInfo;
import arvix.cn.ontheway.service.inter.CacheService;
import arvix.cn.ontheway.ui.LoginActivity;
import arvix.cn.ontheway.ui.usercenter.MyProfileFragment;

/**
 * Created by asdtiang on 2017/7/24 0024.
 * asdtiangxia@163.com
 */

public class StaticMethod {

    /**
     * 根据手机的分辨率从 dp 的单位 转成为 px(像素)
     */
    public static int dip2px(Context context, float dpValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
    }



    /**
     * 根据手机的分辨率从 px(像素) 的单位 转成为 dp
     */
    public static int px2dip(Context context, float pxValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }


    public static String genLesStr(String source,int maxLength){

        if(!TextUtils.isEmpty(source)){
            if(maxLength<source.length()){
                source = source.substring(0,maxLength)+"...";
            }
        }
        return source;
    }

    public static String genLesAddressStr(String source,int maxLength){

        if(!TextUtils.isEmpty(source)){
            if(maxLength<source.length()){
                source.replace("中国","");
                int shiIndex =  source.indexOf("市");
                if(shiIndex > -1){
                    source = source.substring(shiIndex);
                }
                int quIndex = source.indexOf("区");
                if(quIndex>-1){
                    source = source.substring(quIndex);
                }else{
                    int xianIndex = source.indexOf("县");
                    if(xianIndex>-1){
                        source = source.substring(xianIndex);
                    }else{
                        int zhengIndex = source.indexOf("镇");
                        if(zhengIndex>-1){
                            source = source.substring(zhengIndex);
                        }
                    }
                }
                source = source.substring(0,maxLength)+"...";
            }
        }
        return source;
    }

    public static String formatDate(long timeMils,String formatStr){
        Date date = new Date();
        date.setTime(timeMils);
        return DateFormat.format(formatStr,date).toString();
    }

    public static String getUserHeaderUrl(){
        return App.userInfo.getHeadImg();
    }

    public static void setCircularHeaderImg(ImageView imageView,int w,int h){
        setCircularHeaderImg(getUserHeaderUrl(),imageView,w,h);
    }

    public static void setImg(String url,ImageView imageView,int w,int h){
        //设置图片属性的options
        ImageOptions options = new ImageOptions.Builder()
                //设置图片的大小
                .setSize(w, h)
                // 如果ImageView的大小不是定义为wrap_content, 不要crop.
                .setCrop(true)
                // 加载中或错误图片的ScaleType
                //.setPlaceholderScaleType(ImageView.ScaleType.MATRIX)
                .setImageScaleType(ImageView.ScaleType.CENTER_CROP)
                //设置加载过程中的图片
                .setLoadingDrawableId(R.mipmap.ic_launcher)
                //设置加载失败后的图片
                .setFailureDrawableId(R.mipmap.ic_launcher)
                //设置使用缓存
                .setUseMemCache(true)
                //设置支持gif
                .setIgnoreGif(false).build();
        x.image().bind(imageView, url, options);
    }

    public static void setCircularHeaderImg(String headerUrl,ImageView imageView,int w,int h){
        //设置图片属性的options
        ImageOptions options = new ImageOptions.Builder()
                //设置图片的大小
                .setSize(w, h)
                // 如果ImageView的大小不是定义为wrap_content, 不要crop.
                .setCrop(true)
                // 加载中或错误图片的ScaleType
                //.setPlaceholderScaleType(ImageView.ScaleType.MATRIX)
                .setImageScaleType(ImageView.ScaleType.CENTER_CROP)
                //设置加载过程中的图片
                .setLoadingDrawableId(R.mipmap.ic_launcher)
                //设置加载失败后的图片
                .setFailureDrawableId(R.mipmap.ic_launcher)
                //设置使用缓存
                .setUseMemCache(true)
                //设置支持gif
                .setIgnoreGif(false)
                //设置显示圆形图片
                .setCircular(true).build();
        x.image().bind(imageView, headerUrl, options);
    }



    /**
     * 获取网落图片资源
     * @param url
     * @return
     */
    public static Bitmap getHttpBitmap(String url){
        URL myFileURL;
        Bitmap bitmap=null;
        try{

            myFileURL = new URL(url);
            //获得连接
            HttpURLConnection conn=(HttpURLConnection)myFileURL.openConnection();
            //设置超时时间为6000毫秒，conn.setConnectionTiem(0);表示没有时间限制
            conn.setConnectTimeout(6000);
            //连接设置获得数据流
            conn.setDoInput(true);
            //不使用缓存
            conn.setUseCaches(false);
            //这句可有可无，没有影响
            //conn.connect();
            //得到数据流
            InputStream is = conn.getInputStream();
            //解析得到图片
            bitmap = BitmapFactory.decodeStream(is);
            //关闭数据流
            is.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return bitmap;
    }

    public static  BaseResponse genResponse(String jsonStr){
        BaseResponse baseResponse = JSON.parseObject(jsonStr,BaseResponse.class);
        return baseResponse;
    }

    public static <T> BaseResponse<T> genResponse(String jsonStr,Class<T> bodyType){
        BaseResponse baseResponse = JSON.parseObject(jsonStr,new TypeReference<BaseResponse<Pagination<FootPrintBean>>>(){});
        baseResponse.setBodyBean(TypeUtils.castToJavaBean(baseResponse.getBody(), bodyType));
        return baseResponse;
    }

    public static int getStatusBarHeight(Context context) {
        Class<?> c = null;
        Object obj = null;
        Field field = null;
        int x = 0, sbar = 0;
        try {
            c = Class.forName("com.android.internal.R$dimen");

            obj = c.newInstance();

            field = c.getField("status_bar_height");

            x = Integer.parseInt(field.get(obj).toString());

            sbar = context.getResources().getDimensionPixelSize(x);
        } catch (Exception e1) {

            e1.printStackTrace();

        }
        return sbar;
    }



    public static String genSexShow(){
        String sex = "保密";
        if("man".equals(App.userInfo.getGender())){
            sex = "男";
        }
        if("woman".equals(App.userInfo.getGender())){
            sex = "女";
        }
        return  sex;
    }
    public static String genPhoneShow(){
        String phone = App.userInfo.getMobilePhoneNumber();
        if(phone!=null && phone.length()==11){
            phone = phone.substring(0,3)+"*****" + phone.substring(8);
        }
        return phone;
    }

    public static int  goToLogin(Activity activity){
        CacheService cache = OnthewayApplication.getInstahce(CacheService.class);
        Log.i("goToLogin:","cache.get(StaticVar.AUTH_TOKEN)------------->:"+cache.get(StaticVar.AUTH_TOKEN));
        if(cache.get(StaticVar.AUTH_TOKEN)!=null){
            return 0;
        }else{
            int randomInt = new Random().nextInt(Integer.MAX_VALUE);
            Intent intent = new Intent(activity, LoginActivity.class);
            activity.startActivityForResult(intent, randomInt);
            return randomInt;
        }
    }

    public static void showToast(String text,Context context){
        Toast toast = Toast.makeText(context,
                text, Toast.LENGTH_LONG);
        toast.setGravity(Gravity.CENTER, 0, 0);
        toast.show();
    }
    /**
     * 把Bitmap转Byte
     * @Author HEH
     * @EditTime 2010-07-19 上午11:45:56
     */
    public static byte[] bitmap2Bytes(Bitmap bm){
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        bm.compress(Bitmap.CompressFormat.PNG, 100, baos);
        return baos.toByteArray();
    }


    public static void updateUserInfo(Activity activity,UserInfo userInfo){
        CacheService cache = OnthewayApplication.getInstahce(CacheService.class);
        cache.putObject(StaticVar.USER_INFO,userInfo);
        cache.putObjectMem(StaticVar.USER_INFO,userInfo);
        App.userInfo = userInfo;
        LocalBroadcastManager.getInstance(activity).sendBroadcast(new Intent(StaticVar.BROADCAST_ACTION_USER_CHANGE));
    }

    public static Bitmap getViewBitmap(View addViewContent) {
        addViewContent.setDrawingCacheEnabled(true);
        addViewContent.measure(View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED));
        addViewContent.layout(0, 0, addViewContent.getMeasuredWidth(), addViewContent.getMeasuredHeight());
        addViewContent.buildDrawingCache();
        Bitmap cacheBitmap = addViewContent.getDrawingCache();
        Bitmap bitmap = Bitmap.createBitmap(cacheBitmap);
        return bitmap;
    }


}
