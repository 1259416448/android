package arvix.cn.ontheway.ui.msg;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.ui.BaseFragment;

/**
 * Created by asdtiang on 2017/7/24 0024.
 * asdtiangxia@163.com
 */

public class MsgFrag extends BaseFragment {

    @ViewInject(R.id.to_system_msg)
    private View toSystemLine;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View root = inflater.inflate(R.layout.frag_msg, null);
        x.view().inject(this, root);
        toSystemLine.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
               // ARouter.getInstance().build(InterRouterUrl.TO_SYSTEM_MSG).navigation();
                Intent intent = new Intent(act , SystemMsgActivity.class);
                startActivity(intent);
            }
        });
        return root;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

    }
}
