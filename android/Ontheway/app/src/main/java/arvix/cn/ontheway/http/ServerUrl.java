package arvix.cn.ontheway.http;

/**
 * Created by asdtiang on 2017/8/3 0003.
 * asdtiangxia@163.com
 * all url  not  end with /
 */

public interface ServerUrl {

    String BASE_URL = "http://106.75.52.213:9900";

    String SEND_SMS = BASE_URL + "/api/v1/login/sms/sent";

    String SIGN_IN_SMS = BASE_URL + "/api/v1/login/sms";

    String SIGN_OUT = BASE_URL + "/api/v1/login/out";

    String QINIU_UPTOKEN = BASE_URL + "/api/v1/qiniu/upToken";

    String UPDATE_HEADER = BASE_URL + "/app/user/update/image";

    String UPDATE_NAME = BASE_URL + "/app/user/update/name";

    String UPDATE_GENDER = BASE_URL + "/app/user/update/gender";


}
