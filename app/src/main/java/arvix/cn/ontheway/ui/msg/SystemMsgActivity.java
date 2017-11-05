package arvix.cn.ontheway.ui.msg;

import android.app.AlertDialog;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;
import com.alibaba.fastjson.util.TypeUtils;
import com.handmark.pulltorefresh.library.PullToRefreshBase;

import org.xutils.http.RequestParams;
import org.xutils.x;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.concurrent.Callable;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.async.AsyncUtil;
import arvix.cn.ontheway.async.Callback;
import arvix.cn.ontheway.async.Result;
import arvix.cn.ontheway.bean.BaseResponse;
import arvix.cn.ontheway.bean.FootPrintBean;
import arvix.cn.ontheway.bean.MsgBean;
import arvix.cn.ontheway.bean.Pagination;
import arvix.cn.ontheway.data.NewReplyData;
import arvix.cn.ontheway.http.ServerUrl;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;
import arvix.cn.ontheway.ui.view.ListViewHolder;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;
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
        setContentView(R.layout.activity_msg_system);
        x.view().inject(self);
        HeaderHolder head = new HeaderHolder();
        head.init(self, "系统消息");
        datas = new ArrayList();
        initData(true);
        adapter = new SystemMsgAdapter(this, datas);
        listHolder = ListViewHolder.initList(this);
        listHolder.list.setAdapter(adapter);
        listHolder.list.setOnItemClickListener(this);
        listHolder.list.setMode(PullToRefreshBase.Mode.BOTH);
        listHolder.list.setOnRefreshListener(this);
        listHolder.list.setRefreshing();
    }

    private int pageNum = 0;
    private final int pageSize = 30;

    private void initData(final boolean refresh) {
//        final int reqPage = refresh ? 0 : pageNum;
//        AsyncUtil.goAsync(new Callable<Result<List<MsgBean>>>() {
//
//            @Override
//            public Result<List<MsgBean>> call() throws Exception {
                final Result<List<MsgBean>> ret = new Result<List<MsgBean>>();
//                List<MsgBean> aPage = new ArrayList<MsgBean>();
//                for (int i = reqPage * pageSize; i < (reqPage + 1) * pageSize; i++) {
//                    MsgBean b = new MsgBean();
//                    b.setTitle("系统消息:" + i);
//                    b.setContent("可以用在所有的场景，包括外部链接映射到内部页面与内部activity之间的跳转，可以通过Router统一起来" + i + "...");
//                    b.setMsgTimeMils(System.currentTimeMillis());
//                    b.setId(i);
//                    aPage.add(b);
//                }
//                ret.setData(aPage);
//                return ret;
//            }
//        }, new Callback<Result<List<MsgBean>>>() {
//
//            @Override
//            public void onHandle(Result<List<MsgBean>> result) {
//                if (result.ok()) {
//                    //成功才更新page状态
//                    if (refresh) {
//                        pageNum = 0;
//                    }
//                    pageNum++;
//
//                    if (refresh) {
//                        datas.clear();
//                    }
//                    datas.addAll(result.getData());
//                    adapter.notifyDataSetChanged();
//                } else {
//                    new AlertDialog.Builder(SystemMsgActivity.this).setMessage(result.getErrorMsg()).show();
//                }
//                listHolder.mayShowEmpty(adapter.getCount());
//                listHolder.list.onRefreshComplete();
//            }
//        });


        final RequestParams requestParams = new RequestParams();
        requestParams.setUri(ServerUrl.SYSTEM_MESSAGE);
        requestParams.addHeader("x-auth-token", "d9fbe8c5-76a9-48fb-8557-e4522f80955f");
        requestParams.addHeader("remember-me", "7kA6PmR/UW/Tn//mFQrPHHgmTywhKdvMkEW51MzazFCbR24f+LckdcpRKh1oPHgwTsGhS4fnrALCAHQoRAVTkz6YAGc4hIc7hdU6dl5zgMu/6UmYXqDQhBezAAd7fxWTA0rxVQZbWefgVyRHp94pWrjLPP7hF7rUy0Qbaj4PbcZ/EVSkrgqP9mdG7Imqt6H6QU78RKQ+DOcJNCm8wrFeFj3dtFDrzhcyuFsHvvFhLrZAE8P9+ecT8WCygsFHqFXwc2RokOiYu5vdLYF9YJeKLQALbzjUavoL3/EeRhuCHs3BJUbXHOegIbUwXqjx8pIGLX2MyUFqKT73tGbUsaPL7YW16/18jUIWCm3AMAqxv08+4z+9iG5WBEgeHxCvh3UOlQ2a6YV5XJNRjuO2GwigMzbYEefVDzSKqRki2NLmKITwVR8lqf41SYmM/vTmyY50VbYL/ddJYSqwW0HXCWTSY0UQho06gyHojj0AcDon8KF9Z9bQ/yGEru+30Y6m2ACmshJYLHbS+pvo2fmJy2vwgOYoFePkJ8YZRgZsTYsTuOivSpXrpUNenECbxz4j3B7QAUH8enIbniSmz9/ZeMk2vQ==:MTUxMDI5NzUyODc3MA==");
        requestParams.addQueryStringParameter("number", "1");
        requestParams.addQueryStringParameter("size", "10");
        requestParams.addQueryStringParameter("clear", "true");
                x.http().get(requestParams, new org.xutils.common.Callback.CommonCallback<String>() {
                    @Override
                    public void onSuccess(String result) {
                        if (refresh) {
                            pageNum = 0;
                        }
                        pageNum++;
                        if (refresh) {
                            datas.clear();
                        }
                        datas.addAll(ret.getData());
                        adapter.notifyDataSetChanged();
                        Log.e("TAG",datas.size()+"yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");

                    }

                    @Override
                    public void onError(Throwable throwable, boolean b) {
                        Log.i("TAG", "");
                    }

                    @Override
                    public void onCancelled(CancelledException e) {
                        Log.i("TAG", "");
                    }

                    @Override
                    public void onFinished() {
                        Log.i("TAG", "");
                    }
                });
    };

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
