package arvix.cn.ontheway.utils;

import android.content.Context;
import android.text.TextUtils;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.LinearInterpolator;
import android.widget.ImageView;
import android.widget.TextView;

import arvix.cn.ontheway.R;


public class Windows {


	public static MyProgressDialog waiting(final Context context) {
		return waiting(context, null);
	}

	public static MyProgressDialog waiting(final Context context, final String text) {
		MyProgressDialog commonDialog = new MyProgressDialog(context, R.layout.common_waiting, R.style.clean_dialog) {
			private ImageView imageView;

			public void initListener() {
				imageView = (ImageView) findViewById(R.id.waiting);
				if (!TextUtils.isEmpty(text)) {
					TextView v = (TextView) findViewById(R.id.text);
					v.setText(text);
				}
				Animation animation = AnimationUtils.loadAnimation(context, R.anim.wait);
				animation.setInterpolator(new LinearInterpolator());
				imageView.startAnimation(animation);
			}

			@Override
			public void closeListener() {
				imageView.clearAnimation();
			}
		};
		commonDialog.show();
		return commonDialog;
	}

}
