package arvix.cn.ontheway.ui.msg;

import android.app.AlertDialog;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.handmark.pulltorefresh.library.PullToRefreshBase;

import org.xutils.http.RequestParams;
import org.xutils.x;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.async.AsyncUtil;
import arvix.cn.ontheway.async.Callback;
import arvix.cn.ontheway.async.Result;
import arvix.cn.ontheway.bean.MsgBean;
import arvix.cn.ontheway.bean.CommentBean;
import arvix.cn.ontheway.data.NewReplyData;
import arvix.cn.ontheway.http.ServerUrl;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;
import arvix.cn.ontheway.ui.view.ListViewHolder;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.UIUtils;

/**
 * Created by asdtiang on 2017/7/27 0027.
 * asdtiangxia@163.com
 */

public class NewReplyActivity  extends BaseActivity implements AdapterView.OnItemClickListener, PullToRefreshBase.OnRefreshListener2<ListView>  {

    private NewReplyAdapter adapter;
    private List<CommentBean> dataList;
    private ListViewHolder listHolder;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_msg_new_reply);
        x.view().inject(self);
        HeaderHolder head=new HeaderHolder();
        head.init(self,"新的评论");
        dataList = new ArrayList();
        initData(true);
        adapter = new NewReplyAdapter(this, dataList);
        listHolder = ListViewHolder.initList(this);
        listHolder.list.setAdapter(adapter);
        listHolder.list.setOnItemClickListener(this);
        listHolder.list.getRefreshableView().setDividerHeight(StaticMethod.dip2px(self,10));
        listHolder.list.setMode(PullToRefreshBase.Mode.BOTH);
        listHolder.list.setOnRefreshListener(this);
        listHolder.list.setRefreshing();
    }


    private void initData(final boolean refresh) {
        AsyncUtil.goAsync(new Callable<Result<List<CommentBean>>>() {

            @Override
            public Result<List<CommentBean>> call() throws Exception {
                Result<List<CommentBean>> ret = new Result<>();
//                ret.setData(NewReplyData.genData());
                RequestParams requestParams = new RequestParams();
                requestParams.setUri( ServerUrl.COMMENT_SEARCH);
                Map<String,Object> parMap = new HashMap<>();
                parMap.put("number",1);
                parMap.put("size",10);
                requestParams.setBodyContent(JSON.toJSONString(parMap));
                ret.setData(dataList);
                return ret;
            }
        }, new Callback<Result<List<CommentBean>>>() {

            @Override
            public void onHandle(Result<List<CommentBean>> result) {
                if (result.ok()) {
                    if (refresh) {
                        dataList.clear();
                    }
                    dataList.addAll(result.getData());
                    adapter.notifyDataSetChanged();
                } else {
                    new AlertDialog.Builder(NewReplyActivity.this).setMessage(result.getErrorMsg()).show();
                }
                listHolder.mayShowEmpty(adapter.getCount());
                listHolder.list.onRefreshComplete();
            }
        });

    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        MsgBean m = (MsgBean) parent.getItemAtPosition(position);
        UIUtils.toast(NewReplyActivity.this, m.getTitle(), Toast.LENGTH_SHORT);
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
