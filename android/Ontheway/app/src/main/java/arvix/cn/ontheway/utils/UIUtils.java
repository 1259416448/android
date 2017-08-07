package arvix.cn.ontheway.utils;

import android.app.ActivityManager;
import android.app.ActivityManager.RunningTaskInfo;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ResolveInfo;
import android.content.res.Configuration;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.webkit.MimeTypeMap;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.regex.Pattern;

import arvix.cn.ontheway.R;

/**
 * @author shiner
 */
public class UIUtils {
    public static final String TAG = "UIUtils";
    public static final int ANIMATION_FADE_IN_TIME = 250;
    public static SimpleDateFormat dateFormate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    public static SimpleDateFormat dateFormateNoSecond = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    private static Handler uiHandler = new Handler(Looper.getMainLooper());

    public static boolean isGoogleTV(Context context) {
        return context.getPackageManager().hasSystemFeature("com.google.android.tv");
    }

    public static boolean hasFroyo() {
        // Can use static final constants like FROYO, declared in later versions
        // of the OS since they are inlined at compile time. This is guaranteed
        // behavior.
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.FROYO;
    }

    public static boolean hasGingerbread() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.GINGERBREAD;
    }

    public static boolean hasHoneycomb() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB;
    }

    public static boolean hasHoneycombMR1() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR1;
    }

    public static boolean hasICS() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH;
    }

    public static boolean hasJellyBean() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN;
    }

    public static boolean hasJellyBeanMr1() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1;
    }

    public static boolean hasJellyBeanMr2() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2;
    }

    public static boolean hasLOLLIPOP() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP;
    }

    public static boolean isTablet(Context context) {
        return (context.getResources().getConfiguration().screenLayout
                & Configuration.SCREENLAYOUT_SIZE_MASK) >= Configuration.SCREENLAYOUT_SIZE_LARGE;
    }

    public static boolean isHoneycombTablet(Context context) {
        return hasHoneycomb() && isTablet(context);
    }

    public static void toast(final Context ctx, final int resId, final int duration) {
        toast(ctx, ctx.getString(resId), duration);
    }

    private static Toast t;

    public static void toast(final Context ctx, final String resId, final int duration) {
        toast(ctx, resId, duration, false);
    }

    public static void toast(final Context ctx, final String resId, final int duration, boolean cancel) {
        if (cancel && t != null) {
            t.cancel();
        }
        if (Thread.currentThread() == Looper.getMainLooper().getThread()) {
            t = Toast.makeText(ctx, resId, duration);
            t.show();
        } else {
            uiHandler.post(new Runnable() {

                @Override
                public void run() {
                    t = Toast.makeText(ctx, resId, duration);
                    t.show();
                }
            });
        }
    }

    public static void toastInNewThread(final Context ctx, final String resId, final int duration) {
        HandlerThread t = new HandlerThread("toast");
        t.start();
        new Handler(t.getLooper()).post(new Runnable() {

            @Override
            public void run() {
                Toast.makeText(ctx, resId, duration).show();
            }
        });
    }

    public static String toHexColor(int r, int g, int b) {
        return "#" + toBrowserHexValue(r) + toBrowserHexValue(g) + toBrowserHexValue(b);
    }

    private static String toBrowserHexValue(int number) {
        StringBuilder builder = new StringBuilder(Integer.toHexString(number & 0xff));
        while (builder.length() < 2) {
            builder.append("0");
        }
        return builder.toString().toUpperCase();
    }

    public static void safeOpenLink(Context context, Intent linkIntent) {
        try {
            context.startActivity(linkIntent);
        } catch (Exception e) {
            Toast.makeText(context, "不能打开链接", Toast.LENGTH_SHORT).show();
        }
    }

    public static View getIndexView(AbsListView listView, int itemIndex) {
        View v = null;
        try {
            int visiblePosition = listView.getFirstVisiblePosition();
            int targetViewIndex = itemIndex - visiblePosition;
            if (targetViewIndex >= 0 && targetViewIndex < listView.getChildCount()) {
                v = listView.getChildAt(targetViewIndex);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return v;
    }

    public static void goMarket(Context ctx, String pkg) {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(Uri.parse("market://details?id=" + pkg));
        safeOpenLink(ctx, intent);
    }

    public static int dip2px(Context context, float dpValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
    }

    /**
     * 根据手机的分辨率从 px(像素) 的单位 转成为 dp
     */
    public static int px2dip(Context context, float pxValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }

    public static void openImage(Context ctx, String fullName) {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.addCategory(Intent.CATEGORY_DEFAULT);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        Uri uri = Uri.fromFile(new File(fullName));
        intent.setDataAndType(uri, "image/*");
        safeOpenLink(ctx, intent);
    }

    public static void openPath(Context ctx, String path) {
        Intent intent = new Intent();
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.setAction(Intent.ACTION_GET_CONTENT);
        intent.setDataAndType(Uri.parse(path), "file/*");
        safeOpenLink(ctx, intent);
    }

    public static void hideSoftInput(Context ctx, View paramEditText) {
        ((InputMethodManager) ctx.getSystemService(Context.INPUT_METHOD_SERVICE))
                .hideSoftInputFromWindow(paramEditText.getWindowToken(), 0);
    }

    public static void showKeyBoard(final View paramEditText) {
        paramEditText.requestFocus();
        paramEditText.post(new Runnable() {
            @Override
            public void run() {
                ((InputMethodManager) paramEditText.getContext().getSystemService(Context.INPUT_METHOD_SERVICE))
                        .showSoftInput(paramEditText, 0);
            }
        });
    }

    public static DecimalFormat percentFormatePoint = new DecimalFormat("0.00");
    public static DecimalFormat percentFormate = new DecimalFormat("0");

    public static String showSize(long size) {
        String result = null;
        if (size / 1024 / 1024 > 0) {
            result = percentFormatePoint.format(((double) size) / 1024 / 1024) + "Mb";
        } else if (size / 1024 > 0) {
            result = (size / 1024) + "Kb";
        } else {
            result = "0Kb";
        }
        return result;
    }

    public static String showSize(long size, boolean withPoint) {
        DecimalFormat format = percentFormatePoint;
        if (!withPoint) {
            format = percentFormate;
        }
        String result = null;
        if (size / 1024 / 1024 > 0) {
            result = format.format(((double) size) / 1024 / 1024) + "Mb";
        } else if (size / 1024 > 0) {
            result = (size / 1024) + "Kb";
        } else {
            result = "0Kb";
        }
        return result;
    }

    public static String getMimeType(String fullName) {
        String type = null;
        int filenamePos = fullName.lastIndexOf('/');
        String filename = 0 <= filenamePos ? fullName.substring(filenamePos + 1) : fullName;
        String extension = null;
        if (!filename.isEmpty()) {
            int dotPos = filename.lastIndexOf('.');
            if (0 <= dotPos) {
                extension = filename.substring(dotPos + 1);
            }
        }
        if (extension != null) {
            MimeTypeMap mime = MimeTypeMap.getSingleton();
            type = mime.getMimeTypeFromExtension(extension);
        }
        return type;
    }


    public static boolean isForeground(Context context) {
        ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        List<RunningTaskInfo> tasksInfo = am.getRunningTasks(1);
        if (tasksInfo.size() > 0) {
            DLog.d(TAG, "top Activity = " + tasksInfo.get(0).topActivity.getPackageName());
            // 应用程序位于堆栈的顶层
            if (context.getPackageName().equals(tasksInfo.get(0).topActivity.getPackageName())) {
                return true;
            }
        }
        return false;
    }


    public static String formateDBDate(String dbDate, String pattern) {
        try {
            SimpleDateFormat dbFormate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = dbFormate.parse(dbDate);
            SimpleDateFormat showFormate = new SimpleDateFormat(pattern);
            return showFormate.format(date);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }


    public static class Patterns {
        public static Pattern NUMBER = Pattern.compile("[0-9]+");
        public static Pattern MOBILE = Pattern.compile("^1(3|5|7|8)[0-9]{9}$");
        public static Pattern CAR_NUM = Pattern.compile("^[\u4e00-\u9fa5]{1}[A-Z]{1}[A-Z_a-z_0-9]{5}$");
    }

    // 获取栈顶Activity及其所属进程
    public static String getTopActivity(Context context) {
        String topActivityName = null;
        try {
            ActivityManager activityManager = (ActivityManager) (context
                    .getSystemService(android.content.Context.ACTIVITY_SERVICE));
            List<RunningTaskInfo> runningTaskInfos = activityManager.getRunningTasks(1);
            if (runningTaskInfos != null) {
                ComponentName f = runningTaskInfos.get(0).topActivity;
                String topActivityClassName = f.getClassName();
                String temp[] = topActivityClassName.split("\\.");
                // 栈顶Activity的名称
                topActivityName = temp[temp.length - 1];
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return topActivityName;
    }

    public static boolean isMainProcess(Context ctx) {
        int pid = android.os.Process.myPid();
        String processName = "";
        ActivityManager mActivityManager = (ActivityManager) ctx.getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningAppProcessInfo appProcess : mActivityManager.getRunningAppProcesses()) {
            if (appProcess.pid == pid) {
                processName = appProcess.processName;
                break;
            }
        }
        String packageName = ctx.getPackageName();
        return processName.equals(packageName);
    }

    public static void stopScroll(AbsListView view) {
        try {
            Field field = android.widget.AbsListView.class.getDeclaredField("mFlingRunnable");
            field.setAccessible(true);
            Object flingRunnable = field.get(view);
            if (flingRunnable != null) {
                Method method = Class.forName("android.widget.AbsListView$FlingRunnable").getDeclaredMethod("endFling");
                method.setAccessible(true);
                method.invoke(flingRunnable);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static PopupWindow showPopUpWindow(final Context ctx, View anchor,
                                              int xoff, int yoff, final String[] items,
                                              final AdapterView.OnItemClickListener onItemListener) {
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(ctx,
                R.layout.popup_menu_item, items) {
            @Override
            public View getView(int position, View convertView, ViewGroup parent) {
                View root = null;
                if (convertView == null) {
                    root = LayoutInflater.from(ctx).inflate(
                            R.layout.popup_menu_item, parent, false);
                } else {
                    root = convertView;
                }
                TextView tv = (TextView) root.findViewById(R.id.text);
                tv.setText(items[position]);
                return root;
            }

        };
        final ListView listView = new ListView(ctx);
        listView.setCacheColorHint(Color.TRANSPARENT);
        listView.setSelector(android.R.color.transparent);
        listView.setAdapter(adapter);
        final PopupWindow window = new PopupWindow(listView,
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {
                window.dismiss();
                if (onItemListener != null) {
                    onItemListener.onItemClick(parent, listView, position, id);
                }
            }
        });
        window.setOutsideTouchable(true);
        window.setFocusable(true);
        Drawable bg = ctx.getResources().getDrawable(
                R.drawable.nb_bg_dropdownlist);
        int popWidth=UIUtils.dip2px(ctx,100);
        window.setWidth(popWidth);
        window.setHeight(ViewGroup.LayoutParams.WRAP_CONTENT);
        window.setBackgroundDrawable(bg);

        int offsetx=0;
        if(popWidth>anchor.getWidth()){
            offsetx=-(popWidth-anchor.getWidth())/2;
        }else{
            offsetx=(popWidth-anchor.getWidth())/2;
        }
        window.showAsDropDown(anchor, offsetx, yoff);
        return window;
    }

    public static int getStatusBarHeight(Context ctx){
        int statusBarHeight = 0;
        try{
            //获取status_bar_height资源的ID
            int resourceId = ctx.getResources().getIdentifier("status_bar_height", "dimen", "android");
            if (resourceId > 0) {
                //根据资源ID获取响应的尺寸值
                statusBarHeight = ctx.getResources().getDimensionPixelSize(resourceId);
            }return statusBarHeight;}
        catch (Exception e){
            e.printStackTrace();
        }
        return statusBarHeight;
    }
}
