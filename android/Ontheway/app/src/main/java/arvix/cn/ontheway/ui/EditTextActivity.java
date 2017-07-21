package arvix.cn.ontheway.ui;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;
import android.widget.EditText;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import arvix.cn.ontheway.R;

/**
 * Created by asdtiang on 2017/7/21 0021.
 * asdtiangxia@163.com
 */

public class EditTextActivity extends BaseActivity {
    @ViewInject(R.id.edit_et)
    private EditText editEt;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.edittext);
        x.view().inject(this);
        findViewById(R.id.edit_submit).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String s=editEt.getText().toString();
                Intent data=new Intent();
                data.putExtra("data",s);
                setResult(RESULT_OK,data);
                finish();
            }
        });
    }
}
