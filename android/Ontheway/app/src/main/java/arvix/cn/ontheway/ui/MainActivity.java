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
import arvix.cn.ontheway.service.inter.CacheService;
import arvix.cn.ontheway.ui.ar.ArTrackActivity;
import arvix.cn.ontheway.ui.msg.MsgIndexFrag;
import arvix.cn.ontheway.ui.usercenter.MyProfileFragment;
import arvix.cn.ontheway.utils.OnthewayApplication;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;

/**
 * Created by yd on 2017/7/19.
 */

public class MainActivity extends BaseActivity implements View.OnClickListener {
    @ViewInject(R.id.tab_group)
    private RadioGroup tabRG;
    @ViewInject(R.id.tab_zuji)
    private TextView zuJiTextView;
    CacheService cache;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
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
        cache = OnthewayApplication.getInstahce(CacheService.class);
        Log.i(logTag,"onCreate----->");
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
       // fxBtn.setOnClickListener(this);
    }

    private HashMap<Integer, Fragment> frags = new HashMap<>();

    private static int waitForResultValue = -1;

    public void changeFrag(int checkedId) {
        Fragment targetFrag = frags.get(checkedId);

        if (targetFrag == null) {
            Log.i("zuji", "zuji--------------------------fffffff------->" + checkedId);
            if (checkedId == R.id.tab_faxian) {
                targetFrag = new FaXianFrag();
            } else if (checkedId == R.id.tab_xiaoxi) {
                targetFrag = new MsgIndexFrag();
                //list Msg targetFrag = MsgListFrag.newInstance();
            } else if (checkedId == R.id.tab_wode) {
                if(cache.get(StaticVar.AUTH_TOKEN)!=null){
                    targetFrag = new MyProfileFragment();
                }else{
                    Log.i("MainThread----------->",Thread.currentThread().getName());
                    waitForResultValue = StaticMethod.goToLogin(self);
                }
            }
        }
        if (targetFrag != null) {
            Log.i("zuji", "zuji----------------targetFrag----------------->" + targetFrag.getClass().getName());
            getFragmentManager().beginTransaction().replace(R.id.main_frag_container, targetFrag).commit();
            frags.put(checkedId, targetFrag);
        }
    }
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        Log.i(logTag,"main onActivityResult---------> requestCode :" +requestCode +",waitForResultValue:"+waitForResultValue  +",resultCode:"+resultCode+",RESULT_OK:"+RESULT_OK);
        if (requestCode == waitForResultValue) {
           // changeFrag(R.id.tab_faxian);
            tabRG.check(R.id.tab_wode);
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


    @Override
    public void onClick(View view) {
        /*
        if (view == fxBtn) {
            String[] items = new String[]{"one", "two", "three"};
            //40是R.layout.popup_menu_item的高度
            int offsetY = -UIUtils.dip2px(self, 40) * items.length - view.getHeight();
            UIUtils.showPopUpWindow(self, findViewById(R.id.tab_xiaoxi), 0, offsetY, items, new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                    UIUtils.toast(self, i + "", Toast.LENGTH_SHORT);
                }
            });
        }*/
    }
}