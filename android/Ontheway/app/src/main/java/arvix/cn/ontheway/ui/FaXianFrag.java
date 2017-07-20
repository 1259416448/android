package arvix.cn.ontheway.ui;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.style.ImageSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.List;
import java.util.concurrent.Callable;

import arvix.cn.ontheway.MainCardBean;
import arvix.cn.ontheway.MenuBean;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.async.AsyncUtil;
import arvix.cn.ontheway.async.Callback;
import arvix.cn.ontheway.async.Result;
import arvix.cn.ontheway.data.IndexData;
import arvix.cn.ontheway.utils.UIUtils;

/**
 * Created by yd on 2017/7/19.
 */

public class FaXianFrag extends BaseFragment {
    @ViewInject(R.id.main_card_container)
    private LinearLayout cardContainerLL;
    @ViewInject(R.id.main_search_edit)
    private EditText searchET;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View root = inflater.inflate(R.layout.tab_faxian, null);
        x.view().inject(this, root);
        initView(root);
        return root;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        initData();
    }

    private void initData() {
        AsyncUtil.goAsync(new Callable<Result<List<MainCardBean>>>() {
            @Override
            public Result<List<MainCardBean>> call() throws Exception {
                return IndexData.getMainCard();
            }
        }, new Callback<Result<List<MainCardBean>>>() {
            @Override
            public void onHandle(Result<List<MainCardBean>> result) {
                if (result.ok()) {
                    bindCards(result.getData());
                } else {
                    UIUtils.toast(act, result.getErrorMsg(), Toast.LENGTH_LONG);
                }
            }
        });
    }

    private void initView(View root) {
        //android:hint="搜索附近的美食、商场"
        SpannableStringBuilder ssb = new SpannableStringBuilder("  icon搜索附近的美食、商场");
        Bitmap b = BitmapFactory.decodeResource(getResources(), R.drawable.sousuo_1);
        ImageSpan imgSpan = new ImageSpan(act, b);
        ssb.setSpan(imgSpan, 2, 6, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        searchET.setHint(ssb);
        ((ViewGroup) searchET.getParent()).setFocusable(true);
        ((ViewGroup) searchET.getParent()).setFocusableInTouchMode(true);
    }

    private void bindCards(List<MainCardBean> data) {
        LayoutInflater lf = LayoutInflater.from(act);
        for (MainCardBean card : data) {
            View item = lf.inflate(R.layout.main_card, cardContainerLL, false);
            item.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    UIUtils.toast(act, "ccc", Toast.LENGTH_SHORT);
                }
            });
            TextView titleTv = item.findViewById(R.id.card_title);
            titleTv.setText(card.getTitle());
            LinearLayout menuContainerLL = item.findViewById(R.id.menu_container);
            for (int i = 0; i < card.getMenus().size(); i++) {
                MenuBean menu = card.getMenus().get(i);
                View menuItem = lf.inflate(R.layout.main_card_menu_item, menuContainerLL, false);
                TextView tv = menuItem.findViewById(R.id.menu_text);
                tv.setText(menu.getTitle());
                ImageView iv = menuItem.findViewById(R.id.menu_icon);
                iv.setImageResource(menu.getImgSrc());
                if (i == card.getMenus().size() - 1) {
                    menuItem.setPadding(menuItem.getPaddingLeft(), menuItem.getPaddingTop(), 0, menuItem.getPaddingBottom());
                }
                menuContainerLL.addView(menuItem);
            }
            cardContainerLL.addView(item);
        }
    }
}
