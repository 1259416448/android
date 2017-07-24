package arvix.cn.ontheway.ui;

import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.IdRes;
import android.util.Log;
import android.view.View;
import android.widget.RadioGroup;
import android.widget.TextView;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import java.util.HashMap;

import arvix.cn.ontheway.BaiduActivity;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.ui.ar.ArTrackActivity;
import arvix.cn.ontheway.ui.usercenter.MyProfileFragment;

/**
 * Created by yd on 2017/7/19.
 */

public class MainActivity2 extends BaseActivity {
    @ViewInject(R.id.tab_group)
    private RadioGroup tabRG;
    @ViewInject(R.id.tab_zuji)
    private TextView zuJiTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main2);
        x.view().inject(self);
        zuJiTextView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Log.i("zuji", "zuji--------------------------------->");
                Intent intent = new Intent(self, ArTrackActivity.class);
                intent.putExtra(BaiduActivity.EXTRA_KEYWORD, "美食");
                startActivity(intent);
            }
        });
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
            Log.i("zuji", "zuji--------------------------fffffff------->" + checkedId);
            if (checkedId == R.id.tab_faxian) {
                targetFrag = new FaXianFrag();
            } else if (checkedId == R.id.tab_xiaoxi) {
                targetFrag = MsgFrag.newInstance();
            } else if (checkedId == R.id.tab_wode) {
                targetFrag = new MyProfileFragment();
            }
        }
        if (targetFrag != null) {
            Log.i("zuji", "zuji--------------------------------->" + targetFrag.getTag());
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