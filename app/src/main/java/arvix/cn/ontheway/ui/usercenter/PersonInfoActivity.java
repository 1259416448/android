package arvix.cn.ontheway.ui.usercenter;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.annotation.Nullable;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.fastjson.util.TypeUtils;
import com.pizidea.imagepicker.AndroidImagePicker;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.Random;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.BaseResponse;
import arvix.cn.ontheway.bean.UserInfo;
import arvix.cn.ontheway.http.ServerUrl;
import arvix.cn.ontheway.service.inter.CacheService;
import arvix.cn.ontheway.service.inter.FileUploadCallBack;
import arvix.cn.ontheway.service.inter.ImageFileUploadService;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;

import static android.R.attr.data;

/**
 * Created by asdtiang on 2017/7/21 0021.
 * asdtiangxia@163.com
 */

public class PersonInfoActivity extends BaseActivity implements View.OnClickListener{


    @ViewInject(R.id.nameTv)
    private TextView nameTV;
    @ViewInject(R.id.sex_tv)
    private TextView sexTV;
    @ViewInject(R.id.phone_tv)
    private TextView phoneTV;
    @ViewInject(R.id.header_img)
    private ImageView headerIV;
    private PopupWindow popupWindow;
    private Button btn_camera;
    private Button btn_album;
    private Button btn_cancel;
    /* 请求识别码 */
    private static final int CODE_GALLERY_REQUEST = 0xa0;
    private static final int CODE_CAMERA_REQUEST = 0xa1;
    private static final int CODE_RESULT_REQUEST = 0xa2;
    /* 头像文件 */
    private static final String IMAGE_FILE_NAME = "temp_head_image.jpg";
    // 裁剪后图片的宽(X)和高(Y),480 X 480的正方形。
    private static int output_X = 480;
    private static int output_Y = 480;

    ImageFileUploadService imageFileUploadService;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_person_info);
        imageFileUploadService = OnthewayApplication.getInstahce(ImageFileUploadService.class);
        initView();
    }

    //正整数，小于等于0会导致不响应onActivityResult
    private final int REQ_GET_NAME_EDIT = new Random().nextInt(Integer.MAX_VALUE);

    private void initView() {
        x.view().inject(this);
        new HeaderHolder().init(self, "个人信息");
        nameTV.setText(App.userInfo.getName());
        sexTV.setText(StaticMethod.genSexShow());
        phoneTV.setText(StaticMethod.genPhoneShow());
        nameTV.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(self, EditNicknameActivity.class);
                intent.putExtra(EditNicknameActivity.EXTRA_NICKNAME, App.userInfo.getName());
                startActivityForResult(intent, REQ_GET_NAME_EDIT);
            }
        });
        StaticMethod.setCircularHeaderImg(headerIV, 110, 110);
        headerIV.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
              popwindow();
//                AndroidImagePicker.getInstance().pickAndCrop(PersonInfoActivity.this, true, 160, new AndroidImagePicker.OnImageCropCompleteListener() {
//                    @Override
//                    public void onImageCropComplete(final Bitmap bmp, float ratio) {
//                        ByteArrayOutputStream output = new ByteArrayOutputStream();
//                        byte[] sourceData = StaticMethod.bitmap2Bytes(bmp);
//                        bmp.compress(Bitmap.CompressFormat.JPEG , 80, output);
//                        byte[] data = output.toByteArray();
//                        Log.i(logTag,"sourceDataSize-->"+sourceData.length+" commpress data size:"+data.length);
//                        Log.i(logTag, "=====onImageCropComplete (get bitmap=" + bmp.toString());
//                        imageFileUploadService.upload(self,data,ServerUrl.USER_UPDATE_HEADER,new FileUploadCallBack(){
//                            @Override
//                            public void uploadBack(BaseResponse baseResponse) {
//                                if (baseResponse.getCode() == StaticVar.SUCCESS) {
//                                    UserInfo userInfo = TypeUtils.castToJavaBean(baseResponse.getBody(), UserInfo.class);
//                                    StaticMethod.updateUserInfo(self,userInfo);
//                                    StaticMethod.setCircularHeaderImg(headerIV,110,110);
//                                } else {
//                                    StaticMethod.showToast("上传失败" + baseResponse.getCode(), self);
//                                }
//                            }
//                        });
//                    }
//                });
            }
        });
    }


    public void popwindow() {
        popupWindow = new PopupWindow();
        View view = LayoutInflater.from(PersonInfoActivity.this).inflate(
                R.layout.item_popwindow, null);
        popupWindow = new PopupWindow(view,
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT);
        // 取得焦点
        popupWindow.setFocusable(true);
//        //注意  要是点击外部空白处弹框消息  那么必须给弹框设置一个背景色  不然是不起作用的
//        popupWindow.setBackgroundDrawable(new BitmapDrawable());
        //点击外部消失
        popupWindow.setOutsideTouchable(true);
        //设置可以点击
        popupWindow.setTouchable(true);
        //显示窗口
        popupWindow.showAtLocation(view,Gravity.BOTTOM|Gravity.CENTER_HORIZONTAL, 0, 0);
        //设置SelectPicPopupWindow弹出窗体的宽
        popupWindow.setWidth(ViewGroup.LayoutParams.FILL_PARENT);
        //设置SelectPicPopupWindow弹出窗体的高
        popupWindow.setHeight(ViewGroup.LayoutParams.WRAP_CONTENT);
        //实例化一个ColorDrawable颜色为半透明
        ColorDrawable dw = new ColorDrawable(0xb0000000);
        //设置SelectPicPopupWindow弹出窗体的背景
        popupWindow.setBackgroundDrawable(dw);

        btn_camera = (Button) view.findViewById(R.id.btn_camera);
        btn_album = (Button) view.findViewById(R.id.btn_album);
        btn_cancel = (Button) view.findViewById(R.id.btn_cancel);

        btn_camera.setOnClickListener(this);
        btn_album.setOnClickListener(this);
        btn_cancel.setOnClickListener(this);

    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.btn_camera:
                // 启动手机相机拍摄照片作为头像

                Intent intentFromCapture = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

                // 判断存储卡是否可用，存储照片文件
                if (hasSdcard()) {
                    intentFromCapture.putExtra(MediaStore.EXTRA_OUTPUT, Uri
                            .fromFile(new File(Environment
                                    .getExternalStorageDirectory(), IMAGE_FILE_NAME)));
                }

                startActivityForResult(intentFromCapture, CODE_CAMERA_REQUEST);
                break;
            case R.id.btn_album:
                // 从本地相册选取图片作为头像

                Intent intentFromGallery = new Intent();
                // 设置文件类型
                intentFromGallery.setType("image/*");
                intentFromGallery.setAction(Intent.ACTION_GET_CONTENT);
                startActivityForResult(intentFromGallery, CODE_GALLERY_REQUEST);
                break;
            case R.id.btn_cancel:
                popupWindow.dismiss();
                break;

        }
    }


    /**
     * 提取保存裁剪之后的图片数据，并设置头像部分的View
     */
    private void setImageToHeadView(Intent intent) {
        Bundle extras = intent.getExtras();
        if (extras != null) {
            Bitmap photo = extras.getParcelable("data");
            headerIV.setImageBitmap(photo);
        }
    }

    /**
     * 裁剪原始的图片
     */
    public void cropRawPhoto(Uri uri) {

        Intent intent = new Intent("com.android.camera.action.CROP");
        intent.setDataAndType(uri, "image/*");

        // 设置裁剪
        intent.putExtra("crop", "true");

        // aspectX , aspectY :宽高的比例
        intent.putExtra("aspectX", 1);
        intent.putExtra("aspectY", 1);

        // outputX , outputY : 裁剪图片宽高
        intent.putExtra("outputX", output_X);
        intent.putExtra("outputY", output_Y);
        intent.putExtra("return-data", true);

        startActivityForResult(intent, CODE_RESULT_REQUEST);
    }

    /**
     * 检查设备是否存在SDCard的工具方法
     */
    public static boolean hasSdcard() {
        String state = Environment.getExternalStorageState();
        if (state.equals(Environment.MEDIA_MOUNTED)) {
            // 有存储的SDCard
            return true;
        } else {
            return false;
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            if (requestCode == REQ_GET_NAME_EDIT) {
                String s = data.getStringExtra(EditNicknameActivity.EXTRA_NICKNAME);
                nameTV.setText(s);
                App.userInfo.setName(s);
                StaticMethod.updateUserInfo(self,App.userInfo);
            }
        }
//         用户没有进行有效的设置操作，返回
        if (resultCode == RESULT_CANCELED) {
            Toast.makeText(getApplication(), "取消", Toast.LENGTH_LONG).show();
            return;
        }
        switch (requestCode) {
            case CODE_GALLERY_REQUEST:
                cropRawPhoto(data.getData());
                break;

            case CODE_CAMERA_REQUEST:
                if (hasSdcard()) {
                    File tempFile = new File(
                            Environment.getExternalStorageDirectory(),
                            IMAGE_FILE_NAME);
                    cropRawPhoto(Uri.fromFile(tempFile));
                } else {
                    Toast.makeText(getApplication(), "没有SDCard!", Toast.LENGTH_LONG)
                            .show();
                }

                break;

            case CODE_RESULT_REQUEST:
                if (data != null) {
                    setImageToHeadView(data);
                }

                break;
        }
    }
}
