package arvix.cn.ontheway.ui.head;

import android.app.Activity;
import android.graphics.drawable.Drawable;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import arvix.cn.ontheway.R;


public class HeaderHolder {
	@ViewInject(R.id.title)
	public TextView titleTv;

	@ViewInject(R.id.left_btn)
	public ImageButton leftBtn;
	@ViewInject(R.id.left_text_btn)
	public Button leftTextBtn;
	@ViewInject(R.id.right_btn_1)
	public ImageButton rightBtn1;
	@ViewInject(R.id.right_btn_2)
	public ImageButton rightBtn2;
	@ViewInject(R.id.right_btn_2_pao)
	public View rightBtn2Pao;
	@ViewInject(R.id.left_btn_pao)
	public View leftBtnPao;
	@ViewInject(R.id.right_text_btn)
	public Button rightTextBtn;

	public void init(final Activity act, String title) {
		x.view().inject(this,act.getWindow().getDecorView());
		titleTv.setText(title);
		leftBtn.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				act.finish();
			}
		});
	}

	public void setTitle(CharSequence charSequence) {
		titleTv.setText(charSequence);
		titleTv.setBackgroundDrawable(null);
	}

	public void setTitle(Drawable bg) {
		titleTv.setText("");
		titleTv.setBackgroundDrawable(bg);
	}

	public void setUpLeftBtn(Drawable drawable, OnClickListener onClick) {
		if (onClick != null) {
			leftBtn.setVisibility(View.VISIBLE);
			leftBtn.setImageDrawable(drawable);
			leftBtn.setOnClickListener(onClick);
		} else {
			leftBtn.setVisibility(View.GONE);
			leftBtn.setImageDrawable(null);
			leftBtn.setOnClickListener(null);
		}
	}

	public void setUpRight1Btn(Drawable drawable, OnClickListener onClick) {
		if (onClick != null) {
			rightBtn1.setVisibility(View.VISIBLE);
			rightBtn1.setImageDrawable(drawable);
			rightBtn1.setOnClickListener(onClick);
		} else {
			rightBtn1.setVisibility(View.GONE);
			rightBtn1.setImageDrawable(null);
			rightBtn1.setOnClickListener(null);
		}
	}

	public void setUpRightBtn2(Drawable drawable, OnClickListener onClick) {
		if (onClick != null) {
			rightBtn2.setVisibility(View.VISIBLE);
			rightBtn2.setImageDrawable(drawable);
			rightBtn2.setOnClickListener(onClick);
		} else {
			rightBtn2.setVisibility(View.GONE);
			rightBtn2.setImageDrawable(null);
			rightBtn2.setOnClickListener(null);
		}
	}

	public void setUpRightTextBtn(CharSequence text, OnClickListener onClick) {
		if (onClick != null) {
			rightTextBtn.setVisibility(View.VISIBLE);
			rightTextBtn.setText(text);
			rightTextBtn.setOnClickListener(onClick);
		} else {
			rightTextBtn.setVisibility(View.GONE);
			rightTextBtn.setText("");
			rightTextBtn.setOnClickListener(null);
		}
	}

	public void setUpLeftTextBtn(CharSequence text, OnClickListener onClick) {
		if (onClick != null) {
			leftTextBtn.setVisibility(View.VISIBLE);
			leftTextBtn.setText(text);
			leftTextBtn.setOnClickListener(onClick);
		} else {
			leftTextBtn.setVisibility(View.GONE);
			leftTextBtn.setText("");
			leftTextBtn.setOnClickListener(null);
		}
	}

	public void showRightBtn2Pao(boolean show) {
		rightBtn2Pao.setVisibility(show ? View.VISIBLE : View.GONE);
	}

	public void showLeftBtnPao(boolean show) {
		leftBtnPao.setVisibility(show ? View.VISIBLE : View.GONE);
	}
}
