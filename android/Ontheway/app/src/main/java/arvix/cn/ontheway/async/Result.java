package arvix.cn.ontheway.async;


/**
 * @author shiner
 */
public class Result<T> {
	public final static int OK = 0;
	private int error = OK;
	private String errorMsg;
	private Throwable throwable;
	private T data;

	public boolean ok() {
		return error == OK;
	}

	public Result(int error, String errorMsg, Throwable throwable, T data) {
		super();
		this.error = error;
		this.errorMsg = errorMsg;
		this.throwable = throwable;
		this.data = data;
	}

	public Result() {
		super();
	}

	public int getError() {
		return error;
	}

	public void setError(int error) {
		this.error = error;
	}

	public String getErrorMsg() {
		return errorMsg;
	}

	public void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}

	public Throwable getThrowable() {
		return throwable;
	}

	public void setThrowable(Throwable throwable) {
		this.throwable = throwable;
	}

	public T getData() {
		return data;
	}

	public void setData(T data) {
		this.data = data;
	}

	public void defaultError(Throwable e) {
		setError(-1);
		setErrorMsg("未知错误");
		setThrowable(e);
	}
}
