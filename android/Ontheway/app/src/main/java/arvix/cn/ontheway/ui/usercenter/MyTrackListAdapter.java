package arvix.cn.ontheway.ui.usercenter;

import android.content.Context;
import android.support.annotation.LayoutRes;
import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.GridLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import org.xutils.image.ImageOptions;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.Calendar;
import java.util.List;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.TrackBean;
import arvix.cn.ontheway.utils.StaticMethod;

/**
 * Created by asdtiang on 2017/7/25 0025.
 * asdtiangxia@163.com
 */

public class MyTrackListAdapter extends ArrayAdapter<TrackBean> {
    Context ctx;
    List<TrackBean> dataList;
    LayoutInflater mInflater;
    int layout;
    int currentDay;
    int oneImW;
    int oneImH;
    int marginSpace ;
    int halfW;
    int halfH;
    LinearLayout.LayoutParams marginLeft ;
    LinearLayout.LayoutParams marginTop;
    LinearLayout.LayoutParams marginLeftAndTop;
    public MyTrackListAdapter(@NonNull Context context, @LayoutRes int resource,List<TrackBean> dataList) {
        super(context, resource);
        this.layout = resource;
        this.ctx = context;
        mInflater = LayoutInflater.from(ctx);
        this.dataList = dataList;
        this.oneImW = StaticMethod.dip2px(ctx,80);
        this.oneImH = this.oneImW;
        this.marginSpace  = StaticMethod.dip2px(ctx,2);
        this.halfW = StaticMethod.dip2px(ctx,39);
        this.halfH = StaticMethod.dip2px(ctx,39);
        currentDay = Calendar.getInstance().get(Calendar.DAY_OF_MONTH);

        marginLeft = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        marginLeft.setMargins(marginSpace, 0, 0, 0);

        marginTop = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        marginTop.setMargins(0, marginSpace, 0, 0);

        marginLeftAndTop = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        marginLeftAndTop.setMargins(marginSpace, marginSpace, 0, 0);
    }
    public int getCount() {
        return dataList.size();
    }

    public TrackBean getItem(int position) {
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
        MyTrackListAdapter.ViewHolder h = null;
        if (convertView == null) {
            convertView = mInflater.inflate(layout, parent, false);
            h = new MyTrackListAdapter.ViewHolder();
            x.view().inject(h, convertView);
            convertView.setTag(h);
        } else {
            h = (MyTrackListAdapter.ViewHolder) convertView.getTag();
        }
        TrackBean bean = getItem(position);
        h.monthTimeLine.setVisibility(View.VISIBLE);
        h.dayTimeTv.setVisibility(View.VISIBLE);
        if( position==0 && currentDay==bean.getDay()){
            h.monthTimeLine.setVisibility(View.GONE);
            h.dayTimeTv.setVisibility(View.INVISIBLE);
        }if(position>0){
            TrackBean lastBean = getItem(position-1);
            if (bean.getMonth()==lastBean.getMonth()) {
                h.monthTimeLine.setVisibility(View.GONE);
            }
            if (bean.getDay()==lastBean.getDay() && bean.getMonth()==lastBean.getMonth()) {
                h.dayTimeTv.setVisibility(View.INVISIBLE);
            }
        }
      //  ImageView imageView = (ImageView)convertView.findViewById(R.id.photo4_grid_img_item);
        int row = 1;//行
        int column = 1;//列
        int photoCount = bean.getFootprintPhotoArray().size();
        h.gridLayout.removeAllViews();

        if(photoCount==1){
            ImageView imageView = new ImageView(ctx);
            appendImage(h.gridLayout,imageView,bean.getFootprintPhotoArray().get(0),oneImW,oneImH);
        }
        if (photoCount == 2) {
            column = 2;
            ImageView imageView = new ImageView(ctx);
            appendImage(h.gridLayout,imageView,bean.getFootprintPhotoArray().get(0),halfW,oneImH);
            imageView = new ImageView(ctx);
            imageView.setLayoutParams(marginLeft);
            appendImage(h.gridLayout,imageView,bean.getFootprintPhotoArray().get(1),halfW,oneImH);
        }
        if (photoCount == 3) {
            column = 2;
            ImageView imageView = new ImageView(ctx);
            appendImage(h.gridLayout,imageView,bean.getFootprintPhotoArray().get(0),halfW,oneImH);

            LinearLayout linearLayout = new LinearLayout(ctx);
            linearLayout.setLayoutParams(marginLeft);
            linearLayout.setOrientation(LinearLayout.VERTICAL);
            imageView = new ImageView(ctx);
            appendImage(linearLayout,imageView,bean.getFootprintPhotoArray().get(1),halfW,halfH);
            imageView = new ImageView(ctx);
            imageView.setLayoutParams(marginTop);
            appendImage(linearLayout,imageView,bean.getFootprintPhotoArray().get(2),halfW,halfH);
            h.gridLayout.addView(linearLayout);
        }
        if (photoCount >= 4) {
            column = 2;
            row = 2;
            ImageView imageView = new ImageView(ctx);
            appendImage(h.gridLayout,imageView,bean.getFootprintPhotoArray().get(0),halfW,halfH);

            imageView = new ImageView(ctx);
            imageView.setLayoutParams(marginLeft);
            appendImage(h.gridLayout,imageView,bean.getFootprintPhotoArray().get(1),halfW,halfH);

            imageView = new ImageView(ctx);
            imageView.setLayoutParams(marginTop);
            appendImage(h.gridLayout,imageView,bean.getFootprintPhotoArray().get(2),halfW,halfH);

            imageView = new ImageView(ctx);
            imageView.setLayoutParams(marginLeftAndTop);
            appendImage(h.gridLayout,imageView,bean.getFootprintPhotoArray().get(2),halfW,halfH);
        }
        h.photoCountTv.setText(String.valueOf(photoCount));
        h.photoCountTv.setAlpha(0.6f);
        h.gridLayout.setColumnCount(column);
        h.gridLayout.setRowCount(row);
        h.monthTimeTv.setText(bean.getMonth()+"月");
        h.dayTimeTv.setText(bean.getDay()+"日");
        h.contentTv.setText(StaticMethod.genLesStr(bean.getFootprintContent(),30));
        h.addressTv.setText(StaticMethod.genLesStr(bean.getFootprintAddress(),15));
        return convertView;
    }

    private void appendImage(ViewGroup gridOrLineLayout,ImageView imageView,String url,int w,int h){
        ImageOptions options = new ImageOptions.Builder()
                //设置图片的大小
                .setSize(w, h)
                // 如果ImageView的大小不是定义为wrap_content, 不要crop.
                .setCrop(true)
                // 加载中或错误图片的ScaleType
                //.setPlaceholderScaleType(ImageView.ScaleType.MATRIX)
                .setImageScaleType(ImageView.ScaleType.CENTER_CROP)
                //设置加载过程中的图片
                .setLoadingDrawableId(R.mipmap.ic_launcher)
                //设置加载失败后的图片
                .setFailureDrawableId(R.mipmap.ic_launcher)
                //设置使用缓存
                .setUseMemCache(true)
                //设置支持gif
                .setIgnoreGif(false).build();
        x.image().bind(imageView, url, options);
        ViewGroup parent = (ViewGroup) imageView.getParent();
        //Log.i("ViewPaperAdapter", parent.toString());
        if (parent != null) {
            parent.removeView(imageView);
        }
        gridOrLineLayout.addView(imageView);
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
        @ViewInject(R.id.photo4_grid_layout)
        GridLayout gridLayout;
        @ViewInject(R.id.show_count_tv)
        TextView photoCountTv;

    }

}
