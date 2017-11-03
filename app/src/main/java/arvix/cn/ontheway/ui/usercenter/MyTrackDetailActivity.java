package arvix.cn.ontheway.ui.usercenter;

import android.os.Bundle;
import android.os.PersistableBundle;
import android.support.annotation.Nullable;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.viewpagerindicator.CirclePageIndicator;

import org.xutils.image.ImageOptions;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.List;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.ui.BaseActivity;

/**
 * Created by yd on 2017/7/27.
 */

public class MyTrackDetailActivity extends BaseActivity {
    @ViewInject(R.id.pager)
    private ViewPager pager;
    @ViewInject(R.id.pager_indicator)
    private CirclePageIndicator indicator;

    private List<String> pics;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.acitivity_my_track_detail);
        x.view().inject(this);

        pics=new ArrayList<>();
        pics.add("http://f11.baidu.com/it/u=1981748892,3031683197&fm=72");
        pics.add("http://f10.baidu.com/it/u=3243370105,1125765815&fm=72");
        pics.add("https://img6.bdstatic.com/img/image/smallpic/yangmixiaotugengxin.jpg");
        initView();
    }

    private void initView() {
        pager.setAdapter(new PagerAdapter() {

            @Override
            public boolean isViewFromObject(View arg0, Object arg1) {
                return arg0 == arg1;
            }

            @Override
            public int getCount() {
                return pics.size();
            }

            @Override
            public Object instantiateItem(ViewGroup container, final int position) {
                LinearLayout ll = (LinearLayout) LayoutInflater.from(self).inflate(R.layout.track_page_item,
                        container, false);
                final ImageView v = (ImageView) ll.findViewById(R.id.pic);
                container.addView(ll);
                final String ad = pics.get(position);

                //设置图片属性的options
                ImageOptions options = new ImageOptions.Builder()
                        // 如果ImageView的大小不是定义为wrap_content, 不要crop.
                        .setCrop(true)
                        .setImageScaleType(ImageView.ScaleType.CENTER_CROP)
                        //设置使用缓存
                        .setUseMemCache(true)
                        //设置支持gif
                        .setIgnoreGif(false)
                        //设置显示圆形图片
                        .build();
                x.image().bind(v,ad, options);
                return ll;
            }

            @Override
            public void destroyItem(ViewGroup container, int position, Object object) {
                container.removeView((View) object);
            }
        });
        indicator.setViewPager(pager);
    }
}
