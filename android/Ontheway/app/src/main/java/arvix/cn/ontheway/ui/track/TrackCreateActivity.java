package arvix.cn.ontheway.ui.track;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.GridLayout;
import android.widget.GridView;
import android.widget.ImageView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.pizidea.imagepicker.AndroidImagePicker;
import com.pizidea.imagepicker.ImgLoader;
import com.pizidea.imagepicker.UilImgLoader;
import com.pizidea.imagepicker.Util;
import com.pizidea.imagepicker.bean.ImageItem;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.List;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.TrackBean;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;
import arvix.cn.ontheway.ui.view.ListViewHolder;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;

/**
 * Created by asdtiang on 2017/8/1 0001.
 * asdtiangxia@163.com
 */

public class TrackCreateActivity extends BaseActivity {
    @ViewInject(R.id.add_image_btn)
    private Button addImgBtn;
    @ViewInject(R.id.grid_layout_img)
    private GridView mGridView;
    private static String TAG = TrackCreateActivity.class.getName();
    ImgLoader presenter = new UilImgLoader();

   // GridView mGridView;
    SelectAdapter mAdapter;

    private int screenWidth;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_track_create);

        HeaderHolder head=new HeaderHolder();
        head.init(self,"发布足迹");
        head.setUpRightTextBtn("发布", new View.OnClickListener() {
            @Override
            public void onClick(View view) {



            }
        });
        x.view().inject(this);
        mAdapter = new SelectAdapter(this);
        mGridView.setAdapter(mAdapter);

        screenWidth = getWindowManager().getDefaultDisplay().getWidth();

        addImgBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                boolean isShowCamera = true;
                AndroidImagePicker.getInstance().pickMulti(TrackCreateActivity.this, isShowCamera, new AndroidImagePicker.OnImagePickCompleteListener() {
                    @Override
                    public void onImagePickComplete(List<ImageItem> items) {
                        if(items != null && items.size() > 0){
                            Log.i(TAG,"=====selected："+items.get(0).path);
                            mAdapter.clear();
                            mAdapter.addAll(items);
                        }
                    }
                });
            }
        });


    }
    class SelectAdapter extends ArrayAdapter<ImageItem> {

        //private int mResourceId;
        public SelectAdapter(Context context) {
            super(context, 0);
            //this.mResourceId = resource;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {

            ImageItem item = getItem(position);
            LayoutInflater inflater = getLayoutInflater();
            //View view = inflater.inflate(mResourceId, null);
            int width = (screenWidth - Util.dp2px(TrackCreateActivity.this,20*3))/4;

            ImageView imageView = new ImageView(TrackCreateActivity.this);
            imageView.setBackgroundColor(Color.GRAY);
            GridView.LayoutParams params = new AbsListView.LayoutParams(width, width);
            imageView.setLayoutParams(params);
            presenter.onPresentImage(imageView,item.path,width);
            return imageView;
        }

    }

}



