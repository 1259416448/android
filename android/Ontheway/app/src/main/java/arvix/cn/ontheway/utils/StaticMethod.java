package arvix.cn.ontheway.utils;

import android.text.TextUtils;
import android.text.format.DateFormat;
import android.widget.ImageView;

import org.w3c.dom.Text;
import org.xutils.image.ImageOptions;
import org.xutils.x;

import java.util.Date;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.service.inter.CacheInterface;

/**
 * Created by asdtiang on 2017/7/24 0024.
 * asdtiangxia@163.com
 */

public class StaticMethod {

    public static String genLesStr(String source,int maxLength){

        if(!TextUtils.isEmpty(source)){
            if(maxLength<source.length()){
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
        CacheInterface cache = OnthewayApplication.getInstahce(CacheInterface.class);
        return cache.get(StaticVar.HEADER_URL_CACHE_KEY);
    }

    public static void setCircularHeaderImg(ImageView imageView,int w,int h){
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
        x.image().bind(imageView, getUserHeaderUrl(), options);
    }
}
