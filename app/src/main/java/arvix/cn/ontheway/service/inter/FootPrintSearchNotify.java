package arvix.cn.ontheway.service.inter;

import android.os.Handler;

import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.bean.FootPrintSearchVo;

/**
 * Created by asdtiang on 2017/8/9 0009.
 * asdtiangxia@163.com
 */

public interface FootPrintSearchNotify<TrackBean> {
    void trackSearchDataFetchSuccess(FootPrintSearchVo trackSearchVo, Pagination<TrackBean> pagination, Handler handler);
}
