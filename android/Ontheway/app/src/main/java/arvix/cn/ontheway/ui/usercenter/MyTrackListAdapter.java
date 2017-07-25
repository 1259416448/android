package arvix.cn.ontheway.ui.usercenter;

import android.content.Context;
import android.support.annotation.LayoutRes;
import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.Calendar;
import java.util.List;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.been.MyTrackBean;
import arvix.cn.ontheway.utils.StaticMethod;

/**
 * Created by asdtiang on 2017/7/25 0025.
 * asdtiangxia@163.com
 */

public class MyTrackListAdapter extends ArrayAdapter<MyTrackBean> {
    Context ctx;
    List<MyTrackBean> dataList;
    LayoutInflater mInflater;
    int layout;
    int currentDay;
    public MyTrackListAdapter(@NonNull Context context, @LayoutRes int resource,List<MyTrackBean> dataList) {
        super(context, resource);
        this.layout = resource;
        this.ctx = context;
        mInflater = LayoutInflater.from(ctx);
        this.dataList = dataList;
        currentDay = Calendar.getInstance().get(Calendar.DAY_OF_MONTH);
    }
    public int getCount() {
        return dataList.size();
    }

    public MyTrackBean getItem(int position) {
        return dataList.get(position);
    }

    public long getItemId(int position) {
        long id = -1;
        if(dataList.get(position)!=null){
            id  = dataList.get(position).getId();
        }
        return id;
    }

    public View getView(final int position, View convertView, ViewGroup parent) {
        MyTrackListAdapter.ViewHolder h = null;
        if (convertView == null) {
            convertView = mInflater.inflate(layout, parent, false);
            h = new MyTrackListAdapter.ViewHolder();
            x.view().inject(h, convertView);
            convertView.setTag(h);
        } else {
            h = (MyTrackListAdapter.ViewHolder) convertView.getTag();
        }
        MyTrackBean bean = getItem(position);
        h.monthTimeLine.setVisibility(View.VISIBLE);
        h.dayTimeTv.setVisibility(View.VISIBLE);
        if( position==0 && currentDay==bean.getDay()){
            h.monthTimeLine.setVisibility(View.GONE);
            h.dayTimeTv.setVisibility(View.INVISIBLE);
        }if(position>0){
            MyTrackBean lastBean = getItem(position-1);
            if (bean.getMonth()==lastBean.getMonth()) {
                h.monthTimeLine.setVisibility(View.GONE);
            }
            if (bean.getDay()==lastBean.getDay() && bean.getMonth()==lastBean.getMonth()) {
                h.dayTimeTv.setVisibility(View.INVISIBLE);
            }
        }
        h.monthTimeTv.setText(bean.getMonth()+"月");
        h.dayTimeTv.setText(bean.getDay()+"日");
        h.contentTv.setText(StaticMethod.genLesStr(bean.getContent(),200));
        h.addressTv.setText(StaticMethod.genLesStr(bean.getAddress(),20));
        return convertView;
    }

    private class ViewHolder {
        @ViewInject(R.id.month_time_line)
        View monthTimeLine;

        @ViewInject(R.id.month_time_tv)
        TextView monthTimeTv;

        @ViewInject(R.id.day_time_tv)
        TextView dayTimeTv;

        @ViewInject(R.id.content_tv)
        TextView contentTv;
        @ViewInject(R.id.address_tv)
        TextView addressTv;

    }

}
