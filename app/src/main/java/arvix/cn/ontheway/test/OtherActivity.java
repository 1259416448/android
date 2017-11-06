package arvix.cn.ontheway.test;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;

public class OtherActivity extends BaseActivity {

    @ViewInject(R.id.name)
    private TextView name_tv;
    @ViewInject(R.id.address)
    private TextView address_tv;
    @ViewInject(R.id.left_btn)
    private ImageButton btn;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_other);
        x.view().inject(self);

        Intent intent = getIntent();
        name_tv.setText(intent.getStringExtra("name"));
        address_tv.setText(intent.getStringExtra("address"));

        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
    }
}

