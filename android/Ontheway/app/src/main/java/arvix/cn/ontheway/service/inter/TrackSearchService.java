package arvix.cn.ontheway.service.inter;

import android.content.Context;

import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.bean.TrackBean;
import arvix.cn.ontheway.bean.TrackSearchVo;

/**
 * Created by asdtiang on 2017/8/9 0009.
 * asdtiangxia@163.com
 */

public interface TrackSearchService {
    /**
     *
     * @param context
     * @param trackSearchVo
     * @return
     */
    Pagination<TrackBean> search(Context context,TrackSearchVo trackSearchVo,TrackSearchNotify<TrackBean> trackSearchNotify);

}
