package arvix.cn.ontheway.ui.usercenter;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.handmark.pulltorefresh.library.PullToRefreshBase;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;
import java.util.ArrayList;
import java.util.List;
import arvix.cn.ontheway.App;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.FootPrintBean;
import arvix.cn.ontheway.bean.FootPrintSearchVo;
import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.service.inter.FootPrintSearchNotify;
import arvix.cn.ontheway.service.inter.FootPrintSearchService;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.track.TrackCreateActivity;
import arvix.cn.ontheway.ui.track.TrackDetailActivity;
import arvix.cn.ontheway.ui.view.ListViewHolder;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;
import arvix.cn.ontheway.utils.UIUtils;

/**
 * Created by asdtiang on 2017/7/25 0025.
 * asdtiangxia@163.com
 */

public class MyTrackListActivity  extends BaseActivity   implements AdapterView.OnItemClickListener, PullToRefreshBase.OnRefreshListener2<ListView>,FootPrintSearchNotify<FootPrintBean> {

    private MyTrackListAdapter adapter;
    private List<FootPrintBean> footPrintList;
    private ListViewHolder listHolder;
    Pagination pagination;
    @ViewInject(R.id.header_img_track)
    private ImageView headerIV;
    @ViewInject(R.id.to_my_track_map_btn)
    private Button toMyTrackMapBtn ;
    @ViewInject(R.id.back_img)
    private Button backImg ;
    @ViewInject(R.id.to_create_relative)
    private RelativeLayout toCreateRelative;
    private Button toCreateBtn;
    FootPrintSearchService footPrintSearchService;
    private FootPrintSearchVo footPrintSearchVo;
    private boolean fetchDataFinish = false;
    private boolean refresh = false;
    private View emptyView;
    @ViewInject(R.id.track_today)
    private View trackToday;
    @ViewInject(R.id.my_track_list_footer)
    private View footView;
    @ViewInject(R.id.nickname_tv)
    TextView nicknameTv;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_my_track_list);
        footPrintSearchService = OnthewayApplication.getInstahce(FootPrintSearchService.class);
        UIUtils.setBarStyle(self);
        footPrintList = new ArrayList();
        initData();
        adapter = new MyTrackListAdapter(this, R.layout.my_track_list_item, footPrintList);
        emptyView = LayoutInflater.from(self).inflate(R.layout.my_track_empty, (ViewGroup)getWindow().getDecorView(), false);
        listHolder = ListViewHolder.initList(this);
        listHolder.list.setAdapter(adapter);
        listHolder.list.getRefreshableView().setDividerHeight(0);
        listHolder.list.getRefreshableView().addHeaderView(LayoutInflater.from (self).inflate(R.layout.my_track_info_frag,listHolder.list.getRefreshableView(),false));
        listHolder.list.getRefreshableView().addFooterView(LayoutInflater.from (self).inflate(R.layout.my_track_footer,listHolder.list.getRefreshableView(),false));
        x.view().inject(this);
        StaticMethod.setCircularHeaderImg(headerIV,180,180);
        toMyTrackMapBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Log.i("route","MyTrackListActivity btnnnnnn---------------------------------------------------->");
                startActivity(new Intent(self,MyTrackMapActivity.class));
            }
        });
        backImg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        toCreateRelative.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(self,TrackCreateActivity.class));
            }
        });
        listHolder.list.setOnItemClickListener(this);
        Log.i("tag","ccccccccccccccccccccccccccccccccccccccccc");
        listHolder.list.setMode(PullToRefreshBase.Mode.BOTH);
        listHolder.list.setOnRefreshListener(this);
        listHolder.list.setRefreshing();
        nicknameTv.setText(App.userInfo.getName());
        receiverUserInfoChange = StaticMethod.registerUserInfoChange(self,nicknameTv,headerIV);
    }
    private void initData() {
        footPrintSearchVo = new FootPrintSearchVo();
        footPrintSearchVo.setSize(15);
        footPrintSearchVo.setNumber(0);
        footPrintSearchService.fetchByUser(self,footPrintSearchVo, App.userInfo.getId(),this);
    }

    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
        Intent intent = new Intent(self,TrackDetailActivity.class);
        intent.putExtra(StaticVar.EXTRA_TRACK_BEAN,  adapter.getItem(i-2));
        startActivity(intent);
    }

    /**
     * onPullDownToRefresh will be called only when the user has Pulled from
     * the start, and released.
     *
     * @param refreshView
     */
    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        initData();
        refresh = true;
    }

    /**
     * onPullUpToRefresh will be called only when the user has Pulled from
     * the end, and released.
     *
     * @param refreshView
     */
    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        if(fetchDataFinish){
            footPrintSearchVo.setNumber(footPrintSearchVo.getNumber()+1);
            footPrintSearchService.fetchByUser(self,footPrintSearchVo, App.userInfo.getId(),this);
        }else{
            StaticMethod.showToast("没有更多的数据了，发布一条吧",this);
            mayShowEmpty(adapter.getCount());
            delayRefreshComplete(100);
        }
    }

    @Override
    public void trackSearchDataFetchSuccess(FootPrintSearchVo trackSearchVo, Pagination<FootPrintBean> paginationFetch) {
        try{
            pagination = paginationFetch;
            footPrintSearchVo = trackSearchVo;
            Log.i(logTag,"trackSearchDataFetchSuccess---->"+pagination.getContent().size());
            if(refresh){
                footPrintList.clear();
                refresh  = false;
            }
            footPrintList.addAll(pagination.getContent());
            if(pagination.getContent().size()==footPrintSearchVo.getSize()){
                fetchDataFinish = true;
            }else{
                fetchDataFinish = false;
            }
            adapter.notifyDataSetChanged();
            delayRefreshComplete(100);
            mayShowEmpty(adapter.getCount());
            Log.i(logTag,"trackSearchDataFetchSuccess---->adapter.getCount()" + adapter.getCount());
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    private void mayShowEmpty(int count) {
        if(count>0&&emptyView.getParent()!=null){
            listHolder.list.getRefreshableView().removeHeaderView(emptyView);
            trackToday.setVisibility(View.VISIBLE);
            footView.setVisibility(View.VISIBLE);
        }else if(count<=0&&emptyView.getParent()==null){
            listHolder.list.getRefreshableView().addHeaderView(emptyView);
            trackToday.setVisibility(View.GONE);
            footView.setVisibility(View.GONE);
            if(toCreateBtn==null){
                toCreateBtn = (Button) findViewById(R.id.to_create_btn);
                toCreateBtn.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        startActivity(new Intent(self,TrackCreateActivity.class));
                    }
                });
            }
        }
    }

    private void delayRefreshComplete(final int delay) {
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                listHolder.list.onRefreshComplete();
            }
        }, delay);
    }
}
