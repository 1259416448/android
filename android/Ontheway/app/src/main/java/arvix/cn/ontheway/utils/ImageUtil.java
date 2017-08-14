package arvix.cn.ontheway.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;

import org.xutils.common.util.FileUtil;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

import arvix.cn.ontheway.App;

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

    private static int NUMBER_OF_RESIZE_ATTEMPTS = 4;

    private void testCompress(){
        byte[] newBuff=getResizedImageData(1024,1920,500*1024,80,new File(""), App.self);
    }

    public static byte[] getResizedImageData(int widthLimit, int heightLimit, int byteLimit, int minQuality, File file,
                                             Context context) {
        BitmapFactory.Options options = null;
        try {
            options = new BitmapFactory.Options();
            options.inJustDecodeBounds = true;
            InputStream in = new FileInputStream(file);

            BitmapFactory.decodeStream(in, null, options);
            in.close();
        } catch (Exception e) {
            return null;
        }
        int outHeight = options.outHeight;
        int outWidth = options.outWidth;

        float scaleFactor = 1.F;
        while ((outWidth * scaleFactor > widthLimit) || (outHeight * scaleFactor > heightLimit)) {
            scaleFactor *= .99F;
        }

        InputStream input = null;
        try {
            ByteArrayOutputStream os = null;
            int attempts = 1;
            int sampleSize = 1;
            options = new BitmapFactory.Options();
            int quality = 100;
            Bitmap b = null;

            // In this loop, attempt to decode the stream with the best possible
            // subsampling (we
            // start with 1, which means no subsampling - get the original
            // content) without running
            // out of memory.
            do {
                input = new FileInputStream(file);
                options.inSampleSize = sampleSize;
                try {
                    b = BitmapFactory.decodeStream(input, null, options);
                    if (b == null) {
                        return null; // Couldn't decode and it wasn't because of
                        // an exception,
                        // bail.
                    }
                } catch (OutOfMemoryError e) {
                    sampleSize *= 2; // works best as a power of two
                    attempts++;
                    continue;
                } finally {
                    if (input != null) {
                        try {
                            input.close();
                        } catch (IOException e) {
                        }
                    }
                }
            } while (b == null && attempts < NUMBER_OF_RESIZE_ATTEMPTS);

            if (b == null) {
                return null;
            }

            boolean resultTooBig = true;
            attempts = 1; // reset count for second loop
            // In this loop, we attempt to compress/resize the content to fit
            // the given dimension
            // and file-size limits.
            do {
                try {
                    if (options.outWidth > widthLimit || options.outHeight > heightLimit
                            || (os != null && os.size() > byteLimit)) {
                        // The decoder does not support the inSampleSize option.
                        // Scale the bitmap using Bitmap library.
                        int scaledWidth = (int) (outWidth * scaleFactor);
                        int scaledHeight = (int) (outHeight * scaleFactor);

                        b = Bitmap.createScaledBitmap(b, scaledWidth, scaledHeight, false);
                        if (b == null) {
                            return null;
                        }
                    }

                    // Compress the image into a JPG. Start with
                    // MessageUtils.IMAGE_COMPRESSION_QUALITY.
                    // In case that the image byte size is still too large
                    // reduce the quality in
                    // proportion to the desired byte size.
                    os = new ByteArrayOutputStream();
                    b.compress(Bitmap.CompressFormat.JPEG, quality, os);
                    int jpgFileSize = os.size();
                    if (jpgFileSize > byteLimit) {
                        quality = (quality * byteLimit) / jpgFileSize; // watch
                        // for
                        // int
                        // division!
                        if (quality < minQuality) {
                            quality = minQuality;
                        }

                        os = new ByteArrayOutputStream();
                        b.compress(Bitmap.CompressFormat.JPEG, quality, os);
                    }
                } catch (java.lang.OutOfMemoryError e) {
                    e.printStackTrace();
                }
                scaleFactor *= .99F;
                attempts++;
                resultTooBig = os == null || os.size() > byteLimit;
            } while (resultTooBig && attempts < NUMBER_OF_RESIZE_ATTEMPTS);
            b.recycle(); // done with the bitmap, release the memory

            return resultTooBig ? null : os.toByteArray();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return null;
        } catch (java.lang.OutOfMemoryError e) {
            e.printStackTrace();
            return null;
        }
    }
}
