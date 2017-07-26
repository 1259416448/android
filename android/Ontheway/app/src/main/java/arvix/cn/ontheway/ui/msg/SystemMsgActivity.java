package arvix.cn.ontheway.ui.msg;

import android.app.AlertDialog;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;
import com.handmark.pulltorefresh.library.PullToRefreshBase;

import org.xutils.x;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.async.AsyncUtil;
import arvix.cn.ontheway.async.Callback;
import arvix.cn.ontheway.async.Result;
import arvix.cn.ontheway.been.MsgBean;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;
import arvix.cn.ontheway.ui.view.ListViewHolder;
import arvix.cn.ontheway.utils.UIUtils;

/**
 * Created by asdtiang on 2017/7/24 0024.
 * asdtiangxia@163.com
 */

public class SystemMsgActivity extends BaseActivity implements AdapterView.OnItemClickListener, PullToRefreshBase.OnRefreshListener2<ListView> {
    private SystemMsgAdapter adapter;
    private List<MsgBean> datas;
    private ListViewHolder listHolder;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_system_msg);
        x.view().inject(self);
        HeaderHolder head=new HeaderHolder();
        head.init(self,"系统消息");
        Log.i("tag","eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
        datas = new ArrayList();
        initData(true);
        Log.i("tag","aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        adapter = new SystemMsgAdapter(this, datas);
        Log.i("tag","bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");
        listHolder = ListViewHolder.initList(this);
        listHolder.list.setAdapter(adapter);
        listHolder.list.setOnItemClickListener(this);

        Log.i("tag","ccccccccccccccccccccccccccccccccccccccccc");
        listHolder.list.setMode(PullToRefreshBase.Mode.BOTH);
        listHolder.list.setOnRefreshListener(this);
        listHolder.list.setRefreshing();
    }

    private int pageNum = 0;
    private final int pageSize = 30;

    private void initData(final boolean refresh) {
        final int reqPage = refresh ? 0 : pageNum;
        AsyncUtil.goAsync(new Callable<Result<List<MsgBean>>>() {

            @Override
            public Result<List<MsgBean>> call() throws Exception {
                Result<List<MsgBean>> ret = new Result<List<MsgBean>>();
                List<MsgBean> aPage = new ArrayList<MsgBean>();
                for (int i = reqPage * pageSize; i < (reqPage + 1) * pageSize; i++) {
                    MsgBean b = new MsgBean();
                    b.setTitle("系统消息:" + i);
                    b.setContent("可以用在所有的场景，包括外部链接映射到内部页面与内部activity之间的跳转，可以通过Router统一起来"+i+"...");
                    b.setMsgTimeMils(System.currentTimeMillis());
                    b.setId(i);
                    aPage.add(b);
                }
                ret.setData(aPage);
                return ret;
            }
        }, new Callback<Result<List<MsgBean>>>() {

            @Override
            public void onHandle(Result<List<MsgBean>> result) {
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
                    new AlertDialog.Builder(SystemMsgActivity.this).setMessage(result.getErrorMsg()).show();
                }
                listHolder.mayShowEmpty(adapter.getCount());
                listHolder.list.onRefreshComplete();
            }
        });

    }


    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        MsgBean m = (MsgBean) parent.getItemAtPosition(position);
        UIUtils.toast(SystemMsgActivity.this, m.getTitle(), Toast.LENGTH_SHORT);
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        initData(true);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        initData(false);
    }
}
