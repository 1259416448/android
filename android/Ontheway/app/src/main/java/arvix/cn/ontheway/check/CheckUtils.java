package arvix.cn.ontheway.check;

import android.content.Context;
import android.view.Gravity;
import android.widget.Toast;

/**
 * Created by asdtiang on 2017/8/3 0003.
 * asdtiangxia@163.com
 */

public class CheckUtils {

    public static boolean checkPhone(Context content, String phone){
        boolean result = true;
        if (!phone.trim().matches("^1\\d{10}$")) {
            Toast toast = Toast.makeText(content,
                    "手机号格式错误", Toast.LENGTH_LONG);
            toast.setGravity(Gravity.CENTER, 0, 0);
            toast.show();
            result  = false;
        }
        return  result;
    }

}
