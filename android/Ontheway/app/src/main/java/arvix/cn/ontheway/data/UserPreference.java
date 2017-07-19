package arvix.cn.ontheway.data;

import android.content.Context;

import arvix.cn.ontheway.common.XPreference;

public class UserPreference extends XPreference {
	private final static String SP_NAME = "user";

	public UserPreference(Context mContext) {
		super(SP_NAME, mContext);
	}

	public void setId(long id) {
		setLong("id", id);
	}

	public long getId() {
		return getLong("id", 0);
	}

}
