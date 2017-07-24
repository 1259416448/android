package arvix.cn.ontheway.ui.msg;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.List;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.utils.StaticMethod;

/**
 * Created by asdtiang on 2017/7/24 0024.
 * asdtiangxia@163.com
 */

public class SystemMsgAdapter  extends ArrayAdapter<MsgBean> {
    Context ctx;
    List<MsgBean> datas;
    LayoutInflater mInflater;
    int layout;

    public SystemMsgAdapter( Context context,  List<MsgBean> datas) {
        super(context, R.layout.system_msg_item);
        this.layout = R.layout.system_msg_item;
        this.ctx = context;
        this.datas = datas;
        mInflater = LayoutInflater.from(ctx);
    }

    public int getCount() {
        return datas.size();
    }

    public MsgBean getItem(int position) {
        return datas.get(position);
    }

    public long getItemId(int position) {
        long id = -1;
        if(datas.get(position)!=null){
            id  = datas.get(position).getId();
        }
        return id;
    }

    public View getView(final int position, View convertView, ViewGroup parent) {
        SystemMsgAdapter.ViewHolder h = null;
        if (convertView == null) {
            convertView = mInflater.inflate(layout, parent, false);
            h = new SystemMsgAdapter.ViewHolder();
            x.view().inject(h, convertView);
            convertView.setTag(h);
        } else {
            h = (SystemMsgAdapter.ViewHolder) convertView.getTag();
        }
        MsgBean bean = getItem(position);
        h.titleTv.setText(StaticMethod.genLesStr(bean.getTitle(),10));
        h.contentTv.setText(StaticMethod.genLesStr(bean.getContent(),40));
        h.timeTv.setText(StaticMethod.formatDate(bean.getMsgTimeMils(),"HH:MM"));
        return convertView;
    }

    private class ViewHolder {
        @ViewInject(R.id.system_msg_title)
        TextView titleTv;

        @ViewInject(R.id.system_msg_content)
        TextView contentTv;

        @ViewInject(R.id.system_msg_time)
        TextView timeTv;


    }

}
