package arvix.cn.ontheway.ui.track;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;
import java.util.List;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.CommentBean;
import arvix.cn.ontheway.utils.StaticMethod;

/**
 * Created by asdtiang on 2017/7/31 0031.
 * asdtiangxia@163.com
 */

public class TrackDetailReplyAdapter   extends ArrayAdapter<CommentBean> {
    Context ctx;
    List<CommentBean> datas;
    LayoutInflater mInflater;
    int layout;

    public TrackDetailReplyAdapter(Context ctx, List<CommentBean> datas) {
        super(ctx, R.layout.track_detail_reply_item);
        this.layout = R.layout.track_detail_reply_item;
        this.ctx = ctx;
        this.datas = datas;
        mInflater = LayoutInflater.from(ctx);
    }

    public int getCount() {
        return datas.size();
    }

    public CommentBean getItem(int position) {
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
        CommentBean commentBean = getItem(position);
        StaticMethod.setCircularHeaderImg(commentBean.getUserHeadImg(),h.replayHeaderIv,h.replayHeaderIv.getWidth(),h.replayHeaderIv.getHeight());
        h.replayNameTv.setText(commentBean.getUserNickname());
        h.replayTimeTv.setText(commentBean.getDateCreatedStr());
        h.replayContentTv.setText(StaticMethod.genLesStr(commentBean.getCommentContent(),35));
        return convertView;
    }

    private class ViewHolder {
        @ViewInject(R.id.reply_header_iv)
        ImageView replayHeaderIv;

        @ViewInject(R.id.reply_name_tv)
        TextView replayNameTv;

        @ViewInject(R.id.reply_time_tv)
        TextView replayTimeTv;

        @ViewInject(R.id.reply_content_tv)
        TextView replayContentTv;
    }
}
