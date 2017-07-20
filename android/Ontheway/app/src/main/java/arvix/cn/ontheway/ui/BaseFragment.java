package arvix.cn.ontheway.ui;

import android.app.Activity;
import android.app.Fragment;
import android.os.Bundle;

public class BaseFragment extends Fragment {
    protected BaseFragment self;
    protected Activity act;

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        act = activity;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        self = this;
    }
}
