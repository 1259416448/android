package arvix.cn.ontheway.ui.usercenter;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

import com.handmark.pulltorefresh.library.PullToRefreshBase;

import org.xutils.x;

import java.util.ArrayList;
import java.util.List;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.bean.CommentBean;
import arvix.cn.ontheway.bean.MsgBean;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;
import arvix.cn.ontheway.ui.msg.NewReplyActivity;
import arvix.cn.ontheway.ui.msg.NewReplyAdapter;
import arvix.cn.ontheway.ui.view.ListViewHolder;
import arvix.cn.ontheway.utils.StaticMethod;
import arvix.cn.ontheway.utils.UIUtils;

public class MyClaimActivity extends BaseActivity {


    private MyClaimAdapter adapter;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_my_claim);
        x.view().inject(self);
        HeaderHolder head = new HeaderHolder();
        head.init(self, "我的认领");

    }
}
