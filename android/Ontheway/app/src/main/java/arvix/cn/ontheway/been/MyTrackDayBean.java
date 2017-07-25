package arvix.cn.ontheway.been;

import java.util.List;

/**
 * Created by asdtiang on 2017/7/25 0025.
 * asdtiangxia@163.com
 */

public class MyTrackDayBean {

    String day;
    List<MyTrackBean> trackBeanList;

    public String getDay() {
        return day;
    }

    public void setDay(String day) {
        this.day = day;
    }

    public List<MyTrackBean> getTrackBeanList() {
        return trackBeanList;
    }

    public void setTrackBeanList(List<MyTrackBean> trackBeanList) {
        this.trackBeanList = trackBeanList;
    }
}
