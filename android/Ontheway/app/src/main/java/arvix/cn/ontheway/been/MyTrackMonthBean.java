package arvix.cn.ontheway.been;

import java.util.List;

/**
 * Created by asdtiang on 2017/7/25 0025.
 * asdtiangxia@163.com
 */

public class MyTrackMonthBean {

    String month;
    List<MyTrackDayBean> trackDayList;

    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }

    public List<MyTrackDayBean> getTrackDayList() {
        return trackDayList;
    }

    public void setTrackDayList(List<MyTrackDayBean> trackDayList) {
        this.trackDayList = trackDayList;
    }
}
