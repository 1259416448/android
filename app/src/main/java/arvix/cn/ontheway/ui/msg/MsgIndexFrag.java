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

public class MsgIndexFrag extends BaseFragment {

    @ViewInject(R.id.to_system_msg)
    private View toSystemLine;
    @ViewInject(R.id.to_new_like_line)
    private View toNewLikeLine;
    @ViewInject(R.id.to_new_reply_line)
    private View toNewReplyLine;
    @ViewInject(R.id.to_new_track_line)
    private View toNewTrackLine;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View root = inflater.inflate(R.layout.frag_msg, null);
        x.view().inject(this, root);
        toSystemLine.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(act , SystemMsgActivity.class);
                startActivity(intent);
            }
        });
        toNewLikeLine.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(act , NewLikeActivity.class);
                startActivity(intent);
            }
        });
        toNewReplyLine.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(act , NewReplyActivity.class);
                startActivity(intent);
            }
        });
        toNewTrackLine.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent=new Intent(act,NewFootActivity.class);
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
