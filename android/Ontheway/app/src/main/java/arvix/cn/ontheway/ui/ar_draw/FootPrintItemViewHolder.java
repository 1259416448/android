package arvix.cn.ontheway.ui.ar_draw;

import android.widget.ImageView;
import android.widget.TextView;

import org.xutils.view.annotation.ViewInject;

import arvix.cn.ontheway.R;

/**
 * Created by asdtiang on 2017/8/22 0022.
 * asdtiangxia@163.com
 * footPrint item view
 */

class FootPrintItemViewHolder {
    @ViewInject(R.id.header_iv)
    ImageView userHeader;

    @ViewInject(R.id.time_tv)
    TextView timeTv;

    @ViewInject(R.id.content_tv)
    TextView contentTv;
    @ViewInject(R.id.address_tv)
    TextView addressTv;

    @ViewInject(R.id.main_photo_iv)
    ImageView trackPhotoIv;

}