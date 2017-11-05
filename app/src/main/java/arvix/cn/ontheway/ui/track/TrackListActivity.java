package arvix.cn.ontheway.ui.track;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.FootPrintBean;
import arvix.cn.ontheway.bean.FootPrintSearchVo;
import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.service.inter.CacheService;
import arvix.cn.ontheway.service.inter.FootPrintSearchNotify;
import arvix.cn.ontheway.service.inter.FootPrintSearchService;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.MainActivity;
import arvix.cn.ontheway.ui.ar_draw.ArFootPrintDrawActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;
import arvix.cn.ontheway.ui.view.ListViewHolder;
import arvix.cn.ontheway.utils.MyProgressDialog;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;

/**
 * Created by asdtiang on 2017/7/28 0028.
 * asdtiangxia@163.com
 */

public class TrackListActivity extends BaseActivity implements AdapterView.OnItemClickListener, PullToRefreshBase.OnRefreshListener2<ListView>, FootPrintSearchNotify<FootPrintBean> {

    private TrackListAdapter adapter;
    private List<FootPrintBean> footPrintList;
    private ListViewHolder listHolder;
    Pagination pagination;
    private View emptyView;
    private FootPrintSearchVo footPrintSearchVo;
    FootPrintSearchService footPrintSearchService;
    CacheService cache;
    MyProgressDialog wait;
    private boolean fetchDataFinish = false;
    private boolean refresh = false;
    @ViewInject(R.id.to_map_btn)
    private Button toMapBtn;
    @ViewInject(R.id.to_ar_btn)
    private Button toArBtn;
    @ViewInject(R.id.create_btn)
    private Button createBtn;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_track_list);
        footPrintSearchService = OnthewayApplication.getInstahce(FootPrintSearchService.class);
        cache = OnthewayApplication.getInstahce(CacheService.class);
        footPrintList = new ArrayList();
        adapter = new TrackListAdapter(this, R.layout.track_list_item, footPrintList);
        listHolder = ListViewHolder.initList(this);
        listHolder.list.setAdapter(adapter);
        listHolder.list.getRefreshableView().setDividerHeight(0);
        x.view().inject(this);
        listHolder.list.setOnItemClickListener(this);
        listHolder.list.setMode(PullToRefreshBase.Mode.BOTH);
        listHolder.list.setOnRefreshListener(this);
        HeaderHolder head=new HeaderHolder();
        head.init(self,"足迹列表");
        head.leftBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                back();
            }
        });
        emptyView = LayoutInflater.from(self).inflate(R.layout.comment_empty, (ViewGroup)getWindow().getDecorView(), false);
        initData();
        initEvent();
    }

    private void back(){
        Intent intent = new Intent(this, MainActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(intent);
    }
    /**
     * 监听Back键按下事件,方法2:
     * 注意:
     * 返回值表示:是否能完全处理该事件
     * 在此处返回false,所以会继续传播该事件.
     * 在具体项目中此处的返回值视情况而定.
     */
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if ((keyCode == KeyEvent.KEYCODE_BACK)) {
            back();
            return false;
        }else {
            return super.onKeyDown(keyCode, event);
        }
    }


    private void initEvent(){
        toMapBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(self, TrackMapActivity.class);
                //intent.setFlags(Intent.FLAG_ACTIVITY_PREVIOUS_IS_TOP);
                startActivity(intent);
            }
        });

        toArBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(self, ArFootPrintDrawActivity.class);
               // intent.setFlags(Intent.FLAG_ACTIVITY_PREVIOUS_IS_TOP);
                startActivity(intent);
            }
        });
        createBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(self, TrackCreateActivity.class);
                startActivity(intent);
            }
        });
    }

    //正整数，小于等于0会导致不响应onActivityResult
    private final int REQ_GET_NAME_EDIT = new Random().nextInt(Integer.MAX_VALUE);


    private void mayShowEmpty(int count) {
        if(count>0&&emptyView.getParent()!=null){
            listHolder.list.getRefreshableView().removeHeaderView(emptyView);
        }else if(count<=0&&emptyView.getParent()==null){
            listHolder.list.getRefreshableView().addHeaderView(emptyView);
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
    private void initData() {
        footPrintSearchVo = new FootPrintSearchVo();
       // footPrintSearchVo.setSize(5);
        footPrintSearchVo.setSearchType(FootPrintSearchVo.SearchType.list);
        footPrintSearchVo.setLatitude(cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LAT));
        footPrintSearchVo.setLongitude(cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LON));
        footPrintSearchService.search(self,footPrintSearchVo,this);
    }

    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
        //  MsgBean m = (MsgBean) parent.getItemAtPosition(position);
        //  UIUtils.toast(this, m.getTitle(), Toast.LENGTH_SHORT);
        FootPrintBean footPrintBean = adapter.getItem(i-1);
        if(footPrintBean !=null){
            // StaticMethod.showToast(footPrintBean.getFootprintContent(),context);
            Intent intent = new Intent(self,TrackDetailActivity.class);
            intent.putExtra(StaticVar.EXTRA_TRACK_BEAN, footPrintBean);
           // intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
        }
    }

    /**
     * onPullDownToRefresh will be called only when the user has Pulled from
     * the start, and released.
     *
     * @param refreshView
     */
    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        footPrintSearchVo = new FootPrintSearchVo();
       // footPrintSearchVo.setSize(5);
        footPrintSearchVo.setSearchType(FootPrintSearchVo.SearchType.list);
        footPrintSearchVo.setLatitude(cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LAT));
        footPrintSearchVo.setLongitude(cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LON));
        footPrintSearchService.search(self,footPrintSearchVo,this);
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
            footPrintSearchService.search(self,footPrintSearchVo,this);
        }else{
            StaticMethod.showToast("没有更多的数据了，发布一条吧",this);
            mayShowEmpty(adapter.getCount());
            delayRefreshComplete(100);
        }

    }

    /**
     * 数据请求成功回调实现
     * @param trackSearchVo
     * @param paginationFetch
     */
    @Override
    public void trackSearchDataFetchSuccess(FootPrintSearchVo trackSearchVo, Pagination<FootPrintBean> paginationFetch, Handler handler) {
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
}
