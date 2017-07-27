package arvix.cn.ontheway.ui.view;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.res.Configuration;
import android.view.Display;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.WindowManager.LayoutParams;
import android.widget.FrameLayout;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.R;


public class BottomDialog {
    private Dialog dialog;


    public BottomDialog(Context ctx) {
        dialog = getDialog(ctx);
        makeNotFullScreen(dialog);
        Window window = dialog.getWindow();
        LayoutParams param = window.getAttributes();
        param.gravity = Gravity.BOTTOM;
        param.width = ((WindowManager) App.self.getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay()
                .getWidth();
        window.setAttributes(param);
    }

    public Dialog getDialog() {
        return dialog;
    }

    public void show() {
        boolean show = false;
        if (dialog.getContext() instanceof Activity) {
            if (!((Activity) dialog.getContext()).isFinishing()) {
                show = true;
            }
        } else {
            show = true;
        }
        if (show) {
            dialog.show();
        }

    }

    public void dismiss() {
        dialog.dismiss();
    }

    public void setCustom(View v) {
        FrameLayout customLayout = (FrameLayout) dialog.findViewById(R.id.dialog_root);
        customLayout.removeAllViews();
        if (v != null) {
            customLayout.addView(v);
        }
    }

    public static Dialog getDialog(Context ctx) {
        int layout = R.layout.bottom_dialog;
        int style = R.style.bottom_dialog;
        final Dialog dialog = new Dialog(ctx, style);
        dialog.setContentView(layout);
        dialog.setCancelable(true);
        return dialog;
    }

    public static void makeNotFullScreen(Dialog dialog) {
        Window window = dialog.getWindow();
        LayoutParams wmLayoutParams = window.getAttributes();
        // 获取屏幕宽、高用
        Display d = ((WindowManager) (dialog.getContext().getSystemService(Context.WINDOW_SERVICE)))
                .getDefaultDisplay();
        if (dialog.getContext().getResources().getConfiguration().orientation == Configuration.ORIENTATION_PORTRAIT) {
            wmLayoutParams.width = (int) (d.getWidth() * 0.92); // 竖屏时，宽度设置为屏幕的0.92
        } else {
            wmLayoutParams.width = (int) (d.getWidth() * 0.6); // 横屏时，宽度设置为屏幕的0.6
        }
        // wmLayoutParams.gravity = Gravity.BOTTOM | Gravity.FILL_HORIZONTAL;
        window.setAttributes(wmLayoutParams);
    }


    public void setCancelable(boolean flag) {
        if (dialog != null) {
            dialog.setCancelable(flag);
            dialog.setCanceledOnTouchOutside(flag);
        }
    }

    public boolean isShowing() {
        if (dialog != null) {
            return dialog.isShowing();
        }
        return false;
    }
}
