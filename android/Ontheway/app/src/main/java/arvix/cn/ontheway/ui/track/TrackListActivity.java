package arvix.cn.ontheway.ui.track;

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
import arvix.cn.ontheway.been.TrackBean;
import arvix.cn.ontheway.data.TrackListData;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;
import arvix.cn.ontheway.ui.usercenter.MyTrackDetailActivity;
import arvix.cn.ontheway.ui.usercenter.MyTrackListActivity;
import arvix.cn.ontheway.ui.usercenter.MyTrackListAdapter;
import arvix.cn.ontheway.ui.usercenter.MyTrackMapActivity;
import arvix.cn.ontheway.ui.view.ListViewHolder;
import arvix.cn.ontheway.utils.StaticMethod;

/**
 * Created by asdtiang on 2017/7/28 0028.
 * asdtiangxia@163.com
 */

public class TrackListActivity   extends BaseActivity implements AdapterView.OnItemClickListener, PullToRefreshBase.OnRefreshListener2<ListView>{

    private TrackListAdapter adapter;
    private List<TrackBean> datas;
    private ListViewHolder listHolder;
    private int pageNum = 0;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_track_list);
        datas = new ArrayList();
        initData(true);
        adapter = new TrackListAdapter(this, R.layout.track_list_item,datas);
        listHolder = ListViewHolder.initList(this);
        listHolder.list.setAdapter(adapter);
        listHolder.list.getRefreshableView().setDividerHeight(StaticMethod.dip2px(self,10));
        x.view().inject(this);
        listHolder.list.setOnItemClickListener(this);
        listHolder.list.setMode(PullToRefreshBase.Mode.BOTH);
        listHolder.list.setOnRefreshListener(this);
        listHolder.list.setRefreshing();
        HeaderHolder head=new HeaderHolder();
        head.init(self,"足迹列表");
    }

    //正整数，小于等于0会导致不响应onActivityResult
    private final int REQ_GET_NAME_EDIT = new Random().nextInt(Integer.MAX_VALUE);


    private void initData(final boolean refresh) {
        final int reqPage = refresh ? 0 : pageNum;
        AsyncUtil.goAsync(new Callable<Result<List<TrackBean>>>() {

            @Override
            public Result<List<TrackBean>> call() throws Exception {
                Result<List<TrackBean> > ret = new Result<>();
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
                    new AlertDialog.Builder(TrackListActivity.this).setMessage(result.getErrorMsg()).show();
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
