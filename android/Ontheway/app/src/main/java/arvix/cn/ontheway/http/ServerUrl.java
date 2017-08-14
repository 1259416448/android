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

    String USER_UPDATE_HEADER = BASE_URL + "/app/user/update/image";

    String USER_UPDATE_NAME = BASE_URL + "/app/user/update/name";

    String USER_UPDATE_GENDER = BASE_URL + "/app/user/update/gender";

    String FOOTPRINT_SEARCH =  BASE_URL + "/app/footprint/search";

    String FOOTPRINT_CREATE =  BASE_URL + "/app/footprint/create";

    String FOOTPRINT_SHOW = BASE_URL +"/app/footprint/view";

    String COMMENT_SEARCH =BASE_URL +  "/app/footprint/comment/search";

    String COMMENT_CREATE = BASE_URL + "/app/footprint/comment/create";



}
