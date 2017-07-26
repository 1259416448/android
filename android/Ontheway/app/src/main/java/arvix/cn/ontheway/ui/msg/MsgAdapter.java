package arvix.cn.ontheway.ui.msg;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.List;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.been.MsgBean;

public class MsgAdapter extends ArrayAdapter<MsgBean> {
    Context ctx;
    List<MsgBean> datas;
    LayoutInflater mInflater;
    int layout;

    public MsgAdapter(Context ctx, List<MsgBean> datas) {
        super(ctx, R.layout.msg_item, R.id.text);
        this.layout = R.layout.msg_item;
        this.ctx = ctx;
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
        return position;
    }

    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder h = null;
        if (convertView == null) {
            convertView = mInflater.inflate(layout, parent, false);
            h = new ViewHolder();
            x.view().inject(h, convertView);
            convertView.setTag(h);
        } else {
            h = (ViewHolder) convertView.getTag();
        }

        h.titleTv.setText(getItem(position).getTitle());
        return convertView;
    }

    private class ViewHolder {
        @ViewInject(R.id.msg_title)
        TextView titleTv;
    }
}
