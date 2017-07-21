package arvix.cn.ontheway.service;

import android.content.Context;
import android.content.Intent;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.Poi;

import java.util.List;

import arvix.cn.ontheway.BaiduActivity;
import arvix.cn.ontheway.service.inter.CacheInterface;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticVar;

/**
 * Created by asdtiang on 2017/7/18 0018.
 */

public class BaiduLocationListenerService implements BDLocationListener {
    public static String BROADCAST_LOCATION = "broadcastLocation";
    public static String EXTRA_LAT="extraLat";
    public static String EXTRA_LON="extraLon";
    private static java.text.DecimalFormat df = new java.text.DecimalFormat("#.000");
    private static String lastLatAndLong = "";
    private Context context;

    public BaiduLocationListenerService(Context context){
        this.context = context;
    }


    private void cacheLoc(BDLocation location) {
        //TODO cache less
        String latAndLong = df.format(location.getLatitude()) + df.format(location.getLongitude());
        Log.i(BaiduLocationListenerService.class.getName(), "lastLatAndLong:" + lastLatAndLong + " latAndLong:" + latAndLong);
        if (!latAndLong.equals(lastLatAndLong)) {
            CacheInterface cache = OnthewayApplication.getInstahce(CacheInterface.class);
            cache.put(StaticVar.BAIDU_LOC_CACHE_LAT, location.getLatitude() + "");
            cache.put(StaticVar.BAIDU_LOC_CACHE_LON, location.getLongitude() + "");
            if(location.hasAltitude()){
                cache.put(StaticVar.BAIDU_LOC_CACHE_ALT, location.getAltitude() + "");
            }
        }
    }

    @Override
    public void onReceiveLocation(BDLocation location) {


        //获取定位结果
        StringBuffer sb = new StringBuffer(256);

        sb.append("time : ");
        sb.append(location.getTime());    //获取定位时间

        sb.append("\nerror code : ");
        sb.append(location.getLocType());    //获取类型类型

        sb.append("\nlatitude : ");
        sb.append(location.getLatitude());    //获取纬度信息

        sb.append("\nlontitude : ");
        sb.append(location.getLongitude());    //获取经度信息

        sb.append("\nradius : ");
        sb.append(location.getRadius());    //获取定位精准度
        Intent intent = new Intent();
        intent.putExtra(EXTRA_LAT,location.getLatitude());
        intent.putExtra(EXTRA_LON,location.getLongitude());
        LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
        cacheLoc(location);
        if (location.getLocType() == BDLocation.TypeGpsLocation) {

            // GPS定位结果
            sb.append("\nspeed : ");
            sb.append(location.getSpeed());    // 单位：公里每小时

            sb.append("\nsatellite : ");
            sb.append(location.getSatelliteNumber());    //获取卫星数

            sb.append("\nheight : ");
            sb.append(location.getAltitude());    //获取海拔高度信息，单位米

            sb.append("\ndirection : ");
            sb.append(location.getDirection());    //获取方向信息，单位度

            sb.append("\naddr : ");
            sb.append(location.getAddrStr());    //获取地址信息

            sb.append("\ndescribe : ");
            sb.append("gps定位成功");

        } else if (location.getLocType() == BDLocation.TypeNetWorkLocation) {

            // 网络定位结果
            sb.append("\naddr : ");
            sb.append(location.getAddrStr());    //获取地址信息

            sb.append("\noperationers : ");
            sb.append(location.getOperators());    //获取运营商信息

            sb.append("\ndescribe : ");
            sb.append("网络定位成功");

        } else if (location.getLocType() == BDLocation.TypeOffLineLocation) {

            // 离线定位结果
            sb.append("\ndescribe : ");
            sb.append("离线定位成功，离线定位结果也是有效的");

        } else if (location.getLocType() == BDLocation.TypeServerError) {

            sb.append("\ndescribe : ");
            sb.append("服务端网络定位失败，可以反馈IMEI号和大体定位时间到loc-bugs@baidu.com，会有人追查原因");

        } else if (location.getLocType() == BDLocation.TypeNetWorkException) {

            sb.append("\ndescribe : ");
            sb.append("网络不同导致定位失败，请检查网络是否通畅");

        } else if (location.getLocType() == BDLocation.TypeCriteriaException) {

            sb.append("\ndescribe : ");
            sb.append("无法获取有效定位依据导致定位失败，一般是由于手机的原因，处于飞行模式下一般会造成这种结果，可以试着重启手机");

        }

        sb.append("\nlocationdescribe : ");
        sb.append(location.getLocationDescribe());    //位置语义化信息

        List<Poi> list = location.getPoiList();    // POI数据
        if (list != null) {
            sb.append("\npoilist size = : ");
            sb.append(list.size());
            for (Poi p : list) {
                sb.append("\npoi= : ");
                sb.append(p.getId() + " " + p.getName() + " " + p.getRank());
            }
        }

        Log.i("BaiduLocationApiDem", sb.toString());
    }

    public void onConnectHotSpotMessage(String var1, int var2) {
        Log.i("onConnectHot----》", var1);
    }


}
