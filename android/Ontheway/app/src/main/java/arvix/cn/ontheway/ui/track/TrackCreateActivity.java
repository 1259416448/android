package arvix.cn.ontheway.ui.track;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.pizidea.imagepicker.AndroidImagePicker;
import com.pizidea.imagepicker.Util;
import com.pizidea.imagepicker.bean.ImageItem;

import org.xutils.http.RequestParams;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.atomic.AtomicInteger;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.async.AsyncUtil;
import arvix.cn.ontheway.async.Callback;
import arvix.cn.ontheway.async.Result;
import arvix.cn.ontheway.bean.BaseResponse;
import arvix.cn.ontheway.bean.QiniuBean;
import arvix.cn.ontheway.http.ServerUrl;
import arvix.cn.ontheway.service.inter.CacheService;
import arvix.cn.ontheway.service.inter.FileUploadCallBack;
import arvix.cn.ontheway.service.inter.ImageFileUploadService;
import arvix.cn.ontheway.ui.AddressSelectActivity;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;
import arvix.cn.ontheway.utils.MyProgressDialog;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;
import arvix.cn.ontheway.utils.Windows;

/**
 * Created by asdtiang on 2017/8/1 0001.
 * asdtiangxia@163.com
 */

public class TrackCreateActivity extends BaseActivity {
    @ViewInject(R.id.grid_layout_img)
    private GridView mGridView;
    @ViewInject(R.id.change_address_line)
    private View changeAddressLine;
    @ViewInject(R.id.address_tv)
    private TextView addressTV;
    @ViewInject(R.id.content_tv)
    private TextView contentTV;
    CacheService cache;
    private static String TAG = TrackCreateActivity.class.getName();
   // GridView mGridView;
    SelectAdapter mAdapter;
    private View imageViewAddLine;
    private ImageItem addBtnItem = new ImageItem(null,null,System.currentTimeMillis());
    private ViewGroup.LayoutParams gridItemParams ;
    private RelativeLayout.LayoutParams paramsImg ;
    ImageFileUploadService fileUploadService;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        fileUploadService = OnthewayApplication.getInstahce(ImageFileUploadService.class);
        setContentView(R.layout.activity_track_create);
        cache = OnthewayApplication.getInstahce(CacheService.class);
        HeaderHolder head=new HeaderHolder();
        head.init(self,"发布足迹");
        head.setUpRightTextBtn("发布", new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                final MyProgressDialog wait= Windows.waiting(self);
                final Integer count =  mAdapter.getCount();
                final AtomicInteger countAtom = new AtomicInteger(mAdapter.getCount());
                if(count!=9){
                    countAtom.decrementAndGet();
                }
                final List<QiniuBean> qiniuBeanList = new ArrayList<QiniuBean>();
                AsyncUtil.goAsync(new Callable<Result<Void>>() {
                    @Override
                    public Result<Void> call() throws Exception {
                        int countNew = countAtom.get();
                        for(int i=0;i<countNew;i++){
                            try {
                                fileUploadService.upload(self, mAdapter.getItem(i).path,StaticVar.IMAGE_COMPRESS_SIZE_DEFAULT, null, new FileUploadCallBack() {
                                    @Override
                                    public void uploadBack(BaseResponse baseResponse) {
                                        if (baseResponse.getCode() == StaticVar.SUCCESS) {
                                            QiniuBean qiniuBean = (QiniuBean) baseResponse.getBodyBean();
                                            qiniuBeanList.add(qiniuBean);
                                            countAtom.decrementAndGet();
                                        } else {
                                            StaticMethod.showToast("上传失败" + baseResponse.getCode(), self);
                                        }
                                    }
                                });
                            }catch (Exception e){
                                countAtom.decrementAndGet();
                                e.printStackTrace();
                            }
                        }
                        return null;
                    }
                }, new Callback<Result<Void>>() {
                    @Override
                    public void onHandle(Result<Void> result) {
                    }
                });
                AsyncUtil.goAsync(new Callable<Result<Void>>() {
                    @Override
                    public Result<Void> call() throws Exception {
                       while (countAtom.get()!=0){
                           Thread.sleep(100);
                           Log.i(logTag,"countAtom------------->:"+ countAtom.get());
                       }
                       //upload
                        /*
                        *
  "documents": [
    {
      "fileSize": 0,
      "fileType": "string",
      "fileUrl": "string",
      "h": 0,
      "id": 0,
      "name": "string",
      "w": 0
    }
  ],
  "footprint": {
    "address": "string",
    "business": 0,
    "content": "string",
    "distance": 0,
    "footprintPhoto": "string",
    "id": 0,
    "ifDelete": true,
    "latitude": 0,
    "longitude": 0
  }
}*/
                        RequestParams requestParams = new RequestParams();
                        requestParams.setUri( ServerUrl.FOOTPRINT_CREATE);
                        Map<String,Object> parMap = new HashMap<>();
                        parMap.put("documents",qiniuBeanList);
                        Map<String,Object> footprintMap = new HashMap<>();

                        String content = contentTV.getText().toString();
                        String address = addressTV.getText().toString();
                        footprintMap.put("address",address);
                        footprintMap.put("content",content);

                        Double latCache = cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LAT);
                        Double lonCache = 0.0;
                        if(latCache!=null){
                            lonCache = cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LON);
                            footprintMap.put("latitude",latCache);
                            footprintMap.put("longitude",lonCache);
                        }
                        parMap.put("footprint",footprintMap);
                        requestParams.setBodyContent(JSON.toJSONString(parMap));
                        x.http().post(requestParams, new org.xutils.common.Callback.CommonCallback<String>() {
                            @Override
                            public void onSuccess(String result) {
                                try {
                                    Log.i("onSuccess-->","result->"+result.toString());
                                    wait.dismiss();
                                    StaticMethod.showToast("发布成功",self);
                                    finish();
                                }catch (Exception e){
                                    e.printStackTrace();
                                }
                            }

                            @Override
                            public void onError(Throwable throwable, boolean b) {

                            }

                            @Override
                            public void onCancelled(CancelledException e) {

                            }

                            @Override
                            public void onFinished() {

                            }
                        });



                       return null;
                    }
                }, new Callback<Result<Void>>() {
                    @Override
                    public void onHandle(Result<Void> result) {
                        wait.dismiss();
                    }
                });





            }
        });
        x.view().inject(this);
        addressTV.setText(cache.get(StaticVar.BAIDU_LOC_CACHE_ADDRESS));
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



