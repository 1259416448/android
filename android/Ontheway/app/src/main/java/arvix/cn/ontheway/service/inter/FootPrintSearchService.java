package arvix.cn.ontheway.service.inter;

import android.content.Context;

import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.bean.FootPrintBean;
import arvix.cn.ontheway.bean.FootPrintSearchVo;

/**
 * Created by asdtiang on 2017/8/9 0009.
 * asdtiangxia@163.com
 */

public interface FootPrintSearchService {
    /**
     *
     * @param context
     * @param trackSearchVo
     * @return
     */
    void search(Context context, FootPrintSearchVo trackSearchVo, FootPrintSearchNotify<FootPrintBean> trackSearchNotify);


    void fetchByUser(Context context,FootPrintSearchVo searchVo,Long userId,FootPrintSearchNotify<FootPrintBean> searchNotify);

}
