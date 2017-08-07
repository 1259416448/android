package arvix.cn.ontheway.utils;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.view.Gravity;
import android.view.Window;
import android.view.WindowManager.LayoutParams;

public abstract class MyProgressDialog extends Dialog {
	private Context context;
	private Dialog self;

	public MyProgressDialog(Context context, int layout, int style) {
		super(context, style);
		setContentView(layout);
		this.context = context;
		self = this;
		Window window = getWindow();
		if (!(context instanceof Activity)) {
			window.setType(LayoutParams.TYPE_SYSTEM_ALERT);
		}
		LayoutParams params = window.getAttributes();
		params.width = LayoutParams.WRAP_CONTENT;
		params.height = LayoutParams.WRAP_CONTENT;
		params.gravity = Gravity.CENTER;
		window.setAttributes(params);

		setCanceledOnTouchOutside(false);
		setCancelable(false);
		initListener();
	}

	public abstract void initListener();

	public void closeListener() {

	}

	public void closeDialog() {
		self.dismiss();
		closeListener();
	}

	@Override
	public void show() {
		boolean show = false;
		if (context instanceof Activity) {
			if (!((Activity) context).isFinishing()) {
				show = true;
			}
		} else {
			show = true;
		}
		if (show) {
			super.show();
		}
	}
}
