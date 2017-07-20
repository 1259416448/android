package arvix.cn.ontheway.ui;

import android.app.Fragment;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.support.annotation.IdRes;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.style.ImageSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.HashMap;
import java.util.List;
import java.util.concurrent.Callable;

import arvix.cn.ontheway.MainCardBean;
import arvix.cn.ontheway.MenuBean;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.async.AsyncUtil;
import arvix.cn.ontheway.async.Callback;
import arvix.cn.ontheway.async.Result;
import arvix.cn.ontheway.data.IndexData;
import arvix.cn.ontheway.utils.UIUtils;

/**
 * Created by yd on 2017/7/19.
 */

public class MainActivity2 extends BaseActivity {
    @ViewInject(R.id.tab_group)
    private RadioGroup tabRG;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main2);
        x.view().inject(self);
        initView();
    }

    private int lastCheckedTab;

    private void initView() {
        tabRG.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup radioGroup, @IdRes int id) {
                changeFrag(id);
            }

        });
        tabRG.check(R.id.tab_faxian);
    }

    private HashMap<Integer, Fragment> frags = new HashMap<>();

    public void changeFrag(int checkedId) {
        Fragment targetFrag = frags.get(checkedId);
        if (targetFrag == null) {
            if (checkedId == R.id.tab_faxian) {
                targetFrag = new FaXianFrag();
            } else if (checkedId == R.id.tab_xiaoxi) {
                targetFrag = new Fragment();
            } else if (checkedId == R.id.tab_wode) {
                targetFrag = new Fragment();
            }
        }
        if (targetFrag != null) {
            getFragmentManager().beginTransaction().replace(R.id.main_frag_container, targetFrag).commit();
            frags.put(checkedId, targetFrag);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

    }

    @Override
    protected void onResume() {
        super.onResume();

    }

    @Override
    protected void onPause() {
        super.onPause();

    }


}