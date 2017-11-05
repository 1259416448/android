package arvix.cn.ontheway.ui.ar_draw;

/**
 * Created by asdtiang on 2017/8/22 0022.
 * asdtiangxia@163.com
 * 雷达信息
 */

public class RadarPoint {
    public boolean isNegative = false;
    public double lat;
    public double lon;
    @Override
    public String toString() {
        return lat + ", " +lon;
    }
}
