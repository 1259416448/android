package arvix.cn.ontheway.ui;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.Layout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;

import arvix.cn.ontheway.BaiduActivity;
import arvix.cn.ontheway.MainCardBean;
import arvix.cn.ontheway.MenuBean;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.async.AsyncUtil;
import arvix.cn.ontheway.async.Callback;
import arvix.cn.ontheway.async.Result;
import arvix.cn.ontheway.data.IndexData;
import arvix.cn.ontheway.utils.UIUtils;

/**
 * Created by yd on 2017/7/19.
 */

public class MsgFrag extends BaseFragment {
    @ViewInject(R.id.msg_list)
    private ListView listView;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View root = inflater.inflate(R.layout.msg_list, null);
        x.view().inject(this, root);
        initView(root);
        return root;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        initData();
    }

    private void initData() {
        AsyncUtil.goAsync(new Callable<Result<List<MsgBean>>>() {
            @Override
            public Result<List<MsgBean>> call() throws Exception {
                ArrayList<MsgBean> msgs = new ArrayList<MsgBean>();
                for (int i = 0; i < 500; i++) {
                    MsgBean m = new MsgBean();
                    m.setTitle("hello" + i);
                    msgs.add(m);
                }
                Result r = new Result();
                r.setData(msgs);
                return r;
            }
        }, new Callback<Result<List<MsgBean>>>() {
            @Override
            public void onHandle(Result<List<MsgBean>> result) {
                if (result.ok()) {
                    bindView(result.getData());
                } else {
                    UIUtils.toast(act, result.getErrorMsg(), Toast.LENGTH_LONG);
                }
            }
        });
    }

    private void bindView(List<MsgBean> data) {
        MsgAdapter adapter = new MsgAdapter(data);
        listView.setAdapter(adapter);
    }

    private void initView(View root) {
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                MsgBean m = (MsgBean) adapterView.getAdapter().getItem(position);
                UIUtils.toast(act, m.getTitle(), Toast.LENGTH_SHORT);
            }
        });
    }

    private class MsgAdapter extends BaseAdapter {
        private List<MsgBean> datas;

        public MsgAdapter(List<MsgBean> datas) {
            this.datas = datas;
        }

        @Override
        public int getCount() {
            return datas.size();
        }

        @Override
        public MsgBean getItem(int i) {
            return datas.get(i);
        }

        @Override
        public long getItemId(int i) {
            return 0;
        }

        @Override
        public View getView(int i, View convertView, ViewGroup viewGroup) {
            MsgBean b = getItem(i);
            LayoutInflater inflater = LayoutInflater.from(act);

            ViewHolder holder = null;
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.msg_item, null);
                holder = new ViewHolder();
                holder.titleTv=convertView.findViewById(R.id.msg_title);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            holder.titleTv.setText(b.getTitle());



            return convertView;
        }
    }
    private static class ViewHolder{
        public TextView titleTv;
    }

}
