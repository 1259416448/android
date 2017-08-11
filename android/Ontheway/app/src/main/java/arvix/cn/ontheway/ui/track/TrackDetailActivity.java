package arvix.cn.ontheway.ui.track;

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
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import com.alibaba.fastjson.util.TypeUtils;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.youth.banner.Banner;
import com.youth.banner.BannerConfig;
import com.youth.banner.Transformer;
import com.youth.banner.loader.ImageLoader;

import org.w3c.dom.Text;
import org.xutils.http.RequestParams;
import org.xutils.image.ImageOptions;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.List;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.BaseResponse;
import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.bean.CommentBean;
import arvix.cn.ontheway.bean.FootPrintBean;
import arvix.cn.ontheway.http.ServerUrl;
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
    private List<CommentBean> commentBeanList;
    private ListViewHolder listHolder;
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
    @ViewInject(R.id.del_tv)
    TextView delTv;
    @ViewInject(R.id.write_reply_et)
    private EditText writeReplyEt;
    @ViewInject(R.id.right_info_line)
    private View rightInfoLine;
    private FootPrintBean footPrintBean;
    Pagination pagination;
    private boolean commentCanFetch = false;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_track_detail);
        footPrintBean = (FootPrintBean) this.getIntent().getSerializableExtra(StaticVar.EXTRA_TRACK_BEAN);
        commentCanFetch = false;
        commentBeanList = new ArrayList();
        pagination = new Pagination();
        pagination.setSize(10);
        initData();
        adapter = new TrackDetailReplyAdapter(this, commentBeanList);
        listHolder = ListViewHolder.initList(this);
        listHolder.list.setAdapter(adapter);
        listHolder.list.getRefreshableView().setDividerHeight(StaticMethod.dip2px(self,1));
        listHolder.list.getRefreshableView().addHeaderView(LayoutInflater.from (self).inflate(R.layout.track_detail_header,listHolder.list,false));
        listHolder.list.setOnItemClickListener(this);
        listHolder.list.setMode(PullToRefreshBase.Mode.BOTH);
        listHolder.list.setOnRefreshListener(this);
        listHolder.list.setRefreshing();
        View emptyView = LayoutInflater.from(self).inflate(R.layout.comment_empty, (ViewGroup)getWindow().getDecorView(), false);
        listHolder.empty_ll.removeAllViews();
        listHolder.empty_ll.addView(emptyView);
        x.view().inject(this);
        HeaderHolder head=new HeaderHolder();
        head.init(self,"足迹详情");
        initView();
    }

    private void initView() {
        //init field;
        StaticMethod.setCircularHeaderImg(footPrintBean.getUserHeadImg(),userHeader,userHeader.getWidth(),userHeader.getHeight());
        nicknameTv.setText(footPrintBean.getUserNickname());
        timeTv.setText(footPrintBean.getDateCreatedStr());
        contentTv.setText(footPrintBean.getFootprintContent());
        addressTv.setText(footPrintBean.getFootprintAddress());
        if(footPrintBean.getUserId() == App.userInfo.getId()){
            delTv.setVisibility(View.VISIBLE);
        }
        initPhotoList();
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

    private void initPhotoList(){
        if(footPrintBean.getFootprintPhotoArray()!=null && footPrintBean.getFootprintPhotoArray().size()>0){
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
            banner.setImages(footPrintBean.getFootprintPhotoArray());
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
        }
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
    private void initData() {
        x.http().get(new RequestParams(ServerUrl.FOOTPRINT_SHOW+"/"+footPrintBean.getFootprintId()),new org.xutils.common.Callback.CommonCallback<String>(){
           @Override
           public void onSuccess(String result) {
               BaseResponse<FootPrintBean> response = StaticMethod.genResponse(result,FootPrintBean.class);
               if(response.getCode() == StaticVar.SUCCESS){
                   FootPrintBean fetchBean = response.getBodyBean();
                   footPrintBean = fetchBean;
                   initPhotoList();
                   commentBeanList.clear();
                   commentBeanList.addAll(footPrintBean.getComments());
                   adapter.notifyDataSetChanged();

                   listHolder.mayShowEmpty(adapter.getCount());
                   listHolder.list.onRefreshComplete();
                   if(commentBeanList.size()>=10){
                       commentCanFetch = true;
                   }
               }
            }

           @Override
           public void onError(Throwable ex, boolean isOnCallback) {

           }

           @Override
           public void onCancelled(CancelledException cex) {

           }

           @Override
           public void onFinished() {

           }
        });

    }

    private void fetchCommentPagination(){
        if(commentCanFetch){
            boolean fetch = true;
            if(pagination.getTotalPages()==0){
                pagination.setNumber(1);
            }else{
                if(pagination.getNumber() == pagination.getTotalPages()){
                    fetch = false;
                    StaticMethod.showToast("没有更多的数据了，评论一条吧",this);
                }else{
                    pagination.setNumber(pagination.getNumber()+1);
                }
            }
            if(fetch){
                RequestParams requestParams = new RequestParams(ServerUrl.FOOTPRINT_SHOW+"/"+footPrintBean.getFootprintId());
                requestParams.addQueryStringParameter("size", pagination.getSize()+"");
                requestParams.addQueryStringParameter("footprintId", footPrintBean.getFootprintId()+"");
                requestParams.addQueryStringParameter("number", pagination.getNumber()+"");
                x.http().get(requestParams,new org.xutils.common.Callback.CommonCallback<String>(){
                    @Override
                    public void onSuccess(String result) {
                        BaseResponse<Pagination<CommentBean>> response =  JSON.parseObject(result,new TypeReference<BaseResponse<Pagination<CommentBean>>>(){});
                        if (response.getCode() == StaticVar.SUCCESS) {
                            JSONObject jsonObject = response.getBody();
                            Pagination paginationReturn = TypeUtils.castToJavaBean(jsonObject,Pagination.class);
                            if(paginationReturn!=null && paginationReturn.getContent()!=null){
                                List<JSONObject> jsonArray =  (List<JSONObject>) paginationReturn.getContent();
                                List<CommentBean> footPrintBeanList = new ArrayList<>();
                                for(JSONObject object :jsonArray){
                                    footPrintBeanList.add(TypeUtils.castToJavaBean(object,CommentBean.class));
                                }
                                paginationReturn.setContent(footPrintBeanList);
                            }
                            pagination = paginationReturn;
                            commentBeanList.addAll(footPrintBean.getComments());
                            adapter.notifyDataSetChanged();
                            listHolder.list.onRefreshComplete();
                        } else if (response.getCode() == StaticVar.ERROR) {
                            StaticMethod.showToast("获取数据失败", self);
                        } else {
                            StaticMethod.showToast("获取数据失败" + response.getCode(), self);
                        }
                    }

                    @Override
                    public void onError(Throwable ex, boolean isOnCallback) {

                    }

                    @Override
                    public void onCancelled(CancelledException cex) {

                    }

                    @Override
                    public void onFinished() {
                    }
                });
            }
        }else{
            adapter.notifyDataSetChanged();
            listHolder.mayShowEmpty(adapter.getCount());
            listHolder.list.onRefreshComplete();
        }
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
        fetchCommentPagination();
    }

    /**
     * onPullUpToRefresh will be called only when the user has Pulled from
     * the end, and released.
     *
     * @param refreshView
     */
    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        fetchCommentPagination();
    }
}
