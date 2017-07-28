package arvix.cn.ontheway.utils;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;

/**
 * Created by yd on 2017/7/25.
 */

public class ImageUtil {
    public static Bitmap synthesis(Bitmap bg, float bgScaleX, float bgScaleY, Bitmap fg, float x, float y, float rotate,
                                   float scaleX, float scaleY) {
        if (bg == null) {
            return null;
        }
        int w = bg.getWidth();
        int h = bg.getHeight();
        Bitmap newb = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);// 创建一个新的和SRC长度宽度一样的位图
        Canvas canvas = new Canvas(newb);
        Paint p = new Paint();
        p.setAntiAlias(true);
        p.setFilterBitmap(true);

        canvas.drawBitmap(bg, 0, 0, p);
        canvas.save();
        if (fg != null && x != -1 && y != -1) {
            RectF rectF = new RectF(x / bgScaleX, y / bgScaleY, (x + fg.getWidth() * scaleX) / bgScaleX,
                    (y + fg.getHeight() * scaleY) / bgScaleY);
            canvas.rotate(rotate, rectF.centerX(), rectF.centerY());
            canvas.scale(scaleX / bgScaleX, scaleY / bgScaleY, rectF.left, rectF.top);
            canvas.drawBitmap(fg, rectF.left, rectF.top, p);
            canvas.restore();
        }

        return newb;
    }
}
