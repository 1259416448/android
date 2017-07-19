package arvix.cn.ontheway.utils;

import android.util.Log;

import arvix.cn.ontheway.BuildConfig;


public class DLog {
	final String TAG = "DLog_log";

	public static void d(String TAG, String msg) {
		if (BuildConfig.DEBUG) {
			Log.d(TAG, ">>" + TAG + ":" + msg);
		}
	}

	public static void dAlways(String TAG, String msg) {
		Log.d(TAG, ">>" + TAG + ":" + msg);
	}

	public static void e(String TAG, String msg) {
		Log.e(TAG, ">>" + TAG + ":" + msg);
	}

	public static void e(String TAG, String msg, Throwable tr) {
		Log.e(TAG, ">>" + TAG + ":" + msg, tr);
	}
}
