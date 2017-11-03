package arvix.cn.ontheway.ui;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.ForegroundColorSpan;
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

import arvix.cn.ontheway.BaiduActivity;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.async.AsyncUtil;
import arvix.cn.ontheway.async.Callback;
import arvix.cn.ontheway.async.Result;
import arvix.cn.ontheway.bean.MainCardBean;
import arvix.cn.ontheway.bean.MenuBean;
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
        SpannableStringBuilder ssb = new SpannableStringBuilder("  icon  搜索附近的美食、商场");
        int length = ssb.length();
        AbsoluteSizeSpan absoluteSizeSpan = new AbsoluteSizeSpan(12, true);
        ForegroundColorSpan colorSpan = new ForegroundColorSpan(Color.parseColor("#979797"));
        ssb.setSpan(colorSpan, 6, length, Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
        ssb.setSpan(absoluteSizeSpan, 6, length, Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
        Bitmap b = BitmapFactory.decodeResource(getResources(), R.drawable.sousuo_1);
        ImageSpan imgSpan = new ImageSpan(act, b);
        ssb.setSpan(imgSpan, 2, 6, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        searchET.setHint(ssb);
        ((ViewGroup) searchET.getParent()).setFocusable(true);
        ((ViewGroup) searchET.getParent()).setFocusableInTouchMode(true);
    }

    private void bindCards(List<MainCardBean> data) {
        LayoutInflater lf = LayoutInflater.from(act);
        for (final MainCardBean card : data) {
            View item = lf.inflate(R.layout.main_card, cardContainerLL, false);
            item.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Intent intent = new Intent(act, BaiduActivity.class);
                    intent.putExtra(BaiduActivity.EXTRA_KEYWORD, card.getTitle());
                    startActivity(intent);

                }
            });
            TextView titleTv = (TextView) item.findViewById(R.id.card_title);
            titleTv.setText(card.getTitle());
            ImageView itemIv = (ImageView) item.findViewById(R.id.card_bg);
            itemIv.setImageResource(card.getBg());
            LinearLayout menuContainerLL = (LinearLayout) item.findViewById(R.id.menu_container);
            for (int i = 0; i < card.getMenus().size(); i++) {
                final MenuBean menu = card.getMenus().get(i);
                View menuItem = lf.inflate(R.layout.main_card_menu_item, menuContainerLL, false);
                menuItem.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        //二级菜单
                        Intent intent = new Intent(act, BaiduActivity.class);
                        intent.putExtra(BaiduActivity.EXTRA_KEYWORD, menu.getTitle());
                        startActivity(intent);
                    }
                });
                TextView tv = (TextView) menuItem.findViewById(R.id.menu_text);
                tv.setText(menu.getTitle());
                ImageView iv = (ImageView) menuItem.findViewById(R.id.menu_icon);
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