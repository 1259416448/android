package arvix.cn.ontheway.ui.usercenter;

import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.Callable;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.async.AsyncUtil;
import arvix.cn.ontheway.async.Callback;
import arvix.cn.ontheway.async.Result;
import arvix.cn.ontheway.bean.TrackBean;
import arvix.cn.ontheway.data.TrackListData;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.view.ListViewHolder;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.UIUtils;

/**
 * Created by asdtiang on 2017/7/25 0025.
 * asdtiangxia@163.com
 */

public class MyTrackListActivity  extends BaseActivity   implements AdapterView.OnItemClickListener, PullToRefreshBase.OnRefreshListener2<ListView>{

    private MyTrackListAdapter adapter;
    private List<TrackBean> datas;
    private ListViewHolder listHolder;
    @ViewInject(R.id.header_img_track)
    private ImageView headerIV;
    @ViewInject(R.id.to_my_track_map_btn)
    private Button toMyTrackMapBtn ;
    private int pageNum = 0;
    private final int pageSize = 30;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_my_track_list);
        UIUtils.setBarStyle(self);
        initView();
        datas = new ArrayList();

        initData(true);
        Log.i("tag","aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        adapter = new MyTrackListAdapter(this, R.layout.my_track_list_item,datas);
        Log.i("tag","bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
        listHolder = ListViewHolder.initList(this);
        listHolder.list.setAdapter(adapter);
        listHolder.list.getRefreshableView().setDividerHeight(0);
        listHolder.list.getRefreshableView().addHeaderView(LayoutInflater.from (self).inflate(R.layout.my_track_info_frag,listHolder.list.getRefreshableView(),false));
        x.view().inject(this);
        StaticMethod.setCircularHeaderImg(headerIV,180,180);
        toMyTrackMapBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Log.i("route","MyTrackListActivity btnnnnnn---------------------------------------------------->");
                startActivity(new Intent(self,MyTrackMapActivity.class));
            }
        });

        listHolder.list.setOnItemClickListener(this);
        Log.i("tag","ccccccccccccccccccccccccccccccccccccccccc");
        listHolder.list.setMode(PullToRefreshBase.Mode.BOTH);
        listHolder.list.setOnRefreshListener(this);
        listHolder.list.setRefreshing();
    }

    //正整数，小于等于0会导致不响应onActivityResult
    private final int REQ_GET_NAME_EDIT = new Random().nextInt(Integer.MAX_VALUE);

    private void initView() {


    }

    private void initData(final boolean refresh) {
        final int reqPage = refresh ? 0 : pageNum;
        AsyncUtil.goAsync(new Callable<Result<List<TrackBean>>>() {

            @Override
            public Result<List<TrackBean>> call() throws Exception {
                Result<List<TrackBean> > ret = new Result<List<TrackBean> >();
                ret.setData(TrackListData.genData());
                return ret;
            }
        }, new Callback<Result<List<TrackBean>>>() {

            @Override
            public void onHandle(Result<List<TrackBean>> result) {
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
                    new AlertDialog.Builder(MyTrackListActivity.this).setMessage(result.getErrorMsg()).show();
                }
                listHolder.mayShowEmpty(adapter.getCount());
                listHolder.list.onRefreshComplete();
            }
        });

    }




    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
      //  MsgBean m = (MsgBean) parent.getItemAtPosition(position);
      //  UIUtils.toast(this, m.getTitle(), Toast.LENGTH_SHORT);
        startActivity(new Intent(self,MyTrackDetailActivity.class));
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
