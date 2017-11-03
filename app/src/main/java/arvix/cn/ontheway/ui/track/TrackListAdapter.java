package arvix.cn.ontheway.ui.track;

import android.content.Context;
import android.support.annotation.LayoutRes;
import android.support.annotation.NonNull;
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
import arvix.cn.ontheway.bean.FootPrintBean;
import arvix.cn.ontheway.bean.FootPrintSearchVo;
import arvix.cn.ontheway.utils.StaticMethod;

/**
 * Created by asdtiang on 2017/7/28 0028.
 * asdtiangxia@163.com
 */

public class TrackListAdapter  extends ArrayAdapter<FootPrintBean> {
    Context ctx;
    List<FootPrintBean> dataList;
    LayoutInflater mInflater;
    int layout;

    public TrackListAdapter(@NonNull Context context, @LayoutRes int resource, List<FootPrintBean> dataList) {
        super(context, resource);
        this.layout = resource;
        this.ctx = context;
        mInflater = LayoutInflater.from(ctx);
        this.dataList = dataList;
    }
    public int getCount() {
        return dataList.size();
    }

    public FootPrintBean getItem(int position) {
        return dataList.get(position);
    }

    public long getItemId(int position) {
        long id = -1;
        if(dataList.get(position)!=null){
            id  = dataList.get(position).getFootprintId();
        }
        return id;
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
        FootPrintBean bean = getItem(position);

        h.contentTv.setText(StaticMethod.genLesStr(bean.getFootprintContent(),30));
        h.addressTv.setText(StaticMethod.genLesStr(bean.getFootprintAddress(),20));
        StaticMethod.setCircularHeaderImg(bean.getUserHeadImg(),h.userHeader,h.userHeader.getWidth(),h.userHeader.getHeight());
        h.trackPhotoIv.setVisibility(View.GONE);
        if(bean.getFootprintPhotoArray()!=null && !bean.getFootprintPhotoArray().isEmpty()){
            h.trackPhotoIv.setVisibility(View.VISIBLE);
            StaticMethod.setImg(bean.getFootprintPhotoArray().get(0),h.trackPhotoIv,h.trackPhotoIv.getWidth(),h.trackPhotoIv.getHeight());
        }
        h.nicknameTv.setText(bean.getUserNickname());
        h.timeTv.setText(bean.getDateCreatedStr()+"");
        return convertView;
    }

    private class ViewHolder {
        @ViewInject(R.id.header_iv)
        ImageView userHeader;

        @ViewInject(R.id.nickname_tv)
        TextView nicknameTv;

        @ViewInject(R.id.time_tv)
        TextView timeTv;

        @ViewInject(R.id.content_tv)
        TextView contentTv;
        @ViewInject(R.id.address_tv)
        TextView addressTv;

        @ViewInject(R.id.track_photo_iv)
        ImageView trackPhotoIv;

    }

}
