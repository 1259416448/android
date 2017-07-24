package arvix.cn.ontheway.utils;

import android.text.TextUtils;
import android.text.format.DateFormat;

import org.w3c.dom.Text;

import java.util.Date;

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
}
