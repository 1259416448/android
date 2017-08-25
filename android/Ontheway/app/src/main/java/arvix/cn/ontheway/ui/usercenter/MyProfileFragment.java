package arvix.cn.ontheway.ui.usercenter;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.content.LocalBroadcastManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import arvix.cn.ontheway.App;
import arvix.cn.ontheway.R;
import arvix.cn.ontheway.ui.BaseFragment;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.StaticVar;

/**
 * Created by asdtiang on 2017/7/21 0021.
 * asdtiangxia@163.com
 */

public class MyProfileFragment extends BaseFragment {
    @ViewInject(R.id.to_person_info)
    private View nameLineVG;
    @ViewInject(R.id.to_my_map_track)
    private View myMapTrackVG;
    @ViewInject(R.id.nameTv)
    private TextView nameTv;
    @ViewInject(R.id.header_img)
    private ImageView headerIV;
    @ViewInject(R.id.to_person_set)
    private View toSet;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View root = inflater.inflate(R.layout.frag_myprofile, null);
        x.view().inject(this,root);
        nameLineVG.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(act,PersonInfoActivity.class));
            }
        });
        myMapTrackVG.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(act,MyTrackMapActivity.class));
            }
        });
        toSet.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(act,MySetActivity.class));
            }
        });
        nameTv.setText(App.userInfo.getName());
        IntentFilter filter=new IntentFilter(StaticVar.BROADCAST_ACTION_USER_CHANGE);
        LocalBroadcastManager.getInstance(act).registerReceiver(receiver,filter);
        StaticMethod.setCircularHeaderImg(headerIV,110,110);
        return root;
    }

    private BroadcastReceiver receiver=new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            StaticMethod.setCircularHeaderImg(headerIV,110,110);
            nameTv.setText(App.userInfo.getName());
        }
    };

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        LocalBroadcastManager.getInstance(act).unregisterReceiver(receiver);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {


    }
}
