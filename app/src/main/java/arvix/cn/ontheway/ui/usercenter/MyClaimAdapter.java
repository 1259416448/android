package arvix.cn.ontheway.ui.usercenter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.List;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.CommentBean;
import arvix.cn.ontheway.utils.StaticMethod;

/**
 * Created by asdtiang on 2017/7/27 0027.
 * asdtiangxia@163.com
 */

public class MyClaimAdapter extends ArrayAdapter<CommentBean> {
    Context ctx;
    List<CommentBean> datas;
    LayoutInflater mInflater;
    int layout;

    public MyClaimAdapter(Context ctx, List<CommentBean> datas) {
        super(ctx, R.layout.my_claim_item);
        this.layout = R.layout.my_claim_item;
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
        StaticMethod.setImg(commentBean.getMainPhoto(),h.mainPhotoIv,h.mainPhotoIv.getWidth(),h.mainPhotoIv.getHeight());
        StaticMethod.setCircularHeaderImg(commentBean.getUserHeadImg(),h.replayHeaderIv,h.replayHeaderIv.getWidth(),h.replayHeaderIv.getHeight());

        h.replayNameTv.setText(commentBean.getUserNickname());
        h.replayTimeTv.setText(StaticMethod.formatDate(commentBean.getDateCreate(),"MM-dd HH:ss"));
        h.replayContentTv.setText(StaticMethod.genLesStr(commentBean.getCommentContent(),35));
        h.sourceContentTv.setText(StaticMethod.genLesStr(commentBean.getSourceContent(),30));
        h.sourceNameTv.setText(commentBean.getSourceMsgUserName());

        return convertView;
    }

    private class ViewHolder {
        @ViewInject(R.id.reply_header_iv)
        ImageView replayHeaderIv;

        @ViewInject(R.id.reply_name_tv)
        TextView replayNameTv;

        @ViewInject(R.id.reply_time_tv)
        TextView replayTimeTv;

        @ViewInject(R.id.source_name_tv)
        TextView sourceNameTv;

        @ViewInject(R.id.source_content_tv)
        TextView sourceContentTv;

        @ViewInject(R.id.reply_content_tv)
        TextView replayContentTv;

        @ViewInject(R.id.main_photo_iv)
        ImageView mainPhotoIv;

        @ViewInject(R.id.reply_btn)
        Button replayBtn;

    }
}
