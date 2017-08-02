package arvix.cn.ontheway.ui.track;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.GridLayout;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

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
import arvix.cn.ontheway.ui.AddressSelectActivity;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;
import arvix.cn.ontheway.ui.usercenter.MyTrackDetailActivity;
import arvix.cn.ontheway.ui.view.ListViewHolder;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;

/**
 * Created by asdtiang on 2017/8/1 0001.
 * asdtiangxia@163.com
 */

public class TrackCreateActivity extends BaseActivity {
    @ViewInject(R.id.grid_layout_img)
    private GridView mGridView;
    @ViewInject(R.id.change_address_line)
    private View changeAddressLine;

    private static String TAG = TrackCreateActivity.class.getName();
   // GridView mGridView;
    SelectAdapter mAdapter;
    private View imageViewAddLine;
    private ImageItem addBtnItem = new ImageItem(null,null,System.currentTimeMillis());
    private ViewGroup.LayoutParams gridItemParams ;
    private RelativeLayout.LayoutParams paramsImg ;
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
        //init grid item and img width;
        int screenWidth = getWindowManager().getDefaultDisplay().getWidth();
        int delImgRadio = Util.dp2px(TrackCreateActivity.this,12.5f);
        int gridViewWidth =(screenWidth - Util.dp2px(TrackCreateActivity.this,5*3)-Util.dp2px(TrackCreateActivity.this,30))/4;
        int imgWidth =  gridViewWidth -  delImgRadio  ;

        gridItemParams = new ViewGroup.LayoutParams(gridViewWidth, gridViewWidth);
        paramsImg = new RelativeLayout.LayoutParams(imgWidth, imgWidth);
        paramsImg.setMargins(0,delImgRadio,delImgRadio,0);
        //image add line
        addBtnItem.path="";
        addBtnItem.name="";
        addBtnItem.time = 0;
        mAdapter.add(addBtnItem);
        //gen imageViewAdd
        imageViewAddLine = LayoutInflater.from(this).inflate(R.layout.track_create_img_add,mGridView,false);
        ImageView ivAdd = (ImageView) imageViewAddLine.findViewById(R.id.add_image_iv);
        imageViewAddLine.setLayoutParams(gridItemParams);
        LinearLayout.LayoutParams lineImgParams = new LinearLayout.LayoutParams(imgWidth, imgWidth);
        lineImgParams.setMargins(0,delImgRadio,delImgRadio,0);
        ivAdd.setLayoutParams(lineImgParams);

        imageViewAddLine.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                boolean isShowCamera = true;
                AndroidImagePicker picker =  AndroidImagePicker.getInstance();
                // -1 : add img btn
                picker.setSelectLimit(StaticVar.MAX_PHOTO_SELECT - mAdapter.getCount() + 1);
                picker.pickMulti(TrackCreateActivity.this, isShowCamera, new AndroidImagePicker.OnImagePickCompleteListener() {
                    @Override
                    public void onImagePickComplete(List<ImageItem> items) {
                        if(items != null && items.size() > 0){
                            Log.i(TAG,"=====selected："+items.get(0).path);
                            mAdapter.remove(addBtnItem);
                            mAdapter.addAll(items);
                            if(mAdapter.getCount()<9){
                                mAdapter.add(addBtnItem);
                            }
                        }
                    }
                });
            }
        });

        changeAddressLine.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(self,AddressSelectActivity.class));
            }
        });


    }
    class SelectAdapter extends ArrayAdapter<ImageItem> {
        LayoutInflater mInflater;
        public SelectAdapter(Context context) {
            super(context, 0);
            mInflater = LayoutInflater.from(context);
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {

            ImageItem item = getItem(position);
            View view = null;
            if("".equals(item.name)){//添加图标
               view = imageViewAddLine;
            }else{
                view = mInflater.inflate(R.layout.track_create_img_show, parent,false);
                ImageView imageView = (ImageView) view.findViewById(R.id.img_iv);
                imageView.setBackgroundColor(Color.WHITE);
                view.setLayoutParams(gridItemParams);
                imageView.setLayoutParams(paramsImg);
                StaticMethod.setImg(item.path,imageView,imageView.getWidth(),imageView.getWidth());

                View delBtn = view.findViewById(R.id.del_btn);
                delBtn.setTag(item);
                delBtn.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        ImageItem delItem = (ImageItem) v.getTag();
                        mAdapter.remove(delItem);
                        if(mAdapter.getPosition(addBtnItem)==-1){
                            mAdapter.add(addBtnItem);
                        }
                    }
                });
            }
            return view;
        }
    }
}



