package arvix.cn.ontheway.ui.msg;

import android.app.AlertDialog;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.Toast;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.async.AsyncUtil;
import arvix.cn.ontheway.async.Callback;
import arvix.cn.ontheway.async.Result;
import arvix.cn.ontheway.been.MsgBean;
import arvix.cn.ontheway.ui.BaseFragment;
import arvix.cn.ontheway.ui.view.ListViewHolder;
import arvix.cn.ontheway.utils.UIUtils;

public class MsgListFrag extends BaseFragment implements OnItemClickListener, PullToRefreshBase.OnRefreshListener2<ListView> {
    private MsgAdapter adapter;
    private List<MsgBean> datas;
    private ListViewHolder listHolder;

    public static MsgListFrag newInstance() {
        MsgListFrag frag = new MsgListFrag();
        Bundle args = new Bundle();
        frag.setArguments(args);
        return frag;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View root = initView(inflater, container, savedInstanceState);
        listHolder.list.setMode(Mode.BOTH);
        listHolder.list.setOnRefreshListener(this);

        return root;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
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
                    b.setTitle("TITLE:" + i);
                    aPage.add(b);
                }
                Thread.sleep(2000);
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
                    new AlertDialog.Builder(act).setMessage(result.getErrorMsg()).show();
                }
                listHolder.mayShowEmpty(adapter.getCount());
                listHolder.list.onRefreshComplete();
            }
        });

    }


    private View initView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View root = inflater.inflate(R.layout.common_list, container, false);
        listHolder = ListViewHolder.initList(act, root);

        datas = new ArrayList<MsgBean>();
        adapter = new MsgAdapter(act, datas);
        listHolder.list.setAdapter(adapter);
        listHolder.list.setOnItemClickListener(this);
        return root;
    }


    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        MsgBean m = (MsgBean) parent.getItemAtPosition(position);
        UIUtils.toast(act, m.getTitle(), Toast.LENGTH_SHORT);
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
