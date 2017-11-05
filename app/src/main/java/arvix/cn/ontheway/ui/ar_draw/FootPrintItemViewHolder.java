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

public class FootPrintItemViewHolder {
    @ViewInject(R.id.header_iv)
    public ImageView userHeader;

    @ViewInject(R.id.time_tv)
    public TextView timeTv;

    @ViewInject(R.id.content_tv)
    public TextView contentTv;
    @ViewInject(R.id.address_tv)
    public TextView addressTv;

    @ViewInject(R.id.main_photo_iv)
    public ImageView trackPhotoIv;

}