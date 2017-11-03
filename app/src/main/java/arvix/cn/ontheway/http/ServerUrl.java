package arvix.cn.ontheway.http;

/**
 * Created by asdtiang on 2017/8/3 0003.
 * asdtiangxia@163.com
 * all url  not  end with /
 */

public interface ServerUrl {

    String BASE_URL = "http://106.75.52.213:9900";
    //发送登陆验证码
    String SEND_SMS = BASE_URL + "/api/v1/login/sms/sent";
    //使用手机验证码登陆
    String SIGN_IN_SMS = BASE_URL + "/api/v1/login/sms";
    //退出登陆
    String SIGN_OUT = BASE_URL + "/api/v1/login/out";
    //获取七牛上传token
    String QINIU_UPTOKEN = BASE_URL + "/api/v1/qiniu/upToken";
    // 更改用户头像
    String USER_UPDATE_HEADER = BASE_URL + "/app/user/update/image";
    // 更改用户姓名
    String USER_UPDATE_NAME = BASE_URL + "/app/user/update/name";
    // 更改用户性别
    String USER_UPDATE_GENDER = BASE_URL + "/app/user/update/gender";
    // 获取足迹列表数据
    String FOOTPRINT_SEARCH = BASE_URL + "/app/footprint/search";
    // 足迹发布
    String FOOTPRINT_CREATE = BASE_URL + "/app/footprint/create";
    // 删除
    String FOOTPRINT_DELETE = BASE_URL + "/app/footprint/delete";
    // 点赞
    String FOOTPRINT_LIKE = BASE_URL + "/app/footprint/like";
    // 获取某个用户的足迹列表
    String FOOTPRINT_USER = BASE_URL + "/app/footprint/user";
    // 足迹详情
    String FOOTPRINT_SHOW = BASE_URL + "/app/footprint/view";
    //获取评论消息
    String COMMENT_SEARCH = BASE_URL + "/app/message/comment/search";
    //创建评论
    String COMMENT_CREATE = BASE_URL + "/app/footprint/comment/create";
    //删除评论
    String COMMENT_DELETE = BASE_URL + "/app/footprint/comment/delete";
    // 获取系统消息数据GET /api/v1/message/search
    String SYSTEM_MESSAGE=BASE_URL+"/app/message/system/search";
    // 获取新的足迹动态
    String FOOT_DYNAMIC=BASE_URL+"/app/attention/footprint";
    // 获取商家数据
    String BUSINESS=BASE_URL+"/app/business/search";

}


