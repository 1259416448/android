package arvix.cn.ontheway.ui;

import android.content.Context;
import android.support.annotation.LayoutRes;
import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import org.xutils.image.ImageOptions;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;
import java.util.List;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.ARPoint;

/**
 * Created by asdtiang on 2017/8/2 0002.
 * asdtiangxia@163.com
 */

public class AddressSelectAdapter extends ArrayAdapter<ARPoint> {
    Context ctx;
    List<ARPoint> dataList;
    LayoutInflater mInflater;
    int layout;


    public AddressSelectAdapter(@NonNull Context context, @LayoutRes int resource, List<ARPoint> dataList) {
        super(context, resource);
        this.layout = resource;
        this.ctx = context;
        mInflater = LayoutInflater.from(ctx);
        this.dataList = dataList;
    }


    public int getCount() {
        return dataList.size();
    }

    public ARPoint getItem(int position) {
        return dataList.get(position);
    }

    public long getItemId(int position) {
        long id = -1;
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
        ARPoint bean = getItem(position);
        h.contentTv.setText(bean.getPoiInfo().name);
        h.addressTv.setText(bean.getPoiInfo().address);
        h.selectedIv.setVisibility(View.INVISIBLE);
        return convertView;
    }


    private class ViewHolder {

        @ViewInject(R.id.name_tv)
        TextView contentTv;
        @ViewInject(R.id.address_tv)
        TextView addressTv;
        @ViewInject(R.id.selected_iv)
        ImageView selectedIv;

    }

}
