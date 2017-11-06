package arvix.cn.ontheway.async;

import android.content.Context;

import java.io.EOFException;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;

/**
 * @author shiner
 */
public class ExceptionHandler {
	public static void handleException(Context ctx, Result<?> result) {
		if (result.getError() == Result.OK) {
			result.setError(-1);
		}
		Throwable t = result.getThrowable();
		if (t == null) {
			t = new DException("未知错误");
			result.setThrowable(t);
		}
		String clsName = t.getClass().getName();
		if (t instanceof DException) {
			result.setErrorMsg(t.getMessage());
		}
//		else if (t instanceof com.lidroid.xutils.exception.HttpException) {
//			com.lidroid.xutils.exception.HttpException ex = (com.lidroid.xutils.exception.HttpException) t;
//			result.setErrorMsg(getErrorMsg(ex.getExceptionCode()));
//		}
		else if (clsName.startsWith("java.net") || clsName.startsWith("org.apache.http")
				|| t instanceof SocketTimeoutException || t instanceof UnknownHostException
				|| t instanceof EOFException) {
			result.setErrorMsg("网络问题");
		} else if (result.getErrorMsg() == null) {
			result.setErrorMsg("系统错误" + "\r\n" + t.getMessage());
		}
	}

	private static String getErrorMsg(int exceptionCode) {
		return "网络问题:" + exceptionCode;
	}
}
