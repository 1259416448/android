package arvix.cn.ontheway.ui.track;

import android.app.AlertDialog;
import android.content.Context;
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
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.youth.banner.Banner;
import com.youth.banner.BannerConfig;
import com.youth.banner.Transformer;
import com.youth.banner.loader.ImageLoader;

import org.xutils.image.ImageOptions;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.async.AsyncUtil;
import arvix.cn.ontheway.async.Callback;
import arvix.cn.ontheway.async.Result;
import arvix.cn.ontheway.bean.ReplyBean;
import arvix.cn.ontheway.bean.TrackBean;
import arvix.cn.ontheway.data.NewReplyData;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;
import arvix.cn.ontheway.ui.view.ListViewHolder;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;

import static android.text.style.DynamicDrawableSpan.ALIGN_BASELINE;

/**
 * Created by asdtiang on 2017/7/31 0031.
 * asdtiangxia@163.com
 */

public class TrackDetailActivity  extends BaseActivity implements AdapterView.OnItemClickListener, PullToRefreshBase.OnRefreshListener2<ListView> {

    private TrackDetailReplyAdapter adapter;
    private List<ReplyBean> datas;
    private ListViewHolder listHolder;
    private int pageNum = 0;

    @ViewInject(R.id.header_iv)
    ImageView userHeader;
    @ViewInject(R.id.nickname_tv)
    TextView nicknameTv;
    @ViewInject(R.id.create_time_tv)
    TextView timeTv;
    @ViewInject(R.id.content_tv)
    TextView contentTv;
    @ViewInject(R.id.address_tv)
    TextView addressTv;

    @ViewInject(R.id.write_reply_et)
    private EditText writeReplyEt;

    @ViewInject(R.id.right_info_line)
    private View rightInfoLine;
    private TrackBean trackBean;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_track_detail);
        trackBean = (TrackBean) this.getIntent().getSerializableExtra(StaticVar.EXTRA_TRACK_BEAN);
        datas = new ArrayList();
        initData(true);
        adapter = new TrackDetailReplyAdapter(this, datas);
        listHolder = ListViewHolder.initList(this);
        listHolder.list.setAdapter(adapter);
        listHolder.list.getRefreshableView().setDividerHeight(StaticMethod.dip2px(self,1));
        listHolder.list.getRefreshableView().addHeaderView(LayoutInflater.from (self).inflate(R.layout.track_detail_header,listHolder.list,false));
        x.view().inject(this);
        listHolder.list.setOnItemClickListener(this);
        listHolder.list.setMode(PullToRefreshBase.Mode.BOTH);
        listHolder.list.setOnRefreshListener(this);
        listHolder.list.setRefreshing();
        HeaderHolder head=new HeaderHolder();
        head.init(self,"足迹详情");
        initView();

    }

    private void initView() {
        //init field;
        StaticMethod.setCircularHeaderImg(trackBean.getUserHeadImg(),userHeader,userHeader.getWidth(),userHeader.getHeight());
        nicknameTv.setText(trackBean.getUserNickname());
        timeTv.setText(trackBean.getDateCreated()+"");
        contentTv.setText(trackBean.getFootprintContent());
        addressTv.setText(trackBean.getFootprintAddress());
        Banner banner = (Banner) findViewById(R.id.banner);
        //设置banner样式
        banner.setBannerStyle(BannerConfig.NUM_INDICATOR);
        //设置图片加载器
        banner.setImageLoader(new ImageLoader() {
            @Override
            public void displayImage(Context context, Object o, ImageView imageView) {
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
                x.image().bind(imageView,(String)o, options);
            }
        });
        //设置图片集合
        banner.setImages(trackBean.getFootprintPhotoArray());
        //设置banner动画效果
        banner.setBannerAnimation(Transformer.DepthPage);
        //设置标题集合（当banner样式有显示title时）
        // banner.setBannerTitles(titles);
        //设置自动轮播，默认为true
        banner.isAutoPlay(true);
        //设置轮播时间
        banner.setDelayTime(2000);
        //设置指示器位置（当banner模式中有指示器时）
        banner.setIndicatorGravity(BannerConfig.CENTER);
        //banner设置方法全部调用完毕时最后调用
        banner.start();

        //android:hint="icon 写评论"
        SpannableStringBuilder ssb = new SpannableStringBuilder("  icon 写评论");
        int length = ssb.length();
        AbsoluteSizeSpan absoluteSizeSpan = new AbsoluteSizeSpan(15, true);
        ForegroundColorSpan colorSpan = new ForegroundColorSpan(Color.parseColor("#979797"));
        ssb.setSpan(colorSpan, 6, length, Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
        ssb.setSpan(absoluteSizeSpan, 6, length, Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
        Bitmap b = BitmapFactory.decodeResource(getResources(), R.drawable.zj_pinglun);
        ImageSpan imgSpan = new ImageSpan(self, b,ALIGN_BASELINE);

        ssb.setSpan(imgSpan, 2, 6, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        writeReplyEt.setHint(ssb);
        attachKeyboardListeners(R.id.detail_root);

    }

    @Override
    protected void onShowKeyboard(int keyboardHeight) {
        // do things when keyboard is shown
        rightInfoLine.setVisibility(View.GONE);
       // bottomContainer.setVisibility(View.GONE);
    }

    @Override
    protected void onHideKeyboard() {
        // do things when keyboard is hidden
        rightInfoLine.setVisibility(View.VISIBLE);
      //  bottomContainer.setVisibility(View.VISIBLE);
    }
    private void initData(final boolean refresh) {
        final int reqPage = refresh ? 0 : pageNum;
        AsyncUtil.goAsync(new Callable<Result<List<ReplyBean>>>() {

            @Override
            public Result<List<ReplyBean>> call() throws Exception {
                Result<List<ReplyBean> > ret = new Result<>();
                ret.setData(NewReplyData.genData());
                return ret;
            }
        }, new Callback<Result<List<ReplyBean>>>() {

            @Override
            public void onHandle(Result<List<ReplyBean>> result) {
                if (result.ok()) {
                    //成功才更新page状态
                    if (refresh) {
                        pageNum = 0;
                    }
                    pageNum++;

                    if (refresh) {
                        datas.clear();
                    }
                    datas.addAll(result.getData());
                    adapter.notifyDataSetChanged();
                } else {
                    new AlertDialog.Builder(TrackDetailActivity.this).setMessage(result.getErrorMsg()).show();
                }
                listHolder.mayShowEmpty(adapter.getCount());
                listHolder.list.onRefreshComplete();
            }
        });

    }




    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
       // startActivity(new Intent(self,MyTrackDetailActivity.class));
    }

    /**
     * onPullDownToRefresh will be called only when the user has Pulled from
     * the start, and released.
     *
     * @param refreshView
     */
    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        initData(true);
    }

    /**
     * onPullUpToRefresh will be called only when the user has Pulled from
     * the end, and released.
     *
     * @param refreshView
     */
    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        initData(false);
    }
}
