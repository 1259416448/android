package arvix.cn.ontheway.async;

import android.os.Handler;
import android.os.Looper;
import android.widget.Toast;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.utils.UIUtils;

/**
 * @author shiner
 */
public class AsyncUtil {
	private static final String TAG = "AsyncUtil";

	private static final Handler handler = new Handler(Looper.getMainLooper());

	public static <T> AsyncHandler goAsync(final Callable<Result<T>> callable, final Callback<Result<T>> callback) {
		final AsyncHandler h = new AsyncHandler();
		new Thread() {
			public void run() {
				Result<T> result;
				try {
					onStart(callback);
					// 直接调call了。。
					result = callable.call();

					if (!h.canceled()) {
						handle(callback, result);// 返回
					}
				} catch (Throwable e) {
					e.printStackTrace();
					result = new Result<T>(99, null, e, null);
					ExceptionHandler.handleException(App.self, result);
					if (!h.canceled()) {
						handle(callback, result);// 返回
					}
				}
			};
		}.start();
		return h;

	}

	public static <T> void handle(final Callback<Result<T>> callback, final Result<T> result) {
		if (callback == null)
			return;
		if (Looper.getMainLooper().getThread().getId() == Thread.currentThread().getId()) {
			try {
				callback.onHandle(result);
			} catch (Exception e) {
				e.printStackTrace();
				Result<T> seriousResult = new Result<T>(99, null, e, null);
				ExceptionHandler.handleException(App.self, seriousResult);
				UIUtils.toast(App.self, seriousResult.getErrorMsg(), Toast.LENGTH_LONG);
			}
		} else {
			handler.post(new Runnable() {

				@Override
				public void run() {
					try {
						callback.onHandle(result);
					} catch (Exception e) {
						e.printStackTrace();
						Result<T> seriousResult = new Result<T>(99, null, e, null);
						ExceptionHandler.handleException(App.self, seriousResult);
						UIUtils.toast(App.self, seriousResult.getErrorMsg(), Toast.LENGTH_LONG);
					}
				}
			});
		}

	}

	public static <T> void onStart(final Callback<T> callback) {
		if (callback == null)
			return;
		if (Looper.getMainLooper().getThread().getId() == Thread.currentThread().getId()) {
			callback.onStart();
		} else {
			handler.post(new Runnable() {

				@Override
				public void run() {
					callback.onStart();
				}
			});
		}
	}

	private static ExecutorService es = Executors.newFixedThreadPool(8);

	public static <T> AsyncHandler goAsyncInPool(final Callable<Result<T>> callable,
												 final Callback<Result<T>> callback) {
		AsyncHandler h = new AsyncHandler();
		es.submit(new ExecuteCallable<T>(callable, callback, h));
		return h;
	}

	private static class ExecuteCallable<T> implements Runnable {
		private Callable<Result<T>> task;
		private Callback<Result<T>> callback;
		private AsyncHandler h;

		public ExecuteCallable(Callable<Result<T>> task, Callback<Result<T>> callback, AsyncHandler h) {
			super();
			this.task = task;
			this.callback = callback;
			this.h = h;
		}

		@Override
		public void run() {
			Result<T> result;
			try {
				onStart(callback);
				// 直接调call了。。
				result = task.call();
				if (!h.canceled()) {
					handle(callback, result);// 返回
				}
			} catch (Throwable e) {
				e.printStackTrace();
				result = new Result<T>(99, null, e, null);
				ExceptionHandler.handleException(App.self, result);
				if (!h.canceled()) {
					handle(callback, result);// 返回
				}

			}
		}
	}
}
