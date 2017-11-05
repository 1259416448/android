package arvix.cn.ontheway.ui.ar_draw;

import arvix.cn.ontheway.bean.FootPrintBean;

/**
 * Created by asdtiang on 2017/8/22 0022.
 * asdtiangxia@163.com
 * 用于记录footPrint draw info信息
 */

public class DrawFootPrintItemInfo<T> {
    public DrawFootPrintItemInfo(float trackViewItemRectW, float trackViewItemRectH){
        rectWidth = trackViewItemRectW;
        rectHeight = trackViewItemRectH;
    }
    public float drawX;
    public float drawY;
    public T footPrintBean;
    public float rectWidth;
    public float rectHeight;
}
