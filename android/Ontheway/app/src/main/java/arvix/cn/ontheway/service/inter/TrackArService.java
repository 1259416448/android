package arvix.cn.ontheway.service.inter;

import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.bean.TrackBean;
import arvix.cn.ontheway.bean.TrackSearchVo;

/**
 * Created by asdtiang on 2017/8/9 0009.
 * asdtiangxia@163.com
 */

public interface TrackArService {
    /**
     *
     * @param trackSearchVo
     * @param lastSearchResult
     * @return
     */
    Pagination<TrackBean> search(TrackSearchVo trackSearchVo,Pagination<TrackBean> lastSearchResult);
}
