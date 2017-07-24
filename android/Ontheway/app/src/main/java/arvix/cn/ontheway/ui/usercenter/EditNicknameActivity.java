package arvix.cn.ontheway.ui.usercenter;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;

import org.xutils.view.annotation.ViewInject;
import org.xutils.x;

import arvix.cn.ontheway.R;
import arvix.cn.ontheway.ui.BaseActivity;
import arvix.cn.ontheway.ui.head.HeaderHolder;

/**
 * Created by asdtiang on 2017/7/21 0021.
 * asdtiangxia@163.com
 */

public class EditNicknameActivity extends BaseActivity {
    public static String EXTRA_NICKNAME = "nickname";
    @ViewInject(R.id.edit_et)
    private EditText editEt;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.edit_nickname);
        x.view().inject(this);
        String nickname = this.getIntent().getStringExtra(EXTRA_NICKNAME);
        editEt.setText(nickname);
        editEt.setSelection(editEt.getText().length());
        HeaderHolder head=new HeaderHolder();
        head.init(self,"修改名称");
        head.setUpRightTextBtn("保存", new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String s = editEt.getText().toString();
                Intent data=new Intent();
                if(!TextUtils.isEmpty(s)) {
                    data.putExtra(EXTRA_NICKNAME, s);
                    setResult(RESULT_OK, data);
                }else{
                    setResult(RESULT_CANCELED);
                }
                finish();
            }
        });


    }
}
