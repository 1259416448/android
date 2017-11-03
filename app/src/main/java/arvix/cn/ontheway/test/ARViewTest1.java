package arvix.cn.ontheway.test;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.hardware.Camera;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.opengl.Matrix;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.content.ContextCompat;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.KeyEvent;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.widget.Toast;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import arvix.cn.ontheway.BaiduActivity;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.FootPrintSearchVo;
import arvix.cn.ontheway.bean.SearchDistance;
import arvix.cn.ontheway.bean.SearchTime;
import arvix.cn.ontheway.service.impl.BusinessSearchServiceImpl;
import arvix.cn.ontheway.service.inter.CacheService;
import arvix.cn.ontheway.service.inter.FootPrintSearchService;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.MainActivity;
import arvix.cn.ontheway.ui.ar_draw.AROverlayViewDraw;
import arvix.cn.ontheway.ui.ar_view.ARCamera;
import arvix.cn.ontheway.ui.track.TrackCreateActivity;
import arvix.cn.ontheway.ui.track.TrackListActivity;
import arvix.cn.ontheway.ui.track.TrackMapActivity;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;
import arvix.cn.ontheway.utils.UIUtils;

public class ARViewTest1 extends BaseActivity implements SensorEventListener, LocationListener {

	final static String TAG = "ARActivity";
	private  SurfaceView surfaceView;
	private FrameLayout cameraContainerLayout;
	private AROverlayViewDraw arOverlayView;
	private Camera camera;
	private ARCamera arCamera;
	public static TextView tvCurrentLocation;
	public static String searchKeyWord;
	private SensorManager sensorManager;

	float[] accelerometerValues = new float[3];
	float[] magneticFieldValues = new float[3];

	private final static int REQUEST_CAMERA_PERMISSIONS_CODE = 11;
	public static final int REQUEST_LOCATION_PERMISSIONS_CODE = 0;

	private static final long MIN_DISTANCE_CHANGE_FOR_UPDATES = 0; // 10 meters
	private static final long MIN_TIME_BW_UPDATES = 0;//1000 * 60 * 1; // 1 minute
	FootPrintSearchVo trackSearchVo = new FootPrintSearchVo();
	private LocationManager locationManager;
	public Location location;
	boolean isGPSEnabled;
	boolean isNetworkEnabled;
	boolean locationServiceAvailable;
	@ViewInject(R.id.radar_frame)
	private FrameLayout radarFrameLayout;
	@ViewInject(R.id.radar_point_frame)
	private FrameLayout radarPointFrameLayout;
	@ViewInject(R.id.time_btn_line)
	private View timeLine;
	@ViewInject(R.id.range_btn_line)
	private View rangeLine;
	@ViewInject(R.id.time_btn)
	private Button timeButton;
	@ViewInject(R.id.range_btn)
	private Button rangeButton;
	@ViewInject(R.id.to_track_list_btn)
	private Button toTrackListBtn;
	@ViewInject(R.id.total_count_tv)
	private TextView totalCountTv;

	@ViewInject(R.id.address_tv)
	private TextView addressTv;
	@ViewInject(R.id.to_map_btn)
	private Button toMapBtn;
	@ViewInject(R.id.to_create_btn)
	private Button toCreateBtn;
	@ViewInject(R.id.r_100m)
	private Button r100mBtn;
	@ViewInject(R.id.r_500m)
	private Button r500mBtn;
	@ViewInject(R.id.r_1km)
	private Button r1kmBtn;
	@ViewInject(R.id.time_one_day)
	private Button timeOneBtn;
	@ViewInject(R.id.time_7_day)
	private Button timeTwoBtn;
	@ViewInject(R.id.time_one_month)
	private Button timeThreeBtn;
	@ViewInject(R.id.refresh_btn)
	private Button refreshBtn;
	@ViewInject(R.id.back_img)
	private Button backBtn;
	@ViewInject(R.id.shaixuan)
	private Button shaiXuan;
	@ViewInject(R.id.sousuo)
	private Button souSuo;
	public static int SCREEN_WIDTH  = 0;

	public static int SCREEN_HEIGHT  = 0;

	public static Handler handler = null;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Log.i(logTag,"onCreate----------------------------->");
		setContentView(R.layout.activity_ar_view_test);
		UIUtils.setBarStyle(self);
		x.view().inject(this);
		DisplayMetrics metrics = new DisplayMetrics();
		this.getWindowManager().getDefaultDisplay().getMetrics(metrics);

		// 屏幕的分辨率
		SCREEN_WIDTH = metrics.widthPixels;
		SCREEN_HEIGHT = metrics.heightPixels;

		handler = new Handler(){
			public void handleMessage(Message msg){
				String totalCount = msg.getData().getString("totalCount");
				String address = msg.getData().getString("address");
				updateUi(totalCount,address);
			}
		};
		trackSearchVo.setSize(30);
		searchKeyWord = getIntent().getStringExtra(BaiduActivity.EXTRA_KEYWORD);
		sensorManager = (SensorManager) this.getSystemService(SENSOR_SERVICE);
		cameraContainerLayout = (FrameLayout) findViewById(R.id.camera_container_layout);
		surfaceView = (SurfaceView) findViewById(R.id.surface_view);
		tvCurrentLocation = (TextView) findViewById(R.id.tv_current_location);
		arOverlayView = new AROverlayViewDraw(this, FootPrintSearchService.class,(ViewGroup)getWindow().getDecorView(),trackSearchVo,radarPointFrameLayout);

		rangeButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				if(rangeLine.getVisibility() == View.VISIBLE){
					rangeLine.setVisibility(View.INVISIBLE);
				}else{
					rangeLine.setVisibility(View.VISIBLE);
				}
			}
		});

		timeButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				if(timeLine.getVisibility() == View.VISIBLE){
					timeLine.setVisibility(View.INVISIBLE);
				}else{
					timeLine.setVisibility(View.VISIBLE);
				}
			}
		});


		toTrackListBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent intent = new Intent(self, TrackListActivity.class);
				// intent.setFlags(Intent.FLAG_ACTIVITY_PREVIOUS_IS_TOP);
				startActivity(intent);
			}
		});

		toMapBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent intent = new Intent(self, TrackMapActivity.class);
				//  intent.setFlags(Intent.FLAG_ACTIVITY_PREVIOUS_IS_TOP);
				startActivity(intent);
			}
		});

		toCreateBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent intent = new Intent(self, TrackCreateActivity.class);
				// intent.setFlags(Intent.FLAG_ACTIVITY_PREVIOUS_IS_TOP);
				startActivity(intent);
			}
		});
		backBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				back();
			}
		});

		shaiXuan.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {


			}
		});
		souSuo.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {


			}
		});

		initSearchEvent();
	}

	private void back(){
		Intent intent = new Intent(this, MainActivity.class);
		intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
		startActivity(intent);
	}

	/**
	 * 监听Back键按下事件,方法2:
	 * 注意:
	 * 返回值表示:是否能完全处理该事件
	 * 在此处返回false,所以会继续传播该事件.
	 * 在具体项目中此处的返回值视情况而定.
	 */
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if ((keyCode == KeyEvent.KEYCODE_BACK)) {
			back();
			return false;
		}else {
			return super.onKeyDown(keyCode, event);
		}
	}


	private void initSearchEvent(){
		r100mBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				updateSearchDistance(SearchDistance.one);
				rangeLine.setVisibility(View.INVISIBLE);
			}
		});
		r500mBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				updateSearchDistance(SearchDistance.two);
				rangeLine.setVisibility(View.INVISIBLE);
			}
		});
		r1kmBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				updateSearchDistance(SearchDistance.three);
				rangeLine.setVisibility(View.INVISIBLE);
			}
		});


		timeOneBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				updateSearchTime(SearchTime.oneDay);
				timeLine.setVisibility(View.INVISIBLE);
			}
		});
		timeTwoBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				updateSearchTime(SearchTime.sevenDay);
				timeLine.setVisibility(View.INVISIBLE);
			}
		});
		timeThreeBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				updateSearchTime(SearchTime.oneMonth);
				timeLine.setVisibility(View.INVISIBLE);
			}
		});

		refreshBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				if((trackSearchVo.getNumber()+1)<trackSearchVo.getTotalPages()){
					trackSearchVo.setNumber(trackSearchVo.getNumber()+1);
				}else{
					StaticMethod.showToast("已经没有数据了",self);
					trackSearchVo.setNumber(0);
				}
				arOverlayView.updateSearchParams();
			}
		});
	}

	private void updateSearchDistance(SearchDistance distance){
		trackSearchVo.setSearchDistance(distance);
		arOverlayView.updateSearchParams();
	}

	private void updateSearchTime(SearchTime time){
		trackSearchVo.setSearchTime(time);
		arOverlayView.updateSearchParams();
	}


	public void updateUi(String totalCount,String address){
		totalCountTv.setText(totalCount);
		addressTv.setText(StaticMethod.genLesAddressStr(address,5));
		// draw ui
		arOverlayView.invalidate();
	}

	@Override
	public void onResume() {
		super.onResume();
		requestLocationPermission();
		requestCameraPermission();
		registerSensors();
		initAROverlayView();
	}

	@Override
	public void onPause() {
		releaseCamera();
		sensorManager.unregisterListener(this);
		super.onPause();
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		Log.i(logTag,"onDestroy-------------------------------------------->");
		sensorManager.unregisterListener(this);
		if(null!=arOverlayView){
			arOverlayView.clearData();
		}
	}

	public void requestCameraPermission() {
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
				this.checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
			this.requestPermissions(new String[]{Manifest.permission.CAMERA}, REQUEST_CAMERA_PERMISSIONS_CODE);
		} else {
			initARCameraView();
		}
	}

	public void requestLocationPermission() {
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
				this.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
			this.requestPermissions(new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, REQUEST_LOCATION_PERMISSIONS_CODE);
		} else {
			initLocationService();
		}
	}

	public void initAROverlayView() {
		if (arOverlayView.getParent() != null) {
			((ViewGroup) arOverlayView.getParent()).removeView(arOverlayView);
		}
		cameraContainerLayout.addView(arOverlayView);
	}

	public void initARCameraView() {
		reloadSurfaceView();

		if (arCamera == null) {
			arCamera = new ARCamera(this, surfaceView);
		}
		if (arCamera.getParent() != null) {
			((ViewGroup) arCamera.getParent()).removeView(arCamera);
		}
		cameraContainerLayout.addView(arCamera);
		arCamera.setKeepScreenOn(true);
		initCamera();

	}

	private void initCamera() {
		int numCams = Camera.getNumberOfCameras();
		if(numCams > 0){
			try{
				camera = Camera.open();
				camera.startPreview();
				arCamera.setCamera(camera);
			} catch (RuntimeException ex){
				Toast.makeText(this, "Camera not found", Toast.LENGTH_LONG).show();
			}
		}
	}

	private void reloadSurfaceView() {
		if (surfaceView.getParent() != null) {
			((ViewGroup) surfaceView.getParent()).removeView(surfaceView);
		}

		cameraContainerLayout.addView(surfaceView);
	}

	private void releaseCamera() {
		if(camera != null) {
			camera.setPreviewCallback(null);
			camera.stopPreview();
			arCamera.setCamera(null);
			camera.release();
			camera = null;
		}
	}

	private void registerSensors() {
		sensorManager.registerListener(this,
				sensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR),
				SensorManager.SENSOR_DELAY_NORMAL);
		sensorManager.registerListener(this, sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)  , SensorManager.SENSOR_DELAY_NORMAL);
		sensorManager.registerListener(this, sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD) ,SensorManager.SENSOR_DELAY_NORMAL);
		sensorManager.registerListener(this, sensorManager.getDefaultSensor(Sensor.TYPE_ORIENTATION) ,SensorManager.SENSOR_DELAY_NORMAL);
	}

	@Override
	public void onSensorChanged(SensorEvent sensorEvent) {
		if (sensorEvent.sensor.getType() == Sensor.TYPE_ROTATION_VECTOR) {
			float[] rotationMatrixFromVector = new float[16];
			float[] projectionMatrix = new float[16];
			float[] rotatedProjectionMatrix = new float[16];
            /*
            String str = "";
            for(float f : sensorEvent.values){
                str = str+","+f;
            }
            Log.i(TAG, "values----------------->:"+ str);
           */
			SensorManager.getRotationMatrixFromVector(rotationMatrixFromVector, sensorEvent.values);

			if (arCamera != null) {
				projectionMatrix = arCamera.getProjectionMatrix();
			}

			Matrix.multiplyMM(rotatedProjectionMatrix, 0, projectionMatrix, 0, rotationMatrixFromVector, 0);
			this.arOverlayView.updateRotatedProjectionMatrix(rotatedProjectionMatrix);
		}

		if (sensorEvent.sensor.getType() == Sensor.TYPE_MAGNETIC_FIELD) {
			magneticFieldValues = sensorEvent.values;
		}
		if (sensorEvent.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
			accelerometerValues = sensorEvent.values;
		}
		if (sensorEvent.sensor.getType() == Sensor.TYPE_ORIENTATION) {
			float degree = sensorEvent.values[0];// 存放了方向值 90
			// Log.i(TAG, "degree----------------->:"+degree);
			AROverlayViewDraw.zDegrees = degree;
		}
		//  calculateOrientation();
	}





	@Override
	public void onAccuracyChanged(Sensor sensor, int i) {
		//do nothing
	}

	private void initLocationService() {

		if ( Build.VERSION.SDK_INT >= 23 &&
				ContextCompat.checkSelfPermission( this, Manifest.permission.ACCESS_FINE_LOCATION ) != PackageManager.PERMISSION_GRANTED) {
			return  ;
		}

		try   {
			this.locationManager = (LocationManager) this.getSystemService(this.LOCATION_SERVICE);

			// Get GPS and network status
			this.isGPSEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
			this.isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);

			if (!isNetworkEnabled && !isGPSEnabled)    {
				// cannot get location
				this.locationServiceAvailable = false;
			}

			this.locationServiceAvailable = true;

			if (isNetworkEnabled) {
				locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER,
						MIN_TIME_BW_UPDATES,
						MIN_DISTANCE_CHANGE_FOR_UPDATES, this);
				if (locationManager != null)   {
					location = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
					updateLatestLocation();
				}
			}

			if (isGPSEnabled)  {
				locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,
						MIN_TIME_BW_UPDATES,
						MIN_DISTANCE_CHANGE_FOR_UPDATES, this);

				if (locationManager != null)  {
					location = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
					updateLatestLocation();
				}
			}
		} catch (Exception ex)  {
			Log.e(TAG, ex.getMessage());

		}
	}

	private void updateLatestLocation() {
		if (arOverlayView !=null&&location!=null) {
			arOverlayView.updateCurrentLocation(location);
			//  tvCurrentLocation.setText(String.format("lat: %s \nlon: %s \naltitude: %s \n",
			//        location.getLatitude(), location.getLongitude(), location.getAltitude()));
			CacheService cache = OnthewayApplication.getInstahce(CacheService.class);
			Double latCache = cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LAT);
			Double lonCache = 0.0;
			if(latCache!=null){
				lonCache = cache.getDouble(StaticVar.BAIDU_LOC_CACHE_LON);
				Log.i(this.getClass().getName(),"init location from cache");
				trackSearchVo.setLongitude(lonCache);
				trackSearchVo.setLatitude(latCache);
				arOverlayView.updateLocationData(latCache,lonCache);
			}
		}
	}

	@Override
	public void onLocationChanged(Location location) {
		updateLatestLocation();
	}

	@Override
	public void onStatusChanged(String s, int i, Bundle bundle) {

	}

	@Override
	public void onProviderEnabled(String s) {

	}

	@Override
	public void onProviderDisabled(String s) {

	}
	private void calculateOrientation() {
		float[] values = new float[3];
		float[] R = new float[9];
		SensorManager.getRotationMatrix(R, null, accelerometerValues, magneticFieldValues);
		SensorManager.getOrientation(R, values);
		// 要经过一次数据格式的转换，转换为度
		values[0] = (float) Math.toDegrees(values[0]);
		//  Log.i(TAG, values[0]+"");
		values[1] = (float) Math.toDegrees(values[1]);
		values[2] = (float) Math.toDegrees(values[2]);
		//  Log.i(TAG, "xDegrees:"+values[1]+" yDegrees:"+values[2]);
		AROverlayViewDraw.xDegrees = values[1];
		AROverlayViewDraw.yDegrees = values[2];
		AROverlayViewDraw.zDegrees = values[0];

		if(values[0] >= -5 && values[0] < 5){
			Log.i(TAG, "正北");
		}
		else if(values[0] >= 5 && values[0] < 85){
			Log.i(TAG, "东北");
		}
		else if(values[0] >= 85 && values[0] <=95){
			Log.i(TAG, "正东");
		}
		else if(values[0] >= 95 && values[0] <175){
			Log.i(TAG, "东南");
		}
		else if((values[0] >= 175 && values[0] <= 180) || (values[0]) >= -180 && values[0] < -175){
			Log.i(TAG, "正南");
		}
		else if(values[0] >= -175 && values[0] <-95){
			Log.i(TAG, "西南");
		}
		else if(values[0] >= -95 && values[0] < -85){
			Log.i(TAG, "正西");
		}
		else if(values[0] >= -85 && values[0] <-5){
			Log.i(TAG, "西北");
		}

	}
}