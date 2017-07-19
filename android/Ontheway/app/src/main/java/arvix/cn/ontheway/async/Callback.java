package arvix.cn.ontheway.async;

public abstract class Callback<T> {
	public void onStart() {
	}

	abstract public void onHandle(T result);

}
