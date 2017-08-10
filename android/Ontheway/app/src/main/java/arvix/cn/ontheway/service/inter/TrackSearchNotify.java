package arvix.cn.ontheway.service.inter;

import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.bean.TrackSearchVo;

/**
 * Created by asdtiang on 2017/8/9 0009.
 * asdtiangxia@163.com
 */

public interface TrackSearchNotify<TrackBean> {
    void trackSearchDataFetchSuccess(TrackSearchVo trackSearchVo, Pagination<TrackBean> pagination);
}
